@echo off
SETLOCAL

call :makeDirectory c:\\aia
call :makeDirectory c:\\aia\\components

set aiapath=c:\\aia\\components
set setting_url=https://arm101-eiffel004.lmera.ericsson.se:8443/nexus/content/repositories/snapshots/com/ericsson/aia/bps/engine/settings_xml/0.0.1-SNAPSHOT/settings_xml-0.0.1-20160614.114555-4.xml
set hadoop_url=https://arm101-eiffel004.lmera.ericsson.se:8443/nexus/content/repositories/snapshots/com/ericsson/aia/bps/engine/hadoop-bin/0.0.1-SNAPSHOT/hadoop-bin-0.0.1-20160612.123002-2.zip
set maven_url=http://mirror.ox.ac.uk/sites/rsync.apache.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.zip
set scala_url=http://downloads.lightbend.com/scala/2.11.0/scala-2.11.0.zip
set jdk_url=https://arm101-eiffel004.lmera.ericsson.se:8443/nexus/content/repositories/snapshots/com/ericsson/aia/bps/engine/jdk/0.0.1-SNAPSHOT/jdk-0.0.1-20160615.120707-2.zip
set jre_url=https://arm101-eiffel004.lmera.ericsson.se:8443/nexus/content/repositories/snapshots/com/ericsson/aia/bps/engine/jre/0.0.1-SNAPSHOT/jre-0.0.1-20160615.120529-2.zip
set envVal=
set settings_path=%aiapath%\\settings.xml
set currentPath=%cd%

echo Installing AIA_JAVA_HOME
CALL :install AIA_JAVA_HOME %aiapath%\\jdk1.8.0_91 1.8-91 jdk %jdk_url%
echo.

echo Installing AIA_MAVEN_HOME
CALL :install AIA_MAVEN_HOME %aiapath%\\apache-maven-3.3.9 3.3.9 maven %maven_url%
echo.

echo Installing HADOOP_HOME
CALL :install HADOOP_HOME %aiapath%\\hadoop-bin 0.0.1 hadoop-bin %hadoop_url%
echo.

IF NOT EXIST "%settings_path%" (

powershell -command "(new-object System.Net.WebClient).DownloadFile('%setting_url%', '%settings_path%')"

)

call :TakeUserInput

EXIT /B %ERRORLEVEL%

:TakeUserInput

echo.
set /p status="To run spark-batch-app application: Please press R or for Tearing Down dependencies please press T or Press Q for Quit:::   "

if /i "%status%"=="q" (

EXIT /B

) else if /i "%status%"=="t" (

echo ".....Tear Down...!"

rd /q /s "%aiapath%"

	EXIT /B
) else if /i "%status%"=="r" (

	if  not exist "%cd%\\target\\uber-spark-batch-processing-local.jar" (

		%AIA_MAVEN_HOME%\\bin\\mvn clean install -s %settings_path%
	)

	echo Executing application

	%AIA_JAVA_HOME%\\bin\\java.exe -jar "%cd%\\target\\uber-spark-batch-processing-local.jar" "%cd%\\sample-flows\\flow.xml" 1> "%aiapath%\\log.txt" 2>&1

	call :checkFailure "%aiapath%\\log.txt"

	EXIT /B
) else (

	call :TakeUserInput
)

EXIT /B 0

:install
%<HOME_NAME>% %<INSTALL_PATH>% %<VERSION>% %<NAME>% %<URL>%

echo.
IF not exist "%2%" (
	rem if %4 was not located
	rem if %1 has been defined then use the existing value

	echo 	Could not locate, so installing %4 %3. this might take a little while

	call :NoExistingTypeName %1 %2 %3 %4 %5

	set %1=%2

) else IF exist "%2%" (
	rem check if %4 was located
	rem if %4 located display message to user
	rem update %1
	echo 	Located %4 %3 at %2%
	echo 	%1 has been found
	set %1=%2
)
EXIT /B 0

:makeDirectory <PATH>

IF exist "%2%" (

  echo 	%2% Folder already exists

) else IF not exist %1 (

	mkdir %1

)
EXIT /B 0

:NoExistingTypeName <HOME_NAME> <INSTALL_PATH> <VERSION> <NAME> <URL>
echo.
set folder=%aiapath%\\%4.zip

IF exist "%folder%" (
	echo 	using existing zip file, unzipping %4 "%aiapath%\\" "%folder%"
	call :UnZipFile "%aiapath%\\" "%folder%"
	EXIT /B 0
)

::call :makeDirectory %folder%
::Downloading files

echo 	Downloading files %4
powershell -command "(new-object System.Net.WebClient).DownloadFile('%5', '%folder%')"
echo 	downloaded %folder%
echo.
echo 	unzipping %4
call :UnZipFile "%aiapath%\\" "%folder%"

::if exist "%folder%" rd /q /s "%folder%"
::Call :UnZipFile "C:\\Temp\\fff\\" "%cd%\\hadoop-bin.zip%"

rem display message to the user that %1 is not available
echo 	No Existing value of %1 is available
set %1 %2
echo 	Setting environment variable %1 its path is %2
set "envVal=%2\\bin;%envVal%"
rem cd %2\\bin
echo 	Sucessfuly set %2 path end
EXIT /B 0

:UnZipFile <ExtractTo> <newzipfile>
set vbs="%temp%\\_.vbs"
if exist %vbs% del /f /q %vbs%
>%vbs%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%vbs% echo If NOT fso.FolderExists(%1) Then
>>%vbs% echo fso.CreateFolder(%1)
>>%vbs% echo End If
>>%vbs% echo set objShell = CreateObject("Shell.Application")
>>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
>>%vbs% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%vbs% echo Set fso = Nothing
>>%vbs% echo Set objShell = Nothing
cscript //nologo %vbs%
if exist %vbs% del /f /q %vbs%
EXIT /B 0

:checkFailure <LOG_PATH>
echo "%1%"
::If %~z1 EQU 0 (echo Successfully written output to C:\\tmp\\batch-op.)
	find "Exception occurred while executing application" %1
	if %errorlevel%==1 (
		echo Successfully written output.
	)
	echo Please check %1 for more details
EXIT /B 0