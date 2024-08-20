import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifcationServices {
    NotifcationServices();
    Future<void> handleNotificationFunction() async {
        try {
            FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
            initializeNotification(flutterLocalNotificationsPlugin);
            requestNotificationPermissions(flutterLocalNotificationsPlugin);
            showNotificationDetails(flutterLocalNotificationsPlugin);
        } catch (e) {
            print("xxxxxxxxxxxxxxx Cant grant notification permission xxxxxxxxxxxxxxx");
        }
    }
    Future<void> requestNotificationPermissions(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
            flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
            //flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()!.requestPermissions(sound: true, alert: true, badge: true);
    }
    Future<void> initializeNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
        AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
        DarwinInitializationSettings iosInitializationSettings =  DarwinInitializationSettings(
            requestAlertPermission: false,
            requestSoundPermission: false,
            requestBadgePermission: false,
            onDidReceiveLocalNotification: (id, title, body, payload) async { },
            );
        final InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
        try{
          await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (details) { } );
        }catch(e){ 
          print("somthing went wrong ${e.toString()}");
        }
    }
    Future<void> showNotificationDetails(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async{
        const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
            "channel_id",
            "channel_name",
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
        const NotificationDetails notificationDetails = NotificationDetails(android:androidNotificationDetails);
          await flutterLocalNotificationsPlugin.show(0, 'plain title', 'plain body', notificationDetails, payload: 'item x');
    }

}
