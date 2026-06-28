# Buenas prácticas para Flutter

Guía completa de buenas prácticas, convenciones y tips para desarrollar aplicaciones Flutter profesionales.

---

## 📁 1. Estructura del proyecto

### Convenciones de nombrado

| Elemento | Convención | Ejemplo |
|----------|-----------|---------|
| **Archivos** | `snake_case` | `mi_archivo.dart` |
| **Carpetas** | `snake_case` | `feature/auth/` |
| **Clases** | `PascalCase` | `AuthRepository` |
| **Métodos** | `camelCase` | `getUserById()` |
| **Variables** | `camelCase` | `isLoading` |
| **Constantes** | `camelCase` | `kDefaultTimeout` |
| **Enums** | `PascalCase` | `enum LoadState { initial, loading, loaded }` |
| **Extensiones** | `PascalCase` (on Type) | `extension StringValidation on String` |

### Orden de imports
```dart
// 1. SDK de Dart
import 'dart:async';
import 'dart:convert';

// 2. Paquetes externos (pub.dev)
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 3. Paquetes del proyecto
import 'package:core_package/core_package.dart';

// 4. Imports relativos (misma feature)
import '../entities/user.dart';
import '../repositories/user_repository.dart';
```

### Organización de clases
- **Una clase por archivo** (excepción: clases pequeñas estrechamente relacionadas)
- **Un archivo por feature** dentro de su carpeta
- **Máximo 200 líneas por archivo** (si supera, refactorizar)
- **Máximo 3 parámetros posicionales** (usar named parameters para más)

---

## 🧱 2. Widgets y UI

### Widgets deben ser puros
```dart
// ✅ CORRECTO - Widget sin lógica de negocio
class UserAvatar extends StatelessWidget {
  final String photoUrl;
  final double radius;
  
  const UserAvatar({super.key, required this.photoUrl, this.radius = 20});
  
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage(photoUrl),
    );
  }
}

// ❌ INCORRECTO - Lógica de negocio mezclada en el widget
class UserAvatar extends StatefulWidget {
  // ...
  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  // ❌ No hacer llamadas API aquí
  Future<void> _fetchData() async { /* ... */ }
}
```

### Extraer widgets pequeños
```dart
// ✅ CORRECTO - Widgets pequeños y reutilizables
class ProfileHeader extends StatelessWidget { /* ... */ }
class ProfileStats extends StatelessWidget { /* ... */ }
class ProfileActions extends StatelessWidget { /* ... */ }

// ❌ INCORRECTO - Un solo widget gigante
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        // 100 líneas de header
        // 100 líneas de stats
        // 100 líneas de acciones
      ]),
    );
  }
}
```

### Usar `const` siempre que sea posible
```dart
// ✅ CORRECTO
const SizedBox(height: 16);
const Icon(Icons.star, size: 20);
const EdgeInsets.all(16);

// ❌ INCORRECTO
SizedBox(height: 16);
Icon(Icons.star, size: 20);
EdgeInsets.all(16);
```

### Preferir `StatelessWidget` sobre `StatefulWidget`
```dart
// ✅ CORRECTO - Usar StatelessWidget si no hay estado mutable
class MyWidget extends StatelessWidget { /* ... */ }

// ❌ INCORRECTO - StatefulWidget innecesario
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}
```

---

## 📊 3. Manejo de estado

### Elegir el patrón adecuado
```dart
// Para estado local simple
setState(() => _counter++);

// Para estado compartido entre widgets
class MyNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  void increment() { _count++; notifyListeners(); }
}

// Para estado complejo con eventos
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(MyInitial()) {
    on<DoSomething>((event, emit) { /* ... */ });
  }
}
```

### Estados inmutables
```dart
// ✅ CORRECTO - Estado inmutable con copyWith
class UserState {
  final bool isLoading;
  final User? user;
  final String? error;
  
  const UserState({this.isLoading = false, this.user, this.error});
  
  UserState copyWith({bool? isLoading, User? user, String? error}) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

// ❌ INCORRECTO - Estado mutable
class BadState {
  bool isLoading = false;
  User? user;
  String? error;
}
```

---

## 🔌 4. Inyección de dependencias

### Manual (recomendado para apps pequeñas)
```dart
void main() {
  final api = ApiService();
  final repository = UserRepositoryImpl(api);
  final useCase = GetUser(repository);
  runApp(MyApp(useCase: useCase));
}
```

### Con Riverpod (recomendado para apps modernas)
```dart
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(apiServiceProvider));
});

final getUserProvider = Provider<GetUser>((ref) {
  return GetUser(ref.watch(userRepositoryProvider));
});
```

### Con GetIt (recomendado para apps grandes)
```dart
final sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerFactory(() => GetUser(sl()));
}
```

---

## 🌐 5. Manejo de errores

### Tipos de error específicos
```dart
// ✅ CORRECTO - Jerarquía de errores
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  final int statusCode;
  const ServerFailure(super.message, this.statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// ✅ CORRECTO - Manejo en Use Case
class GetUser {
  final UserRepository repository;
  GetUser({required this.repository});
  
  Future<Either<Failure, User>> call(String id) async {
    try {
      final user = await repository.getUser(id);
      return Right(user);
    } on SocketException {
      return Left(NetworkFailure('Sin conexión a internet'));
    } on HttpException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
```

### Mostrar errores al usuario
```dart
// ✅ CORRECTO - Manejo centralizado de errores
class ErrorHandler {
  static void showError(BuildContext context, Failure failure) {
    final message = switch (failure) {
      ServerFailure(msg: var m) => 'Error del servidor: $m',
      NetworkFailure(msg: var m) => 'Error de red: $m',
      CacheFailure(msg: var m) => 'Error de caché: $m',
    };
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
```

---

## 🔐 6. Seguridad y configuraciones

### Variables de entorno
```dart
// ✅ CORRECTO - Configuración externalizada
class AppConfig {
  static String get apiUrl => const String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api.example.com',
  );
  
  static String get apiKey => const String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );
}
```

### Almacenamiento seguro
```dart
// ✅ CORRECTO - Usar flutter_secure_storage para datos sensibles
class SecureStorage {
  final FlutterSecureStorage _storage;
  
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
```

---

## ⚡ 7. Rendimiento

### Evitar rebuilds innecesarios
```dart
// ✅ CORRECTO - Usar const widgets y selectores
class MyWidget extends StatelessWidget {
  const MyWidget({super.key}); // ← Const constructor
  
  @override
  Widget build(BuildContext context) {
    return const OtherWidget(); // ← Const child
  }
}

// ✅ CORRECTO - Riverpod select para evitar rebuilds
final userNameProvider = Provider<String>((ref) {
  return ref.watch(userProvider).select((user) => user.name);
});
```

### Lazy loading
```dart
// ✅ CORRECTO - Cargar datos solo cuando se necesiten
class UserListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    return usersAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
      data: (users) => ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => Text(users[index].name),
      ),
    );
  }
}
```

### Optimizar listas
```dart
// ✅ CORRECTO - ListView.builder para listas largas
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
);

// ❌ INCORRECTO - Column para listas largas
Column(children: items.map((item) => ItemWidget(item: item)).toList());
```

---

## 🧪 8. Testing

### Estrategia de testing
```dart
// ✅ CORRECTO - Testear la capa Domain (la más valiosa)
void main() {
  group('GetUser', () {
    test('should return user when repository succeeds', () async {
      // Arrange
      final repository = MockUserRepository();
      final useCase = GetUser(repository);
      when(() => repository.getUser('1'))
          .thenAnswer((_) async => User(id: '1', name: 'Test'));
      
      // Act
      final result = await useCase('1');
      
      // Assert
      expect(result, isA<User>());
      expect(result.name, 'Test');
    });
    
    test('should throw when repository fails', () async {
      // Arrange
      final repository = MockUserRepository();
      final useCase = GetUser(repository);
      when(() => repository.getUser('1')).thenThrow(Exception('DB error'));
      
      // Act & Assert
      expect(() => useCase('1'), throwsException);
    });
  });
}

// ✅ CORRECTO - Testear widgets
void main() {
  testWidgets('UserProfilePage shows user name', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: UserProfilePage(user: User(id: '1', name: 'Juan')),
      ),
    );
    
    expect(find.text('Juan'), findsOneWidget);
  });
}
```

### Cobertura mínima recomendada
| Capa | Cobertura | Prioridad |
|------|-----------|-----------|
| **Domain** (UseCases, Entities) | 90%+ | 🔴 Alta |
| **Data** (Models, Repositories) | 80%+ | 🟡 Media |
| **Presentation** (Notifiers, Widgets) | 70%+ | 🟢 Baja |

---

## 🎯 9. Principios SOLID aplicados a Flutter

### S - Single Responsibility
```dart
// ✅ CORRECTO - Cada clase tiene una responsabilidad
class UserRepositoryImpl implements UserRepository { /* Solo datos */ }
class GetUser { /* Solo obtener usuario */ }
class UserNotifier { /* Solo gestionar estado de UI */ }
class UserProfilePage { /* Solo renderizar */ }

// ❌ INCORRECTO - Todo mezclado
class UserEverything { /* datos + lógica + UI */ }
```

### O - Open/Closed
```dart
// ✅ CORRECTO - Abierto a extensión, cerrado a modificación
abstract class PaymentMethod {
  Future<void> pay(double amount);
}

class CreditCardPayment implements PaymentMethod { /* ... */ }
class PaypalPayment implements PaymentMethod { /* ... */ }
class CryptoPayment implements PaymentMethod { /* ... */ }
```

### L - Liskov Substitution
```dart
// ✅ CORRECTO - Subtipos pueden reemplazar a su base
void processPayment(PaymentMethod method) {
  method.pay(100); // Funciona con cualquier implementación
}
```

### I - Interface Segregation
```dart
// ✅ CORRECTO - Interfaces específicas
abstract class Readable { Future<User?> get(String id); }
abstract class Writable { Future<void> save(User user); }
abstract class Deletable { Future<void> delete(String id); }

// ❌ INCORRECTO - Interface gigante
abstract class UserRepository {
  Future<User> get(String id);
  Future<void> save(User user);
  Future<void> delete(String id);
  Future<void> update(User user);
  Future<List<User>> getAll();
  // ... más métodos
}
```

### D - Dependency Inversion
```dart
// ✅ CORRECTO - Depender de abstracciones, no de implementaciones
class GetUser {
  final UserRepository repository; // ← Depende de la abstracción
  GetUser({required this.repository}); // ← Inyección por constructor
}
```

---

## 📝 10. Convenciones de código

### Usar pattern matching (Dart 3+)
```dart
// ✅ CORRECTO - Switch expressions
String getStatusMessage(LoadState state) => switch (state) {
  LoadState.initial => 'Esperando...',
  LoadState.loading => 'Cargando...',
  LoadState.loaded => 'Completado',
  LoadState.error => 'Error',
};

// ✅ CORRECTO - Pattern matching en widgets
return switch (state) {
  UserInitial() => const SizedBox(),
  UserLoading() => const CircularProgressIndicator(),
  UserLoaded(:final user) => Text(user.name),
  UserError(:final message) => Text(message),
};
```

### Usar records (Dart 3+)
```dart
// ✅ CORRECTO - Records para retornos múltiples
(String, int) getUserInfo() => ('Juan', 25);

// ✅ CORRECTO - Records con nombre
({String name, int age}) getUserInfo() => (name: 'Juan', age: 25);
```

### Evitar `dynamic`
```dart
// ✅ CORRECTO - Tipado fuerte
List<User> getUsers() => []; // ← Retorna lista tipada

// ❌ INCORRECTO - Usar dynamic
List<dynamic> getUsers() => []; // ← Evitar
```

---

## 🚫 11. Anti-patrones comunes (checklist)

- [ ] ¿Widgets de más de 200 líneas? → Refactorizar
- [ ] ¿Llamadas HTTP en widgets? → Mover a Repository
- [ ] ¿Estado mutable compartido? → Usar Provider/Riverpod
- [ ] ¿Sin manejo de errores? → Añadir Failure classes
- [ ] ¿Código duplicado? → Extraer a métodos/widgets
- [ ] ¿Imports circulares? → Revisar arquitectura
- [ ] ¿Sin tests? → Empezar por Domain
- [ ] ¿Strings quemados? → Usar constantes
- [ ] ¿Sin análisis estático? → Ejecutar `dart analyze`

---

## 📚 Recursos

- [Dart Effective Style](https://dart.dev/effective-dart/style)
- [Flutter Best Practices](https://docs.flutter.dev/best-practices)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Dart 3 Patterns](https://dart.dev/language/patterns)
- [Solid Principles in Dart](https://medium.com/flutter-community/solid-principles-in-flutter)