import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:photo_book_application/screen/home_screen.dart';
import 'package:photo_book_application/screen/register_screen.dart';
import 'package:photo_book_application/utility.dart';
import 'package:photo_book_application/widget/custom_button.dart';
import 'package:photo_book_application/widget/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final mailRegex = RegExp('[a-z0-9]+@[a-z]+\.[a-z]{2,3}');

  bool isValidLogin(String enteredEmail, String enteredPassword) {
    final savedEmail = UserPreferences.getEmail();
    final savedPassword = UserPreferences.getPassword();
    // Check if email and password match the stored values
    return enteredEmail == savedEmail && enteredPassword == savedPassword;
  }

  void navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  void logingIn() {
    final email = UserPreferences.getEmail();
    final password = UserPreferences.getPassword();
    log('Login :$email');
    log('Login :$password');
    if (email != null && password != null) {
      _emailController.text = email;
      _passwordController.text = password;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const FlutterLogo(
                  size: 200,
                  curve: Curves.bounceInOut,
                ),
                const Text(
                  'Flutter photo book app',
                  style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'cursive'),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'E-mail',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!mailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  suffix: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a Password';
                    } else if (_passwordController.text !=
                        UserPreferences.getPassword()) {
                      return 'Password is invalid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      label: 'login',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            final enteredEmail = _emailController.text;
                            final enteredPassword = _passwordController.text;
                            // Replace this with your authentication logic
                            if (isValidLogin(enteredEmail, enteredPassword)) {
                              UserPreferences.saveUserCredentials(
                                enteredEmail,
                                enteredPassword,
                              );
                              logingIn();
      
                              // Navigate to the next screen or perform other actions
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Invalid credentials. Please try again.'),
                                ),
                              );
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 14),
                    CustomButton(
                      label: 'register',
                      onTap: navigateToRegister,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
