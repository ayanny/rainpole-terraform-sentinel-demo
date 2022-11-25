# sentinel-policies Explained

Policy as Code allows organizations to enforce specific behaviors and best practices in an automated fashion to provide instaneous feedback for developers. This provides a more predictable and secure experience for organizations and developers. 

Planet Express has four primary objectives to complete using Policy as Code with Sentinel 

1) Reduce Cloud spend without sacrificing performance

  In order to reduce cloud spend we must first understand where we are spending too much money. As Planet Express's DevOps team increased in size and responsibilities appropriate instance sizing per tier type was eschewed in favor of using a single t2.large instance type. In working with leaders from the DevOps team we have been able to identify a list of requirements per tier of FakeService based on both Production and Development workloads that have been correlated to optimal aws instance types. This list is below : 

  Tier Type | Environment | Instance Type
  Web         Prod          t2.small
  Web         Dev           t2.micro
  Api         Prod          t2.medium
  Api         Dev           t2.small
  Cache       Prod          t3.medium
  Cache       Dev           t2.medium
  Pay         Prod          t3.small
  Pay         Dev           t2.small
  Data        Prod          t3.large
  Data        Dev           t3.medium

  Sentinel policies restrict-ec2-instance-type-<APP> contain both Prod and Dev instance types and look for any EC2 instances that are created with the Application/<APP> tag or tag_all and then compare with the allowed values for their instance_type

  Sentinel policies restrict-ec2-instance-enviornment contains two sets of values. One for Production, one for Development. The appropriate list is checked against all EC2 instances with an Environment tag of "prod" or "dev" to ensure only instance_types from the allowed list are used.

2) Restrict production changes during peak hours

  Peak hours for Planet Express have been defined as 5am - 8pm EST every day. The Sentinel policy restrict-production-deployment-times checks for any resources being created, updated or deleted that contain a tag of Environment/prod. If this policy detects changes to any production resources during peak hours the policy will fail. This policy is set soft-mandatory and can be overridden in TFC. 

3) Provide guaranteed way to audit environments

  In order to properly report based on Environment type Planet Express needs to be able to ensure that all EC2 resources are created with the appropriate tags. The sentinel policy check-ec2-environment-tags-all is an extension of an official Hashicorp Sentinel Example (https://raw.githubusercontent.com/hashicorp/terraform-sentinel-policies/main/aws/check-ec2-environment-tag.sentinel). 

  This was created out of necessity due to the way that Planet Express creates their EC2 instances. Although the AWS provider default_tags value is set in the provider.tf configuration the way that the provider actually adds tags to these resources is with an attribute of tags_all, rather than tags.

  check-ec2-environment-tags-all.sentinel checks all EC2 instances for a key or tags or tags_all and compares it with a list of allowed values. So long as both tags or tags_all does not evaluate to false the policy will pass

4) Ensure latest security patches are applied

  This objective requires two sentinel policies to accomplish. The first policy restrict-ami-owners is a default example from Hashicorp that was easily integrated into this workspace that ensures only the Canonical AMI Owner is used for Ubuntu based AMIs. 

  The second policy require-most-recent-AMI-version.sentinel ensures that only the latest version of an AMI is used. In combination with the the previous policy we can ensure that only the latest versions of the official Ubuntu image are used which will include the latest security patches. 

# sentinel.hcl Explained

  This is the "configuration" file for sentinel policies. Defining a policy in this file will add it to the list of currently enforced policies in the workspace. 

  Sentinel Policies in TFC point to the /sentinel-policies/aws/ directory for sentinel.hcl
