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
    apiKey: 'AIzaSyBwpP_lBw0xGkwvc_PV1qFzr0TzzBxJeDw',
    appId: '1:331928022776:web:517dd3e0cf8ecd251a950d',
    messagingSenderId: '331928022776',
    projectId: 'point-of-sales-d837c',
    authDomain: 'point-of-sales-d837c.firebaseapp.com',
    storageBucket: 'point-of-sales-d837c.appspot.com',
    measurementId: 'G-Y5W7QPNX2R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNl56d6IAMXYQ7srbtVxQ2AjqtJ_UHCLQ',
    appId: '1:331928022776:android:fea5747d934aa44c1a950d',
    messagingSenderId: '331928022776',
    projectId: 'point-of-sales-d837c',
    storageBucket: 'point-of-sales-d837c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBRMYTvHSavTfJ0oL4v5bm8M1Lxn1e7N-A',
    appId: '1:331928022776:ios:ed7aff76253eb60d1a950d',
    messagingSenderId: '331928022776',
    projectId: 'point-of-sales-d837c',
    storageBucket: 'point-of-sales-d837c.appspot.com',
    iosClientId: '331928022776-vh27oemspvab9kmsm105nfegtpesodoi.apps.googleusercontent.com',
    iosBundleId: 'com.example.rnhPos',
  );
}
