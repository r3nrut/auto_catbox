Function Get-RemoteProgram {
<#
.Synopsis
Generates a list of installed programs on a computer

.DESCRIPTION
This function generates a list by querying the registry and returning the installed programs of a local or remote computer.

.NOTES   
Name: Get-RemoteProgram
Author: Jaap Brasser
Version: 1.2.1
DateCreated: 2013-08-23
DateUpdated: 2015-02-28
Blog: http://www.jaapbrasser.com

.LINK
http://www.jaapbrasser.com

.PARAMETER ComputerName
The computer to which connectivity will be checked

.PARAMETER Property
Additional values to be loaded from the registry. Can contain a string or an array of string that will be attempted to retrieve from the registry for each program entry

.EXAMPLE
Get-RemoteProgram

Description:
Will generate a list of installed programs on local machine

.EXAMPLE
Get-RemoteProgram -ComputerName server01,server02

.LONG EXAMPLE
Get-RemoteProgram -Property Publisher,InstallDate,DisplayVersion,InstallSource,IsMinorUpgrade,ReleaseType,ParentDisplayName,SystemComponent | Where-Object {[string]$_.SystemComponent -ne 1 -and ![string]$_.IsMinorUpgrade -and ![string]$_.ReleaseType -and ![string]$_.ParentDisplayName} | Sort-Object ProgramName 

Description:
Will generate a list of installed programs on server01 and server02

.EXAMPLE
Get-RemoteProgram -ComputerName Server01 -Property DisplayVersion,VersionMajor

Description:
Will gather the list of programs from Server01 and attempts to retrieve the displayversion and versionmajor subkeys from the registry for each installed program

.EXAMPLE
'server01','server02' | Get-RemoteProgram -Property Uninstallstring

Description
Will retrieve the installed programs on server01/02 that are passed on to the function through the pipeline and also retrieves the uninstall string for each program
#>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [string[]]
            $ComputerName = $env:COMPUTERNAME,
        [Parameter(Position=0)]
        [string[]]$Property 
    )

    begin {
        $RegistryLocation = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\',
                            'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\'
        $HashProperty = @{}
        $SelectProperty = @('ProgramName','ComputerName')
        if ($Property) {
            $SelectProperty += $Property
        }
    }

    process {
        foreach ($Computer in $ComputerName) {
            $RegBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Computer)
            foreach ($CurrentReg in $RegistryLocation) {
                if ($RegBase) {
                    $CurrentRegKey = $RegBase.OpenSubKey($CurrentReg)
                    if ($CurrentRegKey) {
                        $CurrentRegKey.GetSubKeyNames() | ForEach-Object {
                            if ($Property) {
                                foreach ($CurrentProperty in $Property) {
                                    $HashProperty.$CurrentProperty = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue($CurrentProperty)
                                }
                            }
                            $HashProperty.ComputerName = $Computer
                            $HashProperty.ProgramName = ($DisplayName = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue('DisplayName'))
                            if ($DisplayName) {
                                New-Object -TypeName PSCustomObject -Property $HashProperty |
                                Select-Object -Property $SelectProperty
                            } 
                        }
                    }
                }
            }
        }
    }
}

function AdminIdentity
{

    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [System.Security.Principal.WindowsPrincipal] $identity
    $role = [System.Security.Principal.WIndowsBuiltInRole] "Administrator"

    if(-not $principal.IsInRole($role))
        {
            throw "This user is not an administrator"
        }
    elseif($principal.IsInRole($role))
        {
            echo "This user is an administrator"


        }
}


<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>


# Check for admin rights for the user invoking the script
function AdminRights
{
        [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'https://gallery.technet.microsoft.com/scriptcenter/Start-and-Stop-a-Packet-cce358e8',
                  ConfirmImpact='Medium')]
    [OutputType([String])]


    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [System.Security.Principal.WindowsPrincipal] $identity
    $role = [System.Security.Principal.WIndowsBuiltInRole] "Administrator"

    if(-not $principal.IsInRole($role))
        {
            Write-Output "this user is not an administrator"
            throw "This user is not an administrator"
        }
    elseif($principal.IsInRole($role))
        {
            Write-Output "This user is an administrator"
            
        }
}

#region function Start-PacketTrace
function Start-PacketTrace {
<#	
	.SYNOPSIS
		This function starts a packet trace using netsh. Upon completion, it will begin capture all
		packets coming into and leaving the local computer and will continue to do do until
		Stop-PacketCapture is executed.
	.EXAMPLE
		PS> Start-PacketTrace -TraceFilePath C:\Tracefile.etl

			This example will begin a packet capture on the local computer and place all activity
			in the ETL file C:\Tracefile.etl.
	
	.PARAMETER TraceFilePath
		The file path where the trace file will be placed and recorded to. This file must be an ETL file.
		
	.PARAMETER Force
		Use the Force parameter to overwrite the trace file if one exists already
	
	.INPUTS
		None. You cannot pipe objects to Start-PacketTrace.

	.OUTPUTS
		None. Start-PacketTrace returns no output upon success.
#>
	[CmdletBinding()]
	[OutputType()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]

		[ValidateScript({ Test-Path -Path ($_ | Split-Path -Parent) -PathType Container })]
		[ValidatePattern('.*\.etl$')]
		[string]$TraceFilePath,
	
		[Parameter()]
		[switch]$Force
	)
	begin {
		Set-StrictMode -Version Latest
		$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
	}
	process {
		try {
			if (Test-Path -Path $TraceFilePath -PathType Leaf) {
				if (-not ($Force.IsPresent)) {
					throw "An existing trace file was found at [$($TraceFilePath)] and -Force was not used. Exiting.."
				} else {
					Remove-Item -Path $TraceFilePath
				}
			}
			$OutFile = "$PSScriptRoot\trace_temp_output.txt"
			$Process = Start-Process "$($env:windir)\System32\netsh.exe" -ArgumentList "trace start persistent=yes capture=yes tracefile=$TraceFilePath" -RedirectStandardOutput $OutFile -Wait -NoNewWindow -PassThru
			if ($Process.ExitCode -notin @(0, 3010)) {
				throw "Failed to start the packet trace. Netsh exited with an exit code [$($Process.ExitCode)]"
			} else {
				Write-Verbose -Message "Successfully started netsh packet capture. Capturing all activity to [$($TraceFilePath)]"
			}
		} catch {
			Write-Error -Message "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
		} finally {
			if (Test-Path -Path $OutFile -PathType Leaf) {
				Remove-Item -Path $OutFile
			}	
		}
	}
}
#endregion function Start-PacketTrace

#region function Stop-PacketTrace
function Stop-PacketTrace {
<#	
	.SYNOPSIS
		This function stops a packet trace that is currently running using netsh.
	.EXAMPLE
		PS> Stop-PacketTrace

			This example stops any running netsh packet capture.	
	.INPUTS
		None. You cannot pipe objects to Stop-PacketTrace.

	.OUTPUTS
		None. Stop-PacketTrace returns no output upon success.
#>
	[CmdletBinding()]
	[OutputType()]
	param
	()
	begin {
		Set-StrictMode -Version Latest
		$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
	}
	process {
		try {
			$OutFile = "$PSScriptRoot\temp.txt"
			$Process = Start-Process "$($env:windir)\System32\netsh.exe" -ArgumentList 'trace stop' -Wait -NoNewWindow -PassThru -RedirectStandardOutput $OutFile
			if ((Get-Content $OutFile) -eq 'There is no trace session currently in progress.'){
				Write-Verbose -Message 'There are no trace sessions currently in progress'
			} elseif ($Process.ExitCode -notin @(0, 3010)) {
				throw "Failed to stop the packet trace. Netsh exited with an exit code [$($Process.ExitCode)]"
			} else {
				Write-Verbose -Message 'Successfully stopped netsh packet capture'
			}
		} catch {
			Write-Error -Message "Error: $($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
		} finally {
			if (Test-Path -Path $OutFile -PathType Leaf) {
				Remove-Item -Path $OutFile
			}
		}
	}
}
#endregion function Stop-PacketTrace
