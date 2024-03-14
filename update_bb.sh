#!/bin/bash

set -e
# https://www.shellhacks.com/bash-colors/
BOLD='\033[1m'
DIM='\033[2m'
ULINE='\033[4m'

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;30m'
BLACK='\033[0;37m'
NO_COLOR='\033[0m'
NORMAL='\033[0m'

function print() {
  local message=$1
  info "${message}"
}

function warn() {
  local message=$1
  echo -e "${YELLOW}[WARN] ${message} ${NO_COLOR}"
}

function info() {
  local message=$1
  echo -e "${CYAN}[INFO] ${message} ${NO_COLOR}"
}

function success() {
  local message=$1
  echo -e "${GREEN}[SUCCESS]  ${message} ${NO_COLOR}"
}

function stat() {
  local message=$1
  echo -e "${MAGENTA}[STAT] ${message} ${NO_COLOR}"
}

function error() {
  local message=$1
  line_break
  echo -e "${RED}[ERROR] ${message} ${NO_COLOR}"
  line_break
}


function checkOrCreate(){
  local dir_name=$1
  if [ ! -d "${dir_name}" ]; then
    warn "${dir_name} does not exist .... Creating.."
    mkdir ./"${dir_name}"
  else
    warn "Folder already present"
  fi
}

function cloneOrUpdate(){
 local project_name=$1
 local repo_name=$2
 local repo_path=./"${project_name}"/"${repo_name}"
 
  if [ ! -d "${repo_path}" ]; then
  info "Cloning ${repo_path} "
  pushd ./"${project_name}"/ &> /dev/null
    git_repo="${repo_name}.git"
    git clone git@bitbucket.org:dev_sarangi/"${git_repo}" &> /dev/null
  popd &> /dev/null
  success "${repo_path} Cloned"
  CLONE_COUNT=$((CLONE_COUNT + 1))
 else
   info "${repo_path} already present .... stash & pull"
   pushd ./"${repo_path}" &> /dev/null
    set +e
    git pull -r &> /dev/null
    if [ $? -eq 0 ]; then 
      UPDATE_COUNT=$((UPDATE_COUNT+1))
    fi
    set -e
   popd  &> /dev/null
   success "${repo_path} updated"
 fi
}


function get_accelerators(){
  
  proj_dir_name=project-accelerators
  info "Pulling ${proj_dir_name}"
  checkOrCreate "${proj_dir_name}"
  cloneOrUpdate "${proj_dir_name}" file-upload-monorepo
  cloneOrUpdate "${proj_dir_name}" local-docker-setups
  cloneOrUpdate "${proj_dir_name}" opinionated-full-stack-python
}

function get_data-portal(){
  proj_dir_name=project-data-portal
  info "Pulling ${proj_dir_name}"
  checkOrCreate "${proj_dir_name}"
  cloneOrUpdate "${proj_dir_name}" data-portal
  cloneOrUpdate "${proj_dir_name}" operations-what-if
  cloneOrUpdate "${proj_dir_name}" scorecard-db
}

function  get_detroit-analyst(){
  proj_dir_name=project-detroit-analyst
  info "Pulling ${proj_dir_name}"
  checkOrCreate "${proj_dir_name}"
  cloneOrUpdate "${proj_dir_name}" all-bets-on-poker
  cloneOrUpdate "${proj_dir_name}" design-patterns
  cloneOrUpdate "${proj_dir_name}" order-management-system
  cloneOrUpdate "${proj_dir_name}" spring-starter-demo
  cloneOrUpdate "${proj_dir_name}" thaw
  cloneOrUpdate "${proj_dir_name}" thaw-angular
  cloneOrUpdate "${proj_dir_name}" te-2020-training-set
}

function  get_toolkits(){
  proj_dir_name=project-toolkits
  info "Pulling ${proj_dir_name}"
  checkOrCreate "${proj_dir_name}"
  cloneOrUpdate "${proj_dir_name}" workstation-setup-mac
}

function get_all(){
  get_accelerators 
  get_data-portal 
  get_detroit-analyst 
  get_toolkits 
}

CLONE_COUNT=0
UPDATED_COUNT=0

get_all

stat "Cloned ${CLONE_COUNT} NEW repos"
stat "Updated ${UPDATED_COUNT} EXISTING repos"
