# .NET App Runner via PowerShell

## **What does it do?**
Allows you to write and run a .NET application on Windows **without manually downloading and installing the latest .NET versions**.

## **How does it work?**
1. Runs a PowerShell script (`index.ps1`) that:
   - **Finds and concatenates all C# files** in the project.
   - **Compiles them into a .NET assembly** dynamically.
   - **Executes the compiled assembly** using PowerShell.
   
2. This enables a lightweight way to execute .NET code without needing a pre-installed SDK.

## **How to run**
Run the PowerShell script to compile and execute the .NET assembly:

```powershell
powershell -ep bypass -file index.ps1
```
