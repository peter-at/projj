MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

all : help ;

PHONY_TGTS := help
.PHONY: $(PHONY_TGTS)

help:
	@echo "**** Help ****"
	@grep -E "(^# make|^#\s+-)" Makefile

# make clone  - clone repos for development
clone:
	[ -d jupyterlab ] || git clone --filter=blob:none https://github.com/jupyterlab/jupyterlab.git
	[ -d jupyter_core ] || git clone --filter=blob:none https://github.com/jupyter/jupyter_core.git
	[ -d ipython ] || git clone --filter=blob:none https://github.com/ipython/ipython.git
	[ -d jupyter_server ] || git clone --filter=blob:none https://github.com/jupyter-server/jupyter_server.git
	[ -d jupyterlab_server ] || git clone --filter=blob:none https://github.com/jupyterlab/jupyterlab_server.git
