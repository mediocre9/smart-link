<h1 align="center"><img src="android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" height="100px" alt="Smart Link"/></h1>

_<p align="center">A simple IoT Application</p>_

<p align="center">
  <a href="https://github.com/mediocre9/smart-link/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT"/></a>
</p>

## Smart Link

> Smart Link is an IoT application designed for remote control and management of various devices, including Arduino, HC-05/06, ESP32, and ESP8266 (Node-MCU). The app offers features such as Google authentication, user feedback, in-app update checker, and secure Bluetooth communication. It enables users to control robots via Arduino and provides fingerprint biometric authentication for secure locker access through ESP32 firmware.

## Features

-   [x] Google Oauth.
-   [x] User feedback system.
-   [x] In-app update checker.
-   [x] Crashlytics support. 
-   [x] Account revocation system to restrict app access.
-   [x] Save Robot commands using shared preferences.
-   [x] Bluetooth control for serial communication with HC-05/06 modules on Arduino to control the robot.
-   [x] Fingerprint biometric authentication to securely unlock lockers, communicating with ESP32.

<p align="center">
  <img src="previews/preview.jpeg" width="100%">
</p>

## Architecture:

<p align="center">
  <img src="previews/architecture.png" width="100%">
</p>

## Firmware Repositories:

1. **<a href="https://github.com/mediocre9/arduino-uno-robot">Arduino Uno Robot</a>**
2. **<a href="https://github.com/mediocre9/esp-32-smart-safe-locker">ESP32 Smart Safe Locker Firmware</a>**

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/mediocre9/smart-link/blob/main/LICENSE) for details.
