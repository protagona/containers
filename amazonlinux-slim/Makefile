version_file := .version
image_name := devcontainer
image_os := amazonlinux2023-slim
image_version := $(strip $(shell cat $(version_file)))

registry := 
username := brutalsimplicity
namespace = $(username)

build_context := ../
dockerfile := Dockerfile

include ../makefiles/docker.mk
