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

## GitHub Stacked PRs (ghs*)

alias ghsa='gh stack add'
alias ghsco='gh stack checkout'
alias ghsi='gh stack init'
alias ghsp='gh stack push'
alias ghsr='gh stack rebase'
alias ghsra='gh stack rebase --abort'
alias ghsrc='gh stack rebase --continue'
alias ghsru='gh stack rebase --upstack'
alias ghss='gh stack submit'
alias ghsv='gh stack view'
# navigation aliases
alias ghsnu='gh stack up'
alias ghsnd='gh stack down'
alias ghsnt='gh stack top'
alias ghsnd='gh stack bottom'

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
