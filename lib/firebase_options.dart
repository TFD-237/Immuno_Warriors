// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDL7Y9bIJ2n72A1nIp_mixotRox8_LP-a0',
    appId: '1:174622528956:web:b685c5c0cc1dcd7b9a07b9',
    messagingSenderId: '174622528956',
    projectId: 'immunowarriors-7d770',
    authDomain: 'immunowarriors-7d770.firebaseapp.com',
    storageBucket: 'immunowarriors-7d770.firebasestorage.app',
    measurementId: 'G-K0DLVSSPQ2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAl2Maigyn_QGCI6_gIiKeXqRoE_z1yG60',
    appId: '1:174622528956:android:09a295247b36535c9a07b9',
    messagingSenderId: '174622528956',
    projectId: 'immunowarriors-7d770',
    storageBucket: 'immunowarriors-7d770.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBh0iQPyM35vbCiehI13t8kmYm-Nf04Ye4',
    appId: '1:174622528956:ios:9e99dd6abd612b869a07b9',
    messagingSenderId: '174622528956',
    projectId: 'immunowarriors-7d770',
    storageBucket: 'immunowarriors-7d770.firebasestorage.app',
    iosBundleId: 'com.example.immunowarriors',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBh0iQPyM35vbCiehI13t8kmYm-Nf04Ye4',
    appId: '1:174622528956:ios:9e99dd6abd612b869a07b9',
    messagingSenderId: '174622528956',
    projectId: 'immunowarriors-7d770',
    storageBucket: 'immunowarriors-7d770.firebasestorage.app',
    iosBundleId: 'com.example.immunowarriors',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDL7Y9bIJ2n72A1nIp_mixotRox8_LP-a0',
    appId: '1:174622528956:web:bb7f4194910942ef9a07b9',
    messagingSenderId: '174622528956',
    projectId: 'immunowarriors-7d770',
    authDomain: 'immunowarriors-7d770.firebaseapp.com',
    storageBucket: 'immunowarriors-7d770.firebasestorage.app',
    measurementId: 'G-E7PGXMHJJW',
  );
}
