version_file := .version
image_name := devcontainer
image_os := fedora38
image_version := $(strip $(shell cat $(version_file)))

registry := 
username := brutalsimplicity
namespace = $(username)

build_context := ../
dockerfile := Dockerfile

include ../makefiles/docker.mk