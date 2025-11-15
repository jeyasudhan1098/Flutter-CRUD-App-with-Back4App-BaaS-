import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/task_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Replace these with your Back4App credentials
  const String appId = 'zG6DbymlbkgZhUGsHZJhRrgRi8m7VuiY3a11zO3O';
  const String clientKey = 'JXGXMvTRinq3AKgBhf91JAKT8uk8m7v8l27WAQHk';
  const String serverUrl = 'https://parseapi.back4app.com/';

  await Parse().initialize(appId, serverUrl,
      clientKey: clientKey, autoSendSessionId: true, debug: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => TaskService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager (Back4App)',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const RootDecider(),
      ),
    );
  }
}

class RootDecider extends StatelessWidget {
  const RootDecider({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return FutureBuilder<bool>(
      future: auth.tryRestoreSession(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snap.data == true && auth.isLoggedIn) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
