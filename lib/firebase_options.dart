// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB6byvpKoJHF7hPNzmyPn_Fz0Z3sU_2qbI',
    appId: '1:812958689034:web:a53d85c6e397a3b4c5fcf3',
    messagingSenderId: '812958689034',
    projectId: 'remo-tooth',
    authDomain: 'remo-tooth.firebaseapp.com',
    storageBucket: 'remo-tooth.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAX3oMXbPmmbFhp2MeNzqdbZBnXd__LR7w',
    appId: '1:812958689034:android:a5a9830330cb74b9c5fcf3',
    messagingSenderId: '812958689034',
    projectId: 'remo-tooth',
    storageBucket: 'remo-tooth.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAixS9KCMBMyRdzuvyeY-P-prXJFFQLPcQ',
    appId: '1:812958689034:ios:38ce4801db5e98dfc5fcf3',
    messagingSenderId: '812958689034',
    projectId: 'remo-tooth',
    storageBucket: 'remo-tooth.appspot.com',
    iosClientId: '812958689034-3q1vg7tj71otied79a65a7p5aa5jlaub.apps.googleusercontent.com',
    iosBundleId: 'com.example.remoTooth',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAixS9KCMBMyRdzuvyeY-P-prXJFFQLPcQ',
    appId: '1:812958689034:ios:38ce4801db5e98dfc5fcf3',
    messagingSenderId: '812958689034',
    projectId: 'remo-tooth',
    storageBucket: 'remo-tooth.appspot.com',
    iosClientId: '812958689034-3q1vg7tj71otied79a65a7p5aa5jlaub.apps.googleusercontent.com',
    iosBundleId: 'com.example.remoTooth',
  );
}
