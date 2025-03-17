import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseTracker {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance; // Default app only

  static Future<void> logFirebaseEvent(String eventName, Map<String, dynamic>? parameters) async {
    if (eventName == 'screen_view') {
      if (parameters == null || !parameters.containsKey('screen_name')) {
        throw ArgumentError('screen_name is required for screen view events');
      }
      String screenName = parameters['screen_name'];
      await analytics.logScreenView(screenName: screenName);
    } else {
      await analytics.logEvent(name: eventName, parameters: parameters);
    }
  }

  // Handle background messages
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(); // Required for background handler
    print('Background message received: ${message.messageId}');
    // Log event for message received in background (using default app analytics here)
    await analytics.logEvent(
      name: 'notification_received',
      parameters: {
        'message_id': message.messageId,
        'title': message.notification?.title,
      },
    );
  }


  static Future<void> firebaseRegisterToken(String token) async {
    await Firebase.initializeApp(); // Required for background handler
    print('Background message received: ${token}');
    // Log event for message received in background (using default app analytics here)
    await analytics.logEvent(
      name: 'register_token',
      parameters: {
        'token': token,
        'title': "Notification + Analytics Sample",
      },
    );
  }

}