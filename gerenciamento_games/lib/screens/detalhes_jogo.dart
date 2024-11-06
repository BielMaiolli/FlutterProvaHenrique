import 'package:flutter/material.dart';
import '../models/jogo.dart';
import '../services/jogo_service.dart';

class DetalhesDoJogo extends StatefulWidget {
  final Jogo jogo;
  final Function(Jogo) onEditar;
  final Function() onExcluir;

  DetalhesDoJogo({
    required this.jogo,
    required this.onEditar,
    required this.onExcluir,
  });

  @override
  _DetalhesDoJogoState createState() => _DetalhesDoJogoState();
}

class _DetalhesDoJogoState extends State<DetalhesDoJogo> {
  late TextEditingController _nomeController;
  late TextEditingController _generoController;
  late TextEditingController _percentualController;
  String? _plataformaSelecionada;
  final JogoService _jogoService = JogoService(); 
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 

  final List<String> plataformas = [
    'PC',
    'PS4',
    'PS5',
    'Xbox',
    'Switch',
    'Mobile',
  ];

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.jogo.nome);
    _generoController = TextEditingController(text: widget.jogo.genero);
    _percentualController = TextEditingController(text: widget.jogo.percentualConclusao.toString());
    _plataformaSelecionada = widget.jogo.plataforma;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _generoController.dispose();
    _percentualController.dispose();
    super.dispose();
  }

  Future<void> _salvarJogo() async {
    if (_formKey.currentState!.validate()) { 
      final jogoEditado = Jogo(
        id: widget.jogo.id, 
        nome: _nomeController.text,
        genero: _generoController.text,
        percentualConclusao: int.parse(_percentualController.text),
        plataforma: _plataformaSelecionada ?? '', 
        favorito: widget.jogo.favorito, 
      );

      try {
        await _jogoService.editarJogo(jogoEditado);
        widget.onEditar(jogoEditado);
        Navigator.pop(context);
      } catch (e) {
        _showErrorDialog('Erro ao salvar o jogo.');
      }
    }
  }

  Future<void> _excluirJogo() async {
    try {
      await _jogoService.excluirJogo(widget.jogo.id); 
      widget.onExcluir();
      Navigator.pop(context);
    } catch (e) {
      _showErrorDialog('Erro ao excluir o jogo.'); 
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes do Jogo',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do jogo.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _generoController,
                decoration: InputDecoration(labelText: 'Gênero'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o gênero do jogo.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _percentualController,
                decoration: InputDecoration(labelText: 'Percentual de Conclusão'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o percentual de conclusão.';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0 || int.parse(value) > 100) {
                    return 'Por favor, insira um percentual válido (0-100).';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _plataformaSelecionada,
                decoration: InputDecoration(labelText: 'Plataforma'),
                items: plataformas.map((plataforma) {
                  return DropdownMenuItem(
                    value: plataforma,
                    child: Text(plataforma),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _plataformaSelecionada = value; 
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _salvarJogo,
                    child: Text('Salvar'),
                  ),
                  ElevatedButton(
                    onPressed: _excluirJogo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Excluir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
