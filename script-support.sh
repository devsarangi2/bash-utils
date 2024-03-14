#!/bin/bash

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

CLEAR_LINE='\033[1G\033[K'

function line_break() {
  echo -e
}

function line() {
  chars="***************************************************************"

  echo $chars

  if [[ "${$#}" -eq 2 ]]; then
    echo $2
    echo $chars
  fi
}

function checkOrCreateDir() {
  local dirPath=$1
  if [[ ! -d "${dirPath}" ]]; then
    print "Dir NOT found. Creating : ${dirPath} "
    mkdir "${dirPath}"
    chmod -R 755 .
  fi
}

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

function wait_time() {
  if [[ $# -eq 1 ]]; then
    wait_time=$1
    info "Waiting for ${wait_time} secs"
  else
    wait_time=0
  fi
  sleep $wait_time
}

function forceDeleteFile() {
  FILE_PATTERN=$1
  warn "Force delete files with pattern ${FILE_PATTERN}"
  find . -type f -name "${FILE_PATTERN}" -print -delete
}

function cleanEmptyFiles() {
  FILE_PATTERN=$1
  warn "Deleting empty files with pattern \"${FILE_PATTERN}\""
  find . -type f -name "${FILE_PATTERN}" -empty -delete
}

function cleanAllEmptyFiles() {
  wait_time $1
  warn "Deleting empty .log or .bad files"
  cleanEmptyFiles "*.bad"
  cleanEmptyFiles "*.log"
}

function cleanFileWithoutKeyword() {
  FILE_TYPE=$1
  SEARCH_KEYWORD=$2
  info "Deleting ${FILE_TYPE} files without keyword \"${SEARCH_KEYWORD}\""
  find . -type f -name "${FILE_TYPE}" '!' -exec grep -q "${SEARCH_KEYWORD}" {} \; -delete
}

function cleanFileWithKeyword() {
  FILE_TYPE=$1
  SEARCH_KEYWORD=$2
  warn "Deleting ${FILE_TYPE} files with keyword \"${SEARCH_KEYWORD}\""
  find . -type f -name "${FILE_TYPE}" -exec grep -q "${SEARCH_KEYWORD}" {} \; -delete
}

if [[ "${IS_ARM}" == "" ]]; then
  IS_ARM=$(uname -p)
  export IS_ARM="${IS_ARM}"
  info "Setting chip arch to ${IS_ARM}."
fi
