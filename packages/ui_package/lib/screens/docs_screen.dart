import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  /// Mapa de documentos: clave = nombre para mostrar, valor = asset path
  static const _documents = [
    ('📖 Introducción', 'assets/docs/introduccion.md'),
    ('🏗️ Estructura del proyecto', 'assets/docs/estructura.md'),
    ('🔄 Flujo de datos', 'assets/docs/flujo_de_datos.md'),
    ('🛠️ Comandos CLI', 'assets/docs/comandos.md'),
    ('📚 Buenas prácticas', 'assets/docs/buenas_practicas.md'),
    ('🎯 Patrones y matriz de decisión', 'assets/docs/patrones.md'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Lista de documentos
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Documentación',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ..._documents.map(
                (doc) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(doc.$1),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              _DocViewer(title: doc.$1, assetPath: doc.$2),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Visor de un documento Markdown.
class _DocViewer extends StatelessWidget {
  final String title;
  final String assetPath;

  const _DocViewer({required this.title, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context).loadString(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Error al cargar el documento:\n${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final markdown = snapshot.data ?? '';
          return Markdown(
            data: markdown,
            selectable: true,
            padding: const EdgeInsets.all(16),
            styleSheet: MarkdownStyleSheet(
              h1: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              h2: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              h3: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              p: Theme.of(context).textTheme.bodyLarge,
              code: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                backgroundColor: Color(0xFF1E1E1E),
                color: Color(0xFF9CDCFE),
              ),
              codeblockDecoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
              ),
              codeblockPadding: const EdgeInsets.all(12),
              blockquoteDecoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                border: const Border(
                  left: BorderSide(color: Colors.blue, width: 4),
                ),
              ),
              blockquotePadding: const EdgeInsets.all(12),
              tableBorder: TableBorder.all(
                color: Colors.grey.withValues(alpha: 0.3),
              ),
              tableHead: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
