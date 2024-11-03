#!/bin/bash

function get_size() {
  local bytes=$1
  local suffix="B"
  for unit in "" "K" "M" "G" "T" "P"; do
    if (( bytes < 1024 )); then
      echo "${bytes}${unit}${suffix}"
      return
    fi
    bytes=$((bytes / 1024))
  done
}

echo "================================ System Information ================================"
echo "System: $(uname -s)"
echo "Node Name: $(uname -n)"
echo "Release: $(uname -r)"
echo "Version: $(uname -v)"
echo "Machine: $(uname -m)"
echo "Processor: $(lscpu | grep 'Model name' | awk -F: '{print $2}')"

echo "================================ Boot Time ========================================"
boot_time=$(uptime -s)
echo "Boot Time: $boot_time"

echo "================================ CPU Info ========================================="
echo "Physical cores: $(lscpu | grep 'Core(s) per socket' | awk '{print $4}')"
echo "Total cores: $(nproc)"
cpu_freq=$(lscpu | grep 'MHz')
echo "CPU Frequency: $cpu_freq"

echo "CPU Usage Per Core:"
mpstat -P ALL 1 1 | grep 'Average' | awk '{print "Core " $2 ": " $3 "%"}'

echo "================================ Memory Information ==============================="
total_mem=$(free -b | grep Mem: | awk '{print $2}')
available_mem=$(free -b | grep Mem: | awk '{print $7}')
used_mem=$(free -b | grep Mem: | awk '{print $3}')
echo "Total: $(get_size $total_mem)"
echo "Available: $(get_size $available_mem)"
echo "Used: $(get_size $used_mem)"
echo "Percentage: $(free | grep Mem: | awk '{printf("%.2f", ($3/$2 * 100))}')%"

echo "================================ Disk Information ================================"
df -h --output=source,fstype,size,used,avail,pcent,target | tail -n +2

echo "================================ Network Information ============================="
for iface in $(ip -o link show | awk '{print $2}' | sed 's/://'); do
  echo "=== Interface: $iface ==="
  ip -f inet addr show $iface | awk '{if($1 == "inet") print "  IP Address: " $2}'
  ip -f inet addr show $iface | awk '{if($1 == "inet") print "  Netmask: " $4}'
  ip -f inet addr show $iface | awk '{if($1 == "inet") print "  Broadcast IP: " $6}'
  ip link show $iface | awk '/ether/ {print "  MAC Address: " $2}'
done

echo "================================ Battery Information =============================="
upower -i $(upower -e | grep BAT) | grep -E "state|to\ full|percentage"
