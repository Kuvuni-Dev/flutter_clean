# Comandos CLI

Flutter Generator incluye una CLI para crear proyectos y añadir features desde la terminal.

## Crear proyecto

```bash
dart run flutter_generator_cli:flutter_generator create --name mi_app
```

Este comando:

1. Ejecuta `flutter create --empty` como base
2. Crea la estructura de directorios de la arquitectura seleccionada
3. Genera los archivos core (`main.dart`, `app.dart`, router, theme, etc.)
4. Genera la feature `user` de ejemplo

### Opciones

| Opción | Descripción | Valor por defecto |
|--------|-------------|-------------------|
| `--name` | Nombre del proyecto | (requerido) |
| `--description` | Descripción del proyecto | `""` |
| `--organization` | Organización | `com.kuvuni` |
| `--output` | Directorio de salida | `.` |
| `--template` | Plantilla a usar | `clean` |

## Añadir features

```bash
dart run flutter_generator_cli:flutter_generator make:feature --name auth
```

Este comando añade una nueva feature autocontenida dentro de `lib/features/{nombre}/`.

### Opciones

| Opción | Descripción |
|--------|-------------|
| `--name` | Nombre de la feature (requerido) |
| `--entities` | Lista de entidades separadas por coma (ej: `user,post`) |
| `--no-data` | Omite la capa de datos |
| `--no-presentation` | Omite la capa de presentación |

### Ejemplos

```bash
# Feature básica con entidades personalizadas
dart run flutter_generator_cli:flutter_generator make:feature \
  --name blog \
  --entities post,comment

# Feature solo con capa domain
dart run flutter_generator_cli:flutter_generator make:feature \
  --name analytics \
  --no-data \
  --no-presentation
```

## Instalar paquetes

```bash
# Añadir un paquete al proyecto
flutter pub add dio

# Añadir un paquete con versión específica
flutter pub add dio@5.4.0

# Eliminar un paquete
flutter pub remove dio
```

## Otros comandos útiles

```bash
# Verificar instalación de Flutter
flutter doctor

# Obtener ayuda de la CLI
dart run flutter_generator_cli:flutter_generator --help

# Analizar el proyecto en busca de errores
flutter analyze

# Ejecutar tests
flutter test