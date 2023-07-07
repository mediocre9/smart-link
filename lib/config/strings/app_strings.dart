class AppString {
  AppString._();

  static const String kAppName = 'Smart Link';
  static const String kAppVersion = 'v0.4.2';
  static const String kAppDescription = 'IoT Remote Control';
  static const String kAppLogoPath = 'assets/images/logo.png';
  static const String kInitialDescription = 'Scan for bluetooth devices';
  static const String kDiscoveryDescription =
      'This may take a few moments to discover nearby devices. Please be patient!';
  static const String kNoInternetMessage = 'No Internet Connection!';
  static const String kBluetoothOffStateMessage = 'Bluetooth service is off.';
  static const String kDevicesNotInRangeMessage =
      'No nearby device(s) available. Try Again!';
  static const String kCopyrightStatement =
      '(c) Copyright 2023 CUSIT IT & Robotics Engineering Society. All rights reserved.';

  static const String kBiometricLockMessage =
      "Locked out due to too many attempts!";
  static const String kBiometricPermanentLockMessage =
      "Locked out permanently due to too many attempts!";
  static const String kBiometricEnrollmentMessage =
      "Please register your fingerprint from your device settings!";
  static const String kBiometricSupportMessage =
      "Your device does not have fingerprint support!";
  static const String kNodeMCUDefaultIp = "192.168.4.1";

  static const String kAuthSuspendMessage = 'Your account has been suspended.';
  static const String kGoogleLogoPath = 'assets/images/google_logo.png';
  static const String kRadarAnimationPath = 'assets/animations/radar.json';
  static const String kGoogleButtonText = 'Sign in with Google';
}
