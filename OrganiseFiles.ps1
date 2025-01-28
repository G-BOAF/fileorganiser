$FolderPath = Read-Host 'Enter the path of the folder you want to organize'

if (Test-Path $FolderPath) {
    # Get all the files in the folder
    $Files = Get-ChildItem -Path $FolderPath -File
} else {
    Write-Host "The folder path is invalid!" -ForegroundColor Red
    exit
}

# Define a mapping of file extensions to folder names
$FileTypeMapping = @{
    "txt" = "TextFiles"
    "jpg" = "Images"
    "png" = "Images"
    "pdf" = "PDFs"
    "xlsx" = "ExcelFiles"
}

# Loop through files and check their extensions
foreach ($File in $Files) {
    $Extension = $File.Extension.TrimStart('.').ToLower()

    if ($FileTypeMapping.ContainsKey($Extension)) {
        Write-Host "$($File.Name) is categorized as: $($FileTypeMapping[$Extension])"
    } else {
        Write-Host "$($File.Name) is not categorized" -ForegroundColor Yellow
    }
}

# Create folders for extensions
foreach ($Extension in $FileTypeMapping.Values) {
    $TargetFolder = Join-Path -Path $FolderPath -ChildPath $Extension

    if (!(Test-Path -Path $TargetFolder)) {
        New-Item -Path $TargetFolder -ItemType Directory | Out-Null
        Write-Host "Created Folder: $TargetFolder"
    }
}

# Move files into subfolders
foreach ($File in $Files) {
    $Extension = $File.Extension.TrimStart('.').ToLower()

    if ($FileTypeMapping.ContainsKey($Extension)) {
        $TargetFolder = Join-Path -Path $FolderPath -ChildPath $FileTypeMapping[$Extension]
        $TargetPath = Join-Path -Path $TargetFolder -ChildPath $File.Name

        Move-Item -Path $File.FullName -Destination $TargetPath
        Write-Host "Moved $($File.Name) to $TargetFolder"
    }
}
