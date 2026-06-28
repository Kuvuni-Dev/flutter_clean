# Buenas prácticas

## Nombrado

### Archivos
- Usa **snake_case** para nombres de archivo: `mi_archivo.dart`
- Prefija según la capa: `auth_repository.dart`, `auth_model.dart`
- Una clase por archivo

### Clases
- Usa **PascalCase**: `AuthRepository`, `LoginUseCase`
- Sufija según el tipo: `AuthRepository`, `AuthModel`, `AuthPage`

### Métodos y variables
- Usa **camelCase**: `getUserById()`, `isLoading`
- Verbos para métodos: `loadData()`, `saveUser()`
- Nombres descriptivos > comentarios

## Organización

### Estructura de imports
```dart
// 1. Paquetes externos
import 'package:flutter/material.dart';

// 2. Paquetes del proyecto
import 'package:core/core.dart';

// 3. Imports relativos (misma feature)
import '../entities/user.dart';
```

### Separación de responsabilidades
- **Entities**: Solo datos, sin lógica ni dependencias
- **UseCases**: Una sola operación de negocio
- **Repositories**: Contrato abstracto de datos
- **Models**: Con `fromJson`/`toJson`, mapean a Entity
- **Controllers/Notifiers**: Gestionan estado de la UI
- **Widgets**: Solo renderizan, sin lógica de negocio

## Testing

### Capa Domain (la más fácil de testear)
```dart
void main() {
  test('GetCourses returns list of courses', () async {
    final repository = MockBioRepository();
    final useCase = GetCourses(repository: repository);
    
    when(() => repository.getCourses())
        .thenAnswer((_) async => [fakeCourse]);
    
    final result = await useCase();
    
    expect(result.length, 1);
  });
}
```

### Capa Data
- Testea que los modelos parsean correctamente JSON
- Testea que el repositorio impl mapea bien los modelos a entidades

### Capa Presentation
- Testea que el Notifier emite los estados correctos
- Testea que los widgets renderizan según el estado

## Evita

- ❌ Llamadas a APIs directamente desde widgets
- ❌ Lógica de negocio en el constructor de widgets
- ❌ Dependencias circulares entre features
- ❌ Importar capa Data desde Presentation
- ❌ Clases gigantes con múltiples responsabilidades