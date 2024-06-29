Pre-requisite : 
1. S3 bucket needs to be created/present before using this code. 
2. Create table name "terraform-lock" in DynamoDB with partition key as LockID (String)


This configuration will,
1. Use remote backend as S3 and store tfstate in S3 
2. Created Security Group and EC2 instance 


