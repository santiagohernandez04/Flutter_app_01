import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/local_storage_service.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class EvidenceView extends StatefulWidget {
  const EvidenceView({super.key});

  @override
  State<EvidenceView> createState() => _EvidenceViewState();
}

class _EvidenceViewState extends State<EvidenceView> {
  Map<String, dynamic>? _sessionInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessionInfo();
  }

  Future<void> _loadSessionInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final sessionInfo = await LocalStorageService.getSessionInfo();
      setState(() {
        _sessionInfo = sessionInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar datos: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService.logout();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesión cerrada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/login');
      }
    }
  }

  Widget _buildUserInfoCard() {
    final user = _sessionInfo?['user'] as UserModel?;
    
    if (user == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(Icons.person_off, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text('No hay información de usuario disponible'),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Información del Usuario',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('ID', user.id.toString()),
            _buildInfoRow('Nombre', user.name),
            _buildInfoRow('Email', user.email),
            if (user.phone != null) _buildInfoRow('Teléfono', user.phone!),
            if (user.role != null) _buildInfoRow('Rol', user.role!),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionInfoCard() {
    final hasToken = _sessionInfo?['hasToken'] as bool? ?? false;
    final tokenPresent = _sessionInfo?['tokenPresent'] as bool? ?? false;
    final accessToken = _sessionInfo?['accessToken'] as String?;
    final refreshToken = _sessionInfo?['refreshToken'] as String?;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasToken ? Icons.check_circle : Icons.cancel,
                  color: hasToken ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Estado de Sesión',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Token Presente',
              tokenPresent ? 'Sí' : 'No',
              valueColor: tokenPresent ? Colors.green : Colors.red,
            ),
            _buildInfoRow(
              'Sesión Válida',
              hasToken ? 'Sí' : 'No',
              valueColor: hasToken ? Colors.green : Colors.red,
            ),
            if (accessToken != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Access Token:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${accessToken.substring(0, 20)}...',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
            if (refreshToken != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Refresh Token:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${refreshToken.substring(0, 20)}...',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }


  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: valueColor != null ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evidencia de Almacenamiento'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _loadSessionInfo,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar datos',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título principal
                  Text(
                    'Datos Almacenados Localmente',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Información del usuario
                  _buildUserInfoCard(),
                  const SizedBox(height: 16),

                  // Estado de sesión
                  _buildSessionInfoCard(),
                  const SizedBox(height: 24),

                  // Botón para volver al home
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.home),
                      label: const Text('Volver al Home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón de cerrar sesión
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Cerrar Sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón para ir al login
                  SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/login'),
                      icon: const Icon(Icons.login),
                      label: const Text('Ir al Login'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
