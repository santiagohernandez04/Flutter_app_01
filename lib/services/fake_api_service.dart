import 'dart:math';

class FakeApiService {
  Future<String> fetchData({Duration delay = const Duration(seconds: 2)}) async {
    print('[FakeApiService] Inicio de fetchData');
    await Future.delayed(delay);
    // 20% de probabilidad de error simulado
    final random = Random();
    if (random.nextDouble() < 0.2) {
      print('[FakeApiService] Ocurrió un error simulado');
      throw Exception('Error al obtener datos');
    }
    print('[FakeApiService] Datos obtenidos correctamente');
    return 'Datos simulados recibidos';
  }
}


