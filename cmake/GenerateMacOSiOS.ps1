<#
.SYNOPSIS
Generate the MacOS, iOS, and iOS Simulator projects from the cmake scripts

.DESCRIPTION
Generate the MacOS, iOS, and iOS Simulator projects from the cmake scripts.
Use BuildMacOSiOSNuGet.ps1 to build and generate the nuget packages.


.EXAMPLE
GenerateMacOSiOS.ps1
GenerateMacOSiOS.ps1 -LIB3MF_VERSION_PATCH 21
#>

[CmdletBinding()]
param(
    [switch]$Clean,
    [switch]$NoMacOS,
    [switch]$NoIOS,
    [switch]$NoSimulator,
    $LIB3MF_VERSION_PATCH = 0
)

$MACOS_OUTPUT_FOLDER = "macos"
$IOS_OUTPUT_FOLDER = "ios"
$IOS_SIMULATOR_OUTPUT_FOLDER = "ios_simulator"

function CleanFiles()
{
    Remove-Item "$PSScriptRoot/../build" -Recurse -Force | Write-Host
}

function GenerateProjectMacOS()
{
    Write-Host "Generate XCode Project"
    New-Item -Path "$PSScriptRoot/../build" -Name $MACOS_OUTPUT_FOLDER  -ItemType Directory -Force | Out-Null
    Push-Location "$PSScriptRoot/../build/$MACOS_OUTPUT_FOLDER"
    try
    {
      cmake -G Xcode "-DLIB3MF_VERSION_PATCH=$LIB3MF_VERSION_PATCH" ../..
    }
    finally
    {
      Pop-Location
    }
}

function GenerateProjectIOS()
{
    Write-Host "Generate XCode Project"
    New-Item -Path "$PSScriptRoot/../build" -Name $IOS_OUTPUT_FOLDER -ItemType Directory -Force | Out-Null
    Push-Location "$PSScriptRoot/../build/$IOS_OUTPUT_FOLDER" | Out-Null
    try
    {
      cmake -G Xcode ../.. "-DLIB3MF_VERSION_PATCH=$LIB3MF_VERSION_PATCH" -DCMAKE_TOOLCHAIN_FILE="$PSScriptRoot/ios.toolchain.cmake" -DIOS_PLATFORM=OS -DIOS_DEPLOYMENT_TARGET="9.0" | Write-Host
    }
    finally
    {
      Pop-Location | Out-Null
    }
}

function GenerateProjectIOSSimulator()
{
    Write-Host "Generate XCode Project"
    New-Item -Path "$PSScriptRoot/../build" -Name $IOS_SIMULATOR_OUTPUT_FOLDER -ItemType Directory -Force | Out-Null
    Push-Location "$PSScriptRoot/../build/$IOS_SIMULATOR_OUTPUT_FOLDER" | Out-Null
    try
    {
      cmake -G Xcode ../.. -DCMAKE_TOOLCHAIN_FILE="$PSScriptRoot/ios.toolchain.cmake" -DIOS_PLATFORM=SIMULATOR64 -DIOS_DEPLOYMENT_TARGET="9.0" | Write-Host
    }
    finally
    {
      Pop-Location | Out-Null
    }
}

function Main()
{
    if ($Clean)
    {
        CleanFiles                
    }

    if (!$NoMacOS)
    {
        GenerateProjectMacOS
    }

    if (!$NoIOS)
    {
        GenerateProjectIOS
    }

    if (!$NoSimulator)
    {
        GenerateProjectIOSSimulator
    }
    
}

Main