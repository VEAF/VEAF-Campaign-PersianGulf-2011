@echo off
set MISSION_NUMBER=%1
set MISSION_NAME=VEAF-PersianGulf-2011-%MISSION_NUMBER%
echo.
echo building %MISSION_NAME%

rem echo on

rem -- prepare the folders
echo preparing the folders
mkdir .\build\tempsrc

echo building the mission
rem -- copy all the source mission files and mission-specific scripts
xcopy /y /e src\%MISSION_NUMBER%\mission .\build\tempsrc\ >nul 2>&1
xcopy /y src\%MISSION_NUMBER%\options .\build\tempsrc\  >nul 2>&1
xcopy /y /e src\%MISSION_NUMBER%\scripts\*.lua .\build\tempsrc\l10n\Default\  >nul 2>&1

rem -- set the radio presets according to the settings file
echo set the radio presets according to the settings file
pushd node_modules\veaf-mission-creation-tools\scripts\veaf
"%LUA%" veafMissionRadioPresetsEditor.lua  ..\..\..\..\build\tempsrc ..\..\..\..\src\%MISSION_NUMBER%\radio\radioSettings.lua %LUA_SCRIPTS_DEBUG_PARAMETER% >nul 2>&1
popd

rem -- copy the documentation images to the kneeboard
xcopy /y /e doc\%MISSION_NUMBER%\*.jpg .\build\tempsrc\KNEEBOARD\IMAGES\ >nul 2>&1

rem -- copy all the community scripts
copy .\src\%MISSION_NUMBER%\scripts\community\*.lua .\build\tempsrc\l10n\Default >nul 2>&1
copy .\build\tempscripts\community\*.lua .\build\tempsrc\l10n\Default >nul 2>&1

rem -- copy all the common scripts
copy .\build\tempscripts\veaf\*.lua .\build\tempsrc\l10n\Default >nul 2>&1

rem -- normalize and prepare the weather and time version 
echo normalize and prepare the weather and time version 
FOR %%f IN (.\src\%MISSION_NUMBER%\weatherAndTime\*.lua) DO call normalize.cmd "%MISSION_FILE%" "%%~ff" "%%~nf"

rem -- cleanup the mission files
echo cleanup the mission files
rd /s /q .\build\tempsrc
