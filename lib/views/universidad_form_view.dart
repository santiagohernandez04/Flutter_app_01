import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/universidad_model.dart';
import '../services/universidad_service.dart';

class UniversidadFormView extends StatefulWidget {
  final String? universidadId;

  const UniversidadFormView({
    super.key,
    this.universidadId,
  });

  @override
  State<UniversidadFormView> createState() => _UniversidadFormViewState();
}

class _UniversidadFormViewState extends State<UniversidadFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nitController = TextEditingController();
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _paginaWebController = TextEditingController();
  final _universidadService = UniversidadService();
  bool _isLoading = false;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    if (widget.universidadId != null) {
      _cargarUniversidad();
    } else {
      _isLoadingData = false;
    }
  }

  Future<void> _cargarUniversidad() async {
    try {
      final universidad = await _universidadService.obtenerUniversidadPorId(
        widget.universidadId!,
      );
      if (universidad != null && mounted) {
        _nitController.text = universidad.nit;
        _nombreController.text = universidad.nombre;
        _direccionController.text = universidad.direccion;
        _telefonoController.text = universidad.telefono;
        _paginaWebController.text = universidad.paginaWeb;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar universidad: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
      }
    }
  }

  String? _validarNoVacio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? _validarUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    final uri = Uri.tryParse(value);
    if (uri == null || (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https'))) {
      return 'Ingrese una URL válida (ej: https://www.ejemplo.com)';
    }
    return null;
  }

  Future<void> _guardarUniversidad() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final universidad = UniversidadModel(
        nit: _nitController.text.trim(),
        nombre: _nombreController.text.trim(),
        direccion: _direccionController.text.trim(),
        telefono: _telefonoController.text.trim(),
        paginaWeb: _paginaWebController.text.trim(),
      );

      if (widget.universidadId != null) {
        await _universidadService.actualizarUniversidad(
          widget.universidadId!,
          universidad,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Universidad actualizada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await _universidadService.crearUniversidad(universidad);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Universidad creada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nitController.dispose();
    _nombreController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _paginaWebController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cargando...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.universidadId != null
              ? 'Editar Universidad'
              : 'Nueva Universidad',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nitController,
                decoration: const InputDecoration(
                  labelText: 'NIT *',
                  hintText: 'Ej: 890.123.456-7',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: _validarNoVacio,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  hintText: 'Ej: UCEVA',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: _validarNoVacio,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección *',
                  hintText: 'Ej: Cra 27A #48-144, Tuluá - Valle',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: _validarNoVacio,
                enabled: !_isLoading,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono *',
                  hintText: 'Ej: +57 602 2242202',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: _validarNoVacio,
                enabled: !_isLoading,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paginaWebController,
                decoration: const InputDecoration(
                  labelText: 'Página Web *',
                  hintText: 'https://www.ejemplo.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.language),
                ),
                validator: _validarUrl,
                enabled: !_isLoading,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _guardarUniversidad,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.universidadId != null
                            ? 'Actualizar Universidad'
                            : 'Crear Universidad',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
