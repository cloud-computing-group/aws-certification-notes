Thanks for [brunton-spall's blog](https://www.brunton-spall.co.uk/post/2020/04/28/Using-AWS-Workspaces/) and [brunton-spall's github](https://github.com/bruntonspall/AWSWorkspacesCA).  
  
1. (Only do this step if want to renew CA or did not create and upload CA public key before) run `./gen_CA.sh`, which will generate CA's private and public key, copy the public key (`.pem` file) and upload it onto [AWS Workspaces's Directory Service's Access Control Options](https://docs.aws.amazon.com/workspaces/latest/adminguide/trusted-devices.html#configure-restriction).
2. run `./gen_client.sh`, which will generate client private and public key and corresponding CA sign certificate.
3. copy `.pfx` (or say `p12`) certificate file to Windows laptop, click install, select current user and personal store.
  
Now should be able to login with workspaces client (suppose already setup AWS Workspaces side correctly with other settings).  
