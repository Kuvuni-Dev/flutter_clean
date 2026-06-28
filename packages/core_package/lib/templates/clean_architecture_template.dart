import '../core/file_system.dart';
import '../core/template_engine.dart';
import 'project_template.dart';

/// Plantilla Clean Architecture con capas domain/data/presentation.
///
/// Estructura:
/// ```
/// lib/
///   core/
///     constants/
///     errors/
///     network/
///     theme/
///     router/
///     utils/
///   app/
///   features/
///     {feature}/
///       domain/entities/
///       domain/repositories/
///       domain/usecases/
///       data/models/
///       data/datasources/
///       data/repositories/
///       presentation/controllers/
///       presentation/pages/
///       presentation/widgets/
/// ```
class CleanArchitectureTemplate implements ProjectTemplate {
  @override
  String get name => 'Clean Architecture';

  @override
  String get description =>
      'Arquitectura limpia con capas domain/data/presentation. '
      'Ideal para proyectos grandes y escalables.';

  @override
  TemplateType get type => TemplateType.cleanArchitecture;

  @override
  List<String> directories(String basePath) => [
        '$basePath/assets/images',
        '$basePath/assets/fonts',
        '$basePath/assets/icons',
        '$basePath/lib/core/constants',
        '$basePath/lib/core/errors',
        '$basePath/lib/core/network',
        '$basePath/lib/core/theme',
        '$basePath/lib/core/router',
        '$basePath/lib/core/utils',
        '$basePath/lib/app',
        '$basePath/lib/features',
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

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return _materialPage(
          const Scaffold(
            body: Center(child: Text('Home')),
          ),
          settings,
        );
      case RouteNames.settings:
        return _materialPage(
          const Scaffold(
            body: Center(child: Text('Settings')),
          ),
          settings,
        );
      default:
        return _materialPage(
          Scaffold(
            body: Center(child: Text("Route '\${settings.name}' not found")),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute _materialPage(Widget page, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
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

    final featurePath = '$basePath/lib/features/$folderName';

    // Crear directorios de la feature
    final dirs = [
      '$featurePath/domain/entities',
      '$featurePath/domain/repositories',
      '$featurePath/domain/usecases',
      '$featurePath/data/models',
      '$featurePath/data/datasources',
      '$featurePath/data/repositories',
      '$featurePath/presentation/controllers',
      '$featurePath/presentation/pages',
      '$featurePath/presentation/widgets',
    ];
    for (final dir in dirs) {
      await fileSystem.createDirectories(dir);
    }

    // Domain - Entities
    await fileSystem.writeFile(
      '$featurePath/domain/entities/instructor.dart',
      featureEngine.render('''
class Instructor {
  final String name;
  final String bio;
  final String photoUrl;
  final String githubUrl;
  final String linkedinUrl;
  final String twitterUrl;

  const Instructor({
    required this.name,
    required this.bio,
    required this.photoUrl,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.twitterUrl,
  });
}
'''),
    );

    await fileSystem.writeFile(
      '$featurePath/domain/entities/course.dart',
      featureEngine.render('''
class Course {
  final String id;
  final String title;
  final String description;
  final List<String> technologies;
  final int durationHours;
  final String difficulty;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    required this.durationHours,
    required this.difficulty,
  });
}
'''),
    );

    // Domain - Repository
    await fileSystem.writeFile(
      '$featurePath/domain/repositories/bio_repository.dart',
      featureEngine.render('''
import '../entities/instructor.dart';
import '../entities/course.dart';

abstract class BioRepository {
  Future<Instructor> getInstructorInfo();
  Future<List<Course>> getCourses();
}
'''),
    );

    // Domain - Use cases
    await fileSystem.writeFile(
      '$featurePath/domain/usecases/get_instructor_info.dart',
      featureEngine.render('''
import '../entities/instructor.dart';
import '../repositories/bio_repository.dart';

class GetInstructorInfo {
  final BioRepository repository;

  GetInstructorInfo({required this.repository});

  Future<Instructor> call() {
    return repository.getInstructorInfo();
  }
}
'''),
    );

    await fileSystem.writeFile(
      '$featurePath/domain/usecases/get_courses.dart',
      featureEngine.render('''
import '../entities/course.dart';
import '../repositories/bio_repository.dart';

class GetCourses {
  final BioRepository repository;

  GetCourses({required this.repository});

  Future<List<Course>> call() {
    return repository.getCourses();
  }
}
'''),
    );

    // Data - Models
    await fileSystem.writeFile(
      '$featurePath/data/models/instructor_model.dart',
      featureEngine.render('''
import '../../domain/entities/instructor.dart';

class InstructorModel {
  final String name;
  final String bio;
  final String photoUrl;
  final String githubUrl;
  final String linkedinUrl;
  final String twitterUrl;

  const InstructorModel({
    required this.name,
    required this.bio,
    required this.photoUrl,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.twitterUrl,
  });

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      name: json['name'] as String,
      bio: json['bio'] as String,
      photoUrl: json['photoUrl'] as String,
      githubUrl: json['githubUrl'] as String,
      linkedinUrl: json['linkedinUrl'] as String,
      twitterUrl: json['twitterUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'bio': bio,
        'photoUrl': photoUrl,
        'githubUrl': githubUrl,
        'linkedinUrl': linkedinUrl,
        'twitterUrl': twitterUrl,
      };

  Instructor toEntity() {
    return Instructor(
      name: name,
      bio: bio,
      photoUrl: photoUrl,
      githubUrl: githubUrl,
      linkedinUrl: linkedinUrl,
      twitterUrl: twitterUrl,
    );
  }
}
'''),
    );

    await fileSystem.writeFile(
      '$featurePath/data/models/course_model.dart',
      featureEngine.render('''
import '../../domain/entities/course.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final List<String> technologies;
  final int durationHours;
  final String difficulty;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    required this.durationHours,
    required this.difficulty,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      technologies: (json['technologies'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      durationHours: json['durationHours'] as int,
      difficulty: json['difficulty'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'technologies': technologies,
        'durationHours': durationHours,
        'difficulty': difficulty,
      };

  Course toEntity() {
    return Course(
      id: id,
      title: title,
      description: description,
      technologies: technologies,
      durationHours: durationHours,
      difficulty: difficulty,
    );
  }
}
'''),
    );

    // Data - Data source
    await fileSystem.writeFile(
      '$featurePath/data/datasources/bio_remote_data_source.dart',
      featureEngine.render('''
import '../models/instructor_model.dart';
import '../models/course_model.dart';

class BioRemoteDataSource {
  Future<InstructorModel> fetchInstructorInfo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const InstructorModel(
      name: 'Kuvuni',
      bio: 'Desarrollador Flutter & Dart | Clean Architecture',
      photoUrl: 'assets/images/profile.jpg',
      githubUrl: 'https://github.com/kuvuni',
      linkedinUrl: 'https://linkedin.com/in/kuvuni',
      twitterUrl: 'https://twitter.com/kuvuni',
    );
  }

  Future<List<CourseModel>> fetchCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const CourseModel(
        id: '1',
        title: 'Flutter Clean Architecture',
        description: 'Aprende a estructurar tus proyectos Flutter con Clean Architecture.',
        technologies: ['Flutter', 'Dart', 'Clean Architecture'],
        durationHours: 10,
        difficulty: 'Intermedio',
      ),
      const CourseModel(
        id: '2',
        title: 'Dart Avanzado',
        description: 'Domina las características más avanzadas de Dart.',
        technologies: ['Dart'],
        durationHours: 8,
        difficulty: 'Avanzado',
      ),
    ];
  }
}
'''),
    );

    // Data - Repository impl
    await fileSystem.writeFile(
      '$featurePath/data/repositories/bio_repository_impl.dart',
      featureEngine.render('''
import '../../domain/entities/instructor.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/bio_repository.dart';
import '../datasources/bio_remote_data_source.dart';

class BioRepositoryImpl implements BioRepository {
  final BioRemoteDataSource remoteDataSource;

  BioRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Instructor> getInstructorInfo() async {
    final model = await remoteDataSource.fetchInstructorInfo();
    return model.toEntity();
  }

  @override
  Future<List<Course>> getCourses() async {
    final models = await remoteDataSource.fetchCourses();
    return models.map((model) => model.toEntity()).toList();
  }
}
'''),
    );

    // Presentation - Controller
    await fileSystem.writeFile(
      '$featurePath/presentation/controllers/bio_notifier.dart',
      featureEngine.render('''
import 'package:flutter/foundation.dart';
import '../../domain/entities/instructor.dart';
import '../../domain/entities/course.dart';
import '../../domain/usecases/get_instructor_info.dart';
import '../../domain/usecases/get_courses.dart';

enum BioState { initial, loading, loaded, error }

class BioNotifier extends ChangeNotifier {
  final GetInstructorInfo getInstructorInfo;
  final GetCourses getCourses;

  BioNotifier({
    required this.getInstructorInfo,
    required this.getCourses,
  });

  BioState _state = BioState.initial;
  BioState get state => _state;

  Instructor? _instructor;
  Instructor? get instructor => _instructor;

  List<Course> _courses = [];
  List<Course> get courses => _courses;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> loadBio() async {
    _state = BioState.loading;
    notifyListeners();

    try {
      final results = await Future.wait([
        getInstructorInfo.call(),
        getCourses.call(),
      ]);

      _instructor = results[0] as Instructor;
      _courses = results[1] as List<Course>;
      _state = BioState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = BioState.error;
    }

    notifyListeners();
  }

  void reset() {
    _state = BioState.initial;
    _instructor = null;
    _courses = [];
    _errorMessage = '';
    notifyListeners();
  }
}
'''),
    );

    // Presentation - Pages
    await fileSystem.writeFile(
      '$featurePath/presentation/pages/bio_dashboard_page.dart',
      featureEngine.render('''
import 'package:flutter/material.dart';
import '../controllers/bio_notifier.dart';
import '../widgets/instructor_header.dart';
import '../widgets/course_card.dart';

class BioDashboardPage extends StatefulWidget {
  final BioNotifier notifier;

  const BioDashboardPage({super.key, required this.notifier});

  @override
  State<BioDashboardPage> createState() => _BioDashboardPageState();
}

class _BioDashboardPageState extends State<BioDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.notifier.loadBio();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.notifier,
      builder: (context, _) {
        switch (widget.notifier.state) {
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
                  widget.notifier.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          case BioState.loaded:
            final instructor = widget.notifier.instructor!;
            final courses = widget.notifier.courses;
            return Scaffold(
              appBar: AppBar(title: Text(instructor.name)),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  InstructorHeader(instructor: instructor),
                  const SizedBox(height: 24),
                  Text(
                    'Cursos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...courses.map(
                    (course) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CourseCard(course: course),
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

    await fileSystem.writeFile(
      '$featurePath/presentation/pages/course_details_page.dart',
      featureEngine.render('''
import 'package:flutter/material.dart';
import '../../domain/entities/course.dart';

class CourseDetailsPage extends StatelessWidget {
  final Course course;

  const CourseDetailsPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text('\${course.durationHours} horas'),
                const SizedBox(width: 16),
                const Icon(Icons.signal_cellular_alt, size: 16),
                const SizedBox(width: 4),
                Text(course.difficulty),
              ],
            ),
            const SizedBox(height: 16),
            Text(course.description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text('Tecnologías', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: course.technologies
                  .map((tech) => Chip(label: Text(tech)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
'''),
    );

    // Presentation - Widgets
    await fileSystem.writeFile(
      '$featurePath/presentation/widgets/instructor_header.dart',
      featureEngine.render('''
import 'package:flutter/material.dart';
import '../../domain/entities/instructor.dart';

class InstructorHeader extends StatelessWidget {
  final Instructor instructor;

  const InstructorHeader({super.key, required this.instructor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(instructor.photoUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(instructor.name, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(instructor.bio, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _socialIcon(Icons.code, instructor.githubUrl),
                      const SizedBox(width: 8),
                      _socialIcon(Icons.link, instructor.linkedinUrl),
                      const SizedBox(width: 8),
                      _socialIcon(Icons.alternate_email, instructor.twitterUrl),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return InkWell(
      onTap: () {},
      child: Icon(icon, size: 20),
    );
  }
}
'''),
    );

    await fileSystem.writeFile(
      '$featurePath/presentation/widgets/course_card.dart',
      featureEngine.render('''
import 'package:flutter/material.dart';
import '../../domain/entities/course.dart';
import '../pages/course_details_page.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const Icon(Icons.school, size: 40),
        title: Text(course.title, style: theme.textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(course.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14),
                const SizedBox(width: 2),
                Text('\${course.durationHours}h'),
                const SizedBox(width: 12),
                const Icon(Icons.signal_cellular_alt, size: 14),
                const SizedBox(width: 2),
                Text(course.difficulty),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CourseDetailsPage(course: course),
            ),
          );
        },
      ),
    );
  }
}
'''),
    );
  }
}