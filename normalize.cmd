rem -- normalize and prepare the weather version
set file=%1
set weather_file=%2
set mission_version=%3
set mission_file=%file%_%mission_version%.miz
rem echo file=[%file%]
rem echo weather_file=[%weather_file%]
rem echo version=[%version%]
rem echo mission_file=[%mission_file%]

echo normalize and prepare the version for %version%
pushd node_modules\veaf-mission-creation-tools\scripts\veaf
"%LUA%" veafMissionNormalizer.lua ..\..\..\..\build\tempsrc %weather_file% %LUA_SCRIPTS_DEBUG_PARAMETER%
popd

rem -- compile the mission
"%SEVENZIP%" a -r -tzip "%mission_file%" .\build\tempsrc\* -mem=AES256 >nul 2>&1
echo Built %MISSION_FILE%

:end