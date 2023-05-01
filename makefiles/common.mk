.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.SECONDEXPANSION:
SHELL := bash
.SILENT:

# $(call image_tag,<image_name>,<image_version>,<image_os>,<platform>)
image_tag = $1:$2-$3$(if $4,-$(subst /,-,$4),)

# $(call registry_tag,<image_tag>,<registry>,<namespace>)
registry_tag = $(if $2,$2/,)$3/$(subst /,-,$1)

# $(call build_image,<build_context>,<dockerfile>,<image_name>,<image_version>,<image_os>,<platform>,<no_cache>)
define build_image
docker build $1 \
	--file $2 \
	--tag $(call image_tag,$3,$4,$5,$6) \
	--progress plain \
	--platform $6 \
	$(if $7,--no-cache,)
endef

# $(call docker_login,<registry>,<username>,<token>)
docker_login = echo '$3' | docker login $1 -u $2 --password-stdin

# $(call push_image,<image_tag>,<registry>,<namespace>)
define push_image
	docker tag $1 $(call registry_tag,$1,$2,$3)
	docker push $(call registry_tag,$1,$2,$3)
endef

# $(call push_manifest,<manifest_tag>,<image_tags>)
define push_manifest
docker manifest rm $1 || true
docker manifest create $1 \
	$2
docker manifest push $1
endef
