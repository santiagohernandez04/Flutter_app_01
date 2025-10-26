import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Claves para SharedPreferences (datos no sensibles)
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userPhoneKey = 'user_phone';
  static const String _userRoleKey = 'user_role';
  static const String _userIdKey = 'user_id';

  // Claves para FlutterSecureStorage (datos sensibles)
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Métodos para SharedPreferences (datos no sensibles)
  static Future<void> saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, user.name);
    await prefs.setString(_userEmailKey, user.email);
    await prefs.setString(_userPhoneKey, user.phone ?? '');
    await prefs.setString(_userRoleKey, user.role ?? '');
    await prefs.setInt(_userIdKey, user.id);
  }

  static Future<UserModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_userNameKey);
    final email = prefs.getString(_userEmailKey);
    final phone = prefs.getString(_userPhoneKey);
    final role = prefs.getString(_userRoleKey);
    final id = prefs.getInt(_userIdKey);

    if (name == null || email == null || id == null) {
      return null;
    }

    return UserModel(
      id: id,
      name: name,
      email: email,
      phone: phone?.isNotEmpty == true ? phone : null,
      role: role?.isNotEmpty == true ? role : null,
    );
  }


  // Métodos para FlutterSecureStorage (datos sensibles)
  static Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  // Métodos de verificación
  static Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<bool> isUserLoggedIn() async {
    final user = await getUserData();
    final hasToken = await hasValidToken();
    return user != null && hasToken;
  }

  // Método para limpiar todos los datos
  static Future<void> clearAllData() async {
    // Limpiar SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userIdKey);

    // Limpiar FlutterSecureStorage
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  // Método para obtener información de sesión para la vista de evidencia
  static Future<Map<String, dynamic>> getSessionInfo() async {
    final user = await getUserData();
    final hasToken = await hasValidToken();
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();

    return {
      'user': user,
      'hasToken': hasToken,
      'tokenPresent': accessToken != null,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
