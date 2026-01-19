# Fix Java 25 + Lombok Build Error

## Problem
The build fails with:
```
java.lang.ExceptionInInitializerError: com.sun.tools.javac.code.TypeTag :: UNKNOWN
```

## Root Cause
- You have **Java 25** installed
- **Lombok 1.18.30** does NOT support Java 25
- Spring Boot 3.3.5 is configured for Java 21 (the current LTS version)

## Solution

### Option 1: Install Java 21 (Recommended)
1. Download Java 21 JDK from: https://www.oracle.com/java/technologies/downloads/#java21
2. Install it to `C:\Program Files\Java\jdk-21`
3. Run the build:
   ```bash
   set JAVA_HOME=C:\Program Files\Java\jdk-21
   mvnw clean package
   ```

   OR simply use the provided batch script:
   ```bash
   build-with-java21.bat
   ```

### Option 2: Use Java 21 Temporarily
Set JAVA_HOME before each build:
```bash
set JAVA_HOME=C:\Program Files\Java\jdk-21
mvnw clean package
```

### Option 3: Keep Both Java Versions
- Keep Java 25 as your default
- Install Java 21 alongside it
- Set JAVA_HOME to Java 21 when building this project

## Changes Made
- Updated `pom.xml` to target Java 21:
  ```xml
  <java.version>21</java.version>
  <maven.compiler.source>21</maven.compiler.source>
  <maven.compiler.target>21</maven.compiler.target>
  ```
- Updated Lombok to version 1.18.30 (latest stable supporting Java 21)

## Verify Installation
```bash
java -version
```
Should show:
```
java version "21.x.x"
```

## Additional Notes
- Java 21 is the current LTS (Long Term Support) version
- Spring Boot 3.3.5 officially supports Java 21
- Lombok currently doesn't support Java 25
- You can still use Java 25 for other projects that don't use Lombok
