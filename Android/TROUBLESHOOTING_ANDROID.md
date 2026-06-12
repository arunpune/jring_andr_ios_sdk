# Android Project Setup & Emulator Troubleshooting Guide

This guide provides step-by-step instructions for importing, configuring, and troubleshooting the `2301testjar` Android application on modern versions of Android Studio. Follow these steps if the project fails to build, displays configuration issues (such as `<no module>`), or encounters JVM/Gradle version incompatibility errors.

---

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Step 1: Opening the Correct Directory in Android Studio](#step-1-opening-the-correct-directory-in-android-studio)
3. [Step 2: Configuring Gradle JDK (Java 11)](#step-2-configuring-gradle-jdk-java-11)
4. [Step 3: Resolving AGP & Gradle Incompatibility (For Modern Android Studio)](#step-3-resolving-agp--gradle-incompatibility-for-modern-android-studio)
5. [Step 4: Syncing the Project](#step-4-syncing-the-project)
6. [Step 5: Building and Running on the Emulator](#step-5-building-and-running-on-the-emulator)
7. [Step 6: Bypassing Bluetooth Scanning on the Emulator](#step-6-bypassing-bluetooth-scanning-on-the-emulator)

---

## Prerequisites
* **Android Studio** (Koala, Ladybug, or newer recommended).
* **Virtual Device (AVD)** set up in Android Studio (e.g., Pixel 8, API 33/34).
* **Java Development Kit (JDK) 11** installed on your system.

---

## Step 1: Opening the Correct Directory in Android Studio

> [!IMPORTANT]
> Opening the parent `Android` folder will prevent Android Studio from identifying the Gradle build configuration, resulting in a **`<no module>`** or **`No run configurations added`** state.

1. Launch **Android Studio**.
2. If a project is already open, go to the top menu and select **File > Close Project** to return to the Welcome screen.
3. Click **Open** (or select **File > Open...**).
4. Navigate to the project root directory and select the **`2301testjar`** subfolder:
   * **Correct Path:** `.../jring_andr_ios_sdk/Android/2301testjar`
5. Click **Open** (or **OK**) to open the project as a Gradle root.
6. Click **Trust Project** if prompted.

---

## Step 2: Configuring Gradle JDK (Java 11)

This project compiles on a version of Gradle that requires **JDK 11**. Running it under modern Java versions (like JDK 17 or JDK 21) will cause build failures during Gradle initialization.

1. Open the Android Studio Settings:
   * On macOS: **Android Studio > Settings...** (or press `Cmd + ,`).
   * On Windows/Linux: **File > Settings...** (or press `Ctrl + Alt + S`).
2. In the left-hand sidebar, navigate to:  
   **Build, Execution, Deployment > Build Tools > Gradle**.
3. Under the **Gradle Projects** section, locate the **Gradle JDK** dropdown.
4. Select a compatible **Java 11 (JDK 11)** runtime (e.g., `jbr_dcevm-11` or `openjdk-11`).
5. *If Java 11 is not installed:*
   * Click the **Gradle JDK** dropdown and select **Download JDK...**.
   * Choose **Version 11** and select a vendor (e.g., *Amazon Corretto* or *Eclipse Temurin*).
   * Click **Download**.
6. Click **Apply** and then **OK** to save changes.

---

## Step 3: Resolving AGP & Gradle Incompatibility (For Modern Android Studio)

Modern Android Studio versions enforce a minimum **Android Gradle Plugin (AGP)** version of **7.1.0**. Because the repository originally configured AGP version `3.6.4`, you must manually adjust the configuration files.

### 1. Update Gradle Wrapper Version
Open [gradle-wrapper.properties](file:///Users/omkar/Documents/Canspirit/jring_andr_ios_sdk/Android/2301testjar/gradle/wrapper/gradle-wrapper.properties) and update the `distributionUrl` to point to Gradle **7.5** or **7.2**:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
```

### 2. Update Android Gradle Plugin Classpath
Open the root [build.gradle](file:///Users/omkar/Documents/Canspirit/jring_andr_ios_sdk/Android/2301testjar/build.gradle) file and update the `com.android.tools.build:gradle` dependency under the `dependencies` block to **`7.1.0`**:
```groovy
buildscript {
    ...
    dependencies {
        classpath 'com.android.tools.build:gradle:7.1.0'
        classpath 'org.greenrobot:greendao-gradle-plugin:3.3.0'
    }
}
```

---

## Step 4: Syncing the Project

Once the correct directory is open and the configurations are updated, the project must be synced to generate the run module configurations.

1. Locate the **Sync Project with Gradle Files** button in the top-right toolbar of Android Studio (represented by an **Elephant icon with a circular refresh arrow** next to the Hammer icon).
2. Click the Sync button.
3. Observe the build status in the bottom toolbar. Wait for the progress bar (e.g., *Importing '2301testjar' Gradle Project*) to finish.
4. Once completed, the run configuration dropdown at the top center of Android Studio will automatically change from `Add Configuration` to **`app`**.

---

## Step 5: Building and Running on the Emulator

1. Open the **Device Manager** from the right tool window sidebar (or select **Tools > Device Manager**).
2. Start your configured Android Emulator by clicking the green **Play** button.
3. In the center top toolbar of Android Studio, confirm that:
   * The configuration dropdown is set to **`app`**.
   * The target device dropdown displays your active emulator.
4. Click the green **Run** button (the Play icon) or press `Control + R` on macOS (`Shift + F10` on Windows).
5. Android Studio will build the APK, deploy it to the virtual device, and start the app automatically.

---

## Step 6: Bypassing Bluetooth Scanning on the Emulator

Android Virtual Devices (emulators) do not support native Bluetooth Low Energy (BLE) scanning. The app will launch into a scanning screen, waiting to discover a physical JStyle 2301 Smart Ring.

To test the layout, UI, and SDK feature modules on an emulator:
1. Tap the **"Skip to Dashboard"** button on the scanning screen.
2. The application will transition to the main control screen.
3. The connection state is mocked to allow visual layout inspections and navigation testing without requiring physical hardware.

---

## Troubleshooting Common Build Errors

### Error: `package android.support.test does not exist`
If you encounter compilation errors stating that the `android.support.test` packages do not exist, it is because the project's dependency block is missing the support test library packages.

**Resolution:**
1. Open the app module's [build.gradle](file:///Users/omkar/Documents/Canspirit/jring_andr_ios_sdk/Android/2301testjar/app/build.gradle).
2. Ensure the following test runner and rule libraries are added under the `dependencies` block:
   ```groovy
   dependencies {
       ...
       testImplementation 'junit:junit:4.12'
       androidTestImplementation 'com.android.support.test:runner:1.0.2'
       androidTestImplementation 'com.android.support.test:rules:1.0.2'
       ...
   }
   ```
3. Click the **Sync Project with Gradle Files** button (Elephant icon) to download the missing packages.

