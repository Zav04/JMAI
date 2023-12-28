import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreateDBResponse {
  final bool success;
  final dynamic data;
  final String? errorMessage;

  CreateDBResponse({
    required this.success,
    this.data,
    this.errorMessage,
  });
}

Future<CreateDBResponse> checkConnection() async {
  String checkConnection =
      dotenv.env['API_URL'].toString() + dotenv.env['CONNECTED'].toString();
  try {
    final response = await http.get(Uri.parse(checkConnection));

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);
      return CreateDBResponse(
        success: true,
        data: responseData,
      );
    } else {
      return CreateDBResponse(success: false);
    }
  } catch (e) {
    return CreateDBResponse(success: false, errorMessage: e.toString());
    // Falha, com exceção capturada
  }
}

Future<CreateDBResponse> getEntidadesResponsaveis() async {
  String checkConnection = dotenv.env['API_URL'].toString() +
      dotenv.env['G_ENTIDADES_RESPONSAVEIS'].toString();
  try {
    final response = await http.get(Uri.parse(checkConnection));

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);
      return CreateDBResponse(
        success: true,
        data: responseData,
      );
    } else {
      return CreateDBResponse(success: false);
    }
  } catch (e) {
    return CreateDBResponse(success: false, errorMessage: e.toString());
    // Falha, com exceção capturada
  }
}
