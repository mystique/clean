$CleanKeyValueMapExclude = @{
    # Mounted devices clean
    @("HKLM:\SYSTEM\MountedDevices\") = @(
        "\DosDevices\C:",
        "\DosDevices\D:",
        "\DosDevices\E:",
        "\DosDevices\F:",
        "\DosDevices\G:",
        "\DosDevices\H:",
        "\DosDevices\I:",
        "\DosDevices\J:",
        "\DosDevices\K:",
        "\DosDevices\L:"
    )
    # Native Instruments plugins clean
    @(
        "HKCU:\Software\Native Instruments\Komplete Kontrol\",
        "HKCU:\Software\Native Instruments\Kontakt Application\",
        "HKCU:\Software\Native Instruments\Maschine 2\",
        "HKCU:\Software\Native Instruments\Shared\",
        "HKCU:\Software\Native Instruments\Absynth 5\",
        "HKCU:\Software\Native Instruments\Battery 4\",
        "HKCU:\Software\Native Instruments\Guitar Rig 5\",
        "HKCU:\Software\Native Instruments\Reaktor 6\",
        "HKCU:\Software\Native Instruments\FM8\",
        "HKCU:\Software\Native Instruments\Massive\"
    ) = @(
        "AB2",
        "keyboardVisible",
        "masterVisible",
        "useKBForMIDI",
        "browserLibsAZSort",
        "OnStartupLoadProject",
        "uret-allow-transfer",
        "showNetworkDrivesInBrowser"
    )

}

$CleanKeyValueMapExcludeRecurse = @{
    # FabFilter
    @("HKCU:\Software\FabFilter") = @("LicenseText")
}

$CleanKeyValueMap = @{
    # iZotope clean
    @("HKCU:\Software\iZotope\RX7\") = @(
        "ActiveClipName",
        "ClipController",
        "Last",
        "Recent"
    )
}

function IsExist($Path, $CheckValues, $Reverse = $False) {

    foreach ($Value in $CheckValues) {
        if ($Path.StartsWith($Value)) {
            return !$Reverse
        }
    }
    return $Reverse
}

function CleanRegValues($RegKeys, $Reverse) {

    foreach ($Paths in $RegKeys.Keys) {

        foreach ($Path in $Paths) {

            Get-Item -Path $Path | Select-Object -ExpandProperty Property | ForEach-Object {

                if (IsExist $_ $RegKeys.Item($Paths) $Reverse) {
                    Write-Host "deleting: "$Path$_
                    Remove-ItemProperty -Path $Path -Name $_
                }
            }
        }
    }
}

function CleanRegValuesRecurse($RegKeys, $Reverse) {

    foreach ($Paths in $RegKeys.Keys) {

        foreach ($Path in $Paths) {

            Get-ChildItem -Path $Path -Recurse | Select-Object | ForEach-Object {

                foreach ($Property in $_.Property) {
                    if (IsExist $Property $RegKeys.Item($Paths) $Reverse) {
                        Write-Host "deleting: "$_.Name$Property
                        Remove-ItemProperty -Path $_.PSPath -Name $Property
                    }
                }
            }
        }
    }
}

CleanRegValues $CleanKeyValueMapExclude $True
CleanRegValues $CleanKeyValueMap $False

CleanRegValuesRecurse $CleanKeyValueMapExcludeRecurse $True

Clear-History
