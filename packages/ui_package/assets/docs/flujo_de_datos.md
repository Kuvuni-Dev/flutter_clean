# Flujo de datos

Clean Architecture sigue el principio de **Unidirectional Data Flow**: los datos fluyen en una dirección y las peticiones en la dirección opuesta.

## Dirección de las dependencias

```
UI (Widget)  →  Controller/Notifier  →  UseCase  →  Repository  →  DataSource
     ↑               ↑                    ↑             ↑               ↑
     └────── Los datos fluyen hacia arriba ────────────┘
     └── Las peticiones fluyen hacia abajo ────────────┘
```

## Capas y dependencias

Cada capa solo conoce a la **inmediatamente inferior**:

| Capa | Conoce a | No conoce |
|------|----------|-----------|
| **Presentation** (Widgets, Pages, Controllers) | Domain (UseCases) | Data, frameworks externos |
| **Domain** (Entities, UseCases, Repos abstractos) | Nada externo | Flutter, bases de datos, APIs |
| **Data** (Models, Repos impl, DataSources) | Domain (Entities, Repos abstractos) | Presentation |

## Ejemplo práctico

### 1. El usuario toca un botón (UI)
```dart
onPressed: () => notifier.loadBio(),
```

### 2. El Controller llama al UseCase
```dart
class BioNotifier extends ChangeNotifier {
  Future<void> loadBio() async {
    final instructor = await getInstructorInfo.call();
    // ...
  }
}
```

### 3. El UseCase delega en el Repository
```dart
class GetInstructorInfo {
  Future<Instructor> call() {
    return repository.getInstructorInfo();
  }
}
```

### 4. El Repository obtiene datos del DataSource
```dart
class BioRepositoryImpl implements BioRepository {
  @override
  Future<Instructor> getInstructorInfo() async {
    final model = await remoteDataSource.fetchInstructorInfo();
    return model.toEntity();
  }
}
```

### 5. El DataSource hace la llamada real (API, DB...)
```dart
class BioRemoteDataSource {
  Future<InstructorModel> fetchInstructorInfo() async {
    final response = await http.get(Uri.parse('...'));
    return InstructorModel.fromJson(response.data);
  }
}
```

## Beneficios de este flujo

- ✅ **Testabilidad**: Cada capa puede testearse de forma aislada
- ✅ **Flexibilidad**: Puedes cambiar la fuente de datos sin tocar la UI
- ✅ **Mantenibilidad**: El código es predecible y fácil de seguir
- ✅ **Separación**: Cada capa tiene una única responsabilidad