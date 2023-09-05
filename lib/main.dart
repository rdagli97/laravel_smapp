import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/palette.dart';
import 'package:laravel_smapp/providers/auth_controller.dart';
import 'package:laravel_smapp/providers/comment_controller.dart';
import 'package:laravel_smapp/providers/follow_controller.dart';
import 'package:laravel_smapp/providers/light_mode_provider.dart';
import 'package:laravel_smapp/providers/like_controller.dart';
import 'package:laravel_smapp/providers/post_controller.dart';
import 'package:laravel_smapp/providers/user_controller.dart';
import 'package:laravel_smapp/screens/auth/loading_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LightMode()),
        ChangeNotifierProvider(create: (_) => PostController()),
        ChangeNotifierProvider(create: (_) => LikeController()),
        ChangeNotifierProvider(create: (_) => CommentController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => FollowController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Palette palette = Palette.fromDarkMode(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: palette.bgColor),
        scaffoldBackgroundColor: palette.bgColor,
        colorScheme: ColorScheme.fromSeed(seedColor: palette.primaryColor),
        useMaterial3: true,
      ),
      home: const LoadingScreen(),
    );
  }
}
