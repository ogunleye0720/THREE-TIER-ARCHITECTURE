# THREE-TIER-ARCHITECTURE

## INTRODUCTION
This documentation provides an overview and step-by-step guide to deploy a Three-Tier Architecture on AWS using Terraform. The Three-Tier Architecture consists of three logical layers: Presentation layer, Application layer, and Data layer. Each layer is designed to handle specific functions, promoting modularity, scalability, availability, resilience and maintainability.

## ARCHITECTURE OVERVIEW
- PRESENTATION LAYER : This logical layer is responsible  for the user interface, and interacts directly with the end-users. It is typically implemented using a web server and load balancer to serve static content and forward requests to the Application Layer.
    - [x] NAT-GATEWAY :- The Network Address Translator in AWS, enables the instances in a private subnet to  communicate with the internet or other AWS services while preventing inbound traffic initiated from the internet to reach the instances directly.
    - [x] LAUNCH-TEMPLATE AND AUTOSCALING GROUP :- An AWS Launch Template is a configuration template that defines the various parameters needed to launch EC2 instances. An AWS Auto Scaling group is a core component of Amazon Web Services (AWS) that helps automatically scale instances based on demand. It enables the maintenance of a desired number of instances in an Amazon Elastic Compute Cloud (EC2) fleet and automatically adjusts the capacity to meet changing application needs.
  
- APPLICATION LAYER : ThI logical layer handles the business logic and application functionalities. It handles user requests from the Presentation Layer, communicates with the Data Layer, and returns processed data to the Presentation Layer.
- DATA LAYER : This is the bottom layer that deals with data storage and retrieval. It hosts databases and handles all data-related operations, such as data encryption and decryption.
- 
## PREREQUISITES
- An AWS account with appropriate IAM permissions. Recommendable, create a user with administrative privileges globally. This would enable seamless transitioning between regions while provisioning multi-regional resources.
- Terraform installed on your local machine.
- Basic knowledge of AWS services, Terraform, and Networking concepts.
