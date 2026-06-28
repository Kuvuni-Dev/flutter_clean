import '../core/file_system.dart';
import '../core/template_engine.dart';
import 'project_directories.dart';

/// Genera la feature "bio" de ejemplo dentro del proyecto.
Future<void> generateInitialFeature(
    String basePath, FileSystem fileSystem, TemplateEngine engine) async {
  const folderName = 'bio';
  const className = 'Bio';

  final featureEngine = engine.merge({
    'folderName': folderName,
    'className': className,
  });

  final featurePath = '$basePath/lib/features/$folderName';

  // Crear directorios de la feature
  await createFeatureDirs(featurePath, fileSystem);

  // ──────────────────────────────────────────────
  // DOMAIN - Entidades
  // ──────────────────────────────────────────────
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

  // ──────────────────────────────────────────────
  // DOMAIN - Repositorio abstracto
  // ──────────────────────────────────────────────
  await fileSystem.writeFile(
    '$featurePath/domain/repositories/bio_repository.dart',
    featureEngine.render('''
import '../entities/instructor.dart';
import '../entities/course.dart';

/// Contrato abstracto para obtener datos de la sección bio.
abstract class BioRepository {
  Future<Instructor> getInstructorInfo();
  Future<List<Course>> getCourses();
}
'''),
  );

  // ──────────────────────────────────────────────
  // DOMAIN - Use cases
  // ──────────────────────────────────────────────
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

  // ──────────────────────────────────────────────
  // DATA - Modelos
  // ──────────────────────────────────────────────
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

  // ──────────────────────────────────────────────
  // DATA - Data source
  // ──────────────────────────────────────────────
  await fileSystem.writeFile(
    '$featurePath/data/datasources/bio_remote_data_source.dart',
    featureEngine.render('''
import '../models/instructor_model.dart';
import '../models/course_model.dart';

/// Fuente de datos remota o simulada para la sección bio.
class BioRemoteDataSource {
  Future<InstructorModel> fetchInstructorInfo() async {
    // TODO: Reemplazar con llamada real a API
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
    // TODO: Reemplazar con llamada real a API
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

  // ──────────────────────────────────────────────
  // DATA - Repositorio implementación
  // ──────────────────────────────────────────────
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

  // ──────────────────────────────────────────────
  // PRESENTATION - Controller (Notifier)
  // ──────────────────────────────────────────────
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

  // ──────────────────────────────────────────────
  // PRESENTATION - Pages
  // ──────────────────────────────────────────────
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
            Text(
              course.title,
              style: theme.textTheme.headlineSmall,
            ),
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
            Text(
              course.description,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Tecnologías',
              style: theme.textTheme.titleMedium,
            ),
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

  // ──────────────────────────────────────────────
  // PRESENTATION - Widgets
  // ──────────────────────────────────────────────
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
                  Text(
                    instructor.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    instructor.bio,
                    style: theme.textTheme.bodyMedium,
                  ),
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
      onTap: () {
        // TODO: Abrir URL con url_launcher
      },
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
        title: Text(
          course.title,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              course.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
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
