import '../core/file_system.dart';
import '../core/template_engine.dart';
import 'project_template.dart';

/// Plantilla MVVM (Model-View-ViewModel).
///
/// Estructura:
/// ```
/// lib/
///   models/
///   views/
///   viewmodels/
///   services/
///   utils/
///   app.dart
/// ```
class MvvmTemplate implements ProjectTemplate {
  @override
  String get name => 'MVVM';

  @override
  String get description =>
      'Patrón Modelo-Vista-ViewModel con ChangeNotifier. '
      'Ideal para apps con lógica de presentación compleja.';

  @override
  TemplateType get type => TemplateType.mvvm;

  @override
  List<String> directories(String basePath) => [
        '$basePath/assets/images',
        '$basePath/assets/fonts',
        '$basePath/lib/models',
        '$basePath/lib/views',
        '$basePath/lib/viewmodels',
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

    // viewmodels/home_viewmodel.dart
    await fileSystem.writeFile(
      '$basePath/lib/viewmodels/home_viewmodel.dart',
      engine.render('''
import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  String _message = 'Bienvenido a {{projectName}}';
  String get message => _message;

  void updateMessage(String newMessage) {
    _message = newMessage;
    notifyListeners();
  }
}
'''),
    );

    // views/home_view.dart
    await fileSystem.writeFile(
      '$basePath/lib/views/home_view.dart',
      engine.render('''
import 'package:flutter/material.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = HomeViewModel();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('{{projectName}}')),
          body: Center(
            child: Text(viewModel.message),
          ),
        );
      },
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

    // viewmodels/bio_viewmodel.dart
    await fileSystem.writeFile(
      '$basePath/lib/viewmodels/bio_viewmodel.dart',
      featureEngine.render('''
import 'package:flutter/foundation.dart';
import '../models/instructor.dart';
import '../models/course.dart';

enum BioState { initial, loading, loaded, error }

class BioViewModel extends ChangeNotifier {
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

    // views/bio_view.dart
    await fileSystem.writeFile(
      '$basePath/lib/views/bio_view.dart',
      featureEngine.render('''
import 'package:flutter/material.dart';
import '../viewmodels/bio_viewmodel.dart';

class BioView extends StatefulWidget {
  const BioView({super.key});

  @override
  State<BioView> createState() => _BioViewState();
}

class _BioViewState extends State<BioView> {
  final BioViewModel _viewModel = BioViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        switch (_viewModel.state) {
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
                  _viewModel.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          case BioState.loaded:
            return Scaffold(
              appBar: AppBar(title: Text(_viewModel.instructor?.name ?? 'Bio')),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_viewModel.instructor != null) ...[
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(_viewModel.instructor!.photoUrl),
                    ),
                    const SizedBox(height: 8),
                    Text(_viewModel.instructor!.name),
                    Text(_viewModel.instructor!.bio),
                  ],
                  const SizedBox(height: 24),
                  ..._viewModel.courses.map(
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