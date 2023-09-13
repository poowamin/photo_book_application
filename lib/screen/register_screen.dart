import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:photo_book_application/model/user_model.dart';
import 'package:photo_book_application/widget/custom_button.dart';
import 'package:photo_book_application/widget/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPwController = TextEditingController();
  bool _obscureText = true;
  bool _cfObscureText = true;
  final numRegex = RegExp('^[0-9]');
  final letterRegex = RegExp('[A-Za-zก-ฮ]');
  final mailRegex = RegExp('[a-z0-9]+@[a-z]+.[a-z]{2,3}');

  //ฟังก์ชัน เมื่อกดปุ่มบัทึก
  void onSubmit() async {
    final username = _nameController.text.trim();
    final address = _addressController.text.trim();
    final phoneNum = _phoneNumController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPw = _confirmPwController.text.trim();

    // Check if all field are not empty
    if (username.isNotEmpty &&
        address.isNotEmpty &&
        phoneNum.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPw.isNotEmpty) {
      // Generate a unique ID using Uuid
      const uuid = Uuid();
      final uniqueId = uuid.v4();

      // Create a new user using the User.newUser factory constructor
      final newUser = User(
        id: uniqueId,
        name: username,
        address: address,
        phoneNumber: phoneNum,
        email: email,
        password: password,
        confirmPw: confirmPw,
      );

      // Submit user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', newUser.id);
      await prefs.setString('name', newUser.name);
      await prefs.setString('address', newUser.address);
      await prefs.setString('phoneNumber', newUser.phoneNumber);
      await prefs.setString('email', newUser.email);
      await prefs.setString('password', newUser.password);
      await prefs.setString('confirmPw', newUser.confirmPw);
      // Handle registration completion here
      print(newUser.email);
      print(newUser.password);
      _nameController.clear();
      _addressController.clear();
      _phoneNumController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPwController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Register success.'),
        ),
      );
    } else {
      // Handle empty fields error
      log('something wrong.');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneNumController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'cursive'),
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    hintText: 'Name & Surname',
                    controller: _nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your name & surname';
                      } else if (!letterRegex.hasMatch(value)) {
                        return 'Only allow A-Z, a-z, ก-ฮ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    hintText: 'Address',
                    controller: _addressController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    hintText: 'Phone number',
                    controller: _phoneNumController,
                    inputType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (!numRegex.hasMatch(value)) {
                        return 'Only number allow';
                      } else if (value.length < 10) {
                        return 'Phone number must be 10 charaters';
                      } else if (value.length > 10) {
                        return 'Phone number not over 10 charaters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    hintText: 'E-mail',
                    controller: _emailController,
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
                    hintText: 'Password',
                    controller: _passwordController,
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value.isEmpty || value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
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
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    hintText: 'Confirm-Password',
                    controller: _confirmPwController,
                    obscureText: _cfObscureText,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter confirm password';
                      } else if (value != _passwordController.text) {
                        return 'Confirmpassword hs not match';
                      }
                      return null;
                    },
                    suffix: IconButton(
                      icon: Icon(
                        _cfObscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _cfObscureText = !_cfObscureText;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  CustomButton(
                    label: 'Submit',
                    onTap: () async {
                      // validate all field here.
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          onSubmit();
                          Navigator.of(context).pop();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
