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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBig_GQA30Nh1gTSq9cBfEY_6mJ_2RaZeI',
    appId: '1:114506049180:web:809539db9bf58ba6e1af59',
    messagingSenderId: '114506049180',
    projectId: 'attendance-app-4d18a',
    authDomain: 'attendance-app-4d18a.firebaseapp.com',
    storageBucket: 'attendance-app-4d18a.appspot.com',
    measurementId: 'G-415X6F39NR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDm25mbBMkf6EGQUZiWa8FFEIUOaxQ5b7k',
    appId: '1:114506049180:android:6820425168c6cd6fe1af59',
    messagingSenderId: '114506049180',
    projectId: 'attendance-app-4d18a',
    storageBucket: 'attendance-app-4d18a.appspot.com',
  );
}