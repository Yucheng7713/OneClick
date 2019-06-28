# OneClick
Monitoring as a Service - DevOps Fellow @ Insight
Toolkit for setting up Kubernetes and Prometheus monitoring components.

## Prerequisites 

- Setup AWS & Install AWS CLI
  1. Get an [AWS account](https://aws.amazon.com/)
  2. Create an IAM admin user and group on either AWS console (It is not recommended to set everything up with root account.)
  3. Grant the following IAM permissions to your IAM role in order to use the tool.
      ```
      AmazonEC2FullAccess
      AmazonRoute53FullAccess
      AmazonS3FullAccess
      IAMFullAccess
      AmazonVPCFullAccess
      ```
  4. Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html), and set up the
     credentials of your IAM role.
     Note : Once you create an IAM role, you will get an access key ID and a secret access key. Keep them secure as you 
     are likely to use them frequently to interact with AWS via CLI.
     ```
     # configure the aws account for using your IAM role
     $ aws configure
     AWS Access Key ID : [ Enter your Access Key ID here ]
     AWS Secret Access Key : [ Enter your Secret Key ID here ]
     Default region name : [ Enter the region you will be working in ] e.g. us-west-2
     Default output format : [ You can skip this step by simply pressing Enter ]
     ```

- Install Docker and Create a Docker Hub account
  !! Note that the following instructions are specifically for **Docker Desktop for Mac**, for Linux-based system like Ubuntu,
     visit https://docs.docker.com/install/linux/docker-ce/ubuntu/
  !! The Docker spec in this project is **Docker Desktop Community Version 2.0.0.3 (31259)**
  
  1. For Mac user, the fastest way to install Docker is to go for [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/). 
  2. After docker is installed on your machine, create a Docker account for using [Docker Hub](https://hub.docker.com/)
     as your image registry.
     (Images will be built from your applications and pushed onto Docker Hub.)
  3. Login with your Docker ID through Docker Desktop by clicking <.> on the right.
  
     <a href="url"><img src="https://github.com/Yucheng7713/OneClick/blob/master/README_IMG/README_IMG_a.png" align="middle" height="150" width="280"></a>
     
  4. Set environment variable $DOCKER_USER_NAME to your ~/.bash_profile
     ```
     $ echo "export DOCKER_USER_NAME=<put_your_docker_ID_here>" >> ~/.bash_profile
     $ source ~/.bash_profile
     ```

- Get a registered subdomain and set up Route53 hosted zones for it

  The following instructions are for those who already have a registered domain name, the example used here is for domain name
  hosted on [**Namecheap**](https://www.namecheap.com).
  For more information about how to set up a subdomain for Kubernetes, go to the doc of installing kops on aws
  https://github.com/kubernetes/kops/blob/master/docs/aws.md
  
  1. Go to [AWS Route53](https://console.aws.amazon.com/route53/)
  2. In dashboard on the left, click **Hosted zones**.
  3. Click **Created Hosted Zone**.
  4. Enter the subdomain name you decide to use. For instance, if your domain name is "example.com", you might go for 
     "oneclick.example.com".
     
     <a href="url"><img src="https://github.com/Yucheng7713/OneClick/blob/master/README_IMG/README_IMG_c.png" align="middle" height="302" width="550"></a>
     
  5. For **Type**, choose **Public Hosted Zone**
  6. After the hosted zone is created, you will get name servers for the subdomain name, use these name servers to 
     register the subdomain name on your domain name registration.
     If you are using Namecheap, here is the steps :
     - In dashboard, choose the domain name you would use by clicking "MANAGE".
     - Click on "Advanced DNS", under the host records section, create NS records by entering the NS values that you copy
       from new created hosted zone.
       
       <a href="url"><img src="https://github.com/Yucheng7713/OneClick/blob/master/README_IMG/README_IMG_b.png" align="middle" height="332" width="500"></a>
       
  7. After NS records are set, it takes around 30 min ( sometimes might take up to 2 hours ) until your domain name is ready.
     to test whether your DNS is ready, run the command :
     ```
     $ dig ns oneclick.example.com
     ```
     If it is ready, you shold see some information like below :
     ```
     ;; ANSWER SECTION:
     oneclick.example.com. 4588	IN	NS	ns-22.awsdns-02.com.
     oneclick.example.com. 4588	IN	NS	ns-602.awsdns-11.net.
     oneclick.example.com. 4588	IN	NS	ns-1321.awsdns-37.org.
     oneclick.example.com. 4588	IN	NS	ns-1900.awsdns-45.co.uk.
     ```
  As long as your DNS is up, you are good to go.

## Compatibility 
  - OS spec
    The supported environment is mainly for Mac OSX and Linux. If you are using Windows, it is recommended to go for
    Ubuntu subsystem for Windows 10.
  - Cloud support
    Currently the tool only supports AWS.
  - Restrictions to your project/repository if you want to use the deploying feature to deploy it :
    1. There must be a **requirement.txt** located at the root path of your project, the location and file name are
       non-negotiable.
    2. In **requirement.txt**, clearly state all dependencies that are used in your application with their versions.
       If you are not sure about what dependency you use, there are few ways that you can generate the file automatically:
       a. [Use pigar](https://github.com/damnever/pigar) by traversing your project directory
       b. If you are using conda environment or a virtualenv, run the command :
       ```
       $ pip freeze > requirements.txt
       ```
    3. There must be a **run.py** located at the root path of your project, the location and file name are
       non-negotiable.
    4. In **run.py**, the codes will be a standard Flask app, something like:
       ```
       from flask import Flask
       app = Flask(__name__)
       .....
       if __name__ == '__main__':
       app.run(host='0.0.0.0', port=5000)
       ```
  
  
## Quick Start

  1. Clone this repository to your local workspace.
  2. Build Python click command line tool by installing required dependencies :
     Navigate to the project root and execute :
     ```
     $ pip install -e .
     ```
  3. Initiate the production environment by running the following command :
     ```
     $ oneclick init
     ```
  4. Enter your name which will be used as the name of resources such as VPC on AWS
  5. Enter a valid registered subdomain, the subdomain will be used by Kubernetes cluster
  6. Well done! Now your production environment start initiating, after the initiation completes, a container will be boosted
     up and run, the container will serve as the interface to interact with Kubernetes upon AWS, you can consider it a light-
     weighted virtual machine. 
     When the container is ready, it will start setting up Kubernetes cluster, this takes around 7 to 10 min.
  7. After the cluster is set up on AWS, you will see a prompt information about the domain name of your cluster and the 
     path of S3 bucket which is used to store the configuration of Kubernetes cluster.
     
     !! Warning : Under no circumstance, do not delete the S3 bucket manually or by any other tools.
  8. Now is the time to deploy your application onto the cluster, to deploy from Github, simply run the following command :
     ```
     $ oneclick git-deploy <url_of_git_repository>
     ```
     You can also choose to deploy from your local machine :
     ```
     $ oneclick local-deploy <path_to_project_directory>
     ```
     After the deployment completes, it will expose a domain name which you can use to access your frontend application.
  9. For tearing down the Kubernetes cluster, execute the command :
     ```
     $ oneclick destroy
     ```
  
  10. If you need further configuration or advanced manipulation to the cluster like using kubectl or kops, you can 
      access the container by running the command :
      ```
      $ oneclick access
      ```
      Now it is just like what you usually do on your local host.
  
  
     

