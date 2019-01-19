<#
.SYNOPSIS
Generate the Windows VS 2017 projects (Win32, x64, UWP)

.DESCRIPTION
Generate the Windows VS 2017 projects (Win32, x64, UWP).  Use BuildVS2017NuGet.ps1 to build the projects.

.EXAMPLE
BuildVS2017NuGet.ps1
BuildVS2017NuGet.ps1 -LIB3MF_VERSION_PATCH 5
#>

[CmdletBinding()]
param(
    [switch]$Clean = $false,
    $LIB3MF_VERSION_PATCH = 0
)

function Clean
{
    Write-Host "Cleaning"
    Remove-Item "$PSScriptRoot/../build" -Recurse -Force | Write-Host
}

function BuildPlatform($arch, $path, $isUWP)
{
    New-Item -Path "$PSScriptRoot/../build" -Name $path -ItemType Directory -Force | Out-Null
    Push-Location "$PSScriptRoot/../build/$path" | Out-Null
    try
    {
        $argList = @(
            "-G", "Visual Studio 15 2017"
            "-A", $arch,
            "-DLIB3MF_VERSION_PATCH=$LIB3MF_VERSION_PATCH"
        )

        # Add UWP arguments for UWP build
        if ($isUWP)
        {
            $argList += @(
                "-DCMAKE_SYSTEM_NAME=WindowsStore",
                "-DCMAKE_SYSTEM_VERSION=10.0"
            )
        }

        & cmake $argList "-Wno-dev" "..\.."

    }
    finally
    {
        Pop-Location | Out-Null
    }
}

function Main
{
    if ($Clean)
    {
        Clean
    }

    BuildPlatform "Win32" "buildwin32" $false
    BuildPlatform "x64" "buildwin64" $false
    BuildPlatform "ARM64" "buildwinarm64" $false
    BuildPlatform "Win32" "builduwp32" $true
    BuildPlatform "x64" "builduwp64" $true
    BuildPlatform "ARM" "builduwparm" $true
    BuildPlatform "ARM64" "builduwparm64" $true
}

Main
