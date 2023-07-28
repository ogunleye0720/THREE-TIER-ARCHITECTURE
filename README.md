#                                              THREE-TIER-ARCHITECTURE

## INTRODUCTION

This documentation provides an overview and step-by-step guide to deploy a Three-Tier Architecture on AWS using Terraform. The Three-Tier Architecture consists of three logical layers: Presentation layer, Application layer, and Data layer. Each layer is designed to handle specific functions, promoting modularity, scalability, availability, resilience and maintainability.

## ARCHITECTURE OVERVIEW

1. VIRTUAL PRIVATE CLOUD FOR REGION-1 : A Virtual Private Cloud (VPC) is a logically isolated virtual network in the cloud that allows 
   the provisioning and management of resources, such as compute instances, databases, and LoadBalancers, within a defined virtual 
   network.
  The VPC consists of the following resources:

     - [x] ROUTE-53:- This is a highly scalable and reliable Domain Name System (DNS) web service provided by Amazon Web Services (AWS).
           Its primary function is to route user request from the internet to the target resources, such as loadbalancers, and compute 
           instances. In this three-tier-architecture, the route53 is used to route user request from the internet to the internet-facing            load-balancers.
           
     - [x] WAF:- The Web Application Firewall is a service managed by AWS, it serves a primary function of  protecting web applications 
           from web exploits and security threats, such as Account Take-over, Bots, SQL-injecton, Cross-site scripting, by filtering and 
           monitoring HTTP/HTTPS traffic between a web browser and a web server.
           
     - [x] INTERNET-GATEWAY:- The Internet Gateway (IGW) is a horizontally scaled, redundant, and highly available AWS service that 
           allows communication between instances in the virtual private cloud (VPC) and the internet.
           
     - [x] LOAD-BALANCERS:- Load balancers in AWS are managed services that distribute incoming network traffic across multiple instances 
           or resources to ensure high availability, fault tolerance, and optimal performance for applications. In this project, 2 
           application load balancers were used. An internet-facing application load-balancer was used to distribute traffic from the 
           internet to the compute instances in the presentation layer. while an internal application load-balancer was used to 
           distribute traffic from the presentation layer compute instances to the application layer compute instances. The load- 
           balancers target the instances in the autoscaling groups, which enables horizontal scaling of computes according to traffic.  
           
     - [x] CLOUD-WATCH-ALARM AND SNS_TOPIC:- AWS Cloud-Watch Alarm together with SNS Topic and Subscription were configured to monitor 
           the cpu-usage of the instances in the presentation-layer and application_layer. The metrics pulled were sent to an 
           administrative email for notification.
           
     - [x] MULTI-AZ RDS INSTANCES:- A RELATIONAL DATABASE INSTANCE was configured, with the multi-availability zone option provided by 
           AWS. The Multi-AZ deployment provides enhanced availability and fault tolerance for the RDS database by replicating the 
           database to a standby instance in a different Availability Zone within the same AWS Region. Incase the primary data-base 
           fails, it fails-over to the standby data-base automatically. Storage encyption was enabled to enhance data-base security, when 
           the data in the storage is at rest state or in transit.
           
     - [x] KMS-KEY:-  AWS Key Management Key was created to manage, and use encryption keys to protect the data in the RDS instances. It 
           enables for seamless encryption and decryption of data in the storage.
           
     - [x] PRESENTATION_LAYER:- This logical layer is responsible  for the user interface, and interacts directly with the end-users. It 
           is typically implemented using a web server and load balancer to serve static content and forward requests to the Application 
           Layer. It consists of two public accessible subnets by default.
           The presentation Layer consists of the following resources:

          -  NAT-GATEWAY :- The Network Address Translator in AWS, enables the instances in a private subnet to  communicate with the 
            internet or other AWS services while preventing inbound traffic initiated from the internet to reach the instances directly.

          -  LAUNCH-TEMPLATE AND AUTOSCALING GROUP :- An AWS Launch Template is a configuration template that defines the various 
             parameters needed to launch EC2 instances. An AWS Auto Scaling group is a core component of Amazon Web Services (AWS) that 
             helps automatically scale instances based on demand. It enables the maintenance of a desired number of instances in an 
             Amazon Elastic Compute Cloud (EC2) fleet and automatically adjusts the capacity to meet changing application needs.
  
     - [x] APPLICATION_LAYER : This logical layer handles the business logic and application functionalities. It handles user requests 
           from the Presentation Layer, communicates with the Data Layer, and returns processed data to the Presentation Layer. This 
           layer consists of two private subnets by default. The instances created in this subnet are publicly inaccessible.
           
     - [x] DATA_LAYER : This is the bottom layer that deals with data storage and retrieval. It hosts databases and handles all data- 
           related operations, such as data encryption and decryption

           
## PREREQUISITES

- An AWS account with appropriate IAM permissions. Recommendable, create a user with administrative privileges globally. This would enable seamless transitioning between regions while provisioning multi-regional resources.
- Terraform installed on your local machine.
- Basic knowledge of AWS services, Terraform, and Networking concepts.
