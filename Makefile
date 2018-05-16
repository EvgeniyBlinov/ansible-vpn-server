# vim: set noet ci pi sts=0 sw=4 ts=4 :
# http://www.gnu.org/software/make/manual/make.html
# http://linuxlib.ru/prog/make_379_manual.html
SHELL:=/bin/bash
DEBUG ?= 0

# Fake targets
.PHONY: ssh ssh-config ssh-apply

CURRENT_DIR := $(shell dirname "$(realpath "$(lastword $(MAKEFILE_LIST))")")
########################################################################
# Default variables
########################################################################
MESSAGE ?= ''
########################################################################
-include .env
export

ENV := envs/$(ANSIBLE_ENV)

#ENV = ${env}
ifeq ($(ENV),)
	ENV := $(CURRENT_DIR)/envs/$(shell ls -1 $(CURRENT_DIR)/envs|head -1)
endif
ENV_PATH := $(realpath $(ENV))
ENV_FILE := $(ENV_PATH)/.env

ifneq ("$(wildcard $(ENV_FILE))","")
	include $(ENV_FILE)
endif
########################################################################
## unquote variables
PASSWORD_KEY := $(patsubst '%',%,$(PASSWORD_KEY))
ANSIBLE_ENV := $(patsubst '%',%,$(ANSIBLE_ENV))
SSH_HOSTS := $(patsubst '%',%,$(SSH_HOSTS))
########################################################################
########################################################################
VAULT_PASSWORD_FILE ?= ~/.ssh/ansible-key

all: .env ssh

## Do it first
.env:
	echo "Edit .env params" && \
	cat .env.dist| \
		sed '/^\s*$$/d'| \
		while read line; do \
			param=$${line%=*}; \
			def=$${line#*=}; \
			read -ei "$$def" -p "$$param:" val < /dev/tty; \
			echo $$param=$$val; \
		done > .env

ssh: \
	$(SSH_PATH) \
	$(SSH_PATH)/$(SSH_KEY) \
	ssh-config \
	ssh-apply

$(SSH_PATH):
	mkdir -p $@

$(SSH_PATH)/$(SSH_KEY):
	ssh-keygen -f $@

ssh-config:
	bin/run.sh bin/build.yml

ssh-apply:
	@IFS=',' read -r -a ssh_hosts <<< "$(SSH_HOSTS)"; \
	for host in "$${ssh_hosts[@]}"; do \
		ssh $(SSH_USER)@$$host \
			-oPasswordAuthentication=no \
			-p $(SSH_PORT) \
			-i $(SSH_PATH)/$(SSH_KEY) \
			'hostname' || \
		ssh-copy-id \
			-i $(SSH_PATH)/$(SSH_KEY) \
			-p $(SSH_PORT) \
			$(SSH_USER)@$$host \
			;\
	done

#pip:
	#sudo pip install -r requirements.txt
