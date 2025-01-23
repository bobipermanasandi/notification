import 'package:flutter/material.dart';
import 'package:notification/providers/local_notification_provider.dart';
import 'package:notification/providers/payload_provider.dart';
import 'package:notification/screen/detail_screen.dart';
import 'package:notification/screen/home_screen.dart';
import 'package:notification/services/http_service.dart';
import 'package:notification/services/local_notification_service.dart';
import 'package:notification/static/my_route.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  String route = MyRoute.home.name;

  String? payload;

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final notificationResponse =
        notificationAppLaunchDetails!.notificationResponse;
    route = MyRoute.detail.name;
    payload = notificationResponse?.payload;
  }

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => HttpService(),
        ),
        Provider(
          create: (context) => LocalNotificationService(
            context.read<HttpService>(),
          )..init(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalNotificationProvider(
            context.read<LocalNotificationService>(),
          )..requestPermissions(),
        ),
        ChangeNotifierProvider(
          create: (context) => PayloadProvider(
            payload: payload,
          ),
        ),
      ],
      child: App(
        initialRoute: route,
      ),
    ),
  );
}

class App extends StatelessWidget {
  final String initialRoute;

  const App({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        MyRoute.home.name: (context) => const HomeScreen(),
        MyRoute.detail.name: (context) => const DetailScreen(),
      },
    );
  }
}
