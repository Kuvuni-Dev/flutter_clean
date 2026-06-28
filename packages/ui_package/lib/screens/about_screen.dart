import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Tarjeta de presentación ---
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.code,
                          size: 48,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kuvuni',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Desarrollador Flutter & Dart',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Apasionado por la arquitectura limpia y '
                              'las buenas prácticas en el desarrollo de '
                              'aplicaciones multiplataforma con Flutter.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- Enlaces / Redes ---
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.link, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Enlaces',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _socialTile(
                        context,
                        icon: Icons.code,
                        label: 'GitHub',
                        url: 'https://github.com/kuvuni',
                      ),
                      _socialTile(
                        context,
                        icon: Icons.link,
                        label: 'LinkedIn',
                        url: 'https://linkedin.com/in/kuvuni',
                      ),
                      _socialTile(
                        context,
                        icon: Icons.alternate_email,
                        label: 'Twitter / X',
                        url: 'https://twitter.com/kuvuni',
                      ),
                      _socialTile(
                        context,
                        icon: Icons.mail_outline,
                        label: 'Correo electrónico',
                        url: 'kuvuni@example.com',
                      ),
                    ],
                  ),
                ),
              ),

              // --- Tecnologías ---
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.handyman_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tecnologías',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _chip('Flutter'),
                          _chip('Dart'),
                          _chip('Clean Architecture'),
                          _chip('Firebase'),
                          _chip('REST APIs'),
                          _chip('SQLite'),
                          _chip('Git'),
                          _chip('Bloc / Cubit'),
                          _chip('Provider'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String url,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () {
        // TODO: Abrir URL con url_launcher
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label: $url')));
      },
    );
  }

  Widget _chip(String label) {
    return Chip(
      label: Text(label),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
