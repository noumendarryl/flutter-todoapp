import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  String _email = '';

  String _password = '';

  String _errorMessage = '';

  Future<void> _signInWithEmailAndPassword() async {
    try {
      User? user = (await _authInstance.createUserWithEmailAndPassword(
              email: _email, password: _password))
          .user;
      if (user != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: ((context) => const Login())));
        _formKey.currentState!.reset();
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(40.0),
        color: Colors.white70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Create an account", style: TextStyle(fontSize: 24.0)),
            const SizedBox(
              height: 30.0,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Enter your email address",
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Enter your password",
                      ),
                      obscureText: true,
                      obscuringCharacter: '•',
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }

                        // Check password length
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }

                        // Check for at least one uppercase letter
                        if (!value.contains(RegExp(r'[A-Z]'))) {
                          return 'Password must contain at least one uppercase letter';
                        }

                        // Check for at least one lowercase letter
                        if (!value.contains(RegExp(r'[a-z]'))) {
                          return 'Password must contain at least one lowercase letter';
                        }

                        // Check for at least one digit
                        if (!value.contains(RegExp(r'[0-9]'))) {
                          return 'Password must contain at least one number';
                        }

                        // Check for at least one special character
                        if (!value
                            .contains(RegExp(r'[!@#\$%\^&\*(),.?":{}|<>]'))) {
                          return 'Password must contain at least one special character';
                        }

                        // If all checks pass, return null to indicate valid input
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: TextButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if the form is invalid
                          if (_formKey.currentState!.validate()) {
                            // Process data
                            _formKey.currentState!.save();
                          }

                          _signInWithEmailAndPassword();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(192, 192, 192, .5),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.all(18.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Already have an account ?",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Login()));
                            },
                            child: const Text(
                              " Login",
                              style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontSize: 16.0),
                            )),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
