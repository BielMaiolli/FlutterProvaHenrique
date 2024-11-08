import 'package:flutter/material.dart';
import 'package:gerenciamento_games/screens/app_drawer.dart';
import 'package:gerenciamento_games/screens/lista_jogos.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bem-vindo ao Gerenciador de Jogos!',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'É bom ver você novamente!!! Veio atualizar os progressos?',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaDeJogos()),
                );
              },
              child: Text('Ver Lista de Jogos'),
            ),
          ],
        ),
      ),
    );
  }
}
