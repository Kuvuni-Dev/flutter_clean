# Patrones de diseño para Flutter

Guía práctica para elegir el patrón adecuado según el tipo de aplicación que estés desarrollando.

---

## Matriz de decisión

Usa esta tabla para elegir rápidamente qué patrón aplicar según tu proyecto:

| Si tu app es... | Usa este patrón | ¿Por qué? |
|---|---|---|
| **App pequeña / prototipo** (`< 5 pantallas`) | `ChangeNotifier` + `Clean Architecture` | Simplicidad, sin dependencias externas, rápido de desarrollar |
| **App mediana** (`5-15 pantallas`) | `Cubit` + `Clean Architecture` | Estado predecible, fácil de testear, buena separación |
| **App grande / empresarial** (`> 15 pantallas`) | `Bloc` + `Clean Architecture` | Máximo control de estado, eventos explícitos, ideal para equipos |
| **App en tiempo real** (chat, notificaciones) | `Bloc` + `Streams` | Los streams encajan naturalmente con flujos de datos en tiempo real |
| **App con muchos formularios** | `ChangeNotifier` + `Formz` | Validación declarativa sin complejidad adicional |
| **App multi-plataforma** (web + mobile) | `GoRouter` + `Responsive` | Rutas declarativas que funcionan igual en todas las plataformas |
| **App con autenticación** | `Repository` + `Cubit` | Cubit maneja bien los estados (autenticado/no autenticado/cargando) |
| **App offline-first** | `Repository` + `Data Source` + `Connectivity` | El patrón Repository permite cachear y sincronizar datos |

---

## Catálogo de patrones

### 1. Patrones de estado (State Management)

| Patrón | Dependencias | Complejidad | Testing | Uso recomendado |
|--------|-------------|-------------|---------|-----------------|
| **ChangeNotifier** | Ninguna (nativo Flutter) | ⭐ Baja | ⭐⭐⭐ Alto | Apps pequeñas, prototipos |
| **ValueNotifier** | Ninguna (nativo Flutter) | ⭐ Baja | ⭐⭐⭐ Alto | Valores simples, temas |
| **Cubit** | `flutter_bloc` | ⭐⭐ Media | ⭐⭐⭐ Alto | Apps medianas |
| **Bloc** | `flutter_bloc` | ⭐⭐⭐ Alta | ⭐⭐⭐ Alto | Apps grandes, equipos |
| **Riverpod** | `flutter_riverpod` | ⭐⭐ Media | ⭐⭐⭐ Alto | Apps modernas, compile-safe |

### 2. Patrones de arquitectura

#### Clean Architecture (Recomendado)
```
Features → Domain → Data → Presentation
```
**Ventajas:** Máxima separación, testeable, mantenible  
**Desventajas:** Más archivos, curva de aprendizaje  
**Cuándo usarlo:** Siempre que puedas. Es el estándar para apps profesionales.

#### MVC (Model-View-Controller)
```
Model ← Controller → View
```
**Ventajas:** Simple, conocido  
**Desventajas:** El Controller tiende a crecer mucho  
**Cuándo usarlo:** Prototipos muy rápidos, apps de < 3 pantallas

#### MVVM (Model-View-ViewModel)
```
Model → ViewModel → View
     ↑________________|
```
**Ventajas:** Buena separación, el ViewModel no conoce la UI  
**Desventajas:** Puede generar mucho boilerplate  
**Cuándo usarlo:** Apps con bindings complejos, formularios

### 3. Patrones de datos

#### Repository
```dart
abstract class UserRepository {
  Future<User> getUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  final UserLocalDataSource local;
  
  Future<User> getUser(String id) async {
    try {
      return await remote.getUser(id);
    } catch (e) {
      return await local.getUser(id); // fallback a cache
    }
  }
}
```
**Cuándo usarlo:** Siempre. Oculta la fuente de datos y facilita el testing.

#### Data Source
- **RemoteDataSource:** Llamadas a API, Firebase, GraphQL
- **LocalDataSource:** SQLite, SharedPreferences, archivos

**Cuándo usarlo:** Cuando necesites múltiples fuentes de datos o estrategias de caché.

### 4. Patrones de inyección de dependencias

| Patrón | Descripción | Cuándo usarlo |
|--------|-------------|---------------|
| **Manual DI** | Pasar dependencias por constructor | Apps pequeñas, aprendizaje |
| **GetIt** | Service locator global | Apps medianas, migraciones |
| **Riverpod** | Providers nativos | Apps nuevas con Riverpod |
| **Injectable** | Generación de código con GetIt | Apps grandes, muchos servicios |

### 5. Patrones de navegación

| Patrón | Descripción | Cuándo usarlo |
|--------|-------------|---------------|
| **Navigator 1.0** (onGenerateRoute) | Rutas nombradas básicas | Apps pequeñas, control total |
| **GoRouter** | Rutas declarativas, deep links | Apps medianas/grandes, web |
| **AutoRoute** | Generación de código para rutas | Apps grandes con muchas rutas |

---

## Anti-patrones a evitar

| Anti-patrón | Problema | Solución |
|-------------|----------|----------|
| **God Class** | Una clase lo hace todo | Separar en capas (Clean Architecture) |
| **Spaghetti Code** | Lógica mezclada en widgets | Usar Controller/Notifier separado |
| **Golden Hammer** | Usar el mismo patrón para todo | Elegir según el contexto (ver matriz) |
| **Premature Over-engineering** | Demasiada abstracción para apps pequeñas | Empezar simple, refactorizar después |
| **Circular Dependencies** | Feature A importa Feature B y viceversa | Usar capa Core compartida |

---

## Guía rápida: ¿Qué patrón elegir?

### 1. Evalúa tu app
```
¿Cuántas pantallas tiene?     → < 5 → ChangeNotifier
                               → 5-15 → Cubit
                               → > 15 → Bloc

¿Tiene tiempo real?           → Sí → Bloc + Streams
                               → No → Cubit o ChangeNotifier

¿Es tu primer proyecto?       → Sí → ChangeNotifier (aprende lo básico)
                               → No → Cubit (buen equilibrio)

¿Trabajas en equipo?          → Sí → Bloc (eventos explícitos)
                               → No → El que más te guste
```

### 2. Aplica Clean Architecture siempre
Independientemente del patrón de estado que elijas, **siempre usa Clean Architecture** para la estructura del proyecto. Esto te dará:
- Una base sólida y escalable
- Facilidad para cambiar de patrón de estado después
- Código que otros desarrolladores entenderán rápidamente

### 3. Refactoriza cuando sea necesario
No necesitas empezar con el patrón "perfecto". Empieza simple y refactoriza cuando:
- El archivo supere las 200 líneas
- Un widget tenga más de 3 estados
- Necesites añadir una funcionalidad que cruce varias capas
- Otro desarrollador no entienda el código