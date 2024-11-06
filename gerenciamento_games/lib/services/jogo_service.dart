import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/jogo.dart';

class JogoService {
  final String baseUrl = 'http://localhost:3000/jogos'; 

  Future<List<Jogo>> buscarJogos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> dados = json.decode(response.body);
      return dados.map((jogo) => Jogo.fromJson(jogo)).toList();
    } else {
      throw Exception('Erro ao carregar jogos: ${response.statusCode}');
    }
  }

  Future<Jogo> adicionarJogo(Jogo jogo) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jogo.toJson()),
    );
    if (response.statusCode == 201) {
      return Jogo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao adicionar o jogo: ${response.statusCode}');
    }
  }

  Future<void> editarJogo(Jogo jogo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${jogo.id}'), 
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jogo.toJson()),
    );

    print('Response body: ${response.body}');
    print('Editando jogo com ID: ${jogo.id}');

    if (response.statusCode != 200) {
      throw Exception('Erro ao editar o jogo: ${response.statusCode}');
    }
  }

  Future<List<Jogo>> excluirJogo(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return await buscarJogos();
    } else {
      throw Exception('Erro ao excluir o jogo: ${response.statusCode}');
    }
  }
}
