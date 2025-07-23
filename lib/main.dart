import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/constant/app_route.dart';
import 'package:todo/core/my_bloc_observer.dart';
import 'package:todo/features/Login/Data/Datasource/Local/shared_pref.dart';
import 'package:todo/features/Login/Presentation/pages/logoin.dart';
import 'package:todo/features/todo/presentation/bloc/bloc/todo_bloc.dart';
import 'package:todo/features/todo/presentation/pages/done_todo_page.dart';
import 'package:todo/features/todo/presentation/pages/splash_screen.dart';
import 'package:todo/features/todo/presentation/pages/todo_page.dart';
import 'package:todo/core/services/my_services.dart' as id;
import 'package:todo/theme/my_theme.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([id.init(), SharedPref.init()]);
  Bloc.observer = MyBlocObserver();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        AppRoute.todo: (context) => BlocProvider(
              create: (context) =>
                  id.ls.get<TodoBloc>()..add(GetNotDoneTodoEvent()),
              child: const TodoPage(),
            ),
        AppRoute.done: (context) => BlocProvider(
              create: (context) =>
                  id.ls.get<TodoBloc>()..add(GetDoneTodoEvent()),
              child: const DoneTodoPage(),
            ),
        AppRoute.login: (context) => const Logoin()
      },
      theme: myTheme(),
    );
  }
}
