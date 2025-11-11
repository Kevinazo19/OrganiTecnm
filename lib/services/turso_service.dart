// lib/services/turso_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';

class ServicioTurso {
  Future<bool> registrarUsuario({
    required String email,
    required String usuario,
    required String contrasena,
  }) async {
    final cuerpoPeticion = jsonEncode({
      "requests": [
        {
          "type": "execute",
          "stmt": {
            "sql":
                "INSERT INTO profesores (email, usuario, contraseña) VALUES (?, ?, ?);",
            "args": [
              {"type": "text", "value": email},
              {"type": "text", "value": usuario},
              {"type": "text", "value": contrasena},
            ],
          },
        },
      ],
    });

    try {
      final respuesta = await http.post(
        Uri.parse('$TURSO_API_URL/v2/pipeline'),
        headers: {
          'Authorization': 'Bearer $TURSO_AUTH_TOKEN',
          'Content-Type': 'application/json',
        },
        body: cuerpoPeticion,
      );

      if (respuesta.statusCode == 200) {
        final Map<String, dynamic> datos = jsonDecode(respuesta.body);
        final List<dynamic> resultados = datos['results'] as List<dynamic>;

        if (resultados.isNotEmpty && resultados[0]['type'] == 'ok') {
          return true;
        }

        if (resultados.isNotEmpty && resultados[0]['type'] == 'error') {
          final String mensajeError = resultados[0]['error']['message'] ?? '';
          if (mensajeError.contains('UNIQUE constraint failed')) {
            return false;
          }
        }

        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Iniciar sesión
  Future<bool> iniciarSesion({
    required String usuario,
    required String contrasena,
  }) async {
    final cuerpoPeticion = jsonEncode({
      "requests": [
        {
          "type": "execute",
          "stmt": {
            "sql":
                "SELECT id FROM profesores WHERE usuario = ? AND contraseña = ? LIMIT 1;",
            "args": [
              {"type": "text", "value": usuario},
              {"type": "text", "value": contrasena},
            ],
          },
        },
      ],
    });

    try {
      final respuesta = await http.post(
        Uri.parse('$TURSO_API_URL/v2/pipeline'),
        headers: {
          'Authorization': 'Bearer $TURSO_AUTH_TOKEN',
          'Content-Type': 'application/json',
        },
        body: cuerpoPeticion,
      );

      if (respuesta.statusCode == 200) {
        final Map<String, dynamic> datos = jsonDecode(respuesta.body);
        final List<dynamic> resultados = datos['results'] as List<dynamic>;

        if (resultados.isNotEmpty &&
            resultados[0]['type'] == 'ok' &&
            resultados[0]['response'] != null) {
          final responseData = resultados[0]['response'];
          final resultData = responseData['result'];

          if (resultData != null &&
              resultData['rows'] != null &&
              resultData['rows'].isNotEmpty) {
            return true;
          }
        }

        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
