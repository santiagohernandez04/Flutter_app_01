# Taller 1 - Flutter + Widgets + Git Flow

## Descripción
Aplicación Flutter simple que demuestra el uso de `StatefulWidget` y `setState()`.

## Datos del Estudiante
- **Nombre**: Santiago Hernandez Rosales
- **Rama**: `feature/taller1`

## Características Implementadas ✅

### Requisitos Obligatorios
- **StatefulWidget**: `HomePage` con estado
- **setState()**: Cambia título del AppBar
- **AppBar variable**: "Hola, Flutter" ↔ "¡Título cambiado!"
- **Text centrado**: Nombre del estudiante
- **Imágenes en Row**
- **Botón con setState()**: Cambia título + SnackBar
- **SnackBar**: "Título actualizado"

### Widgets Adicionales
- **Container**: Contenedor con texto centrado
- **ListView**: Lista simple con iconos
- **OutlinedButton**: Botón adicional

## Pasos para Ejecutar

1. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

2. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

## Funcionalidades

- **Cambio de título**: Botón azul que alterna el título del AppBar
- **Imágenes**: Una de red y una local en contenedores
- **Lista simple**: 3 elementos con iconos de colores
- **Container**: Caja con texto explicativo
- **SnackBars**: Mensajes al presionar botones


### Evidencias

Pantalla inicial

<img width="543" height="976" alt="image" src="https://github.com/user-attachments/assets/738d1b31-7688-4165-a017-fcca8e92ae8a" />

Pantalla despues de oprimir el boton

<img width="544" height="987" alt="image" src="https://github.com/user-attachments/assets/b57a51ae-974d-4d89-9b77-e99da7c3b698" />


---

# Taller 2 - Navegación, widgets y ciclo de vida en Flutter

## Descripción
Desarrollar una aplicación en Flutter que implemente navegación con go_router, uso de widgets intermedios y evidencie el ciclo de vida de un StatefulWidget. El objetivo es comprender go, push y replace, el paso de parámetros entre pantallas y el momento de ejecución de los métodos del ciclo de vida.

**Rama**: `feature/taller_paso_parametros`

## Características Implementadas 

### 1. Navegación y Paso de Parámetros
- **go_router**: Implementación de navegación con go_router
- **Paso de parámetros**: Envío de datos entre pantallas principales y secundarias
- **Tipos de navegación**:
  - `go()`: Navegación que reemplaza la pila de navegación
  - `push()`: Navegación que agrega a la pila (botón atrás funcional)
  - `replace()`: Navegación que reemplaza la pantalla actual

### 2. Widgets Implementados
- **GridView**: Lista de elementos en formato de cuadrícula
- **TabBar**: Navegación por pestañas dentro de una pantalla
- **Card**: Widget personalizado para mostrar información de estudiantes

### 3. Ciclo de Vida de StatefulWidget
- **initState()**: Inicialización del estado del widget
- **didChangeDependencies()**: Se ejecuta cuando las dependencias cambian
- **build()**: Construcción del árbol de widgets
- **setState()**: Actualización del estado del widget
- **dispose()**: Limpieza de recursos al destruir el widget

## Arquitectura y Navegación

### Rutas Implementadas
- **`/`**: Pantalla principal (HomeView)
- **`/details/:id`**: Pantalla de detalles con parámetro dinámico

### Envío de Parámetros
```dart
// Navegación con parámetros usando go_router
context.go('/details/${student.id}');
context.push('/details/${student.id}');
context.go('/details/${student.id}');
```

## Widgets Utilizados y Justificación

### GridView
- **Propósito**: Mostrar una lista de estudiantes en formato de cuadrícula
- **Justificación**: Permite visualizar múltiples elementos de manera organizada y eficiente

### TabBar
- **Propósito**: Navegación por secciones dentro de la pantalla principal
- **Justificación**: Mejora la experiencia de usuario al organizar contenido en categorías

### Card (Widget Personalizado)
- **Propósito**: Mostrar información de cada estudiante de manera estructurada
- **Justificación**: Proporciona una interfaz consistente y reutilizable para mostrar datos

## Evidencias del Ciclo de Vida

### Métodos Registrados en Consola
- **initState()**: Se ejecuta una sola vez al crear el widget
- **didChangeDependencies()**: Se ejecuta cuando las dependencias del widget cambian
- **build()**: Se ejecuta cada vez que el widget necesita reconstruirse
- **setState()**: Se ejecuta cuando se actualiza el estado del widget
- **dispose()**: Se ejecuta cuando el widget se elimina de la pila de navegación


---

# Taller 3 - Segundo plano, asincronía y servicios en Flutter

## Descripción
Aplicación Flutter que demuestra asincronía con Future, async/await, uso de Timer (cronómetro) y empleo de Isolate para tareas pesadas, evitando bloquear la UI.

**Rama**: `feature/taller_segundo_plano`

## Características Implementadas

### 1. Asincronía con Future / async / await
- **Servicio simulado**: `FakeApiService` con `Future.delayed` (2-3 segundos)
- **Estados en pantalla**: Cargando… / Éxito / Error
- **Logs en consola**: Orden de ejecución (antes, durante y después)
- **Manejo de errores**: 20% de probabilidad de error simulado

### 2. Timer - Cronómetro
- **Controles**: Iniciar / Pausar / Reanudar / Reiniciar
- **Actualización**: Cada 1 segundo
- **Formato**: HH:MM:SS
- **Limpieza**: Cancelar timer al pausar o salir de la vista (`dispose()`)

### 3. Isolate para tarea pesada
- **Función CPU-bound**: Suma de cuadrados (1 millón de iteraciones)
- **Ejecución**: `Isolate.spawn` para evitar bloquear la UI
- **Comunicación**: Mensajes entre Isolate y UI principal
- **Progreso**: Actualización en tiempo real del progreso
- **Resultado**: Mostrar resultado final en la UI

## Arquitectura y Navegación

### Rutas Implementadas
- **`/`**: Pantalla principal con navegación a todas las funcionalidades
- **`/async`**: Vista de asincronía con Future/async-await
- **`/timer`**: Vista del cronómetro con Timer
- **`/isolate`**: Vista de tarea pesada con Isolate

### Servicios
- **`FakeApiService`**: Servicio simulado con delays y errores aleatorios

## Cuándo usar cada herramienta

### Future / async / await
- **Cuándo usar**: Operaciones de red, base de datos, archivos
- **Ventajas**: Código más legible, manejo de errores simplificado
- **Ejemplo**: Cargar datos de una API, leer archivos

### Timer
- **Cuándo usar**: Actualizaciones periódicas, cronómetros, animaciones
- **Ventajas**: Control preciso del tiempo, cancelación fácil
- **Ejemplo**: Cronómetros, contadores, actualizaciones de UI

### Isolate
- **Cuándo usar**: Tareas CPU-intensivas que pueden bloquear la UI
- **Ventajas**: Paralelismo real, UI siempre responsiva
- **Ejemplo**: Procesamiento de imágenes, cálculos matemáticos complejos

---

# Taller 4 - Peticiones HTTP y Consumo de API Pública en Flutter

## Descripción
Aplicación Flutter que consume datos desde la API pública de Giphy usando el paquete `http`, con navegación mediante `go_router`. Implementa manejo de estados (cargando/éxito/error), manejo de errores y buenas prácticas de separación por servicios.

**Rama**: `feature/taller_http`

## API Utilizada: Giphy

### Endpoint Principal
```
https://api.giphy.com/v1/gifs/search?api_key={API_KEY}&q={query}&limit={limit}
```

### Configuración del API Key

El API key se gestiona mediante variables de entorno usando un archivo `.env`:

1. **Crear archivo `.env`** en la raíz del proyecto:
   ```bash
   # API Key de Giphy
   GIPHY_API_KEY=tu_api_key_aqui
   ```

2. **Obtener API Key**:
   - Visite: https://developers.giphy.com/
   - Cree una cuenta o inicia sesión
   - Cree una nueva app para obtener su API key


### Modelos Implementados

#### `GifModel`
Representa un GIF individual con sus propiedades:
- `id`: Identificador único del GIF
- `title`: Título o descripción del GIF
- `url`: URL del GIF en Giphy
- `rating`: Clasificación de contenido (G, PG, PG-13, R)
- `images`: Objeto con diferentes resoluciones de imágenes

#### `GifImages` y `GifImageData`
Maneja las diferentes resoluciones disponibles del GIF:
- `original`: Imagen original de alta resolución
- `fixedHeight`: Imagen con altura fija (200px)
- `fixedWidth`: Imagen con ancho fijo (200px)
- `downsized`: Versión reducida

#### `GiphyResponse`
Modelo para la respuesta completa de la API:
- `data`: Lista de GIFs
- `pagination`: Información de paginación

### Servicios

#### `GiphyService`
Servicio encargado de realizar las peticiones HTTP a la API de Giphy.

**Métodos implementados**:

1. **`searchGifs()`**
   - Busca GIFs según un término de búsqueda
   - Parámetros: `query` (requerido), `limit` (por defecto 10), `offset`
   - Manejo de errores: códigos 429 (límite de peticiones), 500+ (error del servidor)

2. **`getTrendingGifs()`**
   - Obtiene GIFs trending (populares del momento)
   - Parámetros: `limit` (por defecto 10), `offset`
   - Sin necesidad de término de búsqueda

## Rutas Implementadas con go_router

### Configuración de Rutas

```dart
GoRoute(
  path: '/giphy',
  name: 'giphy',
  builder: (context, state) => const GiphyListView(),
)
```
