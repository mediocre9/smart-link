![GitHub repo size](https://img.shields.io/github/repo-size/mediocre9/smart-link?style=plastic)
![GitHub commit activity (branch)](https://img.shields.io/github/commit-activity/m/mediocre9/smart-link?style=plastic)
![GitHub closed issues](https://img.shields.io/github/issues-closed/mediocre9/smart-link?style=plastic)
![GitHub all releases](https://img.shields.io/github/downloads/mediocre9/smart-link/total?color=light&style=plastic)

<div style=" margin: 20px">
  <img src="android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" height="170">
</div>
  <h1 style="color: lightblue;"><b>Smart Link</b></h1>

> An application to remotely control Arduino devices to interact specifically with the HC-05/06 and ESP8266 (Node-MCU) modules.

## Features
- [X] User authentication
- [X] User feedback
- [X] Bluetooth controller to communicate with HC-05/06 modules with arduino
- [X] Communication with ESP8266 module via http requests
- [X] Device Fingerprint to communicate with ESP8288 via Firebase RTDB

## Hardware Repositories:
1. **<a href="https://github.com/mediocre9/arduino-uno-robot">Arduino Uno Robot</a>**
2. **<a href="https://github.com/mediocre9/nodemcu-esp8266">(SoC) ESP8266 NodeMCU</a>**
3. **<a href="https://github.com/mediocre9/nodemcu-touchpass">(SoC) ESP8266 NodeMCU - Firebase</a>**

## Design Considerations
- Command strings for the HC-05 that are hardcoded was a design choice of my University's Robotics Club. You can customize the [Bluetooth Remote Control](https://github.com/mediocre9/smart-link/blob/main/lib/screens/bluetooth_remote_screen/cubit/bluetooth_remote_cubit.dart) module to change commands or add a new feature like saving commands with shared preferences.
- The app enforces user authentication, which means that you will be prompted to sign in each time you open the app.

## Build Previews:
<p float="left">
  <img src="previews/1.jpg" height="400">
  <img src="previews/2.jpg" height="400">
  <img src="previews/3.jpg" height="400">
  <img src="previews/4.jpg" height="400">
</p>

## License
This project is licensed under the MIT License. See the [LICENSE](https://github.com/mediocre9/smart-link/blob/main/LICENSE) for details.
