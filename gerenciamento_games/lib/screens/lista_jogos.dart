import 'package:flutter/material.dart';
import '../models/jogo.dart';
import '../services/jogo_service.dart';
import 'adicionar_jogo.dart';
import 'detalhes_jogo.dart';
import 'lista_favoritos.dart';

class ListaDeJogos extends StatefulWidget {
  @override
  _ListaDeJogosState createState() => _ListaDeJogosState();
}

class _ListaDeJogosState extends State<ListaDeJogos> {
  final JogoService _jogoService = JogoService();
  late Future<List<Jogo>> _jogosFuture;

  @override
  void initState() {
    super.initState();
    _atualizarJogos(); 
  }

  void _atualizarJogos() {
    setState(() {
      _jogosFuture = _jogoService.buscarJogos(); 
    });
  }

  void _marcarComoFavorito(Jogo jogo) async {
    setState(() {
      jogo.favorito = !jogo.favorito;
    });
    await _jogoService.editarJogo(jogo);
    _atualizarJogos(); 
  }

  Future<void> _adicionarNovoJogo() async {
    final novoJogo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdicionarJogo(
          onSave: (jogo) async {
            await _jogoService.adicionarJogo(jogo);
            _atualizarJogos();
          },
        ),
      ),
    );
    if (novoJogo != null) {
      _atualizarJogos();
    }
  }

  Future<void> _editarJogo(Jogo jogo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesDoJogo(
          jogo: jogo,
          onEditar: (jogoEditado) async {
            await _jogoService.editarJogo(jogoEditado);
            _atualizarJogos();
          },
          onExcluir: () async {
            await _jogoService.excluirJogo(jogo.id);
            _atualizarJogos(); 
            Navigator.pop(context); 
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        title: Text(
          'Meus Jogos',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () async {
                final jogos = await _jogosFuture;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaDeFavoritos(
                      jogos.where((j) => j.favorito).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Jogo>>(
        future: _jogosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar jogos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum jogo encontrado.'));
          } else {
            final jogos = snapshot.data!;
            return ListView.builder(
              itemCount: jogos.length,
              itemBuilder: (context, index) {
                final jogo = jogos[index];
                return Card(
                  child: ListTile(
                    title: Text(jogo.nome),
                    subtitle: Text(
                        'Gênero: ${jogo.genero} | Plataforma: ${jogo.plataforma} | Percentual: ${jogo.percentualConclusao}%'),
                    trailing: IconButton(
                      icon: Icon(
                        jogo.favorito ? Icons.favorite : Icons.favorite_border,
                        color: jogo.favorito ? Colors.red : null,
                      ),
                      onPressed: () => _marcarComoFavorito(jogo),
                    ),
                    onTap: () => _editarJogo(jogo),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _adicionarNovoJogo,
      ),
    );
  }
}
