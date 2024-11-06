import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciamento_games/screens/app_drawer.dart';
import 'package:gerenciamento_games/screens/lista_jogos.dart';

void main() {
  testWidgets('AppDrawer opens and navigates to ListaDeJogos', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Teste Drawer')),
          drawer: AppDrawer(),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.text('Lista de Jogos'), findsOneWidget);

    await tester.tap(find.text('Lista de Jogos'));
    await tester.pumpAndSettle();

    expect(find.byType(ListaDeJogos), findsOneWidget);
  });
}
