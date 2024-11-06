import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../lib/services/jogo_service.dart';
import '../lib/models/jogo.dart';
import 'jogo_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late JogoService jogoService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    jogoService = JogoService();
  });

  test('Deve retornar lista de jogos quando a resposta for 200', () async {
    final jsonResponse = jsonEncode([
      {
        "id": "1",
        "nome": "Jogo Teste",
        "genero": "Aventura",
        "percentualConclusao": 100,
        "plataforma": "PC",
        "favorito": false
      }
    ]);

    when(mockClient.get(Uri.parse(jogoService.baseUrl)))
        .thenAnswer((_) async => http.Response(jsonResponse, 200));

    final jogos = await jogoService.buscarJogos();

    expect(jogos, isA<List<Jogo>>());
    expect(jogos.length, 1);
    expect(jogos[0].nome, "Jogo Teste");
  });

  test('Deve lançar uma exceção quando a resposta for diferente de 200', () async {
    when(mockClient.get(Uri.parse(jogoService.baseUrl)))
        .thenAnswer((_) async => http.Response('Not Found', 404));

    expect(jogoService.buscarJogos(), throwsException);
  });
}
