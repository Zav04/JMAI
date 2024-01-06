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
        'email_utente', usr.email
    )
    FROM RequerimentoJuntaMedica rj
    JOIN Utente u ON rj.id_utente = u.id_utente
    JOIN Utilizador usr ON u.id_utilizador = usr.id_utilizador
    JOIN EntidadeResponsavel e ON u.id_entidade_responsavel = e.id_entidade_responsavel
    WHERE rj.status = 0;
END;
$$ LANGUAGE plpgsql;
