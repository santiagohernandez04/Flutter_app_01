import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';
import 'local_storage_service.dart';

enum AuthState {
  initial,
  loading,
  success,
  error,
}

class AuthService {
  static String get _baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://parking.visiontic.com.co/api';
  
  static AuthState _currentState = AuthState.initial;
  static String? _errorMessage;
  static UserModel? _currentUser;

  // Getters para el estado
  static AuthState get currentState => _currentState;
  static String? get errorMessage => _errorMessage;
  static UserModel? get currentUser => _currentUser;

  // Método para cambiar el estado
  static void _setState(AuthState state, {String? errorMessage}) {
    _currentState = state;
    _errorMessage = errorMessage;
  }

  // Método para registrar un nuevo usuario
  static Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      _setState(AuthState.loading);

      final response = await http.post(
        Uri.parse('$_baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // El registro fue exitoso, ahora hacer login automáticamente
        final loginResponse = await login(email: email, password: password);
        
        if (loginResponse.success) {
          _setState(AuthState.success);
          return AuthResponseModel.success(
            accessToken: loginResponse.accessToken!,
            refreshToken: loginResponse.refreshToken,
            user: loginResponse.user,
            message: 'Usuario registrado e iniciado sesión exitosamente',
          );
        } else {
          _setState(AuthState.error, errorMessage: 'Usuario registrado pero error en login automático');
          return AuthResponseModel.error('Usuario registrado pero error en login automático');
        }
      } else {
        final errorMessage = responseData['message'] ?? 'Error en el registro';
        _setState(AuthState.error, errorMessage: errorMessage);
        return AuthResponseModel.error(errorMessage, errors: responseData['errors']);
      }
    } catch (e) {
      final errorMessage = 'Error de conexión: ${e.toString()}';
      _setState(AuthState.error, errorMessage: errorMessage);
      return AuthResponseModel.error(errorMessage);
    }
  }

  // Método para hacer login
  static Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      _setState(AuthState.loading);

      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(responseData);
        
        if (authResponse.success && authResponse.accessToken != null) {
          // Guardar datos del usuario en SharedPreferences
          if (authResponse.user != null) {
            await LocalStorageService.saveUserData(authResponse.user!);
            _currentUser = authResponse.user;
          }
          
          // Guardar tokens en FlutterSecureStorage
          await LocalStorageService.saveAccessToken(authResponse.accessToken!);
          if (authResponse.refreshToken != null) {
            await LocalStorageService.saveRefreshToken(authResponse.refreshToken!);
          }
          
          _setState(AuthState.success);
        } else {
          _setState(AuthState.error, errorMessage: authResponse.message ?? 'Error en el login');
        }
        
        return authResponse;
      } else {
        final errorMessage = responseData['message'] ?? 'Error en el login';
        _setState(AuthState.error, errorMessage: errorMessage);
        return AuthResponseModel.error(errorMessage, errors: responseData['errors']);
      }
    } catch (e) {
      final errorMessage = 'Error de conexión: ${e.toString()}';
      _setState(AuthState.error, errorMessage: errorMessage);
      return AuthResponseModel.error(errorMessage);
    }
  }

  // Método para hacer logout
  static Future<void> logout() async {
    try {
      _setState(AuthState.loading);
      
      // Limpiar todos los datos locales
      await LocalStorageService.clearAllData();
      
      // Limpiar estado interno
      _currentUser = null;
      _setState(AuthState.initial);
    } catch (e) {
      _setState(AuthState.error, errorMessage: 'Error al cerrar sesión: ${e.toString()}');
    }
  }

  // Método para verificar si el usuario está autenticado
  static Future<bool> isAuthenticated() async {
    return await LocalStorageService.isUserLoggedIn();
  }

  // Método para obtener el usuario actual desde el almacenamiento local
  static Future<UserModel?> getCurrentUserFromStorage() async {
    return await LocalStorageService.getUserData();
  }

  // Método para refrescar el token (si es necesario)
  static Future<AuthResponseModel> refreshToken() async {
    try {
      final refreshToken = await LocalStorageService.getRefreshToken();
      
      if (refreshToken == null) {
        return AuthResponseModel.error('No hay token de refresco disponible');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(responseData);
        
        if (authResponse.success && authResponse.accessToken != null) {
          await LocalStorageService.saveAccessToken(authResponse.accessToken!);
          if (authResponse.refreshToken != null) {
            await LocalStorageService.saveRefreshToken(authResponse.refreshToken!);
          }
        }
        
        return authResponse;
      } else {
        return AuthResponseModel.error('Error al refrescar el token');
      }
    } catch (e) {
      return AuthResponseModel.error('Error de conexión al refrescar token: ${e.toString()}');
    }
  }

  // Método para resetear el estado
  static void resetState() {
    _setState(AuthState.initial);
    _errorMessage = null;
  }
}
