import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/helper/utility.dart';
import 'package:untitled/routes/app_routes.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _ProviderPassword()),
        ChangeNotifierProvider(create: (context) => _ProviderWriter()),
      ],
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Register Page"),
          ),
          body: const _RegisterContent()),
    );
  }
}

final _formKey1 = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _passwordConfirmeController = TextEditingController();

class _RegisterContent extends StatefulWidget {
  const _RegisterContent({Key? key}) : super(key: key);

  @override
  State<_RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<_RegisterContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(child: SingleChildScrollView(child: registerUser())),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      child: const Text("BACK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: OutlinedButton(

                      ///styling button
                      // style: OutlinedButton.styleFrom(),
                      child: const Text("REGISTER"),
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (!_formKey1.currentState!.validate()) {
                          return;
                        }
                        // setState(() {
                        //   writeNewPost({
                        //     'name': _nameController.text,
                        //     'email': _emailController.text,
                        //     "password": _passwordController.text,
                        //   });
                        // });
                        context.read<_ProviderWriter>().writeNewPost(context, {
                          'name': _nameController.text,
                          'email': _emailController.text,
                          "password": _passwordController.text,
                        });
                        // FirebaseAuth.instance.signOut();
                      }))
            ],
          )
        ],
      ),
    );
  }

  Widget registerUser() {
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _formRequiredContent(
            "Nama Lengkap *",
            _nameController,
            (value) {
              if (value == null || value.isEmpty) {
                return "Mohon masukan nama lengkap";
              }
              if (value.length < 2) {
                return "Masukkan nama lengkap dengan benar";
              }
              return null;
            },
          ),
          _formRequiredContent("Email *", _emailController, (value) {
            if (value == null || value.isEmpty) {
              return "Mohon masukan alamat email";
            }
            if (!AppValidate.email(value)) {
              return "Masukkan alamat email dengan benar";
            }
            if (!value.split("@")[1].contains(".")) {
              return "Masukkan alamat email dengan benar";
            }
            return null;
          }),
          passwordContent()
        ],
      ),
    );
  }

  Widget _formRequiredContent(String label, TextEditingController controller,
      String? Function(String?)? validator) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        enableSuggestions: false,
        autocorrect: false,
        validator: validator,
      ),
    );
  }

  Widget passwordContent() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            textInputAction: TextInputAction.go,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Password *",
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<_ProviderPassword>().setInputTypePassword();
                  },
                  icon: Icon(
                    context.watch<_ProviderPassword>().typePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: context.watch<_ProviderPassword>().typePassword
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    size: 21,
                  ),
                  color: Colors.grey,
                )),
            obscureText: context.watch<_ProviderPassword>().typePassword,
            enableSuggestions: false,
            autocorrect: false,
            onChanged: (_) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Mohon masukan password anda.";
              }
              if (value.length < 5) {
                return "Password minimal 5 huruf";
              }
              return null;
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            textInputAction: TextInputAction.go,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordConfirmeController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Konfirmasi Password *",
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<_ProviderPassword>().setInputTypePassword();
                  },
                  icon: Icon(
                    context.watch<_ProviderPassword>().typePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: context.watch<_ProviderPassword>().typePassword
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    size: 21,
                  ),
                  color: Colors.grey,
                )),
            obscureText: context.watch<_ProviderPassword>().typePassword,
            enableSuggestions: false,
            autocorrect: false,
            onChanged: (_) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Mohon masukan password anda.";
              }
              if (value.length < 5) {
                return "Masukkan password baru Anda";
              }
              if (value != _passwordController.text) {
                return "Password tidak sesuai";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SizedBox(
              height: 50, child: Center(child: Text('Registerasi berhasil'))),
          actions: <Widget>[
            TextButton(
              child: const Text('Oke'),
              onPressed: () async {
                await Navigator.pushNamed(context, AppRoute.rLogin);
              },
            ),
          ],
        );
      },
    );
  }
}

class _ProviderPassword with ChangeNotifier {
  bool typePassword = false;

  setInputTypePassword() {
    typePassword = !typePassword;
    notifyListeners();
  }
}

class _ProviderWriter with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference database = FirebaseDatabase.instance.ref("users");
  var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      url: 'https://duniaunggahan.blogspot.com/2023/07/blog-post.html',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'com.agni.untitled.ios',
      androidPackageName: 'com.agni.untitled',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12');

  sendEmail(BuildContext context) async {
    try {
      FirebaseAuth.instance
          .sendSignInLinkToEmail(
              email: _emailController.text, actionCodeSettings: acs)
          .then((value) {
        Navigator.of(context).pop();
        print('Successfully sent email verification');
      });
    } catch (e) {
      print('Error sending email verification: $e');
    }
    notifyListeners();
  }

  addUser(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) => context.read<_ProviderWriter>().sendEmail(context));
      print("masuk");
    } catch (e) {
      print('Error creating user: $e');
    }
    notifyListeners();
  }

  writeNewPost(BuildContext context, dynamic params) async {
    try {
      database.push().set(params);
      await context.read<_ProviderWriter>().addUser(context);
    } catch (e) {
      print('Error creating auth: $e');
    }
    notifyListeners();
  }
}
