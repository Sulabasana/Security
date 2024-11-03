# Define parameters
$DirectoryPath = "C:\Path\To\Scan"  # Set the directory to scan
$DaysOld = 7                         # Files modified within the last X days
$SizeThresholdMB = 10                # Minimum file size (in MB) to flag as suspicious

# Convert size threshold to bytes for easier comparison
$SizeThresholdBytes = $SizeThresholdMB * 1MB

# Get current date and calculate cutoff date for recently modified files
$CutoffDate = (Get-Date).AddDays(-$DaysOld)

# Scan the directory and its subdirectories for suspicious files
Get-ChildItem -Path $DirectoryPath -Recurse -File |
    Where-Object {
        ($_.Attributes -match "Hidden") -or              # Hidden files
        ($_.LastWriteTime -gt $CutoffDate) -or           # Recently modified files
        ($_.Length -ge $SizeThresholdBytes)              # Large files
    } |
    ForEach-Object {
        # Display results
        Write-Output "Suspicious File Detected:"
        Write-Output "  Name: $($_.FullName)"
        Write-Output "  Size: $([math]::round($_.Length / 1MB, 2)) MB"
        Write-Output "  Last Modified: $($_.LastWriteTime)"
        Write-Output "  Attributes: $($_.Attributes)"
        Write-Output "`n---------------------------------------"
    }
