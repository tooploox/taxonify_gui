@ECHO OFF
IF "%3" == "" (
  echo Error: Invalid number of args
  echo Usage:
  echo    build_win.bat workspace build_number commit_hash
  goto :eof
)
set check_silence=""
IF not "%4" == "" (
  set check_silence=/S
)
set workspace=%1
set build_number=%2
set commit_hash=%3
ECHO "Workspace: %workspace%"

ECHO Prepare environment
set PATH=C:\Qt\5.12.0\msvc2017_64\bin;%workspace%\deployment\lib\release;

ECHO Build workspace
cd %workspace%\deployment
python.exe .\build.py --repository-path %workspace% --executables-path executables.yaml --output_zip_path %workspace%/deployment/%build_number%_%commit_hash%.zip

ECHO Run tests %check_silence%
set PATH=%workspace%\deployment\testing_utils\release;%PATH%
nmake check %check_silence% /NOLOGO
cd %workspace%
