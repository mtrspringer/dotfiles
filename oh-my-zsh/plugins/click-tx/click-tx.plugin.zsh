# Exports

export CLOUD_ENV=local
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

# Aliases

## AWS CDK

alias cdk="npx aws-cdk"
alias cdk1="npx cdk"
 
## AWS CLI

alias aws-ec2-instance-ids='aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId"'
alias aws-ec2-instance-ids-dev='aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId" --filters "Name=tag:deployment-stage,Values=development"'
alias aws-ec2-instance-ids-beta='aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId" --filters "Name=tag:deployment-stage,Values=beta"'
alias aws-ec2-instance-ids-prod='aws --profile prod-god ec2 describe-instances --query "Reservations[].Instances[].InstanceId" --filters "Name=tag:deployment-stage,Values=production"'

## Docker

alias dkr='docker'
alias dkr-stop-all='dkr stop $(dkr ps -aq)'
alias dkr-rm-all='dkr rm $(dkr ps -aq)'
alias dkr-rmi-all='dkr rmi $(dkr images -aq)'
alias dkr-login='aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 418480071957.dkr.ecr.us-east-1.amazonaws.com'
alias dkr-login-155-prod='aws --profile ct155_prod ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 343335910610.dkr.ecr.us-east-1.amazonaws.com'
alias dkr-login-152-dev='aws --profile ct152_dev ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 358341525847.dkr.ecr.us-east-1.amazonaws.com'
alias dkrc='docker-compose'
alias dkrc-ci='dkrc -f docker-compose-ci.yml'
alias dkrc-sys='dkrc -f docker-compose-sys.yml'

## Kubernetes

alias kctl="kubectl"
alias kctx="kubectl config use-context"
alias kctx-curr="kubectl config current-context"

## NPM

alias npm-links='npm ls -g --depth=0 --link=true'
alias npm-rm-nm='find . -name "node_modules" -exec rm -rf "{}" +'

# Functions

## AWS

aws-ec2-report() {
  aws ec2 describe-instances \
    --query 'Reservations[*].Instances[*].{Account:NetworkInterfaces[0].OwnerId,VPC:VpcId,Subnet:SubnetId,Name:Tags[?Key==`Name`]|[0].Value,Stage:Tags[?Key==`deployment-stage`]|[0].Value,InstanceId:InstanceId,Type:InstanceType,AZ:Placement.AvailabilityZone,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress}' \
    --output table
}
