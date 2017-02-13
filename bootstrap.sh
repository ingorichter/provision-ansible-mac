#!/bin/bash

set -e

SRC_DIRECTORY="$(pwd)"
ANSIBLE_DIRECTORY="$SRC_DIRECTORY/ansible"
ANSIBLE_CONFIGURATION_DIRECTORY="$HOME/.ansible.d"

info() {
    printf "Info   | $1   | $2\n"
}

# Download and install Command Line Tools
if [[ ! -x /usr/bin/gcc ]]; then
    echo "Info   | Install   | xcode"
    xcode-select --install
fi

# Download and install Homebrew
if [[ ! -x /usr/local/bin/brew ]]; then
    info "Install", "homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Modify the PATH
export PATH=/usr/local/bin:$PATH

# Download and install zsh
if [[ ! -x /usr/local/bin/zsh ]]; then
    info "Install", "zsh"
    brew install zsh
fi

# Download and install git
if [[ ! -x /usr/local/bin/git ]]; then
    info "Install", "git"
    brew install git
fi

# Download and install Ansible
if [[ ! -x /usr/local/bin/ansible ]]; then
    info "Install", "Ansible"
    brew install ansible
fi

# Make the code directory
mkdir -p $SRC_DIRECTORY

# FIX ANSIBLE PERMISSIONS
chmod -R 750 $SRC_DIRECTORY
chmod -R 660 $ANSIBLE_DIRECTORY/inventories/*

# # Clone down ansible
# if [[ ! -d $ANSIBLE_DIRECTORY ]]; then
#     git clone -b devel git://github.com/danieljaouen/ansible.git $ANSIBLE_DIRECTORY
# fi

# # Use the forked Ansible
# source $ANSIBLE_DIRECTORY/hacking/env-setup > /dev/null

# # Clone down the Ansible repo
# if [[ ! -d $ANSIBLE_CONFIGURATION_DIRECTORY ]]; then
#     git clone git@bitbucket.org:danieljaouen/ansible-base-box.git $ANSIBLE_CONFIGURATION_DIRECTORY
#     (cd $ANSIBLE_CONFIGURATION_DIRECTORY && git submodule init && git submodule update)
# fi

# Provision the box
# ansible-playbook -i $ANSIBLE_DIRECTORY/inventories/osx.ini $ANSIBLE_DIRECTORY/playbook.yml --connection=local
ansible-playbook --ask-sudo-pass -i $ANSIBLE_DIRECTORY/inventories/osx.ini $ANSIBLE_DIRECTORY/playbook.yml --connection=local

# Link the casks.
# ~/.bin/link-casks
