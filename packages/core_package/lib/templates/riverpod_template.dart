import '../core/file_system.dart';
import '../core/template_engine.dart';
import 'project_template.dart';

/// Plantilla con Riverpod (flutter_riverpod).
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
class RiverpodTemplate implements ProjectTemplate {
  @override
  String get name => 'Riverpod';

  @override
  String get description =>
      'Patrón Riverpod con AsyncNotifier. '
      'Ideal para apps modernas con gestión de estado reactiva.';

  @override
  TemplateType get type => TemplateType.riverpod;

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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: {{className}}App(),
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
}

final counterProvider = NotifierProvider<CounterNotifier, int>(
  CounterNotifier.new,
);
'''),
    );

    // screens/home_screen.dart
    await fileSystem.writeFile(
      '$basePath/lib/screens/home_screen.dart',
      engine.render('''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/counter_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('{{projectName}}')),
      body: Center(
        child: Text(
          'Contador: \$count',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => ref.read(counterProvider.notifier).increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => ref.read(counterProvider.notifier).decrement(),
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/instructor.dart';
import '../models/course.dart';

class BioState {
  final bool isLoading;
  final Instructor? instructor;
  final List<Course> courses;
  final String? error;

  const BioState({
    this.isLoading = false,
    this.instructor,
    this.courses = const [],
    this.error,
  });

  BioState copyWith({
    bool? isLoading,
    Instructor? instructor,
    List<Course>? courses,
    String? error,
  }) {
    return BioState(
      isLoading: isLoading ?? this.isLoading,
      instructor: instructor ?? this.instructor,
      courses: courses ?? this.courses,
      error: error,
    );
  }
}

class BioNotifier extends Notifier<BioState> {
  @override
  BioState build() => const BioState();

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      state = state.copyWith(
        isLoading: false,
        instructor: const Instructor(
          name: 'Kuvuni',
          bio: 'Desarrollador Flutter & Dart',
          photoUrl: 'assets/images/profile.jpg',
        ),
        courses: [
          const Course(
            id: '1',
            title: 'Flutter Clean Architecture',
            description: 'Aprende a estructurar tus proyectos.',
            durationHours: 10,
          ),
        ],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final bioProvider = NotifierProvider<BioNotifier, BioState>(
  BioNotifier.new,
);
'''),
    );

    // screens/bio_screen.dart
    await fileSystem.writeFile(
      '$basePath/lib/screens/bio_screen.dart',
      featureEngine.render('''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bio_provider.dart';

class BioScreen extends ConsumerWidget {
  const BioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bioState = ref.watch(bioProvider);

    ref.listen(bioProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: \${next.error}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(bioState.instructor?.name ?? 'Bio')),
      body: bioState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (bioState.instructor != null) ...[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(bioState.instructor!.photoUrl),
                  ),
                  const SizedBox(height: 8),
                  Text(bioState.instructor!.name),
                  Text(bioState.instructor!.bio),
                ],
                const SizedBox(height: 24),
                ...bioState.courses.map(
                  (course) => Card(
                    child: ListTile(
                      title: Text(course.title),
                      subtitle: Text(course.description),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(bioProvider.notifier).loadData(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
'''),
    );
  }
}