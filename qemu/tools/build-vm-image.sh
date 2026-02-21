mkdir -p ./qemu-vms/images ./qemu-vms/vms/testvm
pushd ./qemu-vms/images

wget -O noble-amd64.img \
  https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

popd

pushd ./qemu-vms/vms/testvm

qemu-img create -f qcow2 \
  -F qcow2 \
  -b ../../images/noble-amd64.img \
  testvm.qcow2 40G

qemu-img info testvm.qcow2

popd
