@echo off
set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr
set PATH=%JAVA_HOME%\bin;%PATH%
cd android
call gradlew.bat --stop
if exist .gradle rd /s /q .gradle
call gradlew.bat clean assembleDebug --stacktrace