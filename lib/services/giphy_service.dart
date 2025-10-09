import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/gif_model.dart';

/// Servicio para consumir la API de Giphy
class GiphyService {
  // API Key de Giphy desde variables de entorno
  static final String _apiKey = dotenv.env['GIPHY_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.giphy.com/v1/gifs';

  /// Busca GIFs según una categoría o término de búsqueda
  /// 
  /// [query] - Término de búsqueda
  /// [limit] - Cantidad de resultados a obtener (por defecto 20)
  /// [offset] - Desplazamiento para paginación (por defecto 0)
  /// 
  /// Retorna una lista de [GifModel] o lanza una excepción en caso de error
  Future<List<GifModel>> searchGifs({
    required String query,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Validar que el query no esté vacío
      if (query.trim().isEmpty) {
        throw Exception('El término de búsqueda no puede estar vacío');
      }

      // Construir la URL con los parámetros
      final Uri url = Uri.parse(
        '$_baseUrl/search?api_key=$_apiKey&q=$query&limit=$limit&offset=$offset',
      );

      // Realizar la petición GET
      final response = await http.get(url);

      // Verificar el código de estado
      if (response.statusCode == 200) {
        // Decodificar el JSON
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        // Crear el objeto de respuesta
        final giphyResponse = GiphyResponse.fromJson(jsonData);
        
        return giphyResponse.data;
      } else if (response.statusCode == 429) {
        throw Exception('Demasiadas peticiones. Por favor, intenta más tarde.');
      } else if (response.statusCode >= 500) {
        throw Exception('Error en el servidor de Giphy. Intenta más tarde.');
      } else {
        throw Exception(
          'Error al obtener GIFs: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      // Si es una excepción personalizada, relanzarla
      if (e is Exception) {
        rethrow;
      }
      // Para otros errores (como problemas de red)
      throw Exception('Error de conexión: No se pudo conectar con Giphy. Verifica tu conexión a internet.');
    }
  }

  /// Obtiene GIFs trending (populares del momento)
  /// 
  /// [limit] - Cantidad de resultados a obtener (por defecto 20)
  /// [offset] - Desplazamiento para paginación (por defecto 0)
  /// 
  /// Retorna una lista de [GifModel] o lanza una excepción en caso de error
  Future<List<GifModel>> getTrendingGifs({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Construir la URL con los parámetros
      final Uri url = Uri.parse(
        '$_baseUrl/trending?api_key=$_apiKey&limit=$limit&offset=$offset',
      );

      // Realizar la petición GET
      final response = await http.get(url);

      // Verificar el código de estado
      if (response.statusCode == 200) {
        // Decodificar el JSON
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        // Crear el objeto de respuesta
        final giphyResponse = GiphyResponse.fromJson(jsonData);
        
        return giphyResponse.data;
      } else if (response.statusCode == 429) {
        throw Exception('Demasiadas peticiones. Por favor, intenta más tarde.');
      } else if (response.statusCode >= 500) {
        throw Exception('Error en el servidor de Giphy. Intenta más tarde.');
      } else {
        throw Exception(
          'Error al obtener GIFs trending: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      // Si es una excepción personalizada, relanzarla
      if (e is Exception) {
        rethrow;
      }
      // Para otros errores (como problemas de red)
      throw Exception('Error de conexión: No se pudo conectar con Giphy. Verifica tu conexión a internet.');
    }
  }
}

