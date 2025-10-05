import 'dart:async';
import 'package:flutter/material.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _isRunning = false;

  void _start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed += const Duration(seconds: 1);
      });
    });
    setState(() {});
  }

  void _pause() {
    if (!_isRunning) return;
    _isRunning = false;
    _timer?.cancel();
    setState(() {});
  }

  void _resume() {
    if (_isRunning) return;
    _start();
  }

  void _reset() {
    _timer?.cancel();
    _isRunning = false;
    setState(() {
      _elapsed = Duration.zero;
    });
  }

  String _format(Duration d) {
    final two = (int n) => n.toString().padLeft(2, '0');
    final hours = two(d.inHours);
    final minutes = two(d.inMinutes.remainder(60));
    final seconds = two(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cronómetro con Timer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                _format(_elapsed),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            
            // Botones de control 
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Controles del Cronómetro',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 30),
                  
                  // Fila superior de botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: _isRunning ? null : _start,
                          icon: const Icon(Icons.play_arrow, size: 24),
                          label: const Text('Iniciar', style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: _isRunning ? _pause : null,
                          icon: const Icon(Icons.pause, size: 24),
                          label: const Text('Pausar', style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Fila inferior de botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: _isRunning ? null : _resume,
                          icon: const Icon(Icons.play_circle, size: 24),
                          label: const Text('Reanudar', style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: _reset,
                          icon: const Icon(Icons.restart_alt, size: 24),
                          label: const Text('Reiniciar', style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


