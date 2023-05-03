include ../makefiles/common.mk

.PHONY: build/linux/amd64 build/linux/arm64 shell/linux/arm64 shell/linux/amd64 push/all push/linux/amd64 push/linux/arm64 push/manifest

build/all: build/linux/arm64 build/linux/amd64

build/linux/arm64: platform := linux/arm64
build/linux/arm64:
	$(call build_image,$(build_context),$(dockerfile),$(image_name),$(image_version),$(image_os),$(platform),$(no_cache))

build/linux/amd64: platform := linux/amd64
build/linux/amd64:
	$(call build_image,$(build_context),$(dockerfile),$(image_name),$(image_version),$(image_os),$(platform),$(no_cache))

.shell:
	if [ -z "$(platform)" ]; then
		$(call perror,Please specify a platform to run the shell on. Valid platforms: $(platforms))
		exit 1;
	fi

	docker run --rm -it \
		$(image_tag) \
		su developer -c $(shell)


shell/linux/amd64: image_tag = $(image_name):$(image_version)-$(image_os)-$(subst /,-,$(platform))
shell/linux/amd64: shell := bash
shell/linux/amd64: platform := linux/amd64
shell/linux/amd64: .shell

shell/linux/arm64: image_tag = $(image_name):$(image_version)-$(image_os)-$(subst /,-,$(platform))
shell/linux/arm64: shell := bash
shell/linux/arm64: platform := linux/arm64
shell/linux/arm64: .shell

push/linux/arm64: platform := linux/arm64
push/linux/arm64:
	$(call docker_login,$(registry),$(username),$(token))
	$(call push_image,$\
		$(call image_tag,$(image_name),$(image_version),$(image_os),$(platform)),$\
		$(registry),$(namespace),$(token))

push/linux/amd64: platform := linux/amd64
push/linux/amd64:
	$(call docker_login,$(registry),$(username),$(token))
	$(call push_image,$\
		$(call image_tag,$(image_name),$(image_version),$(image_os),$(platform)),$\
		$(registry),$(namespace),$(token))

push/all: push/linux/arm64 push/linux/amd64

push/manifest: tags = \
	$(call image_tag,$(image_name),latest,$(image_os)) \
	$(call image_tag,$(image_name),$(image_version),$(image_os))
push/manifest: current_tag := $(call image_tag,$(image_name),$(image_version),$(image_os))
push/manifest: remote_tags = $(foreach tag,$(tags),$(call registry_tag,$(tag),$(registry),$(namespace)))
push/manifest:
	$(call docker_login,$(registry),$(username),$(token))
	$(foreach remote_tag,$(remote_tags),
		$(call push_manifest,$(remote_tag),$\
			$(call registry_tag,$(current_tag),$(registry),$(namespace))-linux-arm64 \
			$(call registry_tag,$(current_tag),$(registry),$(namespace))-linux-amd64))
	