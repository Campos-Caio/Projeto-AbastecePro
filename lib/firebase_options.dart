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
    apiKey: 'AIzaSyDbON-MOcEWhJK4g5PJBatYc9T0VkGaSFY',
    appId: '1:30445512610:web:93772ddec00562b472b4fb',
    messagingSenderId: '30445512610',
    projectId: 'abastecepro-fb3c1',
    authDomain: 'abastecepro-fb3c1.firebaseapp.com',
    storageBucket: 'abastecepro-fb3c1.firebasestorage.app',
    measurementId: 'G-MCLXCB873R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQyYMl4SE45XddusX4kpvCcU9ysVZygP0',
    appId: '1:30445512610:android:0412e231f8ba66b572b4fb',
    messagingSenderId: '30445512610',
    projectId: 'abastecepro-fb3c1',
    storageBucket: 'abastecepro-fb3c1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGLWFqG8yQf_nuhfwwiRyuHTrPLxfv1YM',
    appId: '1:30445512610:ios:bb06806b119b50b872b4fb',
    messagingSenderId: '30445512610',
    projectId: 'abastecepro-fb3c1',
    storageBucket: 'abastecepro-fb3c1.firebasestorage.app',
    iosClientId: '30445512610-pljfvb5t8gei2tod492lts3s17rgle2f.apps.googleusercontent.com',
    iosBundleId: 'com.example.abastecePro',
  );
}
