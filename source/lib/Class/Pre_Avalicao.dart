class PreAvalicao {
  final String hashed_id_pre_avaliacao;
  final String pre_avaliacao;
  final String? observacoes;
  final String data_pre_avaliacao;
  final String nome_medico;
  final String especialidade;

  PreAvalicao({
    required this.hashed_id_pre_avaliacao,
    required this.pre_avaliacao,
    this.observacoes,
    required this.data_pre_avaliacao,
    required this.nome_medico,
    required this.especialidade,
  });
}
