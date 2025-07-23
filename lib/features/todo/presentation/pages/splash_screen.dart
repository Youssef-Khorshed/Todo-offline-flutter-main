import 'package:flutter/material.dart';
import 'package:todo/core/constant/app_colors.dart';
import 'package:todo/core/constant/app_image.dart';
import 'package:todo/core/constant/app_route.dart';
import 'package:todo/features/Login/Data/Datasource/Local/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> goToLogin() async {
    await Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoute.login, (route) => false));
  }

  Future<void> goToHome() async {
    await Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoute.todo, (route) => false));
  }

  Future<void> _checkSavedCredentials() async {
    SharedPref sharedPref = await SharedPref.getInstance();
    if (sharedPref.isLogin()) {
      goToHome();
    } else {
      goToLogin();
    }
  }

  @override
  void initState() {
    super.initState();
    // Check saved credentials and navigate accordingly
    _checkSavedCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: AppColors.white,
      child: Center(
        child: SizedBox(
          height: 110,
          width: 110,
          child: Image.asset(AppImages.logo),
        ),
      ),
    );
  }
}
