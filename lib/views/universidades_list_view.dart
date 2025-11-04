import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/universidad_model.dart';
import '../services/universidad_service.dart';

class UniversidadesListView extends StatelessWidget {
  const UniversidadesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final universidadService = UniversidadService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Universidades'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<List<UniversidadModel>>(
        stream: universidadService.obtenerUniversidades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar universidades',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay universidades registradas',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Presiona el botón + para agregar una nueva',
                  ),
                ],
              ),
            );
          }

          final universidades = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: universidades.length,
            itemBuilder: (context, index) {
              final universidad = universidades[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.school,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    universidad.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('NIT: ${universidad.nit}'),
                      Text('Dirección: ${universidad.direccion}'),
                      Text('Teléfono: ${universidad.telefono}'),
                      if (universidad.paginaWeb.isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            // Aquí podrías abrir la URL en un navegador
                          },
                          icon: const Icon(Icons.link, size: 16),
                          label: Text(
                            universidad.paginaWeb,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    if (universidad.id != null) {
                      context.push('/universidades/editar/${universidad.id}');
                    }
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.blue,
                        tooltip: 'Editar',
                        onPressed: () {
                          if (universidad.id != null) {
                            context.push('/universidades/editar/${universidad.id}');
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        tooltip: 'Eliminar',
                        onPressed: () async {
                          final confirmar = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmar eliminación'),
                              content: Text(
                                '¿Estás seguro de eliminar ${universidad.nombre}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            ),
                          );

                          if (confirmar == true && universidad.id != null) {
                            try {
                              await universidadService
                                  .eliminarUniversidad(universidad.id!);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Universidad eliminada'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/universidades/nueva');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
