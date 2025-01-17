# Exports

export CLOUD_ENV=local
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export CLICK_REPOS_DIR=~/Code/click

# Aliases

## AWS CDK

alias cdk1="npx aws-cdk@1.x"
alias cdk="npx aws-cdk@2.x"
 
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
alias dkr-login-cicd-np='aws --profile cicd-np-org ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 561618220790.dkr.ecr.us-east-1.amazonaws.com'
alias dkr-login-155-np-us='aws --profile ct155-np-us-org ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 616418525936.dkr.ecr.us-east-1.amazonaws.com'
alias dkr-login-155-pd-us='aws --profile ct155-pd-us ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 343335910610.dkr.ecr.us-east-1.amazonaws.com'
alias dkr-login-152-dev-us='aws --profile ct152-dev-us ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 358341525847.dkr.ecr.us-east-1.amazonaws.com'
alias dkr-login-sbx='aws --profile sbx-org ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 249738588392.dkr.ecr.us-east-1.amazonaws.com'
alias dkrc='docker compose'
alias dkrc-ci='dkrc -f docker-compose-ci.yml'
alias dkrc-sys='dkrc -f docker-compose-sys.yml'

## Kubernetes

alias kctl="kubectl"
alias kctx="kubectl config use-context"
alias kctx-curr="kubectl config current-context"
alias kust="kustomize"
alias pod-images="kubectl get pods --all-namespaces -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c"
alias argo-pf="kubectl port-forward svc/argocd-server -n argo 8080:443"
alias argo-li-np="argocd login argocd.clicktherapeuticsdev.com --grpc-web-root-path / --sso"
alias argo-li-pd="argocd login argocd.clicktherapeutics.com --grpc-web-root-path / --sso"

## Utilities
alias my-ip="echo $(curl --silent ifconfig.me)"

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

aws-cfn-report() {
  aws cloudformation describe-stacks \
    --query 'Stacks[*].{Name:StackName,Description:Description}' \
    --output table
}

aws-mfa-session-set() {
  mfa_code=$1

  if [ -z "$mfa_code" ]; then
    echo 'Error: please provide an MFA code from your authenticator app'
    return 1
  fi

  mfa_session_creds=$(aws --profile ltd sts get-session-token --serial-number arn:aws:iam::418480071957:mfa/matthew_limited --token-code $mfa_code)

  export AWS_ACCESS_KEY_ID=$(echo $mfa_session_creds | jq -r .Credentials.AccessKeyId)
  export AWS_SECRET_ACCESS_KEY=$(echo $mfa_session_creds | jq -r .Credentials.SecretAccessKey)
  export AWS_SESSION_TOKEN=$(echo $mfa_session_creds | jq -r .Credentials.SessionToken)

  echo "AWS MFA Session Identity:"
  aws sts get-caller-identity

  return 0
}

aws-mfa-session-unset() {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
}

## Docker

function dkr-rehost() {
    source=$1
    dest=$2
    docker pull $source
    docker tag $source $dest
    docker push $dest
}

## VS Code

code-click() { code $CLICK_REPOS_DIR/$1 }
