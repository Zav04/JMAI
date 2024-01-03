CREATE OR REPLACE FUNCTION requerimentos_por_utente(p_hashed_id VARCHAR)
RETURNS TABLE (
    hashed_id VARCHAR,
    data_submissao DATE,
    documentos JSON,
    status BIGINT,
    observacoes VARCHAR,
    type BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT rjm.hashed_id,
           rjm.data_submissao, 
           rjm.documentos, 
           rjm.status, 
           rjm.observacoes, 
           rjm.type
    FROM RequerimentoJuntaMedica rjm
    JOIN Utente u ON rjm.id_utente = u.id_utente
    WHERE u.hashed_id = p_hashed_id;
END;
$$ LANGUAGE plpgsql;
