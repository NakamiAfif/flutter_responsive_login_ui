import 'package:flutter/material.dart';
import 'package:flutter_responsive_login_ui/login_screen.dart';
import 'package:flutter_responsive_login_ui/widgets/gradient_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureRetypePassword = true;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _validateRetypePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please retype your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleRetypePasswordVisibility() {
    setState(() {
      _obscureRetypePassword = !_obscureRetypePassword;
    });
  }

  void _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final url =
          'http://192.168.134.1/barterit/register.php'; // Replace with your actual PHP server URL

      final username = _usernameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      // Prepare the registration data
      final data = {
        'username': username,
        'email': email,
        'password': password,
      };

      // Send a POST request to the PHP server
      final response = await http.post(Uri.parse(url), body: data);

      if (response.statusCode == 200) {
        // Registration successful
        final result = json.decode(response.body);
        if (result['success']) {
          // Registration success handling
          _showSnackBar('Registration successful');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
          // Navigate to the next screen or show a success message
        } else {
          // Registration failed handling
          final error = result['error'];
          _showSnackBar('Registration failed: $error');
          // Show an error message or handle the failure scenario
        }
      } else {
        // Error occurred while making the request
        _showSnackBar('Error occurred while making the request');
        // Handle the error case appropriately
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  'BarterIt Sign up.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: _togglePasswordVisibility,
                      child: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _retypePasswordController,
                  obscureText: _obscureRetypePassword,
                  validator: _validateRetypePassword,
                  decoration: InputDecoration(
                    labelText: 'Retype Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: _toggleRetypePasswordVisibility,
                      child: Icon(_obscureRetypePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _usernameController,
                  validator: _validateUsername,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 30),
                GradientButton(
                  buttonText: 'Sign Up',
                  onPressed: () {
                    _signup();
                  },
                ),
                SizedBox(height: 15), // Add space between buttons
                GradientButton(
                  buttonText: 'Sign In',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
