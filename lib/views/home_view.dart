import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/navigation_button.dart';
import '../widgets/grid_item_card.dart';
import '../widgets/student_info_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Evidencia del ciclo de vida
  @override
  void initState() {
    super.initState();
    print('HomeView - initState(): Se ejecuta cuando el widget se inicializa por primera vez');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('HomeView - didChangeDependencies(): Se ejecuta cuando las dependencias del widget cambian');
  }

  @override
  Widget build(BuildContext context) {
    print('HomeView - build(): Se ejecuta cada vez que el widget necesita ser reconstruido');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aprendiendo Flutter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.speed, color: Colors.deepOrange),
            onPressed: () => context.push('/isolate'),
            tooltip: 'Ir a Isolate',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StudentInfoCard(),
            const SizedBox(height: 20),
            const _NavigationSection(),
            const SizedBox(height: 20),
            const _Taller3Section(),
            const SizedBox(height: 20),
            const _Taller4Section(),
            const SizedBox(height: 20),
            const _GridViewSection(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('HomeView - dispose(): Se ejecuta cuando el widget se destruye');
    super.dispose();
  }
}

class _NavigationSection extends StatelessWidget {
  const _NavigationSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona una opción para navegar:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        NavigationButton(
          title: 'Usar GO (reemplaza stack)',
          icon: Icons.arrow_forward,
          color: Colors.blue,
          onPressed: () => context.go('/details/go/GO Navigation'),
        ),
        NavigationButton(
          title: 'Usar PUSH (agrega al stack)',
          icon: Icons.add,
          color: Colors.green,
          onPressed: () => context.push('/details/push/PUSH Navigation'),
        ),
        NavigationButton(
          title: 'Usar REPLACE (reemplaza actual)',
          icon: Icons.swap_horiz,
          color: Colors.orange,
          onPressed: () => context.pushReplacement('/details/replace/REPLACE Navigation'),
        ),
      ],
    );
  }
}

class _Taller3Section extends StatelessWidget {
  const _Taller3Section();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Taller 3 - Segundo plano, asincronía y servicios:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        NavigationButton(
          title: 'Ir a Asincronía (Future / async-await)',
          icon: Icons.cloud_download,
          color: Colors.indigo,
          onPressed: () => context.push('/async'),
        ),
        const SizedBox(height: 8),
        NavigationButton(
          title: 'Ir al Cronómetro (Timer)',
          icon: Icons.timer,
          color: Colors.deepPurple,
          onPressed: () => context.push('/timer'),
        ),
        const SizedBox(height: 8),
        NavigationButton(
          title: 'Ir a Isolate (Tarea Pesada)',
          icon: Icons.speed,
          color: Colors.deepOrange,
          onPressed: () => context.push('/isolate'),
        ),
      ],
    );
  }
}

class _Taller4Section extends StatelessWidget {
  const _Taller4Section();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Taller 4 - Peticiones HTTP y Consumo de API:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        NavigationButton(
          title: 'Ir a Giphy Browser (API)',
          icon: Icons.gif_box,
          color: Colors.pinkAccent,
          onPressed: () => context.push('/giphy'),
        ),
      ],
    );
  }
}

class _GridViewSection extends StatelessWidget {
  const _GridViewSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GridView de elementos:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 300, // Altura fija para el GridView
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemCount: _gridItems.length,
            itemBuilder: (context, index) {
              final item = _gridItems[index];
              return GridItemCard(
                title: item['title'] as String,
                icon: item['icon'] as IconData,
                color: item['color'] as Color,
              );
            },
          ),
        ),
      ],
    );
  }
}

// Datos del GridView
const List<Map<String, dynamic>> _gridItems = [
  {'title': 'Flutter', 'icon': Icons.flutter_dash, 'color': Colors.blue},
  {'title': 'Dart', 'icon': Icons.code, 'color': Colors.green},
  {'title': 'Go Router', 'icon': Icons.route, 'color': Colors.purple},
  {'title': 'Widgets', 'icon': Icons.widgets, 'color': Colors.orange},
  {'title': 'Navigation', 'icon': Icons.navigation, 'color': Colors.red},
  {'title': 'Lifecycle', 'icon': Icons.refresh, 'color': Colors.teal},
];
