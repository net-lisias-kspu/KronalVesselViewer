
set H=R:\KSP_1.3.1_dev
echo %H%
cd

copy /Y "src\bin\Debug\KronalUtils.dll" "GameData\KronalUtils\Plugins"
copy /Y KronalVesselViewer.version GameData\KronalUtils

cd GameData
mkdir "%H%\GameData\KronalUtils"
xcopy /y /s KronalUtils "%H%\GameData\KronalUtils"
