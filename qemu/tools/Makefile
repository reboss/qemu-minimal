.PHONY: driver-check verify-qemu run-testvm clean

qemu-vms/images:
	@mkdir -p $@

qemu-vms/vms/testvm:
	@mkdir -p $@

qemu-vms/images/noble-amd64.img: | qemu-vms/images
	wget -O $@ https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

qemu-vms/vms/testvm/testvm.qcow2: qemu-vms/images/noble-amd64.img | qemu-vms/vms/testvm
	cd $(@D) && qemu-img create -f qcow2 -F qcow2 -b ../../images/$(notdir $<) $(@F) 40G

verify-qemu: qemu-vms/vms/testvm/testvm.qcow2
	qemu-img info $^

driver-check:
	./amd-gpu-health-check.sh

qemu-vms/vms/testvm/user-data: | qemu-vms/vms/testvm
	@echo "#cloud-config" > $@
	@echo "users:" >> $@
	@echo "  - name: ubuntu" >> $@
	@echo "    sudo: ALL=(ALL) NOPASSWD:ALL" >> $@
	@echo "    groups: users, admin" >> $@
	@echo "    shell: /bin/bash" >> $@
	@echo "    ssh_authorized_keys:" >> $@
	@echo "      - $$(cat ~/.ssh/id_rsa.pub 2>/dev/null || cat ~/.ssh/id_ed25519.pub)" >> $@
	@echo "ssh_pwauth: false" >> $@
	@echo "disable_root: true" >> $@

qemu-vms/vms/testvm/meta-data: | qemu-vms/vms/testvm
	@printf "instance-id: testvm\nlocal-hostname: testvm\n" > $@

qemu-vms/vms/testvm/seed.qcow2: qemu-vms/vms/testvm/user-data qemu-vms/vms/testvm/meta-data
	cloud-localds -d qcow2 $@ qemu-vms/vms/testvm/user-data qemu-vms/vms/testvm/meta-data

run-testvm: qemu-vms/vms/testvm/testvm.qcow2 qemu-vms/vms/testvm/seed.qcow2
	sudo qemu-system-x86_64 \
	  -machine q35,accel=kvm \
	  -cpu host \
	  -smp 4 \
	  -m 4096 \
	  -nographic \
	  -drive file=qemu-vms/vms/testvm/testvm.qcow2,if=virtio,format=qcow2 \
	  -drive file=qemu-vms/vms/testvm/seed.qcow2,if=virtio,format=qcow2 \
	  -boot order=c \
	  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
	  -device virtio-net-pci,netdev=net0

clean:
	rm -rf qemu-vms
