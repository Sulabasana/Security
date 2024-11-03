function Get-Size ($bytes) {
    $suffix = "B"
    $factor = 1024
    $units = "", "K", "M", "G", "T", "P"
    foreach ($unit in $units) {
        if ($bytes -lt $factor) {
            return "{0:N2}{1}{2}" -f $bytes, $unit, $suffix
        }
        $bytes = $bytes / $factor
    }
}

Write-Host "================================ System Information ================================"
Write-Host "System:" (Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption)
Write-Host "Node Name:" $env:COMPUTERNAME
Write-Host "Release:" (Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty Version)
Write-Host "Machine:" (Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty SystemType)
Write-Host "Processor:" (Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty Name)

Write-Host "================================ Boot Time ========================================"
$bootTime = (Get-WmiObject -Class Win32_OperatingSystem).LastBootUpTime
Write-Host "Boot Time:" $bootTime

Write-Host "================================ CPU Info ========================================="
$cpu = Get-WmiObject -Class Win32_Processor
Write-Host "Physical cores:" $cpu.NumberOfCores
Write-Host "Total cores:" $cpu.NumberOfLogicalProcessors
Write-Host "Max Frequency:" ("{0:N2}" -f ($cpu.MaxClockSpeed / 1000)) "GHz"

Write-Host "CPU Usage Per Core:"
Get-WmiObject -Class Win32_PerfFormattedData_PerfOS_Processor | Where-Object { $_.Name -ne "_Total" } | ForEach-Object { 
    Write-Host "Core $($_.Name): $($_.PercentProcessorTime)%"
}
Write-Host "Total CPU Usage:" (Get-WmiObject -Class Win32_PerfFormattedData_PerfOS_Processor | Where-Object { $_.Name -eq "_Total" }).PercentProcessorTime "%"

Write-Host "================================ Memory Information ==============================="
$memory = Get-WmiObject -Class Win32_OperatingSystem
$totalMem = $memory.TotalVisibleMemorySize * 1KB
$freeMem = $memory.FreePhysicalMemory * 1KB
$usedMem = $totalMem - $freeMem
Write-Host "Total:" (Get-Size $totalMem)
Write-Host "Available:" (Get-Size $freeMem)
Write-Host "Used:" (Get-Size $usedMem)
Write-Host "Percentage:" ("{0:N2}" -f (($usedMem / $totalMem) * 100)) "%"

Write-Host "================================ Disk Information ================================"
Get-WmiObject -Class Win32_LogicalDisk | ForEach-Object {
    Write-Host "Drive $($_.DeviceID): Total Size:" (Get-Size $_.Size) ", Free:" (Get-Size $_.FreeSpace)
}

Write-Host "================================ Network Information ============================="
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | ForEach-Object {
    Write-Host "=== Interface: $($_.Description) ==="
    Write-Host "  IP Address:" $_.IPAddress[0]
    Write-Host "  Subnet Mask:" $_.IPSubnet[0]
    Write-Host "  MAC Address:" $_.MACAddress
}

Write-Host "================================ Battery Information =============================="
$battery = Get-WmiObject -Class Win32_Battery
if ($battery) {
    Write-Host "Battery Status: $($battery.EstimatedChargeRemaining)%"
} else {
    Write-Host "No battery detected."
}
