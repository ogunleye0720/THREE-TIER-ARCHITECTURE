# THREE-TIER-ARCHITECTURE

## INTRODUCTION
This documentation provides an overview and step-by-step guide to deploy a Three-Tier Architecture on AWS using Terraform. The Three-Tier Architecture consists of three logical layers: Presentation layer, Application layer, and Data layer. Each layer is designed to handle specific functions, promoting modularity, scalability, availability, resilience and maintainability.

## ARCHITECTURE OVERVIEW
- PRESENTATION LAYER : This logical layer is responsible  for the user interface, and interacts directly with the end-users. It is typically implemented using a web server or load balancer to serve static content and forward requests to the Application Layer.
- APPLICATION LAYER : ThI logical layer handles the business logic and application functionalities. It handles user requests from the Presentation Layer, communicates with the Data Layer, and returns processed data to the Presentation Layer.
- DATA LAYER : This is the bottom layer that deals with data storage and retrieval. It hosts databases and handles all data-related operations.
