:: Run the application in development mode (in-memory execution):
powershell -ep Bypass -File ./index.ps1

:: Run the application in build mode (as .exe file):
:: start powershell "powershell -ep Bypass -c { & './index.ps1' -buildExe $true }"
