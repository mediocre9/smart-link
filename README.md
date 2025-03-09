<h1 align="center"><img src="android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" height="100px" alt="Smart Link"/></h1>

_<p align="center">A simple IoT based Application</p>_

<p align="center">
  <a href="https://github.com/mediocre9/smart-link/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT"/></a>
</p>

## Smart Link

> An IoT application designed for remote control and management of various devices, including Arduino, HC-05/06, ESP32 or ESP8266 (Node-MCU). The app offers features such as Google authentication, user feedback, in-app update checker and Bluetooth communication. It enables users to control robots and does also provides fingerprint biometric authentication for secure locker access through ESP32 firmware.

**⚠️ Note: The current mobile app release is incompatible with the latest firmware of <a href="https://github.com/mediocre9/esp-32-smart-safe-locker">ESP32 Smart Safe Locker Firmware</a>. Updating soon!**

## Previews
<p align="center">
  <img src="previews/screen-previews.png" height="100%">
</p>

## Features

-   [x] Google Oauth.
-   [x] User feedback system.
-   [x] In-app update checker.
-   [x] Crashlytics support. 
-   [x] Account revocation system to restrict app access.
-   [x] Save Robot commands using shared preferences.
-   [x] Bluetooth control for serial communication with HC-05/06 modules on Arduino to control the robot.
-   [x] Fingerprint biometric authentication to securely unlock lockers, communicating with ESP32.

## Architecture:

<p align="center">
  <img src="previews/architecture.png" width="100%">
</p>

## Firmware Repositories:

1. **<a href="https://github.com/mediocre9/arduino-uno-robot">Arduino Uno Robot</a>**
2. **<a href="https://github.com/mediocre9/esp-32-smart-safe-locker">ESP32 Smart Safe Locker Firmware</a>**

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/mediocre9/smart-link/blob/main/LICENSE) for details.
