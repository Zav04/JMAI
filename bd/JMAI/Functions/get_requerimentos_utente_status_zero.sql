CREATE OR REPLACE FUNCTION get_requerimentos_utente_status_zero()
RETURNS SETOF json AS $$
BEGIN
    RETURN QUERY SELECT json_build_object(
        'id_requerimento', rj.id_requerimento_junta_medica,
        'hashed_id', rj.hashed_id,
        'data_submissao', rj.data_submissao,
        'documentos', rj.documentos,
        'status_requerimento', rj.status,
        'type_requerimento', rj.type,
		'submetido', rj.submetido,
		'nunca_submetido', rj.nunca_submetido,
		'data_submetido', rj.data_submetido,
		'numero_utente_saude_by_SNS', rj.numero_utente_saude_by_SNS,
        'email_utente', COALESCE(usr.email, NULL),
        'numero_utente_saude', COALESCE(u.numero_utente_saude, NULL)
    )
    FROM RequerimentoJuntaMedica rj
    LEFT JOIN Utente u ON rj.id_utente = u.id_utente
    LEFT JOIN Utilizador usr ON u.id_utilizador = usr.id_utilizador
    WHERE rj.status = 0;
END;
$$ LANGUAGE plpgsql;

