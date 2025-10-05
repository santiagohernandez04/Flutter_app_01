import 'package:flutter/material.dart';
import '../services/fake_api_service.dart';

class AsyncView extends StatefulWidget {
  const AsyncView({super.key});

  @override
  State<AsyncView> createState() => _AsyncViewState();
}

class _AsyncViewState extends State<AsyncView> {
  final FakeApiService _service = FakeApiService();
  String _status = 'Idle';
  String? _data;
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _loadData() async {
    print('[AsyncView] Antes de llamar al servicio');
    setState(() {
      _isLoading = true;
      _status = 'Cargando…';
      _data = null;
      _errorMessage = null;
    });

    try {
      final result = await _service.fetchData();
      print('[AsyncView] Durante: esperando resultado del Future');
      setState(() {
        _isLoading = false;
        _status = 'Éxito';
        _data = result;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error';
        _errorMessage = e.toString();
      });
    } finally {
      print('[AsyncView] Después de completar la llamada');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asincronía: Future / async-await')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Estado: $_status', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            if (_isLoading) const LinearProgressIndicator(),
            const SizedBox(height: 12),
            if (_data != null)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_data!),
                ),
              ),
            if (_errorMessage != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_errorMessage!),
                ),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _loadData,
              child: const Text('Cargar datos (2-3 s)'),
            ),
          ],
        ),
      ),
    );
  }
}


