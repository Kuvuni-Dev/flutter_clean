# Flutter Generator

Monorepo para generar proyectos Flutter con múltiples arquitecturas desde línea de comandos o interfaz gráfica.

> ⚡ Genera automáticamente toda la estructura de capas con entidades, repositorios, casos de uso, modelos y páginas listas para usar. Soporta Clean Architecture, MVC, MVVM, Provider, Riverpod, Bloc y Simple.

---

## 📦 Estructura del monorepo

```
flutter_generator/                    ← Workspace nativo de Dart (SDK ≥3.9)
├── pubspec.yaml                      ← Declaración del workspace
├── packages/
│   ├── core_package/                 ← Lógica compartida (100% Dart puro)
│   │   ├── lib/
│   │   │   ├── models/               ← Configuración de proyecto y features
│   │   │   │   ├── project_config.dart
│   │   │   │   └── feature_config.dart
│   │   │   ├── core/                 ← Utilidades base
│   │   │   │   ├── file_system.dart  ← Operaciones del sistema de archivos
│   │   │   │   └── template_engine.dart ← Motor de templates {{variable}}
│   │   │   └── generators/           ← Generadores de código
│   │   │       ├── project_generator.dart  ← Genera proyecto completo
│   │   │       └── feature_generator.dart  ← Añade features a proyectos
│   │   └── pubspec.yaml
│   ├── cli_package/                  ← Interfaz de línea de comandos
│   │   ├── bin/
│   │   │   └── flutter_generator.dart ← Entry point de la CLI
│   │   └── lib/
│   │       └── commands/
│   │           ├── create_project.dart  ← Comando `create`
│   │           └── make_feature.dart    ← Comando `make:feature`
│   └── ui_package/                   ← Interfaz gráfica (Flutter)
│       └── lib/main.dart
```

---

## 🚀 Cómo usar la CLI

### Requisitos

| Herramienta | Versión mínima |
|------------|----------------|
| Dart SDK | ≥3.9.0 |
| Flutter | ≥3.0.0 (necesario para `flutter create --empty`) |

### Instalación

No requiere instalación global. Se ejecuta directamente desde el monorepo:

```bash
# Desde la raíz del proyecto
cd d:/Kuvuni/flutter_generator

# Ver comandos disponibles
dart run flutter_generator_cli:flutter_generator
```

### Comando `create` — Crear un nuevo proyecto

Ejecuta `flutter create --empty` para generar un proyecto Flutter base limpio y luego superpone la estructura de la arquitectura seleccionada:

```bash
dart run flutter_generator_cli:flutter_generator create --name mi_app --output ./mis_proyectos
```

**Flags:**

| Flag | Abrev. | Descripción | Default | ¿Requerido? |
|------|--------|-------------|---------|:----------:|
| `--name` | `-n` | Nombre del proyecto | — | ✅ Sí |
| `--output` | `-o` | Directorio de salida | `.` | ❌ No |
| `--description` | `-d` | Descripción del proyecto | `""` | ❌ No |
| `--organization` | `-g` | Organización (ej: `com.example`) | `com.kuvuni` | ❌ No |
| `--template` | `-t` | Plantilla a usar | `clean` | ❌ No |

**Ejemplo:**

```bash
dart run flutter_generator_cli:flutter_generator create \
    --name ecommerce_app \
    --description "App de comercio electrónico" \
    --output ./proyectos \
    --organization com.miempresa
```

**Resultado:** Crea la carpeta `./proyectos/ecommerce_app/` con toda la estructura de la arquitectura seleccionada.

### Comando `make:feature` — Añadir una feature

Añade una feature completa (domain + data + presentation) a un proyecto existente:

```bash
dart run flutter_generator_cli:flutter_generator make:feature --name auth --project ./proyectos/ecommerce_app
```

**Flags:**

| Flag | Abrev. | Descripción | Default | ¿Requerido? |
|------|--------|-------------|---------|:----------:|
| `--name` | `-n` | Nombre de la feature | — | ✅ Sí |
| `--project` | `-p` | Ruta del proyecto | `.` | ❌ No |
| `--entities` | `-e` | Entidades separadas por coma | `""` | ❌ No |
| `--no-data` | — | Omitir capa de datos | `false` | ❌ No |
| `--no-presentation` | — | Omitir capa de presentación | `false` | ❌ No |

**Ejemplos:**

```bash
# Feature básica (genera entidad con el mismo nombre de la feature)
dart run flutter_generator_cli:flutter_generator make:feature --name auth --project ./mi_app

# Feature con entidades personalizadas
dart run flutter_generator_cli:flutter_generator make:feature \
    --name tasks \
    --entities task,project,comment \
    --project ./mi_app

# Feature solo con capa de dominio (sin data ni presentación)
dart run flutter_generator_cli:flutter_generator make:feature \
    --name analytics \
    --no-data --no-presentation \
    --project ./mi_app
```

---

## 🧠 Arquitecturas disponibles

El generador soporta múltiples plantillas de arquitectura:

| Plantilla | Descripción |
|-----------|-------------|
| `clean` | Clean Architecture (domain / data / presentation) |
| `mvc` | Model-View-Controller |
| `mvvm` | Model-View-ViewModel |
| `provider` | Provider + ChangeNotifier |
| `riverpod` | Riverpod + code generation |
| `bloc` | Bloc / Cubit |
| `simple` | Estructura básica sin capas |

Cada proyecto generado con Clean Architecture sigue esta estructura:

```
mi_app/lib/
├── core/                              ← Utilidades compartidas (helpers, constantes)
├── data/                              ← Capa de datos
│   ├── datasources/                   ← Fuentes de datos (API, BD local, Firebase)
│   ├── models/                        ← Modelos con fromJson / toJson
│   │   └── auth_model.dart
│   └── repositories/                  ← Implementaciones concretas de los contratos
│       └── auth_repository_impl.dart
├── domain/                            ← Capa de dominio (100% Dart puro, sin Flutter)
│   ├── entities/                      ← Entidades del negocio
│   │   └── auth.dart
│   ├── repositories/                  ← Contratos abstractos (interfaces)
│   │   └── auth_repository.dart
│   └── usecases/                      ← Casos de uso
│       └── get_auth_usecase.dart
└── presentation/                      ← Capa de presentación (Flutter)
    ├── pages/                         ← Pantallas
    │   └── auth_page.dart
    ├── providers/                     ← Lógica de estado (ChangeNotifier, Riverpod, etc.)
    └── widgets/                       ← Widgets reutilizables
```

### Flujo de dependencias

```
Presentation (UI) → Domain (UseCases) → Data (Repository Impl)
                        ↑                        ↓
                  Repositorios (contratos)   DataSources (API/DB)
```

Las dependencias apuntan **hacia adentro**: la capa de dominio no sabe nada de Flutter ni de fuentes de datos externas.

---

## 🖥️ UI de escritorio (Windows, macOS, Linux)

La interfaz gráfica permite crear proyectos y añadir features mediante formularios visuales, sin necesidad de usar la terminal.

### Cómo ejecutar

```bash
# Desde la raíz del monorepo
cd packages/ui_package

# Ejecutar en desktop
flutter run -d windows
# o
flutter run -d macos
# o
flutter run -d linux
```

### Funcionalidades de la UI

- **Formulario "Crear Proyecto":** nombre, descripción, directorio de salida y organización.
- **Formulario "Añadir Feature":** nombre, ruta del proyecto, entidades personalizadas con chips, checkboxes para incluir/excluir capas.
- **Layout responsive:** dos columnas en pantallas anchas (>900px), una columna en estrechas.
- **Tema claro/oscuro:** se adapta automáticamente a la configuración del sistema.
- **Barra de resultados:** feedback visual de éxito o error con opción de cerrar.
- **Indicador de carga:** spinner mientras se ejecuta `flutter create` o se genera código.

### Estructura

```
packages/ui_package/lib/
├── main.dart                    ← Entry point con theming Material 3
├── screens/
│   └── home_screen.dart         ← Pantalla principal con formularios
└── widgets/
    ├── form_section.dart        ← Sección con tarjeta y título
    └── entity_chip.dart         ← Chip para entidades con botón eliminar
```

---

## 📚 Paquetes del monorepo

| Package | Propósito | Tecnología | Dependencias clave |
|---------|-----------|-----------|-------------------|
| `core_package` | Modelos, sistema de archivos, motor de templates, generadores | Dart puro | `path` |
| `cli_package` | CLI con comandos `create` y `make:feature` | Dart puro | `args`, `core_package` |
| `ui_package` | Interfaz gráfica para generar proyectos (Windows, macOS, Linux) | Flutter | Flutter, `core_package` |

---

## 🛠️ Desarrollo

### Resolver dependencias

```bash
dart pub get
```

### Verificar análisis de código

```bash
# Core package
cd packages/core_package && dart analyze lib/

# CLI package
cd packages/cli_package && dart analyze lib/ bin/
```

### Probar la UI localmente

```bash
cd packages/ui_package
flutter run -d windows
```

### Probar la CLI localmente

```bash
# Desde la raíz del monorepo
dart run flutter_generator_cli:flutter_generator
dart run flutter_generator_cli:flutter_generator create --name test_app --output ./tmp
dart run flutter_generator_cli:flutter_generator make:feature --name users --project ./tmp/test_app
```

---

## 📖 Uso educativo

Este proyecto está diseñado como material didáctico para aprender:

- **Monorepos** con Dart workspace nativo
- **Clean Architecture** en Flutter (separación en capas domain/data/presentation)
- **Inyección de dependencias** simple y manual
- **Generación de código** con motor de templates basado en `{{variables}}`
- **CLI** con el paquete `args` de Dart
- **Separación en paquetes**: core (lógica), CLI (interfaz texto), UI (interfaz gráfica)

---

## 🧩 Estructura de archivos generados

### Al crear un proyecto (`create`)

```
mi_app/
├── pubspec.yaml
├── lib/
│   ├── main.dart                        ← Entry point de Flutter
│   ├── core/
│   ├── data/
│   │   ├── datasources/
│   │   ├── models/
│   │   └── repositories/
│   ├── domain/
│   │   ├── entities/
│   │   │   └── user.dart                ← Entidad de ejemplo
│   │   ├── repositories/
│   │   └── usecases/
│   └── presentation/
│       ├── pages/
│       │   └── home_page.dart           ← Página principal
│       ├── providers/
│       └── widgets/
└── test/
```

### Al añadir una feature (`make:feature --name auth`)

```
lib/
├── domain/
│   ├── entities/
│   │   └── auth.dart                    ← Entidad Auth
│   ├── repositories/
│   │   └── auth_repository.dart         ← Contrato abstracto
│   └── usecases/
│       └── get_auth_usecase.dart        ← Caso de uso GetAll
├── data/
│   ├── models/
│   │   └── auth_model.dart             ← Modelo con fromJson/toJson
│   └── repositories/
│       └── auth_repository_impl.dart    ← Implementación del repositorio
└── presentation/
    └── pages/
        └── auth_page.dart              ← Página de la feature