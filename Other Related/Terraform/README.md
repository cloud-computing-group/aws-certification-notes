# IaC and its Benefits
![](./IaC%20and%20its%20Benefits.png)  
  
And:  
* IaC does automate software-defined networks and makes the deployment efficient and consistent every time.
* IaC Tracks state of each resource deployed, which is a crucial part of Terraform, as it keeps track of the deployment and allows for a consistent deployment each time.
* IaC interacts and takes care of the communication with control-layer APIs with ease - Terraforms smart features take out a lot of the manual labor of deploying infrastructure using vendor APIs.
  
Good work!
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
* `terraform init` (This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times, the terraform init command is the very first command that you'll run to fetch required dependencies, such as providers; it initializes and sets up the working directory containing your Terraform code; it does in fact help configure and set up the backend which will store the state file.)  
* `terraform plan` (The terraform plan command goes through the code and creates a plan of execution on which the apply command acts.)  
* `terraform apply` (type "yes")  
* `terraform destroy` (destroy, the terraform destroy command cleans up and deletes all infrastructure tracked in the state file. It is a destructive command which deletes all resources being tracked via the Terraform state file.)  
  
The recommended Terraform workflow is to write the code (Write), review it (Plan), and then execute/deploy the code (Apply).  
  
## Core Concept
![](./Terraform%20Workflow.png)  
![](./Terraform%20Workflow%20Init.png)  
![](./Terraform%20Workflow%20Plan.png)  
![](./Terraform%20Workflow%20Apply.png)  
![](./Terraform%20Workflow%20Destroy.png)  
  
## Syntax
![](./Terraform%20Syntax%20Provider.png)  
![](./Terraform%20Syntax%20Built-in%20Function.png)  
![](./Terraform%20Syntax%20Resource.png)  
![](./Terraform%20Syntax%20Data%20Source.png)
  
## Tips
Enable verbose output logging for Terraform commands using TF_LOG=TRACE:  
`export TF_LOG=TRACE`  
Note: You can turn off verbose logging at any time using the `export TF_LOG=` command.  
  
Customized Provider:  
![](./Terraform%20Customized%20Provider.png)  
