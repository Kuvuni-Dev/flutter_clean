import '../core/file_system.dart';
import '../core/template_engine.dart';
import 'project_template.dart';

/// Plantilla con Provider + ChangeNotifier.
///
/// Estructura:
/// ```
/// lib/
///   providers/
///   models/
///   screens/
///   widgets/
///   services/
///   utils/
///   app.dart
/// ```
class ProviderTemplate implements ProjectTemplate {
  @override
  String get name => 'Provider';

  @override
  String get description =>
      'Patrón Provider con ChangeNotifier. '
      'Ideal para apps medianas con gestión de estado simple.';

  @override
  TemplateType get type => TemplateType.provider;

  @override
  List<String> directories(String basePath) => [
        '$basePath/assets/images',
        '$basePath/assets/fonts',
        '$basePath/lib/providers',
        '$basePath/lib/models',
        '$basePath/lib/screens',
        '$basePath/lib/widgets',
        '$basePath/lib/services',
        '$basePath/lib/utils',
      ];

  @override
  Future<void> generateCore(
    String basePath,
    FileSystem fileSystem,
    TemplateEngine engine,
  ) async {
    // main.dart
    await fileSystem.writeFile(
      '$basePath/lib/main.dart',
      engine.render('''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/counter_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterProvider()),
      ],
      child: const {{className}}App(),
    ),
  );
}
'''),
    );

    // app.dart
    await fileSystem.writeFile(
      '$basePath/lib/app.dart',
      engine.render('''
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class {{className}}App extends StatelessWidget {
  const {{className}}App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '{{projectName}}',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const HomeScreen(),
    );
  }
}
'''),
    );

    // providers/counter_provider.dart
    await fileSystem.writeFile(
      '$basePath/lib/providers/counter_provider.dart',
      engine.render('''
import 'package:flutter/foundation.dart';

class CounterProvider extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}
'''),
    );

    // screens/home_screen.dart
    await fileSystem.writeFile(
      '$basePath/lib/screens/home_screen.dart',
      engine.render('''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/counter_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{projectName}}')),
      body: Center(
        child: Consumer<CounterProvider>(
          builder: (context, counter, _) {
            return Text(
              'Contador: \${counter.count}',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterProvider>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<CounterProvider>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
'''),
    );

    // services/api_service.dart
    await fileSystem.writeFile(
      '$basePath/lib/services/api_service.dart',
      engine.render('''
class ApiService {
  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'data': 'mock response from \$endpoint'};
  }
}
'''),
    );

    // utils/validators.dart
    await fileSystem.writeFile(
      '$basePath/lib/utils/validators.dart',
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
  }

  @override
  Future<void> generateInitialFeature(
    String basePath,
    FileSystem fileSystem,
    TemplateEngine engine,
  ) async {
    const folderName = 'bio';
    const className = 'Bio';

    final featureEngine = engine.merge({
      'folderName': folderName,
      'className': className,
    });

    // models/instructor.dart
    await fileSystem.writeFile(
      '$basePath/lib/models/instructor.dart',
      featureEngine.render('''
class Instructor {
  final String name;
  final String bio;
  final String photoUrl;

  const Instructor({
    required this.name,
    required this.bio,
    required this.photoUrl,
  });
}
'''),
    );

    // models/course.dart
    await fileSystem.writeFile(
      '$basePath/lib/models/course.dart',
      featureEngine.render('''
class Course {
  final String id;
  final String title;
  final String description;
  final int durationHours;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.durationHours,
  });
}
'''),
    );

    // providers/bio_provider.dart
    await fileSystem.writeFile(
      '$basePath/lib/providers/bio_provider.dart',
      featureEngine.render('''
import 'package:flutter/foundation.dart';
import '../models/instructor.dart';
import '../models/course.dart';

enum BioState { initial, loading, loaded, error }

class BioProvider extends ChangeNotifier {
  BioState _state = BioState.initial;
  BioState get state => _state;

  Instructor? _instructor;
  Instructor? get instructor => _instructor;

  List<Course> _courses = [];
  List<Course> get courses => _courses;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> loadData() async {
    _state = BioState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _instructor = const Instructor(
        name: 'Kuvuni',
        bio: 'Desarrollador Flutter & Dart',
        photoUrl: 'assets/images/profile.jpg',
      );

      _courses = [
        const Course(
          id: '1',
          title: 'Flutter Clean Architecture',
          description: 'Aprende a estructurar tus proyectos.',
          durationHours: 10,
        ),
      ];

      _state = BioState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = BioState.error;
    }

    notifyListeners();
  }
}
'''),
    );

    // screens/bio_screen.dart
    await fileSystem.writeFile(
      '$basePath/lib/screens/bio_screen.dart',
      featureEngine.render('''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bio_provider.dart';

class BioScreen extends StatelessWidget {
  const BioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BioProvider()..loadData(),
      child: const _BioBody(),
    );
  }
}

class _BioBody extends StatelessWidget {
  const _BioBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<BioProvider>(
      builder: (context, provider, _) {
        switch (provider.state) {
          case BioState.initial:
          case BioState.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case BioState.error:
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text(
                  provider.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          case BioState.loaded:
            return Scaffold(
              appBar: AppBar(title: Text(provider.instructor?.name ?? 'Bio')),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (provider.instructor != null) ...[
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(provider.instructor!.photoUrl),
                    ),
                    const SizedBox(height: 8),
                    Text(provider.instructor!.name),
                    Text(provider.instructor!.bio),
                  ],
                  const SizedBox(height: 24),
                  ...provider.courses.map(
                    (course) => Card(
                      child: ListTile(
                        title: Text(course.title),
                        subtitle: Text(course.description),
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
'''),
    );
  }
}