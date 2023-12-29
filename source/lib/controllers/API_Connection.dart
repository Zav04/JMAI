import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:JMAI/Class/CreateAPIResponse.dart';

Future<CreateAPIResponse> checkConnection() async {
  String checkConnection =
      dotenv.env['API_URL'].toString() + dotenv.env['CONNECTED'].toString();
  try {
    final response = await http.get(Uri.parse(checkConnection));

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);
      return CreateAPIResponse(
        success: true,
        data: responseData,
      );
    } else {
      return CreateAPIResponse(success: false);
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
    // Falha, com exceção capturada
  }
}

Future<CreateAPIResponse> getEntidadesResponsaveis() async {
  String checkConnection = dotenv.env['API_URL'].toString() +
      dotenv.env['G_ENTIDADES_RESPONSAVEIS'].toString();
  try {
    final response = await http.get(Uri.parse(checkConnection));

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);
      return CreateAPIResponse(
        success: true,
        data: responseData,
      );
    } else {
      return CreateAPIResponse(success: false);
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
    // Falha, com exceção capturada
  }
}
