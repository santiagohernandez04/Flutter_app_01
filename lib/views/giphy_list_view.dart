import 'package:flutter/material.dart';
import '../models/gif_model.dart';
import '../services/giphy_service.dart';

/// Vista principal que muestra un listado de GIFs desde la API de Giphy
class GiphyListView extends StatefulWidget {
  const GiphyListView({super.key});

  @override
  State<GiphyListView> createState() => _GiphyListViewState();
}

class _GiphyListViewState extends State<GiphyListView> {
  final GiphyService _giphyService = GiphyService();
  final TextEditingController _searchController = TextEditingController();
  
  List<GifModel> _gifs = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _currentQuery = 'flutter'; // Búsqueda inicial

  @override
  void initState() {
    super.initState();
    // Cargar GIFs iniciales
    _loadGifs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Carga los GIFs desde la API
  Future<void> _loadGifs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final gifs = await _giphyService.searchGifs(
        query: _currentQuery,
        limit: 10,
      );
      
      setState(() {
        _gifs = gifs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      
      // Mostrar mensaje de error al usuario
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  /// Busca GIFs según el término ingresado
  void _searchGifs() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _currentQuery = query;
      });
      _loadGifs();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un término de búsqueda'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Carga GIFs trending
  Future<void> _loadTrendingGifs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _searchController.clear();
    });

    try {
      final gifs = await _giphyService.getTrendingGifs(limit: 10);
      
      setState(() {
        _gifs = gifs;
        _currentQuery = 'Trending';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giphy Browser'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.trending_up),
            tooltip: 'Ver GIFs trending',
            onPressed: _loadTrendingGifs,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar GIFs...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                    ),
                    onSubmitted: (_) => _searchGifs(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: _searchGifs,
                  ),
                ),
              ],
            ),
          ),

          // Indicador de búsqueda actual
          if (_currentQuery.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.grey[200],
              child: Text(
                'Mostrando resultados para: $_currentQuery',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

          // Contenido principal
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  /// Construye el contenido principal según el estado
  Widget _buildContent() {
    // Estado de carga
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Cargando GIFs...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Estado de error
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                '¡Oops! Algo salió mal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadGifs,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    // Sin resultados
    if (_gifs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No se encontraron GIFs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Intenta con otro término de búsqueda',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadTrendingGifs,
              child: const Text('Ver GIFs Trending'),
            ),
          ],
        ),
      );
    }

    // Lista de GIFs
    return RefreshIndicator(
      onRefresh: _loadGifs,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _gifs.length,
        itemBuilder: (context, index) {
          final gif = _gifs[index];
          return _GifCard(gif: gif);
        },
      ),
    );
  }
}

/// Widget de tarjeta para mostrar un GIF en el listado
class _GifCard extends StatelessWidget {
  final GifModel gif;

  const _GifCard({
    required this.gif,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del GIF
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                gif.images.fixedHeight?.url ?? gif.images.original.url,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            // Información del GIF
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gif.title.isEmpty ? 'Sin título' : gif.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          gif.rating.toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: _getRatingColor(gif.rating),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  /// Retorna un color según el rating del GIF
  Color _getRatingColor(String rating) {
    switch (rating.toLowerCase()) {
      case 'g':
        return Colors.green[100]!;
      case 'pg':
        return Colors.blue[100]!;
      case 'pg-13':
        return Colors.orange[100]!;
      case 'r':
        return Colors.red[100]!;
      default:
        return Colors.grey[100]!;
    }
  }
}

