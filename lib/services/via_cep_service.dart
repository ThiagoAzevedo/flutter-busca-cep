import 'package:consulta_cep/models/cep_convert.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ViaCepService {
  static Future<CepCovertDart> fetchCep({String cep}) async {
    final response = await http.get('https://viacep.com.br/ws/$cep/json/');
    if (response.statusCode == 200) {
      return CepCovertDart.fromJson(convert.jsonDecode(response.body));
    } else {
      throw Exception('Requisição inválida');
    }
  }
}
