@echo off

copy /Y "src\bin\Release\KronalUtils.dll" "GameData\KronalUtils\Plugins"
copy /Y KronalVesselViewer.version GameData\KronalUtils
copy README.md GameData\KronalUtils
copy LICENSE GameData\KronalUtils

copy /Y ..\MiniAVC.dll GameData\KronalUtils


set RELEASEDIR=d:\Users\jbb\release
set ZIP="c:\Program Files\7-zip\7z.exe"



type KronalVesselViewer.version
set /p VERSION= "Enter version: "



set FILE="%RELEASEDIR%\KronalVesselViewer-%VERSION%.zip"
IF EXIST %FILE% del /F %FILE%
%ZIP% a -tzip %FILE% GameData

