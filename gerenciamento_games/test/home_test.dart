import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciamento_games/screens/home.dart';
import 'package:gerenciamento_games/screens/lista_jogos.dart';

void main() {
  testWidgets('Teste de Widget para a tela Home', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Home(),
      ),
    );

    expect(find.text('Bem-vindo ao Gerenciador de Jogos!'), findsOneWidget);

    expect(find.text('É bom ver você novamente!!! Veio atualizar os progressos?'), findsOneWidget);

    expect(find.text('Ver Lista de Jogos'), findsOneWidget);

    await tester.tap(find.text('Ver Lista de Jogos'));
    await tester.pumpAndSettle();

    expect(find.byType(ListaDeJogos), findsOneWidget);
  });
}
