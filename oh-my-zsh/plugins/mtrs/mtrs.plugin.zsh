# Exports

export CLOUD_ENV=local
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

# Aliases

## AWS CDK

alias cdk1="npx aws-cdk@1.x"
alias cdk="npx aws-cdk@2.x"
 
## AWS CLI

## Docker

alias dkr='docker'
alias dkr-stop-all='dkr stop $(dkr ps -aq)'
alias dkr-rm-all='dkr rm $(dkr ps -aq)'
alias dkr-rmi-all='dkr rmi $(dkr images -aq)'
alias dkrc='docker compose'

## Kubernetes

alias kctl="kubectl"
alias kctx="kubectl config use-context"
alias kctx-curr="kubectl config current-context"
alias kust="kustomize"
alias pod-images="kubectl get pods --all-namespaces -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c"

## Utilities

alias my-ip="curl -fsSL ifconfig.me && echo"

## NPM

alias npm-links='npm ls -g --depth=0 --link=true'
alias npm-rm-nm='find . -name "node_modules" -exec rm -rf "{}" +'

## Terraform

alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'

# Functions

## AWS

## Docker

function dkr-rehost() {
    source=$1
    dest=$2
    docker pull $source
    docker tag $source $dest
    docker push $dest
}

## VS Code

## Cursor
