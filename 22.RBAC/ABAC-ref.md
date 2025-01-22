Here is an example of how to implement **Attribute-Based Access Control (ABAC)** in Amazon EKS using YAML configurations. This example will demonstrate how to set up IAM policies that leverage tags (attributes) for controlling access to Kubernetes resources.

### Step 1: Tagging IAM Roles

First, you need to create IAM roles with specific tags that will be used for ABAC. For instance, you might have two roles: one for developers and another for auditors.

#### IAM Role Example (Developer)

```yaml
# Create a role for developers with a tag
Resources:
  DeveloperRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: DeveloperRole
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: eks.amazonaws.com
            Action: sts:AssumeRole
      Tags:
        - Key: role
          Value: developer
```

#### IAM Role Example (Auditor)

```yaml
# Create a role for auditors with a tag
Resources:
  AuditorRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: AuditorRole
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: eks.amazonaws.com
            Action: sts:AssumeRole
      Tags:
        - Key: role
          Value: auditor
```

### Step 2: Define ABAC Policies

Next, you need to create IAM policies that allow actions based on the tags assigned to the roles.

#### Developer Policy

This policy allows users with the `developer` tag to create, update, and delete Pods and Deployments.

```yaml
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:CreatePod",
        "eks:UpdatePod",
        "eks:DeletePod",
        "eks:CreateDeployment",
        "eks:UpdateDeployment",
        "eks:DeleteDeployment"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:RequestTag/role": "developer"
        }
      }
    }
  ]
}
```

#### Auditor Policy

This policy allows users with the `auditor` tag to list and get all resources.

```yaml
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:GetResource",
        "eks:ListResources"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:RequestTag/role": "auditor"
        }
      }
    }
  ]
}
```

### Step 3: Configure `aws-auth` ConfigMap

You must configure the `aws-auth` ConfigMap in your EKS cluster to map these IAM roles to Kubernetes roles.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::<account-id>:role/DeveloperRole
      username: developer-user
      groups:
        - system:masters # or any other group based on your RBAC setup

    - rolearn: arn:aws:iam::<account-id>:role/AuditorRole
      username: auditor-user
      groups:
        - system:viewers # or any other group based on your RBAC setup
```

### Summary

In this example, we created two IAM roles with specific tags (`role=developer` and `role=auditor`) and defined policies that grant permissions based on those tags. The `aws-auth` ConfigMap maps these IAM roles to Kubernetes users/groups, allowing for ABAC in your EKS environment. This setup enables fine-grained control over who can perform actions on Kubernetes resources based on their attributes.

Citations:
[1] https://docs.aws.amazon.com/ru_ru/IAM/latest/UserGuide/introduction_attribute-based-access-control.html
[2] https://eng.grip.security/enabling-aws-iam-group-access-to-an-eks-cluster-using-rbac
[3] https://aws.amazon.com/blogs/security/how-to-use-aws-secrets-manager-and-abac-for-enhanced-secrets-management-in-amazon-eks/
[4] https://repost.aws/knowledge-center/amazon-eks-cluster-access
[5] https://overcast.blog/mastering-kubernetes-attribute-based-access-control-abac-bb6a732cd561?gi=d4e2573f7cc5
[6] https://faun.pub/attribute-based-access-control-abac-in-kubernetes-91fd8486ffb9?gi=7489bb82865e
[7] https://aws.github.io/aws-eks-best-practices/security/docs/iam/