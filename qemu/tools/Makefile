
.PHONY: driver-check verify-qemu

qemu-vms/images:
	mkdir -p $@

qemu-vms/vms/testvm:
	mkdir -p $@

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
