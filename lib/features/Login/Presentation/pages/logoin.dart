import 'package:flutter/material.dart';
import 'package:todo/features/Login/Data/Datasource/Local/shared_pref.dart';
import 'package:todo/features/Login/Presentation/widgets/background_head.dart';
import 'package:todo/features/Login/Presentation/widgets/login_form_widget.dart';

class Logoin extends StatefulWidget {
  const Logoin({super.key});

  @override
  State<Logoin> createState() => _LogoinState();
}

class _LogoinState extends State<Logoin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Navigate to home/todo screen
  Future<void> goToHome() async {
    await Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil('/todo', (route) => false));
  }

  // Handle login button press
  Future<void> _handleLogin() async {
    setState(() {
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_emailError == null && _passwordError == null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 2));

        // Save credentials for future use
        SharedPref sharedPref = await SharedPref.getInstance();
        await sharedPref.saveCredentials(
            _emailController.text, _passwordController.text);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful! Welcome to your tasks.'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to todo screen after successful login
          await goToHome();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const BackgroundHeader(), // New Widget 1
            LoginForm(
              // New Widget 2
              emailController: _emailController,
              passwordController: _passwordController,
              emailError: _emailError,
              passwordError: _passwordError,
              isLoading: _isLoading,
              onEmailChanged: (value) {
                setState(() {
                  _emailError = _validateEmail(value);
                });
              },
              onPasswordChanged: (value) {
                setState(() {
                  _passwordError = _validatePassword(value);
                });
              },
              onLoginPressed: _isLoading ? null : _handleLogin,
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
