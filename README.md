# **Rainpole-terraform-sentinel-demo**
Policy As Code using Terraform


Amir Yanny's Hashicorp - Senior Partner Solution Engineer - Technical Exercise

This directory and it's contents were created to demonstrate Policy as Code workflows and enforcements using AWS and Terraform Cloud with Sentinel. The goal of this exercise is to demonstrate how Sentinel policies can enforce best practices like resource tagging, instance sizing and restrict deployment times based on dynamic criteria like tags.


## **Bussiness Objectives**

Rainpole is a multi international transportation company obsessed with customer satisfaction and technical innovation. Rainpole has grown rapidly in the past 12 months with their DevOps team expanding from a single individual to a global team of dozens. During this accelerated growth period Rainpole prioritized innovation and deadlines over best practices.

Recent events have caused Rainpole leadership to reasses the current direction of development practices. Four primary initiatives have been identified to improve Rainpole's Cloud Operating Model.

1- Reduce Cloud spend without sacrificing performance

2- Restrict Production changes during peak hours

3- Provide guaranteed way to audit environments (Dev/Prod)

4- Ensure latest security patches are applied

## **Application (FakeService) Explained**

FakeService (https://github.com/nicholasjackson/fake-service) is a customizable solution that demonstrates application dependencies through either HTTP or GRPC connections.

FakeService is a mission critical application for Rainpole that front ends all customer inquiries and payments for shipping requests. There are five tiers to the application:

**Web** : Pubicly accessible web instances that customers directly connect to

**Api** : Backend for Web services, Api services talk to both cache and pay instances

**Cache** : Repository of data for Api retrieval

**Pay** : Accepts and verifies payments

**Data** : Database backend for Cache

Each tier of FakeService is independently scalable from one another based on a variable of var."APPTYPE"count. All tiers of FakeService use a loadbalancer as an ingress for the service. Web instances are the only tier that uses a publicly accessible Loadbalancer, all other tiers use an internal Loadbalancer type.

Configuration of each instance is performed by cloud-init. See cloudinit"APP".yaml for specific instance configuration parameters.

## **Providers.tf Explained**

This defines the providers that will be used and the configuration of those providers. AWS login variables are set as variable sets in Terraform Cloud.

## **ec2.tf Explained**

This file first retrieves the most recent AMIs to be used in EC2 provisioning. A group of resource blocks define the type of instances that should be created. Each resource block correlates to a tier in FakeService.

Then an ssh key is created and associated with each instance that will be created

var."APP"instance are set in TFC per workspace as they are specific to the environment and cannot be overridden.

## **iam.tf Explained**

This file creates a role that will be used to allow SSM connections into AWS instances.

## **security.tf Explained**

This file creates the required security groups inside AWS for FakeService connectivity. Each security group is tailored to only allow the necessary port and CIDR ranges for each tier of the application. Although SSH service is defined it is not used in any resource configurations. This is by design as SSH access is typically only used for troubleshooting purposes.

## **variables.tf Explained**

Variables to be used in the terraform configuration. Variables environment and "APP"instance are configured in TFC workspaces as they are specific to the workspace they are being deployed in. TFC variables have the highest precedence and will not be overwritten.

## **loadbalancing.tf Explained**

Two different types of load balancers are created. First is a public load balancer that will consume a public elastic IP. Secondly are a number of internal load balancers that do not consume EIPs.

Target group resources are defined that will later have instances associated with them.

Create listeners that correlate to the appropriate port for each tier of FakeService.

Associate instances with target groups

## **networking.tf Explained**

This file creates the VCN and associated CIDR block that the rest of the networks and resources will consume. A data source retrieves the available AZ's which are used to keep load balancers and instances in the same AZ.

Networks are created for each tier of FakeService.

An Internet Gateway (DNAT/SNAT capabilties) is defined.

A NAT Gateway (SNAT capabilties) is defined and consumes one of the previoulsy created EIPs.

Route tables are defined for Public Networks (Internet Gateway) and Private Networks (NAT Gateway)

Route tables are associated with the appropriate networks depending on gateway type

## **cloudinitconfigs.tf Explained**

This file takes the contents of each cloudinit"APP".yaml and then base64 encodes it to be used during instance configuration with cloud-init

## **cloudinit"APP".yaml Explained**

These files are specific to the tier of the instance that is being deployed and describes the steps cloud-init should take in order to configure the instances to run their part of FakeServices

## **sentinel-policies Explained**

Policy as Code allows organizations to enforce specific behaviors and best practices in an automated fashion to provide instaneous feedback for developers. This provides a more predictable and secure experience for organizations and developers.

Rainpole has four primary objectives to complete using Policy as Code with Sentinel

### 1- Reduce Cloud spend without sacrificing performance

In order to reduce cloud spend we must first understand where we are spending too much money. As Rainpole's DevOps team increased in size and responsibilities appropriate instance sizing per tier type was eschewed in favor of using a single t2.large instance type. In working with leaders from the DevOps team we have been able to identify a list of requirements per tier of FakeService based on both Production and Development workloads that have been correlated to optimal aws instance types. This list is below :

Tier Type | Environment | Instance Type Web Prod t2.small Web Dev t2.micro Api Prod t2.medium Api Dev t2.small Cache Prod t3.medium Cache Dev t2.medium Pay Prod t3.small Pay Dev t2.small Data Prod t3.large Data Dev t3.medium

Sentinel policies restrict-ec2-instance-type-"APP" contain both Prod and Dev instance types and look for any EC2 instances that are created with the Application/"APP" tag or tag_all and then compare with the allowed values for their instance_type

Sentinel policies restrict-ec2-instance-enviornment contains two sets of values. One for Production, one for Development. The appropriate list is checked against all EC2 instances with an Environment tag of "prod" or "dev" to ensure only instance_types from the allowed list are used.

### 2- Restrict production changes during peak hours

Peak hours for Planet Express have been defined as 5am - 8pm EST every day. The Sentinel policy restrict-production-deployment-times checks for any resources being created, updated or deleted that contain a tag of Environment/prod. If this policy detects changes to any production resources during peak hours the policy will fail. This policy is set soft-mandatory and can be overridden in TFC.

### 3- Provide guaranteed way to audit environments

In order to properly report based on Environment type Rainpole's needs to be able to ensure that all EC2 resources are created with the appropriate tags. The sentinel policy check-ec2-environment-tags-all is an extension of an official Hashicorp Sentinel Example (https://raw.githubusercontent.com/hashicorp/terraform-sentinel-policies/main/aws/check-ec2-environment-tag.sentinel).

This was created out of necessity due to the way that Rainpole creates their EC2 instances. Although the AWS provider default_tags value is set in the provider.tf configuration the way that the provider actually adds tags to these resources is with an attribute of tags_all, rather than tags.

check-ec2-environment-tags-all.sentinel checks all EC2 instances for a key or tags or tags_all and compares it with a list of allowed values. So as long as both tags or tags_all does not evaluate to false the policy will pass

### 4- Ensure latest security patches are applied

This objective requires two sentinel policies to accomplish. The first policy restrict-ami-owners is a default example from Hashicorp that was easily integrated into this workspace that ensures only the Canonical AMI Owner is used for Ubuntu based AMIs.

The second policy require-most-recent-AMI-version.sentinel ensures that only the latest version of an AMI is used. In combination with the the previous policy we can ensure that only the latest versions of the official Ubuntu image are used which will include the latest security patches.

## **sentinel.hcl Explained**

This is the "configuration" file for sentinel policies. Defining a policy in this file will add it to the list of currently enforced policies in the workspace.

Workspaces in TFC point to the /sentinel-policies/aws/ directory for sentinel.hcl
