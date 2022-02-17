# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/usr/local/sbin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="/Users/matthewspringer/.oh-my-zsh"
export ZSH_DISABLE_COMPFIX="true"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# general use
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# aws
alias build-ssh='ssh -i "~/.ssh/click-build-root.pem"'
alias aws='docker run --rm -it -v ~/.aws:/root/.aws -v ~/.kube:/root/.kube -v $(pwd):/aws amazon/aws-cli:latest'
alias aws-update='docker pull amazon/aws-cli:latest'
alias aws-ec2-instance-ids='aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId"'
alias cdk="npx aws-cdk"
alias cdk1="npx cdk"

# terraform
alias tf='terraform'

# TODO: this is not yet autoloaded

function aws-db-secrets() {
    stage=$1
    service=$2
    service_name="$stage-$service"
    # secret_arn=$(aws secretsmanager list-secrets --query "SecretList[?Name=='$service_name-secrets'].ARN | [0]")
    # echo $secret_arn
    var_prefix=${3:-'DB'}
    db_user_var=${var_prefix}_USERNAME
    db_pass_var=${var_prefix}_PASSWORD
    db_host_var=${var_prefix}_HOST
    db_port_var=${var_prefix}_PORT
    db_name_var=${var_prefix}_NAME
    if [ $stage = "production" ]; then
        echo "using AWS profile: prod-god"
        db_user_val=$(aws --profile=prod-god secretsmanager get-secret-value --secret-id $service_name-secrets | jq -r '.SecretString' | jq -r ".$db_user_var")
        db_pass_val=$(aws --profile=prod-god secretsmanager get-secret-value --secret-id $service_name-secrets | jq -r '.SecretString' | jq -r ".$db_pass_var")
        db_host_val=$(aws --profile=prod-god ecs describe-task-definition --task-definition $service_name --query "taskDefinition.containerDefinitions[0].environment[?name=='$db_host_var'] | [0]" | jq -r '.value')
        db_port_val=$(aws --profile=prod-god ecs describe-task-definition --task-definition $service_name --query "taskDefinition.containerDefinitions[0].environment[?name=='$db_port_var'] | [0]" | jq -r '.value')
        db_name_val=$(aws --profile=prod-god ecs describe-task-definition --task-definition $service_name --query "taskDefinition.containerDefinitions[0].environment[?name=='$db_name_var'] | [0]" | jq -r '.value')
    else
        db_user_val=$(aws secretsmanager get-secret-value --secret-id $service_name-secrets | jq -r '.SecretString' | jq -r ".$db_user_var")
        db_pass_val=$(aws secretsmanager get-secret-value --secret-id $service_name-secrets | jq -r '.SecretString' | jq -r ".$db_pass_var")
        db_host_val=$(aws ecs describe-task-definition --task-definition $service_name --query "taskDefinition.containerDefinitions[0].environment[?name=='$db_host_var'] | [0]" | jq -r '.value')
        db_port_val=$(aws ecs describe-task-definition --task-definition $service_name --query "taskDefinition.containerDefinitions[0].environment[?name=='$db_port_var'] | [0]" | jq -r '.value')
        db_name_val=$(aws ecs describe-task-definition --task-definition $service_name --query "taskDefinition.containerDefinitions[0].environment[?name=='$db_name_var'] | [0]" | jq -r '.value')
    fi
    echo "sudo docker run --rm -it jbergknoff/postgresql-client --dbname postgresql://${db_user_val}:${db_pass_val}@${db_host_val}:${db_port_val}/${db_name_val}"
}

function npe-db-secrets() {
    db_name=$1
    profile=${2:-default}
    current_cluster=$(kctx-curr)
    cluster_name=${3:-${current_cluster}}
    comp_env=${cluster_name::-1}
    comp_env_lower=${comp_env,,}
    secret_name=${comp_env_lower}-${db_name}-db-secrets
    echo "DB name: ${cluster_name}"
    echo "AWS profile: ${profile}"
    echo "Cluster name: ${cluster_name}"
    echo "Computing env: ${comp_env_lower}"
    echo "Secret name: ${secret_name}"

    # echo "using AWS profile: ${profile}"
    # db_user_val=$(aws --profile=${profile} secretsmanager get-secret-value --secret-id $secret_name_lower | jq -r '.SecretString' | jq -r ".username")
    # db_pass_val=$(aws --profile=${profile} secretsmanager get-secret-value --secret-id $secret_name_lower | jq -r '.SecretString' | jq -r ".password")
    # db_host_val=$(aws --profile=${profile} secretsmanager get-secret-value --secret-id $secret_name_lower | jq -r '.SecretString' | jq -r ".dbhost")
    # db_port_val=$(aws --profile=${profile} secretsmanager get-secret-value --secret-id $secret_name_lower | jq -r '.SecretString' | jq -r ".port")
    # db_name_val=$(aws --profile=${profile} secretsmanager get-secret-value --secret-id $secret_name_lower | jq -r '.SecretString' | jq -r ".name")

    # echo " Cluster name: ${cluster_name}"
    # kctx $cluster_name
    # pod_name=$(kctl get pods --selector app=psql -o name)
    # echo "kctl exec -it ${pod_name} -- env PGPASSWORD=${db_pass_val} psql -U ${db_user_val} -h ${db_host_val} -d ${db_name_val}"
}

function aws-stack-version() {
    stage=$1
    stack=$2
    stack_name="$stage--$stack"
    param_key=${3:-'ServiceTag'}
    if [ $stage = "production" ]; then
        echo "using AWS profile: prod-god"
        param_val=$(aws --profile prod-god cloudformation describe-stacks --stack-name $stack_name --query "Stacks[0].Parameters[?ParameterKey=='$param_key'].ParameterValue | [0]")
    else
        param_val=$(aws cloudformation describe-stacks --stack-name $stack_name --query "Stacks[0].Parameters[?ParameterKey=='$param_key'].ParameterValue | [0]")
    fi
    echo "$stack_name: $param_val"
}

function all-stack-versions() {
    stack=$1
    param_key=${2:-'ServiceTag'}
    stages=(development beta production)
    for stage in "${stages[@]}"; do
        aws-stack-version $stage $stack $param_key
    done
}

function aws-ecr-image-tags() {
    repo=$1
    tag=$2
    aws ecr describe-images --repository-name $repo --image-ids imageTag=$tag --query "imageDetails[0].imageTags"
}

function dkr-rehost() {
    source=$1
    dest=$2
    docker pull $source
    docker tag $source $dest
    docker push $dest
}

function write-secrets() {
    secret_id=$1
    file=$2
    profile=${3:-default}
    aws secretsmanager --profile $profile get-secret-value --secret-id $secret_id --query SecretString --output text > $file-secrets.json
}

# docker
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
alias bexec='docker-compose run --rm web bundle exec'

# kubernetes
alias kctl="kubectl"
alias kctx="kubectl config use-context"
alias kctx-curr="kubectl config current-context"

# networking
alias dns-cache-clear='dscacheutil -flushcache'

# npm
alias npm-links='npm ls -g --depth=0 --link=true'
alias npm-rm-nm='find . -name "node_modules" -exec rm -rf "{}" +'

# python
alias rm-pyc='find . -name "*.pyc" -exec rm -f {} \;'

# Custom functions
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

# Java setup
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Node setup
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Ruby setup
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# Golang setup
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/matthewspringer/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/matthewspringer/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/matthewspringer/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/matthewspringer/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
