## Introduction

This code will help you deploy nginx on ec2 instance by creating a vpc and its components, ec2, and elb in AWS Account (Account A).

Make a note that, the state file will be stored in a different account (Account B), it will not be stored in the same accout where infrastructure will be creaated.
Also, Dynamodb(Account B) table is used for state locking.


## Notes

1. Infra Account = Account A = Account where the infra will be created

   a. arn:aws:iam::175394936240:role/DeveloperRole

2. State Account = Account B = Account where the state file will be stored

   a. arn:aws:iam::837449071151:role/terraform-iac


## Prerequisites

1. S3 Bucket 837449071151-other-account in 837449071151

2. DynamoDB Table 837449071151-other-account-dynamodb in 837449071151

3. Backend assume Role arn:aws:iam::837449071151:role/terraform-iac in 837449071151

4. This Role arn:aws:iam::837449071151:role/terraform-iac must have sufficient pemissions on S3 bucket and dynamodb table.

3. Role arn:aws:iam::837449071151:role/terraform-iac Trust Relationship

```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::175394936240:role/DeveloperRole"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }  
```

4. Change the role_arn in backend.tf file in case you are using some other account to store the state in the s3 bucket.

5. Policy in the role that Lazsa will assume. This Role must have sufficient permissions(S3 and Assume Role) to perform action in 837449071151

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListStorageLensConfigurations",
                "s3:ListAccessPointsForObjectLambda",
                "s3:GetAccessPoint",
                "s3:PutAccountPublicAccessBlock",
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAllMyBuckets",
                "s3:ListAccessPoints",
                "s3:PutAccessPointPublicAccessBlock",
                "s3:ListJobs",
                "s3:PutStorageLensConfiguration",
                "s3:ListMultiRegionAccessPoints",
                "s3:CreateJob"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::837449071151-other-account/*"
        }
    ]
}
```

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sts:*",
            "Resource": "*"
        }
    ]
}
```

## Inputs

| Name | Value | Note |
|------|------| ------|
| TF_VERSION | 1.1.9 | |
| GIT_BRANCH | master | |
| Non-sensitive TERRAFORM_VARIABLES sample run 1 input| -var aws_amis=ami-08d4ac5b634553e16 -var instance_name=terraform-iac-instance -var elb_name=terraform-iac-elb -var sg_name=terraform-iac-sg -var elb_sg_name=terraform-iac-elb-sg -var vpc_name=terraform-iac-vpc -var vpc_cidr=10.0.0.0/16 -var subnet_range=10.0.1.0/24 -var key_name=terraform-iac-demo | Change value of elb_name, vpc_cidr, subnet_range, key_name for each run | 
| Non-sensitive TERRAFORM_VARIABLES sample run 2 input| -var aws_amis=ami-08d4ac5b634553e16 -var instance_name=terraform-iac-instance -var elb_name=terraform-iac-elb-qa -var sg_name=terraform-iac-sg -var elb_sg_name=terraform-iac-elb-sg -var vpc_name=terraform-iac-vpc -var vpc_cidr=10.1.0.0/16 -var subnet_range=10.1.1.0/24 -var key_name=terraform-iac-demo-qa | Change value of elb_name, vpc_cidr, subnet_range key_name for each run | 
| Sensitive TERRAFORM_VARIABLES | -var public_key_path=./id_rsa.pub -var private_key_path=./id_rsa | |
| Non-sensitive ENVIRONMENT_VARIABLES sample run 1 input | -e TF_WORKSPACE=dev | change value of TF_WORKSPACE for each run  |
| Non-sensitive ENVIRONMENT_VARIABLES sample run 1 input | -e TF_WORKSPACE=qa | change value of TF_WORKSPACE for each run  |
| Sensitive ENVIRONMENT_VARIABLES | -e TF_LOG=trace | |
| TERRAFORM_ROOT_FOLDER_PATH | sample-app | |

