# Patrones y Plantillas para Flutter

Guía completa para elegir la plantilla y el patrón adecuado según el tipo de aplicación que estés desarrollando.

---

## 🤔 ¿Qué es boilerplate y por qué importa?

**Boilerplate** es el código repetitivo que necesitas escribir en múltiples proyectos o features para que la aplicación funcione correctamente, pero que no aporta valor de negocio directo.

### Ejemplos de boilerplate en Flutter

```dart
// ❌ Boilerplate: Escribir esto cada vez que creas una feature
class UserModel {
  final String id;
  final String name;
  
  const UserModel({required this.id, required this.name});
  
  // Este código de serialización es boilerplate
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
  
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  
  User toEntity() => User(id: id, name: name);
}

// Otro boilerplate común: crear la misma estructura de carpetas
// una y otra vez en cada proyecto
```

### Cómo reduce boilerplate `flutter_clean`

| Sin flutter_clean | Con flutter_clean |
|------------------|-------------------|
| `flutter create app` → proyecto vacío | `flutter_clean create --name app` → proyecto con estructura completa |
| Crear carpetas `domain/entities/`, `data/models/`, etc. a mano | Las plantillas ya incluyen toda la estructura |
| Escribir `main.dart`, `app.dart`, tema, router desde cero | Se generan automáticamente con {{variables}} |
| Crear feature de ejemplo para entender la estructura | Cada plantilla incluye una feature "bio" funcional |
| Escribir modelos, repositorios, use cases repetitivos | El CLI `make:feature` los genera con un comando |

### ¿Todo boilerplate es malo?

No. Parte del boilerplate es necesario para mantener la **estructura y calidad del código**. La clave está en:

1. **Automatizar** lo repetitivo (estructura de carpetas, archivos base)
2. **Mantener** lo valioso (lógica de negocio, reglas de dominio)
3. **Elegir** la plantilla con el nivel adecuado de boilerplate para tu proyecto

> 💡 **Las plantillas de `flutter_clean` están diseñadas para darte el punto justo de boilerplate:**
> - Suficiente para mantener una arquitectura sólida
> - El mínimo necesario para empezar a desarrollar rápidamente
> - Fáciles de modificar si necesitas más o menos estructura

---

## 📋 Plantillas disponibles en flutter_clean

El CLI `flutter_clean` ofrece **7 plantillas** listas para usar. Cada una genera un proyecto completo con su estructura, archivos core y una feature de ejemplo.

| Plantilla | Slug | Estado | Arquitectura | Ideal para |
|-----------|------|--------|-------------|------------|
| **Clean Architecture** | `clean` | ✅ Estable | Domain/Data/Presentation | Apps profesionales y escalables |
| **MVC** | `mvc` | ✅ Estable | Model/View/Controller | Prototipos y apps pequeñas |
| **MVVM** | `mvvm` | ✅ Estable | Model/View/ViewModel | Apps con lógica de UI compleja |
| **Provider** | `provider` | ✅ Estable | Provider/ChangeNotifier | Apps medianas con estado simple |
| **Riverpod** | `riverpod` | ✅ Estable | Riverpod/Notifier | Apps modernas con estado reactivo |
| **BLoC** | `bloc` | ✅ Estable | Event/State/Bloc | Apps grandes y empresariales |
| **Simple** | `simple` | ✅ Estable | StatefulWidget | Prototipos muy rápidos |

```bash
# Crear proyecto con cada plantilla
flutter_clean create --name mi_app --template clean
flutter_clean create --name mi_app --template mvc
flutter_clean create --name mi_app --template mvvm
flutter_clean create --name mi_app --template provider
flutter_clean create --name mi_app --template riverpod
flutter_clean create --name mi_app --template bloc
flutter_clean create --name mi_app --template simple
```

---

## 🎯 Matriz de decisión: ¿Qué plantilla usar?

### Según el tamaño del proyecto

| Tamaño | Pantallas | Plantilla recomendada | Motivo |
|--------|-----------|----------------------|--------|
| **Micro** | 1-3 | `simple` | Mínimo boilerplate, desarrollo ultrarrápido |
| **Pequeño** | 3-8 | `mvc` o `mvvm` | Estructura clara sin sobrecarga |
| **Mediano** | 8-20 | `provider` o `riverpod` | Estado gestionado, escalable |
| **Grande** | 20+ | `clean` o `bloc` | Máxima separación, testeable en equipo |
| **Empresarial** | 50+ | `bloc` + `clean` | Eventos explícitos, ideal para equipos grandes |

### Según la experiencia del equipo

| Experiencia | Plantilla recomendada | Motivo |
|-------------|----------------------|--------|
| **Junior / Principiante** | `simple` o `mvc` | Curva de aprendizaje mínima |
| **Intermedio** | `mvvm` o `provider` | Buen equilibrio entre estructura y simplicidad |
| **Avanzado** | `riverpod` o `clean` | Control total, compile-safe, testeable |
| **Experto / Equipo** | `bloc` | Eventos explícitos, fácil de revisar en code review |

### Según el tipo de aplicación

| Tipo de app | Plantilla | Patrón de estado | Por qué |
|-------------|-----------|-----------------|---------|
| **CRUD / Formularios** | `clean` | ChangeNotifier | Estados simples (cargando, datos, error) |
| **Tiempo real (chat, notificaciones)** | `bloc` | BLoC + Streams | Los streams encajan naturalmente |
| **E-commerce** | `riverpod` | Riverpod Notifier | Estado compartido entre pantallas |
| **Redes sociales** | `bloc` | BLoC | Múltiples estados simultáneos |
| **Dashboard / Analytics** | `mvvm` | ChangeNotifier | Binding de datos a UI |
| **App offline-first** | `clean` | Repository Pattern | Cache y sincronización de datos |
| **Autenticación** | `provider` | ChangeNotifier | Estados: autenticado/no autenticado/cargando |
| **Juegos / Animaciones** | `simple` | setState | Control total del ciclo de renderizado |
| **Web + Mobile** | `riverpod` | Riverpod | Providers que funcionan en ambas plataformas |

---

## 🏗️ Estructura generada por cada plantilla

### Clean Architecture (`--template clean`)
```
lib/
├── core/                    # Código compartido
│   ├── constants/           # Constantes de la app
│   ├── errors/              # Clases de error/failure
│   ├── network/             # Cliente HTTP, connectivity
│   ├── theme/               # Tema claro/oscuro
│   ├── router/              # Navegación
│   └── utils/               # Validadores, helpers
├── app/                     # Configuración de la app
│   └── app.dart             # Widget raíz MaterialApp
└── features/                # Features autocontenidas
    └── {feature}/
        ├── domain/          # Reglas de negocio
        │   ├── entities/    # Objetos de negocio
        │   ├── repositories/# Contratos abstractos
        │   └── usecases/    # Casos de uso
        ├── data/            # Implementación de datos
        │   ├── models/      # DTOs con fromJson/toJson
        │   ├── datasources/ # Fuentes de datos (API, DB)
        │   └── repositories/# Implementación del contrato
        └── presentation/    # Capa de UI
            ├── controllers/ # Notifiers/ChangeNotifiers
            ├── pages/       # Pantallas completas
            └── widgets/     # Widgets reutilizables
```

### MVC (`--template mvc`)
```
lib/
├── models/                  # Modelos de datos
├── views/                   # Vistas (Widgets)
├── controllers/             # Controladores (lógica)
└── utils/                   # Utilidades
```

### MVVM (`--template mvvm`)
```
lib/
├── models/                  # Modelos de datos
├── views/                   # Vistas (Widgets)
├── viewmodels/              # ViewModels con ChangeNotifier
├── services/                # Servicios (API, DB)
└── utils/                   # Utilidades
```

### Provider (`--template provider`)
```
lib/
├── providers/               # ChangeNotifier providers
├── models/                  # Modelos de datos
├── screens/                 # Pantallas
├── widgets/                 # Widgets reutilizables
├── services/                # Servicios
└── utils/                   # Utilidades
```

### Riverpod (`--template riverpod`)
```
lib/
├── providers/               # Riverpod providers/notifiers
├── models/                  # Modelos de datos
├── screens/                 # Pantallas (ConsumerWidget)
├── widgets/                 # Widgets reutilizables
├── services/                # Servicios
└── utils/                   # Utilidades
```

### BLoC (`--template bloc`)
```
lib/
├── blocs/                   # Lógica de negocio (BLoCs)
├── events/                  # Eventos del BLoC
├── states/                  # Estados del BLoC
├── models/                  # Modelos de datos
├── screens/                 # Pantallas
├── widgets/                 # Widgets reutilizables
├── services/                # Servicios
└── utils/                   # Utilidades
```

### Simple (`--template simple`)
```
lib/
├── pages/                   # Pantallas (StatefulWidget)
├── widgets/                 # Widgets reutilizables
└── utils/                   # Utilidades
```

---

## 🔄 Explicación de los patrones de estado

### ChangeNotifier (Nativo de Flutter)

**ChangeNotifier** es una clase del SDK de Flutter (`package:flutter/foundation.dart`) que implementa el patrón **Observer**. Permite que un objeto notifique a sus "oyentes" (listeners) cuando algo cambia, sin necesidad de dependencias externas.

#### ¿Cómo funciona?

```dart
import 'package:flutter/foundation.dart';

// 1. Crear un ChangeNotifier con el estado y la lógica
class CounterNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // ← Notifica a los widgets que escuchan
  }

  void decrement() {
    _count--;
    notifyListeners(); // ← Notifica a los widgets que escuchan
  }
}

// 2. En el widget, escuchar los cambios
class CounterPage extends StatelessWidget {
  final CounterNotifier notifier;

  const CounterPage({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: notifier, // ← Se suscribe a las notificaciones
      builder: (context, _) {
        return Text('Valor: ${notifier.count}'); // ← Se reconstruye al notificar
      },
    );
  }
}
```

#### Flujo de datos

```
Usuario toca botón "+"
       ↓
notifier.increment()  ← Se ejecuta la lógica
       ↓
_count++              ← Cambia el estado
       ↓
notifyListeners()     ← Notifica a todos los widgets suscritos
       ↓
ListenableBuilder     ← Se reconstruye con el nuevo valor
       ↓
UI actualizada        ← El usuario ve el cambio
```

#### ¿Cuándo usarlo?

| Situación | ¿Usar ChangeNotifier? |
|-----------|----------------------|
| Estado local de un widget | ✅ Sí, combinado con ListenableBuilder |
| Estado compartido entre widgets | ✅ Sí, con Provider o inyección manual |
| App pequeña (< 5 pantallas) | ✅ Sí, es la opción más simple |
| App mediana (5-15 pantallas) | ⚠️ Puede funcionar, pero considera Riverpod o Cubit |
| App grande (> 15 pantallas) | ❌ Mejor usar BLoC o Riverpod |
| Estado con mucha inmutabilidad | ⚠️ ChangeNotifier no fuerza inmutabilidad |
| Múltiples streams/eventos | ❌ BLoC maneja mejor flujos complejos |

#### Ventajas
- ✅ **Sin dependencias externas** — viene con Flutter
- ✅ **Simple de entender** — solo necesitas `notifyListeners()`
- ✅ **Flexible** — puedes combinarlo con Provider, Riverpod o inyectarlo manualmente
- ✅ **Buen rendimiento** — solo se reconstruyen los widgets que escuchan

#### Desventajas
- ❌ **No fuerza inmutabilidad** — puedes mutar el estado accidentalmente
- ❌ **Sin eventos explícitos** — cualquiera puede llamar `notifyListeners()`
- ❌ **Manual** — tú decides cuándo y cómo notificar
- ❌ **Escalabilidad limitada** — en apps grandes puede volverse desordenado

#### En las plantillas de flutter_clean

ChangeNotifier se usa en las plantillas **Clean Architecture** y **MVVM** para los controllers/viewmodels:

```dart
// Clean Architecture: presentation/controllers/bio_notifier.dart
class BioNotifier extends ChangeNotifier {
  BioState _state = BioState.initial;
  BioState get state => _state;

  Future<void> loadBio() async {
    _state = BioState.loading;
    notifyListeners();
    // ... lógica ...
    _state = BioState.loaded;
    notifyListeners();
  }
}
```

---

## 📊 Comparativa de patrones de estado

| Característica | setState | ChangeNotifier | Cubit | BLoC | Riverpod |
|---------------|----------|---------------|-------|------|----------|
| **Dependencias** | Ninguna | Ninguna | flutter_bloc | flutter_bloc | flutter_riverpod |
| **Boilerplate** | Mínimo | Bajo | Medio | Alto | Medio |
| **Curva aprendizaje** | ⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Testeabilidad** | Baja | Alta | Alta | Alta | Alta |
| **Inmutabilidad** | ❌ | ❌ | ✅ | ✅ | ✅ |
| **Eventos explícitos** | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Compile-safe** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Rebuilds optimizados** | ❌ | Manual | Automático | Automático | Automático |
| **Escalabilidad** | Baja | Media | Alta | Muy alta | Muy alta |
| **Uso en producción** | Prototipos | Apps pequeñas | Apps medianas | Apps grandes | Apps modernas |

---

## 🧩 Patrones de diseño complementarios

### 1. Repository Pattern (Siempre recomendado)
```dart
// Contrato abstracto - define QUÉ se puede hacer
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<List<User>> getAllUsers();
}

// Implementación concreta - define CÓMO se hace
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  final UserLocalDataSource local;

  UserRepositoryImpl({required this.remote, required this.local});

  @override
  Future<User> getUser(String id) async {
    try {
      final user = await remote.getUser(id);
      await local.cacheUser(user); // Actualizar caché
      return user;
    } catch (e) {
      return await local.getUser(id); // Fallback a caché
    }
  }
}
```

### 2. Use Case Pattern
```dart
// Un caso de uso = una operación de negocio
class GetUserProfile {
  final UserRepository repository;

  GetUserProfile({required this.repository});

  Future<User> call(String userId) {
    return repository.getUser(userId);
  }
}
```

### 3. Dependency Injection
```dart
// Manual (recomendado para apps pequeñas)
final repository = UserRepositoryImpl(remote: api, local: db);
final useCase = GetUserProfile(repository: repository);

// Con Riverpod (recomendado para apps modernas)
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    remote: ref.watch(remoteDataSourceProvider),
    local: ref.watch(localDataSourceProvider),
  );
});

// Con GetIt (recomendado para apps grandes)
GetIt.I.registerSingleton<UserRepository>(UserRepositoryImpl(...));
```

### 4. Adapter Pattern (para servicios externos)
```dart
// Adaptador para Firebase Auth
class FirebaseAuthAdapter implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<User> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return User(id: result.user!.uid, email: result.user!.email!);
  }
}
```

### 5. Strategy Pattern (para múltiples algoritmos)
```dart
abstract class SortingStrategy {
  List<T> sort<T>(List<T> items);
}

class QuickSort implements SortingStrategy { /* ... */ }
class MergeSort implements SortingStrategy { /* ... */ }
class BubbleSort implements SortingStrategy { /* ... */ }
```

---

## 📐 Buenas prácticas por capa

### Domain Layer (la más importante)
```dart
// ✅ Entity - Solo datos, sin dependencias
class User {
  final String id;
  final String email;
  final String name;
  const User({required this.id, required this.email, required this.name});
}

// ✅ Repository - Contrato abstracto
abstract class UserRepository {
  Future<User> getUser(String id);
}

// ✅ Use Case - Una sola responsabilidad
class GetUser {
  final UserRepository repository;
  GetUser({required this.repository});
  Future<User> call(String id) => repository.getUser(id);
}
```

### Data Layer
```dart
// ✅ Model - Con serialización JSON
class UserModel {
  final String id;
  final String email;
  final String name;
  
  const UserModel({required this.id, required this.email, required this.name});
  
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
  );
  
  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name};
  
  User toEntity() => User(id: id, email: email, name: name);
}

// ✅ Data Source - Una fuente de datos específica
class UserRemoteDataSource {
  final http.Client client;
  UserRemoteDataSource({required this.client});
  
  Future<UserModel> fetchUser(String id) async {
    final response = await client.get(Uri.parse('https://api.example.com/users/$id'));
    return UserModel.fromJson(jsonDecode(response.body));
  }
}
```

### Presentation Layer
```dart
// ✅ Controller/Notifier - Gestiona estado
class UserNotifier extends ChangeNotifier {
  final GetUser getUser;
  UserNotifier({required this.getUser});
  
  UserState _state = UserState.initial;
  UserState get state => _state;
  
  Future<void> loadUser(String id) async {
    _state = UserState.loading;
    notifyListeners();
    try {
      final user = await getUser(id);
      _state = UserState.loaded(user);
    } catch (e) {
      _state = UserState.error(e.toString());
    }
    notifyListeners();
  }
}

// ✅ Widget - Solo renderiza, sin lógica de negocio
class UserProfilePage extends StatelessWidget {
  final UserNotifier notifier;
  const UserProfilePage({super.key, required this.notifier});
  
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: notifier,
      builder: (context, _) {
        return switch (notifier.state) {
          UserStateInitial() => const SizedBox(),
          UserStateLoading() => const Center(child: CircularProgressIndicator()),
          UserStateLoaded(:final user) => _UserContent(user: user),
          UserStateError(:final message) => Center(child: Text(message)),
        };
      },
    );
  }
}
```

---

## 🚫 Anti-patrones comunes en Flutter

| Anti-patrón | Problema | Solución |
|-------------|----------|----------|
| **God Widget** | Widget de 500+ líneas | Extraer widgets pequeños, usar controller separado |
| **Llamadas API en widgets** | `initState` con HTTP calls | Mover a UseCase/Repository, inyectar dependencias |
| **setState para todo** | Rebuilds innecesarios de todo el árbol | Usar ChangeNotifier + ListenableBuilder o Provider |
| **Contexto mal usado** | `context` en clases que no son widgets | Pasar solo lo necesario, no el contexto entero |
| **Sin manejo de errores** | try/catch vacíos o prints | Propagar errores al Notifier, mostrar en UI |
| **Datos en memoria global** | Variables static mutables | Usar Provider/Riverpod para estado compartido |
| **Importar Data desde Presentation** | `import 'data/...'` en widgets | Siempre pasar por Domain (entidades, no modelos) |
| **Dependencias circulares** | Feature A importa B y B importa A | Crear capa core compartida, mover interfaces |
| **Sin testing** | 0% cobertura | Testear Domain primero (es la capa más valiosa) |
| **Hardcodear URLs** | URLs quemadas en el código | Usar archivo de configuración o variables de entorno |

---

## 🚀 Flujo de trabajo recomendado

### Para un proyecto nuevo:

```
1. Elegir plantilla según la matriz de decisión
   ↓
2. Generar proyecto: flutter_clean create --name app --template <slug>
   ↓
3. Añadir features: flutter_clean make:feature --name users
   ↓
4. Implementar Domain (entidades, repositorios, use cases)
   ↓
5. Implementar Data (modelos, datasources, repositorios)
   ↓
6. Implementar Presentation (notifiers, páginas, widgets)
   ↓
7. Añadir tests (unitarios de domain, widget tests)
   ↓
8. Ejecutar: flutter run
```

### Para añadir una plantilla personalizada:

```dart
// 1. Crear clase que implemente ProjectTemplate
class MiTemplate implements ProjectTemplate {
  @override String get name => 'Mi Arquitectura';
  @override String get description => 'Descripción de mi plantilla';
  @override TemplateType get type => TemplateType.custom;
  
  @override List<String> directories(String basePath) => [
    '$basePath/lib/mi_capa',
    '$basePath/lib/otra_capa',
  ];
  
  @override Future<void> generateCore(String basePath, FileSystem fs, TemplateEngine engine) async {
    // Generar archivos core
  }
  
  @override Future<void> generateInitialFeature(String basePath, FileSystem fs, TemplateEngine engine) async {
    // Generar feature de ejemplo
  }
}

// 2. Registrar en tiempo de ejecución
TemplateRegistry().register(MiTemplate());

// 3. Usar con el CLI
flutter_clean create --name mi_app --template custom
```

---

## 📚 Recursos adicionales

- [Flutter Architecture Guide](https://docs.flutter.dev/app-architecture)
- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod Documentation](https://riverpod.dev/)
- [BLoC Library](https://bloclibrary.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Dart Effective Style](https://dart.dev/effective-dart/style)