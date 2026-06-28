# Introducción a Clean Architecture

Clean Architecture es un patrón de diseño de software propuesto por **Robert C. Martin (Uncle Bob)** que busca separar el código en capas con responsabilidades bien definidas.

## Principios fundamentales

### 1. Independencia del framework
El código de negocio no debe depender de frameworks externos. Los frameworks son herramientas, no la base de tu aplicación.

### 2. Testeabilidad
Las reglas de negocio pueden ser testeadas sin necesidad de UI, base de datos o servidores externos.

### 3. Independencia de la UI
La interfaz de usuario puede cambiar sin afectar las reglas de negocio. Puedes reemplazar Flutter por otra tecnología sin tocar el core.

### 4. Independencia de la base de datos
Puedes cambiar de SQLite a Firebase o a una API REST sin modificar la lógica de negocio.

### 5. Independencia de agentes externos
Las reglas de negocio no conocen nada sobre el mundo exterior.

## Principios SOLID

| Principio | Descripción |
|-----------|-------------|
| **S** - Single Responsibility | Una clase debe tener una sola razón para cambiar |
| **O** - Open/Closed | Abierto a extensión, cerrado a modificación |
| **L** - Liskov Substitution | Las subclases deben poder reemplazar a sus padres |
| **I** - Interface Segregation | Mejor interfaces específicas que una general |
| **D** - Dependency Inversion | Depende de abstracciones, no de implementaciones |

## Regla de dependencia

La regla fundamental de Clean Architecture: **las dependencias deben apuntar hacia adentro**, es decir, las capas externas (UI, frameworks) dependen de las capas internas (reglas de negocio), nunca al revés.

## Beneficios

- ✅ Código más mantenible y escalable
- ✅ Separación clara de responsabilidades
- ✅ Fácil de testear cada capa por separado
- ✅ Menor acoplamiento entre componentes
- ✅ Mayor flexibilidad para cambios futuros