import 'package:flutter/material.dart';

// Widget 5: Login Button
class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoginButton({
    Key? key,
    required this.isLoading,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isLoading ? 60 : 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: isLoading
                ? [
                    const Color(0xff254DDE).withOpacity(0.7),
                    const Color(0xff00FFFF).withOpacity(0.7),
                  ]
                : [
                    const Color(0xff254DDE),
                    const Color(0xff00FFFF),
                  ],
          ),
          boxShadow: isLoading
              ? [
                  BoxShadow(
                    color: const Color(0xff254DDE).withOpacity(0.4),
                    spreadRadius: 0,
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ]
              : [
                  BoxShadow(
                    color: const Color(0xff254DDE).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
        ),
        child: Center(
          child: isLoading
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Logging in...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              : const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }
}
