import 'package:flutter/material.dart';
import 'screens/main_shell.dart';

/// Notifier global para el modo de tema de la aplicación.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
  ThemeMode.system,
);

void main() {
  runApp(const FlutterGeneratorApp());
}

class FlutterGeneratorApp extends StatelessWidget {
  const FlutterGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Flutter Generator',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: const Color(0xFF4CAF50),
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: const Color(0xFF4CAF50),
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          themeMode: themeMode,
          home: const MainShell(),
        );
      },
    );
  }
}
