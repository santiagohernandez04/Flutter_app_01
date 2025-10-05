import 'dart:isolate';
import 'package:flutter/material.dart';

// Función que se ejecuta en el Isolate
Future<void> heavyTaskIsolate(SendPort sendPort) async {
  print('[Isolate] Iniciando tarea pesada en Isolate separado');
  
  // Simular una tarea CPU-bound: suma de números grandes
  BigInt result = BigInt.zero;
  const iterations = 1000000; // 1 millón de iteraciones
  
  for (int i = 0; i < iterations; i++) {
    result += BigInt.from(i * i);
    
    // Enviar progreso cada 100,000 iteraciones
    if (i % 100000 == 0 && i > 0) {
      sendPort.send({
        'type': 'progress',
        'progress': (i / iterations * 100).round(),
        'current': i,
        'total': iterations,
      });
    }
  }
  
  print('[Isolate] Tarea completada, resultado: $result');
  
  // Enviar resultado final
  sendPort.send({
    'type': 'result',
    'result': result.toString(),
    'iterations': iterations,
  });
}

class IsolateView extends StatefulWidget {
  const IsolateView({super.key});

  @override
  State<IsolateView> createState() => _IsolateViewState();
}

class _IsolateViewState extends State<IsolateView> {
  bool _isRunning = false;
  int _progress = 0;
  String? _result;
  String? _error;
  Isolate? _isolate;

  Future<void> _runHeavyTask() async {
    print('[IsolateView] Iniciando tarea pesada con Isolate');
    
    setState(() {
      _isRunning = true;
      _progress = 0;
      _result = null;
      _error = null;
    });

    try {
      // Crear un ReceivePort para recibir mensajes del Isolate
      final receivePort = ReceivePort();
      
      // Crear el Isolate
      _isolate = await Isolate.spawn(
        heavyTaskIsolate,
        receivePort.sendPort,
      );
      
      print('[IsolateView] Isolate creado, esperando mensajes...');
      
      // Escuchar mensajes del Isolate
      await for (final message in receivePort) {
        if (mounted) {
          setState(() {
            if (message['type'] == 'progress') {
              _progress = message['progress'] as int;
              print('[IsolateView] Progreso: ${_progress}%');
            } else if (message['type'] == 'result') {
              _result = message['result'] as String;
              _progress = 100;
              _isRunning = false;
              print('[IsolateView] Resultado recibido: ${_result}');
            }
          });
        }
        
        // Si recibimos el resultado, salir del loop
        if (message['type'] == 'result') {
          break;
        }
      }
      
    } catch (e) {
      print('[IsolateView] Error: $e');
      setState(() {
        _error = e.toString();
        _isRunning = false;
      });
    } finally {
      // Limpiar el Isolate
      _isolate?.kill();
      _isolate = null;
    }
  }

  @override
  void dispose() {
    // Limpiar el Isolate al salir de la vista
    _isolate?.kill();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isolate - Tarea Pesada')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tarea CPU-bound: Suma de cuadrados (1M iteraciones)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            if (_isRunning) ...[
              Text(
                'Progreso: $_progress%',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: _progress / 100),
              const SizedBox(height: 10),
              const Text(
                'Ejecutando en Isolate separado...',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
            
            if (_result != null) ...[
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resultado:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        _result!,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            if (_error != null) ...[
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: $_error'),
                ),
              ),
            ],
            
            const Spacer(),
            
            ElevatedButton.icon(
              onPressed: _isRunning ? null : _runHeavyTask,
              icon: const Icon(Icons.speed),
              label: const Text('Ejecutar Tarea Pesada'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            
            const SizedBox(height: 10),
            
            const Text(
              'Nota: Esta tarea se ejecuta en un Isolate separado para no bloquear la UI.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
