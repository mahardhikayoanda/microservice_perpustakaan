@echo off
REM This script builds the buku module with Java 21
REM 
REM IMPORTANT: You must have Java 21 JDK installed!
REM Download from: https://www.oracle.com/java/technologies/downloads/#java21
REM
REM After installation, update the path below to match your installation:

REM Default installation paths to check
if exist "C:\Program Files\Java\jdk-21" (
    set "JAVA_HOME=C:\Program Files\Java\jdk-21"
    echo Using Java 21 from: %JAVA_HOME%
) else if exist "C:\Program Files\Java\jdk-21.0.1" (
    set "JAVA_HOME=C:\Program Files\Java\jdk-21.0.1"
    echo Using Java 21 from: %JAVA_HOME%
) else (
    echo ERROR: Java 21 JDK not found!
    echo.
    echo Please install Java 21 from: https://www.oracle.com/java/technologies/downloads/#java21
    echo Then either:
    echo   1. Install to: C:\Program Files\Java\jdk-21
    echo   2. Or edit this script and set JAVA_HOME to your installation path
    echo.
    pause
    exit /b 1
)

echo.
echo Building buku module with Java 21...
echo.

cd /d "%~dp0"
mvnw clean package -DskipTests

pause
