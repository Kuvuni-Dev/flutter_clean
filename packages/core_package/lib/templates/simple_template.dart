import '../core/file_system.dart';
import '../core/template_engine.dart';
import 'project_template.dart';

/// Plantilla Simple - estructura mínima de Flutter.
///
/// Estructura:
/// ```
/// lib/
///   pages/
///   widgets/
///   utils/
///   app.dart
/// ```
class SimpleTemplate implements ProjectTemplate {
  @override
  String get name => 'Simple';

  @override
  String get description =>
      'Estructura minimalista de Flutter sin patrones complejos. '
      'Ideal para prototipos y proyectos muy pequeños.';

  @override
  TemplateType get type => TemplateType.simple;

  @override
  List<String> directories(String basePath) => [
        '$basePath/assets/images',
        '$basePath/assets/fonts',
        '$basePath/lib/pages',
        '$basePath/lib/widgets',
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
import 'pages/home_page.dart';

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
      home: const HomePage(),
    );
  }
}
'''),
    );

    // pages/home_page.dart
    await fileSystem.writeFile(
      '$basePath/lib/pages/home_page.dart',
      engine.render(r'''
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _increment() => setState(() => _counter++);
  void _decrement() => setState(() => _counter--);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{projectName}}')),
      body: Center(
        child: Text(
          'Contador: $_counter',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _increment,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: _decrement,
            child: const Icon(Icons.remove),
          ),
        ],
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

    // pages/bio_page.dart
    await fileSystem.writeFile(
      '$basePath/lib/pages/bio_page.dart',
      featureEngine.render('''
import 'package:flutter/material.dart';

class BioPage extends StatefulWidget {
  const BioPage({super.key});

  @override
  State<BioPage> createState() => _BioPageState();
}

class _BioPageState extends State<BioPage> {
  Map<String, dynamic>? _data;
  bool _isLoading = false;

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _data = {
        'name': 'Kuvuni',
        'bio': 'Desarrollador Flutter & Dart',
        'photoUrl': 'assets/images/profile.jpg',
        'courses': [
          {
            'title': 'Flutter Clean Architecture',
            'description': 'Aprende a estructurar tus proyectos.',
          },
        ],
      };
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bio')),
      body: _data == null
          ? const Center(child: Text('Sin datos'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(_data!['photoUrl'] as String),
                ),
                const SizedBox(height: 8),
                Text(_data!['name'] as String),
                Text(_data!['bio'] as String),
                const SizedBox(height: 24),
                ...(_data!['courses'] as List).map(
                  (course) => Card(
                    child: ListTile(
                      title: Text(course['title'] as String),
                      subtitle: Text(course['description'] as String),
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