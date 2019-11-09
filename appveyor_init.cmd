REM Download and install OCaml and flexlink (unless it was already done).
REM Prepare the environment variables,... to use it.  OCaml is installed
REM at %OCAMLROOT%
REM
REM If you are using Cygwin, install it in C:\cygwin first and then
REM execute this script.  Execute bash with the option "-l".

REM set OCAMLROOT=%PROGRAMFILES%/OCaml
set OCAMLROOT=C:/PROGRA~1/OCaml

if not defined OCAML_BRANCH (set OCAML_BRANCH=4.09)
set OCAMLURL=https://ci.appveyor.com/api/projects/madroach/ocaml-appveyor/artifacts/ocaml-4.09.0.zip

if not exist "%OCAMLROOT%/bin/ocaml.exe" (
  echo Downloading OCaml %OCAML_BRANCH% from "%OCAMLURL%"
  appveyor DownloadFile "%OCAMLURL%" -FileName "%temp%/ocaml.zip"
  REM Intall 7za using Chocolatey:
  choco install 7zip.commandline
  cd "%PROGRAMFILES%"
  7za x -y "%temp%/ocaml.zip"
  del %temp%\ocaml.zip
)

REM Cygwin is always installed on AppVeyor.  Its path must come
REM before the one of Git but after those of MSCV and OCaml.
set Path=C:\cygwin\bin;%Path%

call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x64

set Path=%OCAMLROOT%\bin;%OCAMLROOT%\bin\flexdll;C:\opam\bin;%Path%
set CAML_LD_LIBRARY_PATH=%OCAMLROOT%/lib/stublibs

set CYGWINBASH=C:\cygwin\bin\bash.exe

if exist %CYGWINBASH% (
  REM Make sure that "link" is the MSVC one and not the Cynwin one.
  echo VCPATH="`cygpath -u -p '%Path%'`" > C:\cygwin\tmp\msenv
  echo PATH="$VCPATH:$PATH" >> C:\cygwin\tmp\msenv
  %CYGWINBASH% -lc "tr -d '\\r' </tmp/msenv > ~/.msenv64"
  %CYGWINBASH% -lc "echo '. ~/.msenv64' >> ~/.bash_profile"
  REM Make OCAMLROOT available in Unix form:
  echo OCAMLROOT_WIN="`cygpath -w -s '%OCAMLROOT%'`" > C:\cygwin\tmp\env
  (echo OCAMLROOT="`cygpath -u \"$OCAMLROOT_WIN\"`") >>C:\cygwin\tmp\env
  echo export OCAMLROOT_WIN OCAMLROOT >>C:\cygwin\tmp\env
  %CYGWINBASH% -lc "tr -d '\\r' </tmp/env >> ~/.bash_profile"
)

set <NUL /p=Ready to use OCaml & ocamlc -version
