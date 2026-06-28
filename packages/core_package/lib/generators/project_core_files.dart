import '../core/file_system.dart';
import '../core/template_engine.dart';

/// Genera los archivos base del proyecto: main.dart, app.dart,
/// core/router, core/theme, core/errors, core/network, core/utils y assets.
Future<void> generateCoreFiles(
    String basePath, FileSystem fileSystem, TemplateEngine engine) async {
  // main.dart
  await fileSystem.writeFile(
    '$basePath/lib/main.dart',
    engine.render('''
import 'package:flutter/material.dart';
import 'app/app.dart';

void main() {
  runApp(const {{className}}App());
}
'''),
  );

  // app/app.dart
  await fileSystem.writeFile(
    '$basePath/lib/app/app.dart',
    engine.render('''
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/router/route_names.dart';
import '../core/router/app_router.dart';

class {{className}}App extends StatelessWidget {
  const {{className}}App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '{{projectName}}',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: RouteNames.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
'''),
  );

  // core/theme/app_theme.dart
  await fileSystem.writeFile(
    '$basePath/lib/core/theme/app_theme.dart',
    engine.render('''
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.teal,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.teal,
    );
  }
}
'''),
  );

  // core/constants/app_constants.dart
  await fileSystem.writeFile(
    '$basePath/lib/core/constants/app_constants.dart',
    engine.render('''
class AppConstants {
  static const String appName = '{{projectName}}';
  static const String baseUrl = 'https://api.example.com';
  static const Duration timeout = Duration(seconds: 30);
}
'''),
  );

  // core/router/route_names.dart
  await fileSystem.writeFile(
    '$basePath/lib/core/router/route_names.dart',
    engine.render('''
/// Constantes con los nombres de todas las rutas de la aplicación.
abstract final class RouteNames {
  static const String home = '/';
  static const String settings = '/settings';
}
'''),
  );

  // core/router/app_router.dart
  await fileSystem.writeFile(
    '$basePath/lib/core/router/app_router.dart',
    engine.render('''
import 'package:flutter/material.dart';
import 'route_names.dart';

/// Genera las rutas de la aplicación a partir del nombre de ruta.
class AppRouter {
  /// Devuelve la ruta correspondiente a [settings.name].
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return _materialPage(
          const Scaffold(
            body: Center(
              child: Text('Home'),
            ),
          ),
          settings,
        );
      case RouteNames.settings:
        return _materialPage(
          const Scaffold(
            body: Center(
              child: Text('Settings'),
            ),
          ),
          settings,
        );
      default:
        return _materialPage(
          Scaffold(
            body: Center(
              child: Text("Route '\${settings.name}' not found"),
            ),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute _materialPage(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
'''),
  );

  // core/errors/failure.dart
  await fileSystem.writeFile(
    '$basePath/lib/core/errors/failure.dart',
    engine.render('''
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
'''),
  );

  // core/network/network_info.dart
  await fileSystem.writeFile(
    '$basePath/lib/core/network/network_info.dart',
    engine.render('''
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // TODO: implementar con connectivity_plus
    return true;
  }
}
'''),
  );

  // core/utils/validators.dart
  await fileSystem.writeFile(
    '$basePath/lib/core/utils/validators.dart',
    engine.render(r'''
class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Invalid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
'''),
  );

  // assets/
  await fileSystem.writeFile(
    '$basePath/assets/images/',
    '',
  );
  await fileSystem.writeFile(
    '$basePath/assets/fonts/',
    '',
  );
  await fileSystem.writeFile(
    '$basePath/assets/icons/',
    '',
  );
}
