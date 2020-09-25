help:
	@echo 'available make targets:'
	@grep PHONY: Makefile | cut -d: -f2 | sed '1d;s/^/make/'

.PHONY: check-packer
check-packer:
	test -x /usr/local/bin/packer
	packer version
	packer validate -syntax-only packer.json

.PHONY: check-ansible
check-ansible:
	ansible-playbook --syntax-check playbook.yml
	ansible-lint playbook.yml
	find . -name "*.yml" | xargs yamllint

.PHONY: check              # pre-flight checks
check: check-packer check-ansible

.PHONY: prepare            # force re-install dependencies
prepare:
	ansible-galaxy install --force -p roles -r roles/requirements.yml

.PHONY: arm-windows-image  # build the Azure image with Packer
arm-windows-image: check-packer check-ansible
	@echo arm-windows-image
	./packer.sh
