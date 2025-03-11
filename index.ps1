# Run the application in development mode (in-memory execution):
# ```ps1
#   powershell -ep Bypass -File ./index.ps1
# ```

# Run the application in build mode (as .exe file):
# ```ps1
#   powershell -ep Bypass -c { & "./index.ps1" -buildExe $true }
# ```

# Alternatively, set $buildExe = $true below:
Param(
    [bool] $buildExe = $false
)   

Set-StrictMode -Version Latest

[string] $ASSEMBLY_PATH = "./CustomWPFApp.dll"
[string] $EXECUTABLE_PATH = "./MyApp.exe"
[string] $SOURCE_CODE_PATH = "./CustomWPFApp"

function ConcatinateCodeFiles([string] $codeFilesPath)
{
    [string[]] $filePaths = Get-ChildItem `
        -Path $codeFilesPath `
        -Filter "*.cs" `
        -Recurse `
    | ForEach-Object { $_.FullName }
    
    [System.Collections.ArrayList] $headers = New-Object System.Collections.ArrayList
    [System.Text.StringBuilder] $body = New-Object System.Text.StringBuilder

    foreach ($filePath in $filePaths)
    {
        CollectHeadersAndBody `
            -filePath $filePath `
            -headers $headers `
            -body $body
    }

    [System.Text.StringBuilder] $resultCode = New-Object System.Text.StringBuilder
    foreach ($header in $headers)
    {
        [void] $resultCode.Append("using ").Append($header).AppendLine(";")
    }

    [void] $resultCode.AppendLine()
    [void] $resultCode.Append($body.ToString())
    return $resultCode.ToString()
}

function CollectHeadersAndBody(
    [string] $filePath, 
    [System.Collections.ArrayList] $headers, 
    [System.Text.StringBuilder] $body
)
{
    [string[]] $lines = Get-Content -Path $filePath
    [int] $firstBodyLineIndex = 0

    for ([int] $i = 0; $i -lt $lines.Count; $i++)
    {
        $line = $lines[$i]
        $matched = [System.Text.RegularExpressions.Regex]::Matches($line, "(?:\s*using\s)([\w\.]+)(?:\s*;\s*)")

        if ($matched.Count -eq 0)
        {
            $firstBodyLineIndex = $i
            break;
        }
        
        foreach ($match in $matched)
        {
            if (-not $match.Success) { continue; }
            $capturedHeader = $match.Groups[1]
            if ($null -eq $capturedHeader) { continue; }
            if ($headers.Contains($capturedHeader.Value)) { continue; }
            [void] $headers.Add($capturedHeader.Value)
        }
    }

    for ([int] $i = $firstBodyLineIndex; $i -lt $lines.Count; $i++)
    {
        [void] $body.AppendLine($lines[$i])
    }
}

function CompileToAssembly([string] $outputAssemblyName, [string] $sourceCode)
{   
    try
    {
        Add-Type `
            -TypeDefinition $sourceCode `
            -ErrorAction Stop `
            -ReferencedAssemblies PresentationFramework, PresentationCore, WindowsBase, System.Xaml `
            -OutputAssembly $outputAssemblyName
    }
    catch
    {
        Write-Host "Failed to compile assembly, reason:`n$($_.Exception.Message)"
    }
}

function GenerateExecutable(
    [string] $assemblyPath, 
    [string] $executableName, 
    [bool] $buildExecutable
)
{
    [System.Collections.Hashtable] $buildArguments = @{}
    if ($buildExecutable)
    {
        $buildArguments["OutputAssembly"] = $executableName
        $buildArguments["OutputType"] = "WindowsApplication"
    }

    try
    {
        Add-Type -Path $assemblyPath
        Add-Type -TypeDefinition @"
        using System;
            public class Program {
                    [STAThread]
                    public static void Main()
                    {
                        CustomWPFApp.App app = new CustomWPFApp.App();
                        app.Start();
                    }
                }
"@ `
            -ReferencedAssemblies `
        (Resolve-Path $assemblyPath), `
            PresentationCore, `
            PresentationFramework, `
            WindowsBase, `
            System.Xaml `
            @buildArguments
    }
    catch
    {
        Write-Host "Failed to compile executable, reason:`n$($_.Exception.Message)"
    }
}

function StartProgram([bool] $runExecutable)
{
    if ($runExecutable -eq $true)
    {
        Write-Host "Running executeble..."w
        # runs the compiled executable
        Start-Process $EXECUTABLE_PATH
    }
    else
    {
        Write-Host "Running in-memmory assembly"
        # runs the compiled in-memory assembly
        [Program]::Main()
    }
}

$sourceCode = ConcatinateCodeFiles -codeFilesPath $SOURCE_CODE_PATH

CompileToAssembly `
    -outputAssemblyName $ASSEMBLY_PATH `
    -sourceCode $sourceCode

GenerateExecutable `
    -assemblyPath $ASSEMBLY_PATH `
    -executableName $EXECUTABLE_PATH `
    -buildExecutable $buildExe

StartProgram `
    -runExecutable $buildExe