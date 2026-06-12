# JStyle 2301 Smart Ring SDK & Test App - Android

This directory contains the Android SDK integration and test application for the **JStyle 2301 Smart Ring**.

---

## Running the Android App on Android Studio Emulator

The Android test application can be built and run on the Android Studio Emulator for layout, UI, and navigation flow testing.

### Prerequisites
- **Android Studio** (Koala or newer recommended).
- **JDK 11** (recommended for compilation due to Gradle 6.5 compatibility).

### Step-by-Step Procedure

#### Step 1: Open the Project in Android Studio
1. Launch **Android Studio**.
2. Select **File > Open...** (or click **Open** on the Welcome Screen).
3. Navigate to the project root directory and select the `Android/2301testjar` folder.
4. Click **OK** to open the Gradle-based project.
5. Wait for the project sync and indexing to complete.

#### Step 2: Set Up an Emulator (AVD)
1. Open the **Device Manager** (found in the right-side tool window or via **Tools > Device Manager**).
2. Click **Create Device**.
3. Select a phone hardware profile (e.g., *Pixel 8*) and click **Next**.
4. Choose a system image (e.g., *API 33 (Tiramisu)* or *API 34 (Upside Down Cake)*). If the image is not downloaded, click the download icon next to it.
5. Click **Next**, review the settings, and click **Finish**.
6. Launch the emulator by clicking the green **Play** icon next to the created device in the Device Manager.

#### Step 3: Run the App
1. In the top toolbar of Android Studio, ensure the **app** configuration is selected in the Run Configurations dropdown.
2. Choose your running emulator from the target device dropdown.
3. Click the green **Run** button (or press `Shift + F10` on Windows/Linux or `Control + R` on macOS).
4. The application will build, deploy, and launch automatically on the emulator.

---

## Skipping BLE Scanning for Emulator Testing

Since the Android Studio Emulator does not support real Bluetooth Low Energy (BLE) scanning or hardware connectivity, the app would normally get stuck on the scanning screen, preventing UI testing of the control dashboard.

To resolve this, we added an option to skip the scanning process:

### 1. "Skip to Dashboard" Button
On the scanning screen (`DeviceScanActivity.java` / `activity_scan.xml`), we added a **Skip to Dashboard** button (`btn_skip`).
- When clicked, it stops any active BLE scan.
- It launches `MainActivity.java` directly, passing an `isSkip = true` intent extra.

### 2. Enabling Controls and Mock Connection State
Normally, the command control buttons on the main dashboard are disabled by default. They are only enabled after a device successfully connects and writes BLE descriptors (notified via `ACTION_GATT_onDescriptorWrite`).

When the user chooses to skip scanning:
- `MainActivity.java` reads the `isSkip` intent extra.
- It calls `mainAdapter.setEnable(true)` immediately during initialization.
- It enables the connection button and sets its text to **"Disconnected (Skipped Scan)"** to visually indicate the mocked state.
- This allows testing layout options, buttons, and navigation on the emulator without needing a physical JStyle 2301 Smart Ring.

---

## Troubleshooting Build Issues

### Unsupported class file major version (e.g., version 65)
The project runs on Gradle 6.5, which is not compatible with modern Java runtimes like Java 21 (class major version 65).
- If you build via CLI, ensure you compile using **JDK 11** by configuring `JAVA_HOME`.
- If compiling via Android Studio, configure the JDK version in **Settings > Build, Execution, Deployment > Build Tools > Gradle > Gradle JDK** to use Java 11.

---

## Building and Locating the APK File

To generate a standalone APK package file for testing or deployment, use one of the following methods:

### Method 1: Using the Android Studio UI (Recommended)
1. In the top menu bar of Android Studio, select **Build > Build Bundle(s) / APK(s) > Build APK(s)**.
2. Wait for the build task to complete (monitor the progress in the bottom status bar).
3. Once completed, a notification popup will appear at the bottom-right corner stating:  
   `APK(s) generated successfully for 1 module: Locate`
4. Click the blue **Locate** link in that popup. Android Studio will open your macOS Finder directly in the directory containing the APK file.

### Method 2: Using the Command Line
1. Open your terminal and navigate to the project directory:
   ```bash
   cd Android/2301testjar
   ```
2. Execute the Gradle assemble task:
   ```bash
   ./gradlew assembleDebug
   ```

### Output Location
The compiled debug APK file is named **`app-debug.apk`** and is generated at:
* **Path:** [app-debug.apk](file:///Users/omkar/Documents/Canspirit/jring_andr_ios_sdk/Android/2301testjar/app/build/outputs/apk/debug/app-debug.apk) *(Relative: `Android/2301testjar/app/build/outputs/apk/debug/app-debug.apk`)*

---

## App Features

At the bottom of the main dashboard, the app lists the following SDK interaction features:

1. **Device Time**: Set and retrieve the current date and time on the smart ring.
2. **Personal Info**: Configure and get personal profile metadata (e.g., height, weight, gender, age).
3. **Goal**: Manage steps/activity goals.
4. **Battery**: Query the current battery percentage of the smart ring.
5. **Device Version**: Read firmware and hardware version numbers.
6. **Factory Reset**: Wipe all settings on the device and restore defaults.
7. **MCU Reset**: Perform a soft reset of the device's microcontroller.
8. **Auto Measurement**: Setup intervals and toggle auto HR/temperature/Spo2/BP measurements.
9. **Real-time Step**: Enable or disable real-time activity and step data sync.
10. **Total Activity Data**: Retrieve historical total exercise and activity data.
11. **Detail Activity Data**: Retrieve granular step and exercise interval records.
12. **Sleep Data**: Read historical sleep phase data (deep, light, awake).
13. **HR Data**: Fetch historical and real-time heart rate records.
14. **Temperature Data**: Retrieve auto and manual body temperature measurements.
15. **Spo2 Data**: Fetch automatic and manual blood oxygen level data.
16. **HRV Data**: Read Heart Rate Variability information.
17. **PPG**: Access Photoplethysmogram data streams.
18. **Log**: Access and export debugging log files.