$RegKey = @(
    "HKCU:\Software\Native Instruments\Komplete Kontrol\",
    "HKCU:\Software\Native Instruments\Kontakt 5\",
    "HKCU:\Software\Native Instruments\Maschine 2\",
    "HKCU:\Software\Native Instruments\Shared\",
    "HKCU:\Software\Native Instruments\Absynth 5\",
    "HKCU:\Software\Native Instruments\Battery 4\",
    "HKCU:\Software\Native Instruments\Guitar Rig 5\",
    "HKCU:\Software\Native Instruments\Reaktor 6\",
    "HKCU:\Software\Native Instruments\FM8\",
    "HKCU:\Software\Native Instruments\Massive\"
)

$ExcludeValue = @(
    "AB2",
    "keyboardVisible",
    "masterVisible",
    "useKBForMIDI",
    "browserLibsAZSort",
    "OnStartupLoadProject",
    "uret-allow-transfer"
)

foreach ($Path in $RegKey) {

    function IsRemove ($Path) {
        foreach ($ValueName in $ExcludeValue) {
            if ($Path.StartsWith($ValueName)) {
                return $False
            }
        }
        return $True
    }

    Get-Item -Path $Path | Select-Object -ExpandProperty Property | ForEach-Object {
        if (IsRemove($_)) {
            Write-Host "deleting: "$Path$_
            Remove-ItemProperty -Path $Path -Name $_
        }
    }
}
