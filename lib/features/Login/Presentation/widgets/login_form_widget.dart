// Widget 2: Login Form Section
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:todo/features/Login/Presentation/widgets/email_input_field.dart';
import 'package:todo/features/Login/Presentation/widgets/login_button_widget.dart';
import 'package:todo/features/Login/Presentation/widgets/password_input_filed.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;
  final String? passwordError;
  final bool isLoading;
  final Function(String)? onEmailChanged;
  final Function(String)? onPasswordChanged;
  final VoidCallback? onLoginPressed;

  const LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    this.emailError,
    this.passwordError,
    required this.isLoading,
    this.onEmailChanged,
    this.onPasswordChanged,
    this.onLoginPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          FadeInUp(
            duration: const Duration(milliseconds: 1800),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xff254DDE),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33254DDE),
                    blurRadius: 20.0,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: <Widget>[
                  EmailInputField(
                    controller: emailController,
                    errorText: emailError,
                    onChanged: onEmailChanged,
                  ),
                  PasswordInputField(
                    controller: passwordController,
                    errorText: passwordError,
                    onChanged: onPasswordChanged,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          FadeInUp(
            duration: const Duration(milliseconds: 1900),
            child: LoginButton(
              isLoading: isLoading,
              onPressed: onLoginPressed,
            ),
          ),
        ],
      ),
    );
  }
}
