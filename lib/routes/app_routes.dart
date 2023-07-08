import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/views/forgot.dart';
import 'package:untitled/views/home.dart';
import 'package:untitled/views/login.dart';
import 'package:untitled/views/register.dart';

///Routing with defined name
class AppRoute {
  static const rMain = '/';
  static const rHome = '/home';
  static const rRegister = '/register';
  static const rLogin = '/login';
  static const rForgot = '/forgot';

  /// Route list
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rMain:
        return _buildRoute(settings, const MainPage());
      case rHome:
        return _buildRoute(settings, const HomePage());
      case rLogin:
        return _buildRoute(settings, const LoginPage());
      case rRegister:
        return _buildRoute(settings, const RegisterPage());
      case rForgot:
        return _buildRoute(settings, const ForgotPage());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body:
                      Center(child: Text('Page not found : ${settings.name}')),
                ));
    }
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }
}
