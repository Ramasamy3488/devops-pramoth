#!bin/bash

pkgName = ${1}
userId = $(id -u)

if[[ $# -ne 1]]; then
   echo "Please pass input as some package name."
   exit 1
fi

if [[ ${userId} -ne 0]]; then
   echo "you are not the root user. Please run this script as root."
   exit 2
fi

if command -v ${pkgName} >/dev/null 2>&1; then
   echo "Your package ${pkgName} is already deployed."
else
    if [["${pkgName}" == "jenkins"]]; then
        wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
        rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
        yum upgrade     # Add required dependencies for the jenkins package                  
        yum install -y java-17-amazon-corretto

        yum install -y ${pkgName} >/dev/null 2>&1
        yumExitSt=$?

       if [[ ${yumExitSt} -eq 0]]; then
           systemctl enable jenkins
           systemctl start jenkins
           echo "${pkgName} package is installed successfully and ${pkgName} service started."
        else
           echo "Installation failed."
       fi
     else
       read -p "Required to install ${pkgName}. Do you want to proceed? (y/n): " confirm
       case $confirm in
              y|Y)
                  yum install -y ${pkgName} >/dev/null 2>&1
                  yumExitSt=$?
                  if [[ ${yumExitSt} -eq 0]]; then
                  echo "${pkgName} package is installed successfully."
                  else
                      echo "Installation failed."
                  fi
                  ;;

               n|N)
                   echo "Not installing."
                   ;;
                *)
                   echo "Invalid input. Please enter 'y' or 'n'."
                   ;;
            esac
        fi
fi
                  


















