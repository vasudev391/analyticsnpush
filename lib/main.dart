import 'package:analyticsnpush/analytics_tracker.dart';
import 'package:analyticsnpush/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'messagingApp', options: FirebaseConfig.push);

  // messagingApp = FirebaseMessaging.instanceFor(app:messagingApp);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _setupFCM();
  }

  void _setupFCM() async {
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get the token for sending notifications
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
    FirebaseTracker.firebaseRegisterToken(token ?? 'NA');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        FirebaseTracker.logFirebaseEvent(
          'notification_listen',
          {
            'message_id': message.messageId,
            'title': message.notification?.title,
          },
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        FirebaseTracker.logFirebaseEvent(
          'notification_opened',
          {
            'message_id': message.messageId,
            'title': message.notification?.title,
          },
        );
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('App launched from notification: ${message.messageId}');
        FirebaseTracker.logFirebaseEvent(
          'notification_opened_initial',
          {
            'message_id': message.messageId,
            'title': message.notification?.title,
          },
        );
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message: ${message.messageId}');
    FirebaseTracker.firebaseMessagingBackgroundHandler(message);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Notification + Analytics Sample"),
        ),
        body: Scaffold(
          body: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  child: Text('Click me'),
                  onPressed: () {
                    FirebaseTracker.logFirebaseEvent('button_clicked',
                        {'button_analytics': 'Click Me'});
                  },
                ),
                ElevatedButton(
                  child: Text('Analytics'),
                  onPressed: () {
                    FirebaseTracker.logFirebaseEvent('button_clicked',
                        {'button_analytics': 'main_button_clicked'});

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
