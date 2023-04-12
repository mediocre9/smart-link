// ignore_for_file: constant_identifier_names

/// Constant string values for app.
class AppString {
  AppString._();

  static const String APP_NAME = 'Smart Link';
  static const String APP_VERSION = 'v0.3.2';
  static const String APP_DESCRIPTION = 'IoT Remote Control';
  static const String INITIAL_HOME_SCREEN = 'Scan for bluetooth devices';
  static const String DISCOVERING_MSG =
      'This may take a few moments to discover nearby devices. Please be patient!';
  static const String NO_INTERNET_MSG = 'No Internet Connection!';
  static const String DISABLED_BLUETOOTH_MSG = 'Bluetooth service is off.';
  static const String UNDISCOVERED_DEVICES_MSG =
      'No nearby device(s) available. Try Again!';
  static const String COPYRIGHT =
      '(c) Copyright 2023 CUSIT IT & Robotics Engineering Society. All rights reserved.';

  static const String TEMPORARY_LOCKED_OUT_ERROR =
      "Locked out due to too many attempts!";
  static const String PERMANENT_LOCKED_OUT_ERROR =
      "Locked out permanently due to too many attempts!";
  static const String BIOMETRIC_NOT_ENROLLED_ERROR =
      "Please register your fingerprint from your device settings!";
  static const String HARDWARE_SUPPORT_NOT_AVAILABLE =
      "Your device does not have fingerprint support!";
  static const String NODEMCU_DEFAULT_IP = "192.168.4.1";
}
