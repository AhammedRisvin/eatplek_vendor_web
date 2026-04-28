import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'constants/extensions.dart';
import 'constants/prefferences.dart';
import 'constants/providers.dart';
import 'constants/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPref.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers().providers,
      builder: (context, child) => LayoutBuilder(
        builder: (context, constraints) => OrientationBuilder(
          builder: (context, orientation) {
            Responsive().init(constraints, orientation);
            return MaterialApp.router(
              title: 'Eatplek Vendor',
              debugShowCheckedModeBanner: false,
              routeInformationProvider:
                  AppRouter.router.routeInformationProvider,
              routeInformationParser: AppRouter.router.routeInformationParser,
              routerDelegate: AppRouter.router.routerDelegate,
              theme: ThemeData(fontFamily: GoogleFonts.urbanist().fontFamily),
            );
          },
        ),
      ),
    );
  }
}
