CREATE OR REPLACE FUNCTION get_requerimentos_utente_status_zero()
RETURNS SETOF json AS $$
BEGIN
    RETURN QUERY SELECT json_build_object(
        'id_requerimento', rj.id_requerimento_junta_medica,
        'hashed_id', rj.hashed_id,
        'data_submissao', rj.data_submissao,
        'documentos', rj.documentos,
        'status_requerimento', rj.status,
        'observacoes_requerimento', rj.observacoes,
        'type_requerimento', rj.type,
		'submetido', rj.submetido,
		'nunca_submetido', rj.nunca_submetido,
		'data_submetido',rj.data_submetido,
        'nome_completo', u.nome_completo,
        'sexo_utente', u.sexo,
        'morada', u.morada,
        'data_nascimento_utente', u.data_nascimento,
        'nr_porta', u.nr_porta,
        'nr_andar', u.nr_andar,
        'codigo_postal', u.codigo_postal,
        'distrito_utente', u.distrito,
        'concelho_utente', u.concelho,
        'freguesia_utente', u.freguesia,
        'naturalidade', u.naturalidade,
        'pais_nacionalidade_utente', u.pais_nacionalidade,
        'tipo_documento_identificacao', u.tipo_documento_identificacao,
        'numero_documento_identificacao', u.numero_de_documento_de_identificacao,
        'numero_utente_saude', u.numero_utente_saude,
        'numero_identificacao_fiscal', u.numero_de_identificacao_fiscal,
        'numero_seguranca_social', u.numero_de_seguranca_social,
        'numero_telemovel', u.numero_de_telemovel,
        'obito', u.obito,
        'documento_validade', u.documento_validade,
        'nome_entidade_responsavel', e.nome,
        'email_utente', usr.email
    )
    FROM RequerimentoJuntaMedica rj
    JOIN Utente u ON rj.id_utente = u.id_utente
    JOIN Utilizador usr ON u.id_utilizador = usr.id_utilizador
    JOIN EntidadeResponsavel e ON u.id_entidade_responsavel = e.id_entidade_responsavel
    WHERE rj.status = 0;
END;
$$ LANGUAGE plpgsql;
