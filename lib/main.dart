import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/routing/app_router.dart';
import 'package:furniture_ecommerce_app/core/services/dependency_injection/injection_container.dart';
import 'package:furniture_ecommerce_app/core/services/logging/app_bloc_observer.dart';
import 'package:furniture_ecommerce_app/core/theme/app_theme.dart';
import 'package:furniture_ecommerce_app/firebase_options.dart';


void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: ".env");

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      if (!kReleaseMode) {
        await FirebaseCrashlytics.instance.sendUnsentReports();
      }

      Bloc.observer = AppBlocObserver();

      final crashlyticsEnabled = dotenv.env['ENABLE_CRASHLYTICS'] == 'true';
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        crashlyticsEnabled,
      );

      FlutterError.onError = (details) {
        if (!kReleaseMode) FlutterError.dumpErrorToConsole(details);
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        if (!kReleaseMode) {
          FlutterError.dumpErrorToConsole(
            FlutterErrorDetails(exception: error, stack: stack),
          );
        }
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      try {
        await initDependencies();
      } catch (e, s) {
        if (!kReleaseMode) {
          FlutterError.dumpErrorToConsole(
            FlutterErrorDetails(exception: e, stack: s),
          );
        }
        FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
        rethrow;
      }

      runApp(const MainApp());
    },
    (error, stack) {
      if (!kReleaseMode) {
        FlutterError.dumpErrorToConsole(
          FlutterErrorDetails(exception: error, stack: stack),
        );
      }
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Furniture Ecommerce App',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
      ),
    );
  }
}
