# .NET App Runner via PowerShell

## **What does it do?**

Allows you to write and run a .NET application on Windows **without manually downloading and installing the latest .NET versions**.

## **How does it work?**

1. Runs a PowerShell script (`index.ps1`) that:
   - **Finds and concatenates all C# files** in the project.
   - **Compiles them into a .NET assembly for WPF app**, stores it as _.dll_ file.
   - **Loads the compiled assembly in memory for specific WPF usecases**
   - **Compiles new assemby - full app**. You can choose to run it in-memory (in dev-mode) or to build executable file - and then run the executable.
2. This enables a lightweight way to execute .NET code without needing a pre-installed SDK.

## **How to run**

Run the PowerShell script to compile and execute the .NET assembly:

Run the application in **development mode** (in-memory execution):
```ps1
  powershell -ep Bypass -File ./index.ps1
```

Run the application in **build mode** (as .exe file):
```ps1
  powershell -ep Bypass -c { & "./index.ps1" -buildExe $true }
```
