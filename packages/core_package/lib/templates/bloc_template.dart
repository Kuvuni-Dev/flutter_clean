import '../core/file_system.dart';
import '../core/template_engine.dart';
import 'project_template.dart';

/// Plantilla con BLoC (flutter_bloc).
///
/// Estructura:
/// ```
/// lib/
///   blocs/
///   events/
///   states/
///   models/
///   screens/
///   widgets/
///   services/
///   utils/
///   app.dart
/// ```
class BlocTemplate implements ProjectTemplate {
  @override
  String get name => 'BLoC';

  @override
  String get shortDescription => 'Gestión de estado reactiva y escalable';

  @override
  String get description =>
      'Patrón BLoC (Business Logic Component) con flutter_bloc. '
      'Ideal para apps complejas con flujos de estado predecibles.';

  @override
  TemplateType get type => TemplateType.bloc;

  @override
  List<String> directories(String basePath) => [
        '$basePath/assets/images',
        '$basePath/assets/fonts',
        '$basePath/lib/blocs',
        '$basePath/lib/events',
        '$basePath/lib/states',
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'blocs/counter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterBloc()),
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

    // events/counter_event.dart
    await fileSystem.writeFile(
      '$basePath/lib/events/counter_event.dart',
      engine.render('''
abstract class CounterEvent {}

class CounterIncrement extends CounterEvent {}

class CounterDecrement extends CounterEvent {}
'''),
    );

    // states/counter_state.dart
    await fileSystem.writeFile(
      '$basePath/lib/states/counter_state.dart',
      engine.render('''
class CounterState {
  final int count;

  const CounterState({this.count = 0});

  CounterState copyWith({int? count}) {
    return CounterState(count: count ?? this.count);
  }
}
'''),
    );

    // blocs/counter_bloc.dart
    await fileSystem.writeFile(
      '$basePath/lib/blocs/counter_bloc.dart',
      engine.render('''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../events/counter_event.dart';
import '../states/counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<CounterIncrement>((event, emit) {
      emit(state.copyWith(count: state.count + 1));
    });
    on<CounterDecrement>((event, emit) {
      emit(state.copyWith(count: state.count - 1));
    });
  }
}
'''),
    );

    // screens/home_screen.dart
    await fileSystem.writeFile(
      '$basePath/lib/screens/home_screen.dart',
      engine.render('''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/counter_bloc.dart';
import '../events/counter_event.dart';
import '../states/counter_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{projectName}}')),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Text(
              'Contador: \${state.count}',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterBloc>().add(CounterIncrement()),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<CounterBloc>().add(CounterDecrement()),
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

    // events/bio_event.dart
    await fileSystem.writeFile(
      '$basePath/lib/events/bio_event.dart',
      featureEngine.render('''
abstract class BioEvent {}

class LoadBio extends BioEvent {}
'''),
    );

    // states/bio_state.dart
    await fileSystem.writeFile(
      '$basePath/lib/states/bio_state.dart',
      featureEngine.render('''
import '../models/instructor.dart';
import '../models/course.dart';

abstract class BioState {
  const BioState();
}

class BioInitial extends BioState {
  const BioInitial();
}

class BioLoading extends BioState {
  const BioLoading();
}

class BioLoaded extends BioState {
  final Instructor instructor;
  final List<Course> courses;

  const BioLoaded({required this.instructor, required this.courses});
}

class BioError extends BioState {
  final String message;

  const BioError(this.message);
}
'''),
    );

    // blocs/bio_bloc.dart
    await fileSystem.writeFile(
      '$basePath/lib/blocs/bio_bloc.dart',
      featureEngine.render('''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../events/bio_event.dart';
import '../states/bio_state.dart';
import '../models/instructor.dart';
import '../models/course.dart';

class BioBloc extends Bloc<BioEvent, BioState> {
  BioBloc() : super(const BioInitial()) {
    on<LoadBio>((event, emit) async {
      emit(const BioLoading());
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(BioLoaded(
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
        ));
      } catch (e) {
        emit(BioError(e.toString()));
      }
    });
  }
}
'''),
    );

    // screens/bio_screen.dart
    await fileSystem.writeFile(
      '$basePath/lib/screens/bio_screen.dart',
      featureEngine.render('''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bio_bloc.dart';
import '../events/bio_event.dart';
import '../states/bio_state.dart';

class BioScreen extends StatelessWidget {
  const BioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BioBloc()..add(LoadBio()),
      child: const _BioView(),
    );
  }
}

class _BioView extends StatelessWidget {
  const _BioView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BioBloc, BioState>(
      builder: (context, state) {
        if (state is BioInitial || state is BioLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is BioError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is BioLoaded) {
          return Scaffold(
            appBar: AppBar(title: Text(state.instructor.name)),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(state.instructor.photoUrl),
                ),
                const SizedBox(height: 8),
                Text(state.instructor.name),
                Text(state.instructor.bio),
                const SizedBox(height: 24),
                ...state.courses.map(
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

        return const Scaffold(
          body: Center(child: Text('Estado no soportado')),
        );
      },
    );
  }
}
'''),
    );
  }
}
