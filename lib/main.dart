import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_view.dart';
import 'l10n/generated/app_localizations.dart';
import 'providers/app_settings_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: AppTheme.light,
          themeMode: settings.themeMode,
          darkTheme: AppTheme.dark,
          home: const SplashView(),
        );
      },
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettingsProvider(),
      child: const MyApp(),
    ),
  );
}
