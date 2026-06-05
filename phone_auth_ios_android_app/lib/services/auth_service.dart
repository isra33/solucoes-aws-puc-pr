import 'dart:io';
import 'dart:async';
import 'dart:convert';
import '../models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';




class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  Future<String> getDeviceUuid() async {
  final prefs = await SharedPreferences.getInstance();

  if (Platform.isIOS) {
    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;

    final identifierForVendor = iosInfo.identifierForVendor;

    if (identifierForVendor != null && identifierForVendor.isNotEmpty) {
      return identifierForVendor;
    }
  }

  String? savedUuid = prefs.getString('device_uuid');

  if (savedUuid == null) {
    savedUuid = const Uuid().v4();
    await prefs.setString('device_uuid', savedUuid);
  }

  return savedUuid;
}

  Future<http.Response> _safeRequest(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 8));
    } on SocketException {
      throw ApiException(
        'Não foi possível conectar com a API. Verifique se o Spring Boot está rodando na porta 8080.',
      );
    } on TimeoutException {
      throw ApiException(
        'A API demorou muito para responder. Verifique se o servidor está ativo.',
      );
    } on FormatException {
      throw ApiException(
        'A API retornou uma resposta inválida.',
      );
    } catch (_) {
      throw ApiException(
        'Erro inesperado ao conectar com a API.',
      );
    }
  }

  dynamic _decodeBody(String body) {
    if (body.isEmpty) return null;

    try {
      return jsonDecode(body);
    } catch (_) {
      throw ApiException('Resposta inválida recebida da API.');
    }
  }

  Future<Map<String, dynamic>> login(String telefone) async {
    final uuid = await getDeviceUuid();

    final response = await _safeRequest(
      () => http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'telefone': telefone,
          'uuid': uuid,
        }),
      ),
    );

    final body = _decodeBody(response.body);

    if (response.statusCode == 200) {
      return {
        'status': 'logged',
        'user': User.fromJson(body),
      };
    }

    if (response.statusCode == 202) {
      return {
        'status': 'confirmation_required',
        'codigo': body['codigo'],
        'telefone': telefone,
        'uuid': uuid,
      };
    }

    throw ApiException('Erro no login. Código HTTP: ${response.statusCode}');
  }

  Future<User> confirmCode({
    required String telefone,
    required String codigo,
  }) async {
    final uuid = await getDeviceUuid();

    final response = await _safeRequest(
      () => http.post(
        Uri.parse('$baseUrl/users/confirm'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'telefone': telefone,
          'uuid': uuid,
          'codigo': codigo,
        }),
      ),
    );

    if (response.statusCode == 200) {
      return User.fromJson(_decodeBody(response.body));
    }

    if (response.statusCode == 404) {
      throw ApiException('Código de confirmação não encontrado.');
    }

    throw ApiException('Erro ao confirmar código. Código HTTP: ${response.statusCode}');
  }

  Future<User> updateUser({
    required int id,
    required String nome,
    required String descricao,
  }) async {
    final response = await _safeRequest(
      () => http.put(
        Uri.parse('$baseUrl/users/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'descricao': descricao,
        }),
      ),
    );

    if (response.statusCode == 200) {
      return User.fromJson(_decodeBody(response.body));
    }

    throw ApiException('Erro ao atualizar perfil. Código HTTP: ${response.statusCode}');
  }

  Future<String> simularNovoDispositivo() async {
  final prefs = await SharedPreferences.getInstance();

  final novoUuid = const Uuid().v4();

  await prefs.setString(
    'device_uuid',
    novoUuid,
  );

  return novoUuid;
}


}

