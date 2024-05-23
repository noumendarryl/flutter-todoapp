import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/auth/register.dart';
import 'package:todo_list/views/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  String _email = '';

  String _password = '';

  bool isProcessing = false;

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User? user = (await _authInstance.signInWithEmailAndPassword(
          email: _email, password: _password))
          .user;
      if (user != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));
        _formKey.currentState!.reset();
      }
    } catch (error) {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(40.0),
        color: Colors.white70,
        child: isProcessing
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome back !",
                style: TextStyle(fontSize: 24.0)),
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

                            _signInWithEmailAndPassword();

                            setState(() {
                              isProcessing = true;
                            });
                          }
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
                          'Log in',
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
                          "Don't yet have an account ?",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const Register()));
                            },
                            child: const Text(
                              " Register",
                              style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontSize: 16.0),
                            )),
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
