version_file := .version
image_name := cicd
image_os := amazonlinux2023
image_version := $(strip $(shell cat $(version_file)))

registry := 
username := brutalsimplicity
namespace = $(username)

build_context := ../
dockerfile := Dockerfile

include ../makefiles/docker.mk
