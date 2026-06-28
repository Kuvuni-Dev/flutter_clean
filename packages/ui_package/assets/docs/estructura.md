# Estructura del proyecto

Un proyecto generado con Flutter Clean Generator sigue esta estructura:

```
mi_proyecto/
├── assets/
│   ├── images/              # Imágenes estáticas
│   ├── fonts/               # Fuentes personalizadas
│   └── icons/               # Iconos SVG/PNG
├── lib/
│   ├── main.dart            # Punto de entrada
│   ├── app/
│   │   └── app.dart         # Configuración del MaterialApp
│   ├── core/
│   │   ├── constants/       # Constantes globales
│   │   ├── errors/          # Clases de error/failure
│   │   ├── network/         # Cliente HTTP, conexión
│   │   ├── router/          # Sistema de rutas
│   │   ├── theme/           # Tema claro/oscuro
│   │   └── utils/           # Utilidades (validadores, etc.)
│   └── features/            # Features autocontenidas
│       └── bio/             # Ejemplo: feature "bio"
│           ├── data/
│           ├── domain/
│           └── presentation/
└── test/
```

## Core

La capa `core/` contiene código compartido por todas las features:

| Carpeta | Propósito |
|---------|-----------|
| `constants/` | Constantes como URLs, timeouts, nombres de app |
| `errors/` | Clases `Failure` para manejo de errores |
| `network/` | Información de conectividad, cliente HTTP |
| `router/` | Sistema de rutas nombradas (`RouteNames`, `AppRouter`) |
| `theme/` | Temas claro/oscuro con Material 3 |
| `utils/` | Validadores y utilidades generales |

## App

`lib/app/app.dart` es el widget raíz que configura:

- Título de la aplicación
- Tema claro y oscuro
- Sistema de rutas (`initialRoute` + `onGenerateRoute`)
- Modo de tema (system por defecto)

## Features

Cada feature dentro de `lib/features/` es **autocontenida** con sus propias capas: