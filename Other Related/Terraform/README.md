# IaC and its Benefits
![](./IaC%20and%20its%20Benefits.png)  
  
# What is Terraform
Terraform is an open-source infrastructure as code software tool. It enables users to define and provision a datacenter infrastructure using a high-level configuration language known as Hashicorp Configuration Language (HCL), or optionally JSON.  
  
## Install
1. Download the appropriate Terraform binary package for the provided lab server VM (Linux 64-bit) using the wget command:
`wget -c https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip` (0.13.4 may not be latest version as you see it, set it to the one latest please)  
2. Unzip the downloaded file:
`unzip terraform_0.13.4_linux_amd64.zip` (0.13.4 may not be latest version as you see it, set it to the one latest please)  
3. Place the Terraform binary in the PATH of the VM operating system so the binary is accessible system-wide to all users:
`sudo mv terraform /usr/sbin/`  
4. Check the Terraform version information:
`terraform version`  
Since the Terraform version is returned, you have validated that the Terraform binary is installed and working properly.  
  
## Usage
After finish terraform coding (pre-request the machine which run the following command have set IAM permission already):  
`terraform init` (This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times)  
`terraform plan`  
`terraform apply` (type "yes")  
`terraform destroy` (destroy)  
  
## Core Concept
![](./Terraform%20Workflow.png)  
  
## Tips
Enable verbose output logging for Terraform commands using TF_LOG=TRACE:  
`export TF_LOG=TRACE`  
Note: You can turn off verbose logging at any time using the `export TF_LOG=` command.  
