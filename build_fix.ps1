# PowerShell script to fix JAVA_HOME and build
$env:JAVA_HOME = 'C:\Program Files\Android\Android Studio\jbr'
$env:Path = "$env:JAVA_HOME\bin;$env:Path"
cd android
.\gradlew --stop
.\gradlew clean assembleDebug --stacktrace