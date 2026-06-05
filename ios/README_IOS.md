# JStyle 2301 Smart Ring SDK & Test App - iOS

This directory contains the iOS SDK integration and test application for the **JStyle 2301 Smart Ring**.

---

## Running the iOS App on Xcode Simulator (Emulator)

The iOS test application can be built and run on the Xcode Simulator for layout, UI, and navigation flow testing.

### Prerequisites
- **macOS** operating system.
- **Xcode** IDE (version 13 or newer recommended).

### Step-by-Step Procedure

#### Step 1: Open the Project in Xcode
1. Locate and open the iOS project directory: `ios/Ble SDK Demo`.
2. Double-click the file `Ble SDK Demo.xcodeproj` to open it in **Xcode**.
3. Allow Xcode to complete indexing the project files.

#### Step 2: Select a Simulator Target
1. In the top-left toolbar of Xcode (next to the play and stop buttons), click the scheme destination dropdown (it usually shows the project name and target device).
2. From the dropdown menu, under the **iOS Simulators** section, select a device simulator (e.g., *iPhone 15 Pro* or *iPhone SE (3rd generation)*).

#### Step 3: Run the App
1. Click the **Run** button (the triangular Play icon in the top-left corner) or press `Cmd + R` on your keyboard.
2. Xcode will build the project. Once the compilation is complete, it will launch the selected iOS Simulator.
3. The test application will boot and launch automatically on the simulated iOS screen.

---

## Skipping BLE Scanning for Emulator Testing

Since the iOS Simulator does not support real Bluetooth Low Energy (BLE) scanning or connection to physical peripherals, the app would normally require a physical device connected to debug/view the central dashboard features.

To resolve this, we added an option to skip the scanning process:

### 1. "Skip to Dashboard" Button
- When clicking the **Scan** button on the main view, the app displays `myTableView` to list nearby peripherals.
- We modified the layout of this view's footer (`MyFootView`) to be taller (`90 * Proportion`) and added a **Skip to Dashboard** button alongside the standard **Cancel** button.
- Tapping **Skip to Dashboard** calls the `skipToDashboard` method, which:
  - Sets the state tracker `isSkip = YES;`.
  - Hides the scanning overlay and stops active BLE scanning (`[self HiddenTableView]`).
  - Sets the title of the scan button (`_btnScan`) to **"Disconnected (Skipped Scan)"** to visually indicate the mocked/skipped state.

### 2. State Management & Resetting
- While in the skipped state, the dashboard buttons remain enabled, allowing developers to click them to inspect secondary view layouts and configurations.
- Tapping the scan button again (`findMyBle`) or experiencing actual BLE connection/disconnection events (`ConnectSuccessfully` / `Disconnect:`) will:
  - Reset `isSkip` to `NO`.
  - Set the scan button text back to **"Scan"** (`LocalForkey(@"扫描")`).

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
