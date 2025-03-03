function ConcatinateAllCodeFiles([string] $scriptsFolderPath) {
    $regex = New-Object System.Text.RegularExpressions.Regex '(?:\s?using[\s]+)([\w\.]+)(?:;)'
    $headers = New-Object System.Collections.ArrayList
    $body = New-Object System.Collections.ArrayList
    ls $scriptsFolderPath -Recurse -Filter "*.cs" `
        | % { CollectHeadersAndBody -path $_.FullName -regex $regex -headers $headers -body $body }

    [System.Text.StringBuilder] $sb = New-Object System.Text.StringBuilder

    if ($headers.Count -ne 0) {
        $sb.Append('using ') | Out-Null
        $sb.Append($headers[0]) | Out-Null

        for ([int] $i = 1; $i -lt $headers.Count; $i++) {
            $sb.Append(";`nusing ") | Out-Null
            $sb.Append($headers[$i]) | Out-Null
        }
        
        $sb.Append(";`n`n") | Out-Null
    }

    foreach ($bodyLine in $body) {
        $sb.AppendLine($bodyLine) | Out-Null
    }

    return ($sb.ToString())
}

function CollectHeadersAndBody(
    [string] $path, 
    [System.Text.RegularExpressions.Regex] $regex, 
    [System.Collections.ArrayList] $headers, 
    [System.Collections.ArrayList] $body
) {    
    $lines = Get-Content -Path $path
    [int] $lastHeaderLine = 0
    
    for ([int] $i = 0; $i -lt $lines.Count; $i++) {
        $match = $regex.Match($lines[$i])
        
        if (-not $match.Success) {
            $lastHeaderLine = $i
            break
        }
        
        if ($headers.Contains($match.Groups[1].Value)) {
            continue
        }

        $headers.Add($match.Groups[1].Value) | Out-Null
    }
    
    for ([int] $i = $lastHeaderLine; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Length -ne 0) {
            $body.Add($lines[$i]) | Out-Null
        }
    }
}

function GenerateAssembly([string] $scriptsFolderPath) {
    try {
        Add-Type `
            -TypeDefinition (ConcatinateAllCodeFiles -scriptsFolderPath "./scripts") `
            -ErrorAction Stop `
            -ReferencedAssemblies WindowsBase, PresentationFramework, PresentationCore, System.Xaml
        Write-Host `
            -Object "Assembly compiled successfully" `
            -Background Green `
            -Foreground White
    } 
    catch {
        Write-Host `
            -Object "Failed to compile assembly, reason`n$($_.Exception.Message)" `
            -Background Red `
            -Foreground Yellow 
    }
}

GenerateAssembly -scriptsFolderPath "./scripts"
[Program]::Main()