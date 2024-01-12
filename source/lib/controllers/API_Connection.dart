import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:JMAI/Class/APIResponse.dart';
import 'package:JMAI/Class/ClassesForData.dart';

Future<APIResponse> checkConnection() async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['CONNECTED'].toString();
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> getEntidadesResponsaveis() async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['G_ENTIDADES_RESPONSAVEIS'].toString();
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return APIResponse(
        success: false, errorMessage: 'Erro ao Carregar os Centros de Saúde');
  }
}

Future<APIResponse> getDadosNSS(int nss) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['RNU_GET_DADOS_NNS'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"NNS": nss}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> createUser(UtenteRegister utente) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['CREATE_USER'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(utente.toJson()),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> validationEditUser(UtenteRegister utente) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['VALIDATION_EDIT_USER'].toString();
  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(utente.toJson()),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> validationCreateSecretarioClinico(
    SecretarioClinicoRegister secretarioClinico) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['VALIDATION_CREATE_SECRETARIO_CLINICO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(secretarioClinico.toJson()),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> validationCreateMedico(MedicoRegister medico) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['VALIDATION_CREATE_MEDICO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(medico.toJson()),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> loadEspecialidades() async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['LOAD_ESPECIALIDADE'].toString();
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return APIResponse(
        success: false, errorMessage: 'Erro ao Carregar os Centros de Saúde');
  }
}

Future<APIResponse> singin(String email, String password) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['FIREBASE_SIGIN'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> verifyEmailExist(String email) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['V_EMAIL_EXIST'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> resetPassword(String email) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['FIREBASE_FORGOTPASSWORD'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> login(String email, String password) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['FULL_LOGIN'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> getUserRole(String email) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['GETUSERINFO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> getUtenteInfo(String hashed_id) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['GET_UTENTE_INFO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashed_id}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> getMedicoInfo(String hashed_id) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['GET_MEDIC_INFO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashed_id}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> getSecretarioClinicoInfo(String hashed_id) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['GET_SECRETARIA_CLINICO_INFO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashed_id}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> insertRequerimento(
    RequerimentoRegister requerimento) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['INSERT_REQUIREMENT'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requerimento.toJson()),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> fetchRequerimentos(String hashed_id) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['FETCH_REQUIREMENT'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashed_id}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> getRequerimentosUtenteStatusZero() async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['GET_REQUERIMENTOS_UTENTE_STATUS_ZERO'].toString();
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return APIResponse(
        success: false, errorMessage: 'Erro ao Carregar os Centros de Saúde');
  }
}

Future<APIResponse> getRequerimentosUtenteStatusone() async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['GET_REQUERIMENTOS_UTENTE_STATUS_ONE'].toString();
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(
          success: false,
          errorMessage: 'Erro no servidor: ${response.statusCode}');
    }
  } catch (e) {
    return APIResponse(
        success: false, errorMessage: 'Erro ao Carregar os Centros de Saúde');
  }
}

Future<APIResponse> validarRequerimento(String hashed_id) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['VALIDAR_REQUERIMENTO'].toString();
  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashed_id}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> recusarRequerimento(String hashed_id) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['RECUSAR_REQUERIMENTO'].toString();
  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashed_id}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> sendEmailRequerimentoAceite(String email) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['SEND_EMAIL_VALIDAR_REQUERIMENTO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> sendEmailRequerimentoRecusado(
    String email, String observacoes) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['SEND_EMAIL_RECUSAR_REQUERIMENTO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'observacoes': observacoes}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> sendEmailAgendado(String email, String agendamento) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['SEND_EMAIL_AGENDADO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'agendamento': agendamento}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> sendEmailPreAvaliacao(
    String email, double preavalicao) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['SEND_EMAIL_PREAVALICAO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'preavalicao': preavalicao}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> insertPreavliacao(PreAvalicaoRegister preavalicao) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['INSERT_PREAVALIACAO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(preavalicao.toJson()),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> getDadosPreAvalicao(String hashed_id) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['GET_DADOS_PREAVALICAO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashed_id}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> acceptJuntaMedicaRequerimento(String hashed_id) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['ACCEPT_JUNTA_MEDICA_REQUERIMENTO'].toString();
  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashed_id}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> declineJuntaMedicaRequerimento(String hashed_id) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['DECLINE_JUNTA_MEDICA_REQUERIMENTO'].toString();
  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashed_id}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> agendarJuntaMedicaRequerimento(
    String data, String hashed_id) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['AGENDAR_JUNTA_MEDICA_REQUERIMENTO'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'data': data, 'hashed_id': hashed_id}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> getAgendamentoJuntaMedica(String hashed_id) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['GET_DATA_AGENDAMENTO_JUNTA_MEDICA'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashed_id}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}

Future<APIResponse> verificarRequerimentoExistente(String hashed_id) async {
  String url = dotenv.env['API_URL_ANDROID'].toString() +
      dotenv.env['VERIFICAR_REQUERIMENTO_EXISTENTE'].toString();
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hashed_id': hashed_id}),
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      var responseData = jsonDecode(responseBody);

      if (responseData.containsKey('error') && responseData['error'] != null) {
        return APIResponse(success: false, errorMessage: responseData['error']);
      } else {
        return APIResponse(
          success: true,
          data: responseData['response'],
        );
      }
    } else {
      return APIResponse(success: false);
    }
  } catch (e) {
    return APIResponse(success: false, errorMessage: e.toString());
  }
}
