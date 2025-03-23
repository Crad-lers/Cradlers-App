import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: "AIzaSyBvWkdSJk8kwkrs6nT0c9dTBt9_lDnTECg",
        authDomain: "cradlers-69c8b.firebaseapp.com",
        databaseURL: "https://cradlers-69c8b-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "cradlers-69c8b",
        storageBucket: "cradlers-69c8b.firebasestorage.app",
        messagingSenderId: "726880339466",
        appId: "1:726880339466:web:f0bdbfdd852e144d6bc1f3",
        measurementId: "G-4Y72VJRG77",
      );

    }

    throw UnsupportedError("Unsupported platform");
  }
}