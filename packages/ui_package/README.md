# Flutter Generator UI

Interfaz gráfica para **Flutter Generator**, construida con Flutter para escritorio (Windows, macOS, Linux).

## Requisitos

- Flutter SDK (con soporte para desktop habilitado)
- Dart SDK ≥3.12.0

## Cómo ejecutar

```bash
# Desde la raíz del monorepo
cd packages/ui_package

# Habilitar soporte desktop (si no está habilitado)
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop

# Ejecutar
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

## Funcionalidades

- **Crear proyecto**: Formulario para generar un proyecto Flutter con la arquitectura seleccionada usando `flutter create --empty` como base.
- **Añadir feature**: Formulario para añadir una feature completa (domain/data/presentation) a un proyecto existente.
- **Entidades personalizadas**: Permite añadir múltiples entidades por feature.
- **Opción de capas**: Checkboxes para incluir/excluir capa de datos y presentación.
- **Resultados visuales**: Barra de estado con feedback de éxito/error.
- **Responsive**: Layout adaptable a ventanas anchas (dos columnas) o estrechas (una columna).
- **Tema claro/oscuro**: Sigue la configuración del sistema.

## Estructura

```
lib/
├── main.dart                    ← Entry point con theming
├── screens/
│   └── home_screen.dart         ← Pantalla principal con formularios
└── widgets/
    ├── form_section.dart        ← Widget de sección con tarjeta
    └── entity_chip.dart         ← Chip para entidades con botón eliminar