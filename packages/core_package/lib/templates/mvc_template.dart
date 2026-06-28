import '../core/file_system.dart';
import '../core/template_engine.dart';
import 'project_template.dart';

/// Plantilla MVC (Model-View-Controller).
///
/// Estructura:
/// ```
/// lib/
///   models/
///   views/
///   controllers/
///   utils/
///   app.dart
/// ```
class MvcTemplate implements ProjectTemplate {
  @override
  String get name => 'MVC';

  @override
  String get description =>
      'Patrón Modelo-Vista-Controlador clásico. '
      'Ideal para proyectos pequeños y medianos.';

  @override
  TemplateType get type => TemplateType.mvc;

  @override
  List<String> directories(String basePath) => [
        '$basePath/assets/images',
        '$basePath/assets/fonts',
        '$basePath/lib/models',
        '$basePath/lib/views',
        '$basePath/lib/controllers',
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
import 'app.dart';

void main() {
  runApp(const {{className}}App());
}
'''),
    );

    // app.dart
    await fileSystem.writeFile(
      '$basePath/lib/app.dart',
      engine.render('''
import 'package:flutter/material.dart';
import 'views/home_view.dart';

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
      home: const HomeView(),
    );
  }
}
'''),
    );

    // controllers/home_controller.dart
    await fileSystem.writeFile(
      '$basePath/lib/controllers/home_controller.dart',
      engine.render('''
class HomeController {
  String _message = 'Bienvenido a {{projectName}}';
  String get message => _message;

  void updateMessage(String newMessage) {
    _message = newMessage;
  }
}
'''),
    );

    // views/home_view.dart
    await fileSystem.writeFile(
      '$basePath/lib/views/home_view.dart',
      engine.render('''
import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{projectName}}')),
      body: Center(
        child: Text(_controller.message),
      ),
    );
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

    // controllers/bio_controller.dart
    await fileSystem.writeFile(
      '$basePath/lib/controllers/bio_controller.dart',
      featureEngine.render('''
import '../models/instructor.dart';
import '../models/course.dart';

class BioController {
  Instructor? _instructor;
  List<Course> _courses = [];
  bool _isLoading = false;

  Instructor? get instructor => _instructor;
  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
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

    _isLoading = false;
  }
}
'''),
    );

    // views/bio_view.dart
    await fileSystem.writeFile(
      '$basePath/lib/views/bio_view.dart',
      featureEngine.render('''
import 'package:flutter/material.dart';
import '../controllers/bio_controller.dart';

class BioView extends StatefulWidget {
  const BioView({super.key});

  @override
  State<BioView> createState() => _BioViewState();
}

class _BioViewState extends State<BioView> {
  final BioController _controller = BioController();

  @override
  void initState() {
    super.initState();
    _controller.loadData().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_controller.instructor?.name ?? 'Bio')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_controller.instructor != null) ...[
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(_controller.instructor!.photoUrl),
            ),
            const SizedBox(height: 8),
            Text(_controller.instructor!.name),
            Text(_controller.instructor!.bio),
          ],
          const SizedBox(height: 24),
          ..._controller.courses.map(
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
}
'''),
    );
  }
}