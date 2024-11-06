import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/models/jogo.dart';
import '../lib/screens/adicionar_jogo.dart';

void main() {
  testWidgets('Teste de AdicionarJogo', (WidgetTester tester) async {
    String? resultadoSelecionado;

    void onSave(Jogo jogo) {
      resultadoSelecionado = jogo.plataforma;
    }

    await tester.pumpWidget(
      MaterialApp(
        home: AdicionarJogo(onSave: onSave),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(3)); 
    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Gênero'), findsOneWidget);
    expect(find.text('Percentual de Conclusão'), findsOneWidget);

   
    await tester.enterText(find.byType(TextField).at(0), 'The Last of Us');
    await tester.enterText(find.byType(TextField).at(1), 'Aventura');
    await tester.enterText(find.byType(TextField).at(2), '75');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(resultadoSelecionado, isNull); 
  });
}
