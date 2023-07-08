import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/helper/shared_prefs_const.dart';
import 'package:untitled/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRoute.generateRoute,
      initialRoute: AppRoute.rMain,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _toPage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).primaryColor,
        child: const Center(
          child: Text(
            "AUTH",
            style: TextStyle(fontSize: 35, color: Colors.white),
          ),
        ));
  }
}

Future<void> _toPage(BuildContext context) async {
  AppSharedPrefs.isLoggedIn().then((login) {
    if (login) {
      Future.delayed(const Duration(milliseconds: 200), () async {
        Navigator.pushReplacementNamed(context, AppRoute.rHome);
      });
    } else {
      Navigator.pushReplacementNamed(context, AppRoute.rLogin);
    }
  });
// Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FormPerbaikan()));
}
