# ⚙️ CLI — flutter_clean

Esta sección explica cómo usar la herramienta de línea de comandos `flutter_clean` incluida en este monorepo para generar proyectos y features automáticamente.

---

## 📄 Documentos disponibles

> Coloca aquí tus archivos `.md` sobre la CLI. Algunos temas sugeridos:

| Archivo | Tema |
|--------|------|
| `instalacion.md` | Requisitos previos y cómo ejecutar la CLI desde el monorepo |
| `comando_create.md` | Uso del comando `create`: flags, ejemplos y resultado esperado |
| `comando_make_feature.md` | Uso del comando `make:feature`: flags, ejemplos y archivos generados |
| `estructura_generada.md` | Qué archivos y carpetas se generan y por qué |

---

## ⚡ Referencia rápida

```bash
# Ver ayuda general
dart run flutter_clean_cli:flutter_clean

# Crear un proyecto nuevo
dart run flutter_clean_cli:flutter_clean create --name mi_app --output ./proyectos

# Añadir una feature a un proyecto existente
dart run flutter_clean_cli:flutter_clean make:feature --name auth --project ./proyectos/mi_app
```

---

> 💡 Añade tus archivos `.md` en esta carpeta y actualiza la tabla de arriba.
