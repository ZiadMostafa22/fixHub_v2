import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_maintenance_system_new/core/theme/app_theme.dart';
import 'package:car_maintenance_system_new/core/router/app_router.dart';

void main() {
  runApp(const CarMaintenanceApp());
}

class CarMaintenanceApp extends StatelessWidget {
  const CarMaintenanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Design size based on standard mobile dimensions (adjust based on your design)
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Car Maintenance System',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}