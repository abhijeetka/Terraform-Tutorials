This demo is basically going to create a ECR registry and push the image to this registry.


docker tag abhijeetka/golang-webapp 9999cccccc.dkr.ecr.us-west-1.amazonaws.com/ecr_demo:1.0

ECR Login
aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 33333eddede.dkr.ecr.us-west-1.amazonaws.com/ecr_demo