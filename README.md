# Terraform AWS ECS Deploy Pipeline

##  Architecture
<img src="https://github.com/nana808-git/actions/blob/master/.github/workflows/sleestak.png?raw=true" width="650px">

### Resources:
1. Codepipeline
2. Elastic Container Services
3. MariaDB RDS
4. s3 Bucket
5. Cloudfront
6. Cloudwatch
7. IAM

### Architecture Overview
 * Sleestack image built with GitHub actions pushed to Amazon ECR
 * Cloudwatch event rule triggers Codepipeline build with "PUT IMAGE" action
 * Image deployed to ECS fargate spins up two replicas of ECS task definition
 * AWS load balancer in front of ECS fargate serves as backend api endpoint
 * s3 bucket host front end react-app static website
 * Cloudfront serves as reverse proxy for both s3 bucket static website and load balancer api endpoint.


### Infrastructure Setup - Teraform provisioned
 * module VPC - provisions VPC network and all components needed
 * module RDS - provisions MariaDB database in private subnet
 * module CDN - provisions Cloudfront, s3 bucket, Route 53
 * module ECS - provisions ECS Fargate, Service, Load Balacers
 * module PIPELINE - provisions Codepipeline and all components
 * module ECS-PIPELINE - spins up modules RDS, CDN, ECS, PIPELINE

### Issues
1. Cloudfront as proxy not conecting. Alternate solution ,ay be proposed.
2. 
3. 
4. 
5. TO BE UPDATED