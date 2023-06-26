import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/signup_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final EdgeInsets _textFieldMargin = const EdgeInsets.symmetric(horizontal: 20);
  final EdgeInsets _textFieldPadding = const EdgeInsets.only(bottom: 10);
  final EdgeInsets _buttonMargin = const EdgeInsets.symmetric(horizontal: 20);
  final EdgeInsets _buttonPadding = const EdgeInsets.only(bottom: 10);
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.deepPurple),
          title: const Text("Login"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: _textFieldMargin,
                          padding: _textFieldPadding,
                          child: TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: "Enter your registered email",
                              label: Text("Email"),
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return "Enter your email!";
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: _textFieldMargin,
                          padding: _textFieldPadding,
                          child: TextFormField(
                            controller: _password,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.password),
                              hintText: "Enter your password",
                              label: Text("Password"),
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return "Enter your password!";
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: _buttonMargin,
                          padding: _buttonPadding,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                                fixedSize:
                                MaterialStatePropertyAll(Size(200, 40))),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  showSpinner = true;
                                });

                                try {
                                  final registerUser =
                                  await _auth.signInWithEmailAndPassword(
                                      email: _email.text,
                                      password: _password.text);

                                  if (registerUser is FirebaseAuthException) {
                                    throw registerUser;
                                  }
                                } catch (e) {
                                  if (kDebugMode) {
                                    print(e);
                                  }
                                }

                                setState(() {
                                  showSpinner = false;
                                });

                                if (context.mounted) {
                                  Navigator.of(context).pushNamed('HomeScreen');
                                }
                              }
                            },
                            child: const Text('Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: _buttonMargin,
                    padding: _buttonPadding,
                    child: TextButton(
                      style: const ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(Size(400, 40))),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        );
                      },
                      child: const Text("New user? Register here!"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
