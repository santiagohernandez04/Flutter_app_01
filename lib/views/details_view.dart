import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/info_card.dart';
import '../widgets/lifecycle_item.dart';
import '../widgets/grid_item_card.dart';

class DetailsView extends StatefulWidget {
  final String navigationType;
  final String parameter;

  const DetailsView({
    super.key,
    required this.navigationType,
    required this.parameter,
  });

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _counter = 0;

  // Evidencia del ciclo de vida
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    print('DetailsView - initState(): Se ejecuta cuando el widget se inicializa por primera vez');
    print('Parámetros recibidos - Tipo: ${widget.navigationType}, Parámetro: ${widget.parameter}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('DetailsView - didChangeDependencies(): Se ejecuta cuando las dependencias del widget cambian');
  }

  @override
  Widget build(BuildContext context) {
    print('DetailsView - build(): Se ejecuta cada vez que el widget necesita ser reconstruido');
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla: ${widget.navigationType}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Información'),
            Tab(icon: Icon(Icons.widgets), text: 'Widgets'),
            Tab(icon: Icon(Icons.settings), text: 'Configuración'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _InfoTab(navigationType: widget.navigationType, parameter: widget.parameter),
          const _WidgetsTab(),
          _ConfigTab(counter: _counter, onCounterChanged: _updateCounter),
        ],
      ),
    );
  }

  void _updateCounter(int newValue) {
    setState(() {
      _counter = newValue;
      print('DetailsView - setState(): Se ejecuta cuando se actualiza el estado del widget');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    print('DetailsView - dispose(): Se ejecuta cuando el widget se destruye');
    super.dispose();
  }
}

class _InfoTab extends StatelessWidget {
  final String navigationType;
  final String parameter;

  const _InfoTab({
    required this.navigationType,
    required this.parameter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoCard(
            title: 'Información de Navegación',
            color: Colors.blue,
            items: [
              {'label': 'Tipo de navegación:', 'value': navigationType},
              {'label': 'Parámetro recibido:', 'value': parameter},
              {'label': 'Comportamiento del botón atrás:', 'value': _getBackButtonBehavior()},
            ],
          ),
          const SizedBox(height: 20),
          InfoCard(
            title: 'Ciclo de Vida del Widget',
            color: Colors.green,
            items: [
              {'label': 'Revisa la consola para ver los mensajes de:', 'value': ''},
            ],
          ),
          const SizedBox(height: 12),
          const LifecycleItem(
            method: 'initState()',
            description: 'Inicialización del widget',
          ),
          const LifecycleItem(
            method: 'didChangeDependencies()',
            description: 'Cambio de dependencias',
          ),
          const LifecycleItem(
            method: 'build()',
            description: 'Reconstrucción del widget',
          ),
          const LifecycleItem(
            method: 'setState()',
            description: 'Actualización de estado',
          ),
          const LifecycleItem(
            method: 'dispose()',
            description: 'Destrucción del widget',
          ),
        ],
      ),
    );
  }

  String _getBackButtonBehavior() {
    switch (navigationType) {
      case 'GO':
        return 'Regresa a la pantalla anterior (reemplaza stack)';
      case 'PUSH':
        return 'Regresa a la pantalla anterior (mantiene stack)';
      case 'REPLACE':
        return 'No regresa (reemplaza la pantalla actual)';
      default:
        return 'Comportamiento por defecto';
    }
  }
}

class _WidgetsTab extends StatelessWidget {
  const _WidgetsTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Widgets Implementados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                GridItemCard(
                  title: 'TabBar',
                  icon: Icons.tab,
                  color: Colors.blue,
                ),
                GridItemCard(
                  title: 'GridView',
                  icon: Icons.grid_view,
                  color: Colors.green,
                ),
                GridItemCard(
                  title: 'Card',
                  icon: Icons.credit_card,
                  color: Colors.orange,
                ),
                GridItemCard(
                  title: 'ElevatedButton',
                  icon: Icons.touch_app,
                  color: Colors.purple,
                ),
                GridItemCard(
                  title: 'TextField',
                  icon: Icons.edit,
                  color: Colors.red,
                ),
                GridItemCard(
                  title: 'Icon',
                  icon: Icons.star,
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigTab extends StatelessWidget {
  final int counter;
  final Function(int) onCounterChanged;

  const _ConfigTab({
    required this.counter,
    required this.onCounterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configuración y Estado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'Contador (Evidencia de setState)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$counter',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.redAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => onCounterChanged(counter - 1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.remove, size: 20),
                          label: const Text(
                            'Decrementar',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.green, Colors.lightGreen],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => onCounterChanged(counter + 1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text(
                            'Incrementar',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Campo de Texto (Tercer Widget)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Escribe algo aquí',
                      hintText: 'Este es un TextField personalizado',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Este TextField demuestra el uso de widgets de entrada de datos.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
