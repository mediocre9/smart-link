class AppStrings {
  AppStrings._();

  static const String appName = "Smart Link";

  static const String appVersion = "v0.7.0";

  static const String appDescription = "IoT Remote Control";

  static const String appLogo = "assets/images/logo.png";

  static final String copyright = "(c) Copyright ${DateTime.now().year} CUSIT IT & Robotics Society. All rights reserved.";

  static const String permissionInfo = "Allow Smart Link to access Bluetooth and Location permissions on this device?";

  static const String noInternet = "No internet connection. Please check your network settings and try again.";

  static const String lockerHomeInfo = "Info: Connect to the \"It & Robotics - (Node-MCU)\" network through your system's Wi-Fi settings. You will be prompted to enter the Wi-Fi password, which is \"1116equj5\". After successful connection, simply press the \"Connect\" button.";

  static const String bluetoothOnHomeDescription = "Scan for bluetooth devices";

  static const String bluetoothDiscoveryDescription = "This may take a few moments to discover nearby devices. Please be patient!";

  static const String gettingPairedDevices = "Getting paired devices . . .";

  static const String bluetoothOff = "Bluetooth is disabled!";

  static const String connectionSuccessful = "Connected!";

  static const String bluetoothDisconnected = "Disconnected!";

  static const String connectionFailed = "End device not responding!";

  static const String devicesNotInRange = "No nearby devices are available. Try Again!";

  static const String feedbackPosted = "Thank you for your valuable feedback!";

  static const String biometricLock = "Locked out due to too many attempts!";

  static const String biometricPermanent = "Locked out permanently due to too many attempts!";

  static const String biometricEnrollment = "Please register your fingerprint from your device settings!";

  static const String biometricNotSupported = "Your device does not have fingerprint support!";

  static const String deviceServerIP = "192.168.4.1";

  static const String userBlocked = "Your account access has been revoked!";

  static const String googleLogoPath = "assets/images/google_logo.png";

  static const String radarAnimationPath = "assets/animations/radar.json";

  static const String signinButtonText = "Sign in with Google";
}