class Jogo {
  String id;
  String nome;
  String genero;
  int percentualConclusao;
  String plataforma;
  bool favorito;

  Jogo({
    required this.id,
    required this.nome,
    required this.genero,
    required this.percentualConclusao,
    required this.plataforma,
    required this.favorito,
  });

  factory Jogo.fromJson(Map<String, dynamic> json) {
    return Jogo(
      id: json['id'],
      nome: json['nome'],
      genero: json['genero'],
      percentualConclusao: json['percentualConclusao'],
      plataforma: json['plataforma'],
      favorito: json['favorito'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'genero': genero,
      'percentualConclusao': percentualConclusao,
      'plataforma': plataforma,
      'favorito': favorito,
    };
  }
}
