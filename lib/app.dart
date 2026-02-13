import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:skye_app/app/auth_gate.dart';
import 'package:skye_app/app/routes/app_routes.dart';
import 'package:skye_app/shared/theme/app_theme.dart';

class SkyeApp extends StatelessWidget {
  const SkyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('[SkyeApp] build()');

    return MaterialApp(
      title: 'Skye',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) {
        debugPrint('[SkyeApp] builder() child=${child.runtimeType}');

        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        );

        if (child == null) {
          debugPrint('[SkyeApp] builder() child is null');
          return const SizedBox.shrink();
        }

        return Material(
          color: Colors.transparent,
          child: child,
        );
      },
      home: const AuthGate(),
      routes: AppRoutes.routes,
    );
  }
}
