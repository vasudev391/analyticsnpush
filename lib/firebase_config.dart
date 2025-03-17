import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  // Configuration for Analytics Project
  static FirebaseOptions get analytics {
    return const FirebaseOptions(
      apiKey: 'AIzaSyAv4YCxoFL6ZSIMCaz0eVER6IBrcynfU3g',
      appId: '1:291232627991:android:f95b8805ae06787752cb52',
      messagingSenderId: '291232627991',
      projectId: 'analytics-b11d8',
      storageBucket: 'analytics-b11d8.firebasestorage.app',
      // Add platform-specific keys (android, iOS, web) if needed
    );
  }

  // Configuration for Push Notification Project
  static FirebaseOptions get push {
    return const FirebaseOptions(
      apiKey: 'AIzaSyAYCsRAt4TZ_thma_5hHqktetU9J1AwKrQ',
      appId: '1:547440788257:android:37319db36d04043f68b460',
      messagingSenderId: '547440788257',
      projectId: 'apps-push-notification-b0458',
      storageBucket: 'apps-push-notification-b0458.firebasestorage.app',
      // Add platform-specific keys (android, iOS, web) if needed
    );
  }
}