import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

import 'features/restuarent/screens/welcome_screen.dart';
import 'features/restuarent/screens/home_screen.dart';
import 'features/restuarent/screens/restaurent_screen.dart';
import 'features/restuarent/screens/review_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AI Assistant",

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      initialRoute: "/",

      routes: {
        "/": (context) => const WelcomeScreen(),
        "/home": (context) => const HomeScreen(),
        "/restaurant": (context) => const RestaurantScreen(),
        "/review": (context) => const ReviewScreen(),
      },
    );
  }
}
