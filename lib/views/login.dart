import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:untitled/helper/shared_prefs_const.dart';
import 'package:untitled/routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => _LoginPageProvider()),
    ], child: const Scaffold(body: _LoginPage()));
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage({Key? key}) : super(key: key);

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/login.svg',
            height: MediaQuery.of(context).size.width / 1.5,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 10),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      hintText: "Email",
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    enableSuggestions: false,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        context
                            .read<_LoginPageProvider>()
                            .setSubmitButtonStatus(false);
                      } else {
                        context
                            .read<_LoginPageProvider>()
                            .setSubmitButtonStatus(true);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "emailnya diisi dong.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: "Password",
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        suffixIcon: IconButton(
                          onPressed: () {
                            context
                                .read<_LoginPageProvider>()
                                .setInputTypePassword();
                          },
                          icon: Icon(
                            context.watch<_LoginPageProvider>().typePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color:
                                context.watch<_LoginPageProvider>().typePassword
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                            size: 21,
                          ),
                          color: Colors.grey,
                        )),
                    obscureText:
                        context.watch<_LoginPageProvider>().typePassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    textInputAction: TextInputAction.send,
                    onFieldSubmitted: (_) {
                      // submitLogin();
                    },
                    onChanged: (_) {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        context
                            .read<_LoginPageProvider>()
                            .setSubmitButtonStatus(false);
                      } else {
                        context
                            .read<_LoginPageProvider>()
                            .setSubmitButtonStatus(true);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Passwordnya jangan lupa.";
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      bool value = context.read<_LoginPageProvider>().checked;
                      context
                          .read<_LoginPageProvider>()
                          .setCheckBoxValue(!value);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Checkbox(
                          shape: const CircleBorder(),
                          checkColor: Colors.white,
                          value: context.watch<_LoginPageProvider>().checked,
                          onChanged: (bool? value) {
                            context
                                .read<_LoginPageProvider>()
                                .setCheckBoxValue(value ?? false);
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "Remember",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoute.rForgot);
                              },
                              child: const Text(
                                "Forgot Password ?",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<_LoginPageProvider>(
            builder: (context, value, child) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 6),
                        backgroundColor: value.enableSubmitButton
                            ? Theme.of(context).primaryColor
                            : Colors.grey),
                    onPressed: value.enableSubmitButton
                        ? () async {
                            submitLogin();
                            await AppSharedPrefs.setLogin(true);
                          }
                        : null,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("LOGIN",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )),
              );
            },
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 6),
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () async {
                  Navigator.pushNamed(context, AppRoute.rRegister);
                  // final user = FirebaseAuth.instance.currentUser!;
                  // final idToken = await user.getIdToken();
                  // print(idToken);
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("DAFTAR",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> submitLogin() async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) async {
        Navigator.pushNamed(context, AppRoute.rHome);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}

class _LoginPageProvider with ChangeNotifier {
  bool enableSubmitButton = false;
  bool typePassword = true;
  bool checked = true;

  setInputTypePassword() {
    typePassword = !typePassword;
    notifyListeners();
  }

  setSubmitButtonStatus(bool enable) {
    enableSubmitButton = enable;
    notifyListeners();
  }

  setCheckBoxValue(bool checked) {
    this.checked = checked;
    notifyListeners();
  }
}
