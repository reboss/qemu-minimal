
.PHONY: driver-check verify-qemu

qemu-vms/images:
	@mkdir -p $@

qemu-vms/vms/testvm:
	@mkdir -p $@

qemu-vms/images/noble-amd64.img: qemu-vms/images
	wget -O $@ https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

qemu-vms/vms/testvm/testvm.qcow2: qemu-vms/vms/testvm
	qemu-img create -f qcow2 \
	  -F qcow2 \
	  -b ../../images/noble-amd64.img \
	  $@ 40G

verify-qemu: qemu-vms/vms/testvm/testvm.qcow2
	qemu-img info $^

driver-check:
	./amd-gpu-health-check.sh

generate-user-data: qemu-vms/vms/testvm
	@echo "#cloud-config" > $</user-data
	@echo "users:" >> $</user-data
	@echo "  - name: ubuntu" >> $</user-data
	@echo "    sudo: ALL=(ALL) NOPASSWD:ALL" >> $</user-data
	@echo "    groups: users, admin" >> $</user-data
	@echo "    shell: /bin/bash" >> $</user-data
	@echo "    ssh_authorized_keys:" >> $</user-data
	@echo "      - $$(cat ~/.ssh/id_rsa.pub 2>/dev/null || cat ~/.ssh/id_ed25519.pub)" >> $</user-data
	@echo "ssh_pwauth: false" >> $</user-data
	@echo "disable_root: true" >> $</user-data