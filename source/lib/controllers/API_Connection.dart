import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:JMAI/Class/CreateAPIResponse.dart';
import 'package:JMAI/Class/ClassesForData.dart';
import 'package:JMAI/Class/Utente.dart';
import 'package:JMAI/Class/Medico.dart';
import 'package:JMAI/Class/SecretarioClinico.dart';

Future<CreateAPIResponse> checkConnection() async {
  String URL =
      dotenv.env['API_URL'].toString() + dotenv.env['CONNECTED'].toString();
  try {
    final response = await http.get(Uri.parse(URL));

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return CreateAPIResponse(
            success: false, errorMessage: responseData['error']);
      } else {
        return CreateAPIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return CreateAPIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
    // Falha, com exceção capturada
  }
}

Future<CreateAPIResponse> getEntidadesResponsaveis() async {
  String URL = dotenv.env['API_URL'].toString() +
      dotenv.env['G_ENTIDADES_RESPONSAVEIS'].toString();
  try {
    final response = await http.get(Uri.parse(URL));

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return CreateAPIResponse(
            success: false, errorMessage: responseData['error']);
      } else {
        return CreateAPIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return CreateAPIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return CreateAPIResponse(
        success: false, errorMessage: 'Erro ao Carregar os Centros de Saúde');
    // Falha, com exceção capturada
  }
}

Future<CreateAPIResponse> validationCreateUser(UtenteRegister utente) async {
  String URL = dotenv.env['API_URL'].toString() +
      dotenv.env['VALIDATION_CREATE_USER'].toString();
  try {
    final response = await http.post(
      Uri.parse(URL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(utente.toJson()),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return CreateAPIResponse(
            success: false, errorMessage: responseData['error']);
      } else {
        return CreateAPIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return CreateAPIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
  }
}

Future<CreateAPIResponse> singin(String email, String password) async {
  String URL = dotenv.env['API_URL'].toString() +
      dotenv.env['FIREBASE_SIGIN'].toString();
  try {
    final response = await http.post(
      Uri.parse(URL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return CreateAPIResponse(
            success: false, errorMessage: responseData['error']);
      } else {
        return CreateAPIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return CreateAPIResponse(success: false);
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
  }
}

Future<CreateAPIResponse> verifyEmailExist(String email) async {
  String URL =
      dotenv.env['API_URL'].toString() + dotenv.env['V_EMAIL_EXIST'].toString();
  try {
    final response = await http.post(
      Uri.parse(URL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return CreateAPIResponse(
            success: false, errorMessage: responseData['error']);
      } else {
        return CreateAPIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return CreateAPIResponse(success: false);
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
  }
}

Future<CreateAPIResponse> resetPassword(String email) async {
  String URL = dotenv.env['API_URL'].toString() +
      dotenv.env['FIREBASE_FORGOTPASSWORD'].toString();
  try {
    final response = await http.post(
      Uri.parse(URL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return CreateAPIResponse(
            success: false, errorMessage: responseData['error']);
      } else {
        return CreateAPIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return CreateAPIResponse(success: false);
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
  }
}

Future<CreateAPIResponse> login(String email, String password) async {
  String URL =
      dotenv.env['API_URL'].toString() + dotenv.env['FULL_LOGIN'].toString();
  try {
    final response = await http.post(
      Uri.parse(URL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return CreateAPIResponse(
            success: false, errorMessage: responseData['error']);
      } else {
        return CreateAPIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return CreateAPIResponse(success: false);
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
  }
}

Future<CreateAPIResponse> getUserRole(String email) async {
  String URL =
      dotenv.env['API_URL'].toString() + dotenv.env['GETUSERINFO'].toString();
  try {
    final response = await http.post(
      Uri.parse(URL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return CreateAPIResponse(
            success: false, errorMessage: responseData['error']);
      } else {
        return CreateAPIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return CreateAPIResponse(success: false);
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
  }
}

Future<CreateAPIResponse> getUtenteInfo(String hashedId) async {
  String URL = dotenv.env['API_URL'].toString() +
      dotenv.env['GET_UTENTE_INFO'].toString();
  try {
    final response = await http.post(
      Uri.parse(URL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashedId}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return CreateAPIResponse(
            success: false, errorMessage: responseData['error']);
      } else {
        return CreateAPIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return CreateAPIResponse(success: false);
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
  }
}

Future<CreateAPIResponse> getMedicoInfo(String hashedId) async {
  String URL = dotenv.env['API_URL'].toString() +
      dotenv.env['GET_MEDIC_INFO'].toString();
  try {
    final response = await http.post(
      Uri.parse(URL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashedId}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return CreateAPIResponse(
            success: false, errorMessage: responseData['error']);
      } else {
        return CreateAPIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return CreateAPIResponse(success: false);
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
  }
}

Future<CreateAPIResponse> getSecretarioClinicoInfo(String hashedId) async {
  String URL = dotenv.env['API_URL'].toString() +
      dotenv.env['GET_SECRETARIA_CLINICO_INFO'].toString();
  try {
    final response = await http.post(
      Uri.parse(URL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashedId}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return CreateAPIResponse(
            success: false, errorMessage: responseData['error']);
      } else {
        return CreateAPIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return CreateAPIResponse(success: false);
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
  }
}

Future<CreateAPIResponse> logout(String email) async {
  String URL =
      dotenv.env['API_URL'].toString() + dotenv.env['LOGOUT'].toString();
  try {
    final response = await http.post(
      Uri.parse(URL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return CreateAPIResponse(
            success: false, errorMessage: responseData['error']);
      } else {
        return CreateAPIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return CreateAPIResponse(success: false);
    }
  } catch (e) {
    return CreateAPIResponse(success: false, errorMessage: e.toString());
  }
}
