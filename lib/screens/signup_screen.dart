import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final EdgeInsets _margin = const EdgeInsets.symmetric(horizontal: 20);
  final EdgeInsets _padding = const EdgeInsets.only(bottom: 10);
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.deepPurple),
          title: const Text("Register"),
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
                          margin: _margin,
                          padding: _padding,
                          child: TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: "Enter your email",
                              label: Text("Email"),
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return "Email is required to register!";
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: _margin,
                          padding: _padding,
                          child: TextFormField(
                            controller: _password,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.password),
                              hintText: "Enter your password",
                              label: Text("Create Password"),
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return "Password cannot be empty!";
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: _margin,
                          padding: _padding,
                          child: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.password),
                              hintText: "Re-enter your password",
                              label: Text("Confirm Password"),
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return "Re-type your password!";
                              } else if (value != _password.text) {
                                return "Password does not match! Re-enter your password!";
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: _margin,
                          padding: _padding,
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
                                  final registerUser = await _auth
                                      .createUserWithEmailAndPassword(
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
                                  Navigator.of(context).pushNamed("Login");
                                }
                              }
                            },
                            child: const Text('Register'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: _margin,
                    padding: _padding,
                    child: TextButton(
                      style: const ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(Size(400, 40))),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: const Text("Already registered? Login here!"),
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
