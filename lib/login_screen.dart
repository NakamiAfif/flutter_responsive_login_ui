import 'package:flutter/material.dart';
import 'package:flutter_responsive_login_ui/dashboard.dart';
import 'package:flutter_responsive_login_ui/widgets/gradient_button.dart';
import 'package:flutter_responsive_login_ui/widgets/login_field.dart';
import 'package:flutter_responsive_login_ui/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _login(BuildContext context) async {
    final url =
        'http://192.168.134.1/barterit/login.php'; // Replace with your actual PHP server URL

    final username = _usernameController.text;
    final password = _passwordController.text;

    // Prepare the login data
    final data = {
      'username': username,
      'password': password,
    };

    // Send a POST request to the PHP server
    final response = await http.post(Uri.parse(url), body: data);

    if (response.statusCode == 200) {
      // Login request successful
      final result = json.decode(response.body);
      if (result['success']) {
        // Login success handling
        final username = result['username'];
        // Show a success message or navigate to the next screen
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Successful'),
            content: Text('Welcome, $username!'),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog and navigate to the next screen
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                  // TODO: Navigate to the next screen after successful login
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Login failed handling
        final error = result['error'];
        // Show an error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Failed'),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Error occurred while making the request
      // Handle the error case appropriately
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An error occurred while making the request.'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/signin_balls.png'),
              const Text(
                'Welcome to BarterIt',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 50),
              const SizedBox(height: 15),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
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
              const SizedBox(height: 20),
              GradientButton(
                buttonText: 'Sign In',
                onPressed: () {
                  _login(context);
                },
              ),
              const Text(
                'or',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 20),
              GradientButton(
                buttonText: 'Sign Up',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
