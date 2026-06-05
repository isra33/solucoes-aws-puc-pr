class User {
  final int id;
  final String telefone;
  final String uuid;
  final String? nome;
  final String? descricao;
  final bool ativo;

  User({
    required this.id,
    required this.telefone,
    required this.uuid,
    this.nome,
    this.descricao,
    required this.ativo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      telefone: json['telefone'],
      uuid: json['uuid'],
      nome: json['nome'],
      descricao: json['descricao'],
      ativo: json['ativo'] ?? false,
    );
  }
}