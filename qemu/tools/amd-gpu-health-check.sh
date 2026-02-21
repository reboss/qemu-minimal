# 1) Identify AMD GPUs and their PCI addresses (BDFs)
lspci -nn | egrep -i 'vga|3d|display' | egrep -i 'amd|advanced micro devices'

# 2) Confirm the kernel driver bound to each GPU
for d in /sys/bus/pci/devices/*; do
  [ -f "$d/vendor" ] && [ "$(cat "$d/vendor")" = "0x1002" ] || continue
  bdf="$(basename "$d")"
  class="$(cat "$d/class")"
  # 0x03xxxx = display controller classes
  case "$class" in 0x03*) ;;
    *) continue ;;
  esac
  drv="$(basename "$(readlink "$d/driver" 2>/dev/null)" 2>/dev/null || echo none)"
  echo "$bdf driver=$drv"
done