#                                             AWS-THREE-TIER-ARCHITECTURE

### INTRODUCTION

This documentation provides an overview and step-by-step guide to deploy a Three-Tier Architecture on AWS using Terraform. The Three-Tier Architecture consists of three logical layers: Presentation layer, Application layer, and Data layer. Each layer is designed to handle specific functions, promoting modularity, scalability, availability, resilience and maintainability.

### ARCHITECTURE OVERVIEW

1. VIRTUAL PRIVATE CLOUD FOR REGION-1 : A Virtual Private Cloud (VPC) is a logically isolated virtual network in the cloud that allows 
   the provisioning and management of resources, such as compute instances, databases, and LoadBalancers within a defined virtual 
   network.
   The VPC consists of the following resources:

     - [x] ROUTE-53 :- This is a highly scalable and reliable Domain Name System (DNS) web service provided by Amazon Web Services (AWS).
           Its primary function is to route user request from the internet to the target resources, such as loadbalancers, and compute 
           instances. In this three-tier-architecture, the route53 is used to route user request from the internet to the        
           internet-facing load-balancers.
           
     - [x] WAF :- The Web Application Firewall is a service managed by AWS, it serves a primary function of  protecting web applications 
           from web exploits and security threats, such as Account Take-over, Bots, SQL-injecton, Cross-site scripting, by filtering and 
           monitoring HTTP/HTTPS traffic between a web browser and a web server.
           
     - [x] INTERNET-GATEWAY :- The Internet Gateway (IGW) is a horizontally scaled, redundant, and highly available AWS service that 
           allows communication between instances in the virtual private cloud (VPC) and the internet.
           
     - [x] LOAD-BALANCERS :- Load balancers in AWS are managed services that distribute incoming network traffic across multiple 
           instances or resources to ensure high availability, fault tolerance, and optimal performance for applications. In this 
           project, 2 application load balancers were used. An internet-facing application load-balancer was used to distribute traffic 
           from the internet to the compute instances in the presentation layer. while an internal application load-balancer was used to 
           distribute traffic from the presentation layer compute instances to the application layer compute instances. The load- 
           balancers target the instances in the autoscaling groups, which enables horizontal scaling of computes according to traffic.  
           
     - [x] CLOUD-WATCH-ALARM AND SNS_TOPIC :- AWS Cloud-Watch Alarm together with SNS Topic and Subscription were configured to monitor 
           the cpu-usage of the instances in the presentation-layer and application_layer. The metrics pulled were sent to an 
           administrative email for notification.
           
     - [x] MULTI-AZ RDS INSTANCES :- A RELATIONAL DATABASE INSTANCE was configured with the multi-availability zone option provided by 
           AWS. The Multi-AZ deployment provides enhanced availability and fault tolerance for the RDS database by replicating the 
           database to a standby instance in a different Availability Zone within the same AWS Region. Incase the primary data-base 
           fails, it fails-over to the standby data-base automatically. Storage encyption was enabled to enhance data-base security, when 
           the data in the storage is at rest state or in transit.
           
     - [x] KMS-KEY :-  AWS Key Management Key was created to manage, and use encryption keys to protect the data in the RDS instances. It 
           enables for seamless encryption and decryption of data in the storage.
           
     - [x] PRESENTATION_LAYER :- This logical layer is responsible  for the user interface, and interacts directly with the end-users. It 
           is typically implemented using a web server and load balancer to serve static content and forward requests to the Application 
           Layer. It consists of two public accessible subnets by default.
           The presentation Layer consists of the following resources:

          -  NAT-GATEWAY :- The Network Address Translator in AWS, enables the instances in a private subnet to  communicate with the 
             internet or other AWS services while preventing inbound traffic initiated from the internet to reach the instances directly.

          -  LAUNCH-TEMPLATE AND AUTOSCALING GROUP :- An AWS Launch Template is a configuration template that defines the various 
             parameters needed to launch EC2 instances. An AWS Auto Scaling group is a core component of Amazon Web Services (AWS) that 
             helps automatically scale instances based on demand. It enables the maintenance of a desired number of instances in an 
             Amazon Elastic Compute Cloud (EC2) fleet and automatically adjusts the capacity to meet changing application needs.
  
     - [x] APPLICATION_LAYER :- This logical layer handles the business logic and application functionalities. It handles user requests 
           from the Presentation Layer, communicates with the Data Layer, and returns processed data to the Presentation Layer. This 
           layer consists of two private subnets by default. The instances created in this subnet are publicly inaccessible.
           The application layer also consists of the Launch-Template and Autoscaling Group as in the presentation_layer.
           
     - [x] DATA_LAYER :- This is the bottom layer that deals with data storage and retrieval. It hosts databases and handles all data- 
           related operations, such as data encryption and decryption.

           
### PREREQUISITES

- An AWS account with appropriate IAM permissions. Recommendable, create a user with administrative privileges globally. This would 
  enable seamless transitioning between regions while provisioning multi-regional resources.
- Terraform installed on your local machine.
- Basic knowledge of AWS services, Terraform, and Networking concepts.

### REQUIREMENTS

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | => 4.0 |

### PROVIDERS

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

### MODULES 
I have created modules for the resources required to create the three-tier-architecture. This was done to enable reusability of specific resources across different projects and environments. This promotes consistency and reduces duplication of effort.

#### Click On The Module To Check variables description in the variables.tf file

- [x] [Backend(Required For Multi-team deployment, else optional)](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/tree/master/Backend)
- [X] [Cloudwatch_alarm(Optional)](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/tree/master/modules/Cloudwatch_Alarm)
- [X] [KMS(Optional IF storage_encryption is set to False)](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/tree/master/modules/KMS)
- [X] [WAF(Optional)](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/tree/master/modules/WAF)
- [X] [Compute(Required)](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/tree/master/modules/Compute)
- [X] [Load-Balancer(Required)](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/tree/master/modules/Load-Balancer)
- [X] [Network(Required)](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/tree/master/modules/Network)
- [X] [RDS(Required)](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/tree/master/modules/RDS)
- [X] [Route_53(Required)](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/tree/master/modules/Route_53)
- [X] [RDS_read_replica(Optional)](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/tree/master/modules/RDS_read_replica)

### DEPLOYMENT STEPS
The method of Deployment can be divided into two :-
- [x] Multi-Team deployment with Remote State Management using S3 and Dynamo-DB
- [x] Deployment without Remote State Management

## MULTI-TEAM DEPLOYMENT 
- STEP 1 : -  Clone Repository Into Local Machine

  ```
  $ sudo git clone https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE.git
  ```

- STEP 2 : - Open The THREE-TIER-ARCHITECTURE Folder On Your Local Machine and edit the variables.tf, main.tf, and output.tf files in 
             the modules to suit your use-case.
- STEP 3 : - Also Edit The Backend Module, main.tf, variable.tf, and output.tf In The project Root Directory To Suit Your Use-Case.
- STEP 4 : - Enable Remote State and State-Lock With S3 And Dynamodb, This would Enable Remote State Management Of The .tfstate files.

  ```
  $ cd path/to/THREE-TIER-ARCHITECTURE/Backend
  ```

  ```
  path/to/THREE-TIER-ARCHITECTURE/Backend$ terraform init
  ```
  
  ```
  path/to/THREE-TIER-ARCHITECTURE/Backend$ terraform plan
  ```
  
  ```
  path/to/THREE-TIER-ARCHITECTURE/Backend$ terraform apply -auto-approve
  ```
- STEP 5 : - Wait Until The Process Is Completed
- STEP 6 : - Return To The Project Root Directory

  ```
  path/to/THREE-TIER-ARCHITECTURE/Backend$ cd ..
  ```
- STEP 7 : - Open The main.tf file, And Validate All Inputs. Sample Usage: -

  ```
   terraform {
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 5.0"
       }
     }
     backend "s3" {
       bucket = "cloudgen-bucket"
       region = "us-east-1"
       key = "region-1/terraform.tfstate"
       dynamodb_table = "state_lock"
     }
   }
   
   # Configure the AWS Provider
   provider "aws" {
     region = var.region
   }
   
   # NETWORK MODULE SECTION
   
   module "Network" {
     source = "./modules/Network"
   }
   
   # COMPUTE MODULE SECTION
   
   module "Compute" {
     source                     = "./modules/Compute"
     public_cidrs               = module.Network.public_cidrs
     app_private_cidrs          = module.Network.app_private_cidrs
     presentation_layer_sg      = module.Network.presentation_layer_sg
     application_layer_sg       = module.Network.application_layer_sg
     presentation_layer_subnets = module.Network.presentation_layer_subnet
     application_layer_subnets  = module.Network.application_layer_subnet
     key_name                   = var.key_name
     presentation_layer_tg_arn  = module.Load-Balancer.presentation_layer_tg_arn
     application_layer_tg_arn   = module.Load-Balancer.application_layer_tg_arn
   }
   
   # LOAD-BALANCER MODULE SECTION
   
   module "Load-Balancer" {
     source                    = "./modules/Load-Balancer"
     vpc_id                    = module.Network.vpc_id
     public_cidrs              = module.Network.public_cidrs
     app_private_cidrs         = module.Network.app_private_cidrs
     presentation_layer_subnet = module.Network.presentation_layer_subnet
     application_layer_subnet  = module.Network.application_layer_subnet
     presentation_layer_lb_sg  = module.Network.presentation_layer_lb_sg
     alb_sg                    = module.Network.alb_sg
     presentation_layer_asg_id = module.Compute.presentation_layer_asg_id
     application_layer_asg_id  = module.Compute.application_layer_asg_id
   }
   
   # KMS MODULE SECTION
   
   module "KMS" {
     source = "./modules/KMS"
   }
   
   # RDS INSTANCE MODULE SECTION 
   
   module "RDS" {
     source               = "./modules/RDS"
     vpc_id               = module.Network.vpc_id
     db_private_subnet_id = module.Network.data_layer_subnet
     data_layer_sg        = module.Network.data_layer_sg
     kms_key_id           = module.KMS.kms_key_id
     db_name = var.db_name 
     username = var.username
     password = var.password
   }
   
   # CLOUDWATCH ALARM
   
   module "CloudWatch" {
     source                                    = "./modules/Cloudwatch_Alarm"
     data_layer_instance_id                    = module.RDS.rds_instance_id
     presentation_layer_autoscaling_group_name = module.Compute.presentation_layer_autoscaling_group_name
     application_layer_autoscaling_group_name  = module.Compute.application_layer_autoscaling_group_name
     endpoint                                  = "sample@email.com"
   }
   
   # WAF MODULE SECTION
   
   module "WAF" {
     source  = "./modules/WAF"
     alb_arn = module.Load-Balancer.presentation_layer_lb_arn
   }
   
   # ROUTE_53 MODULE SECTION
   
   module "Route_53" {
     source                     = "./modules/Route_53"
     presentation_layer_lb_dns  = module.Load-Balancer.presentation_layer_lb_dns
     presentation_layer_zone_id = module.Load-Balancer.presentation_layer_lb_zone_id
     domain_name                = "domainname.com"
   }
 
  ```
- STEP 8 : - Deploy The Three-Tier-Architecture Infrastructure To AWS. 
  
  ```
  path/to/THREE-TIER-ARCHITECTURE$ terraform init
  ```
  
  ```
  path/to/THREE-TIER-ARCHITECTURE$ terraform plan
  ```
  
  ```
  path/to/THREE-TIER-ARCHITECTURE$ terraform apply -auto-approve
  ```
- STEP 9 :- The Entire Process Might Take Approximately 25mins Atmost Depending On Network Connection !!!! Just Be Patient
- STEP 10 :- Once The Process Is Completed, Log Into Your AWS Management Console And Verify All Resources Are Created !!

## FOR DEPLOYMENT WITHOUT REMOTE STATE MANAGEMENT

- STEP 1 : -  Clone Repository Into Local Machine

  ```
  $ sudo git clone https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE.git
  ```
- STEP 2 : - Open The THREE-TIER-ARCHITECTURE Folder On Your Local Machine and edit the variables.tf, main.tf, and output.tf files in 
             the modules to suit your use-case.
    ```
  $ cd path/to/THREE-TIER-ARCHITECTURE
  ```
- STEP 3 : - Also Edit The Modules, main.tf, variable.tf, and output.tf, With The Exception Of The Backend Module In The project Root 
             Directory To Suit Your Use-Case.
- STEP 4 : - Open The main.tf file, And Verify All Inputs. Sample Usage: -

  ```
   terraform {
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 5.0"
       }
     }
   /*   backend "s3" {
          bucket = "cloudgen-bucket"
          region = "us-east-1"
          key = "region-1/terraform.tfstate"
          dynamodb_table = "state_lock"
     } */
   }
   
   # Configure the AWS Provider
   provider "aws" {
     region = var.region
   }
   
   # NETWORK MODULE SECTION
   
   module "Network" {
     source = "./modules/Network"
   }
   
   # COMPUTE MODULE SECTION
   
   module "Compute" {
     source                     = "./modules/Compute"
     public_cidrs               = module.Network.public_cidrs
     app_private_cidrs          = module.Network.app_private_cidrs
     presentation_layer_sg      = module.Network.presentation_layer_sg
     application_layer_sg       = module.Network.application_layer_sg
     presentation_layer_subnets = module.Network.presentation_layer_subnet
     application_layer_subnets  = module.Network.application_layer_subnet
     key_name                   = var.key_name
     presentation_layer_tg_arn  = module.Load-Balancer.presentation_layer_tg_arn
     application_layer_tg_arn   = module.Load-Balancer.application_layer_tg_arn
   }
   
   # LOAD-BALANCER MODULE SECTION
   
   module "Load-Balancer" {
     source                    = "./modules/Load-Balancer"
     vpc_id                    = module.Network.vpc_id
     public_cidrs              = module.Network.public_cidrs
     app_private_cidrs         = module.Network.app_private_cidrs
     presentation_layer_subnet = module.Network.presentation_layer_subnet
     application_layer_subnet  = module.Network.application_layer_subnet
     presentation_layer_lb_sg  = module.Network.presentation_layer_lb_sg
     alb_sg                    = module.Network.alb_sg
     presentation_layer_asg_id = module.Compute.presentation_layer_asg_id
     application_layer_asg_id  = module.Compute.application_layer_asg_id
   }
   
   # KMS MODULE SECTION
   
   module "KMS" {
     source = "./modules/KMS"
   }
   
   # RDS INSTANCE MODULE SECTION 
   
   module "RDS" {
     source               = "./modules/RDS"
     vpc_id               = module.Network.vpc_id
     db_private_subnet_id = module.Network.data_layer_subnet
     data_layer_sg        = module.Network.data_layer_sg
     kms_key_id           = module.KMS.kms_key_id
     db_name = var.db_name 
     username = var.username
     password = var.password
   }
   
   # CLOUDWATCH ALARM
   
   module "CloudWatch" {
     source                                    = "./modules/Cloudwatch_Alarm"
     data_layer_instance_id                    = module.RDS.rds_instance_id
     presentation_layer_autoscaling_group_name = module.Compute.presentation_layer_autoscaling_group_name
     application_layer_autoscaling_group_name  = module.Compute.application_layer_autoscaling_group_name
     endpoint                                  = "sample@email.com"
   }
   
   # WAF MODULE SECTION
   
   module "WAF" {
     source  = "./modules/WAF"
     alb_arn = module.Load-Balancer.presentation_layer_lb_arn
   }
   
   # ROUTE_53 MODULE SECTION
   
   module "Route_53" {
     source                     = "./modules/Route_53"
     presentation_layer_lb_dns  = module.Load-Balancer.presentation_layer_lb_dns
     presentation_layer_zone_id = module.Load-Balancer.presentation_layer_lb_zone_id
     domain_name                = "domainname.com"
   }
 
  ```
- STEP 5 : - Deploy The Three-Tier-Architecture Infrastructure To AWS. 
  
  ```
  path/to/THREE-TIER-ARCHITECTURE$ terraform init
  ```
  
  ```
  path/to/THREE-TIER-ARCHITECTURE$ terraform plan
  ```
  
  ```
  path/to/THREE-TIER-ARCHITECTURE$ terraform apply -auto-approve
  ```
- STEP 6 :- The Entire Process Might Take Approximately 25mins Atmost Depending On Network Connection !!!! Just Be Patient
- STEP 7 :- Once The Process Is Completed, Log Into Your AWS Management Console And Verify All Resources Are Created !!

## RELATIONAL DATABASE (RDS) READ_REPLICA DEPLOYMENT (OPTIONAL)
This Deployment Is Optional, And Is Applicable To All Deployment Use-Cases (Multi-Team Deployment With Remote State Management And Deployment Without Remote State Management) !!

In Summary, An AWS Read_Replica Is A DataBase Service Provided By AWS To Enable Duplication Of A Master DataBase Instance In The Same Region Or Different Region. This Replica Is A Read-Only Dupicate Of The Master DataBase Instance. For A Cross-Regional Read_Replica, In This Project Use-Case, Serves The Sole Purpose Of Backing Up The Master DataBase In The Source Region Incase Of Disasters. In the event Of A Disaster In The Primary Region, The cross-regional Read_Replica Can Be Promoted To Become The New Primary Instance, Thus Minimizing Downtime And Data Loss.

## STEPS TO DEPLOY A CROSS-REGIONAL READ_REPLICA RDS INSTANCE

STEP 1 : - The source_db_instance ARN Is Required By The Read_Replica To Connect Across Region With The Master RDS. Log Into Your AWS account, Search For The RDS Management Console In The Source Region, Which Is By Default "us-east-1". Select The RDS Matching The Idenfier. Click On The Configuration tab, Navigate until you Find The ARN. Copy The ARN and Paste Somewhere Safe For Future Reference.
There Are Other ways To  Get The Source_db ARN :

   - [x] An Amazon Resource Name Can Be Constructed Using The Following Syntax:

     ```
     arn:aws:rds:<region>:<aws account Number>:<resourcetype>:<identifier>
     ```
     In Our Use-Case,

     arn:aws:rds:us-east-1:123456789012:db:db-identifier

NOTE !!! The Identifier Is Equivalent To The [var.rds_identifier](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/blob/master/modules/RDS/variable.tf) declared in RDS module variable.tf file.

STEP 2 : - Open The cloned THREE-TIER-ARCHITECTURE Directory In Your Local Machine, Locate modules sub-directory And Open The 
           RDS_read_replica module. 

           $ path/to/THREE-TIER-ARCHITECTURE/modules/RDS_read_replica
STEP 3 :- Open The variables.tf File And Paste The Source_db_arn in The default placeholder. For Instance;

              variable "source_db_arn" {
                  type = string
                  default = "arn:aws:rds:us-east-1:123456789012:db:db-identifier"     
        
                  # Example of source_db_arn arn:aws:rds:us-east-1:123456789012:db:db-identifier
              }
STEP 4 :- Edit The .tf Files To Suit Your Use-Case, Ensure All Changes Are Saved.

NOTE :- The Default Region Of The Read_replica is "us-west-2". 

STEP 5 :- Deploy The RDS_read_replica.

           path/to/THREE-TIER-ARCHITECTURE/modules/RDS_read_replica$ terraform init
           
           path/to/THREE-TIER-ARCHITECTURE/modules/RDS_read_replica$ terraform plan

           path/to/THREE-TIER-ARCHITECTURE/modules/RDS_read_replica$ terraform apply -auto-approve
         
STEP 6 :- Wait Until The Process Is Completed!!! This Process Might Take Approximately 25mins. 

STEP 7 :- Log Into Your Management Console, On The Top Left Corner Of The Navigation Bar, Click The Drop-Down And Switch To The Region 
          Where The Read_replica was created. 
STEP 8 :- Verify All Resources Were Created.

## DEFAULT OUTPUT OF THE THREE-TIER-ARCHITECTURE

| NAME | DESCRIPTION | DEFAULT REGION | REQUIRED |
|------|-------------|-----------------|:--------:|
|[cloudgen-s3](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/blob/master/Backend/s3.tf) | AWS S3 Bucket To Store .tfstate Files Remotely. | us-east-1 | Optional |
|[dynamodb](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/blob/master/Backend/dynamodb.tf) | Dynamodb database to enable state locking | us-east-1 | Optional |
|[aws_sns_topic](https://github.com/ogunleye0720/THREE-TIER-ARCHITECTURE/blob/master/modules/Cloudwatch_Alarm/main.tf?plain=1#L2-5) | Dynamodb database to enable state locking | us-east-1 | Optional |
