@ECHO OFF
SET startpath=%~dp1
SET port=%2
start "IIS Express" cmd /C "C:\Program Files (x86)\IIS Express\iisexpress" /path:%startpath%  /port:%port% /systray:true