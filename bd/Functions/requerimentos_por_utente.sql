CREATE OR REPLACE FUNCTION requerimentos_por_utente(p_hashed_id VARCHAR)
RETURNS TABLE (
    id_requerimento_junta_medica BIGINT,
    hashed_id VARCHAR,
    data_submissao DATE,
    documentos JSON,
    status BIGINT,
    observacoes VARCHAR,
    type BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT rjm.id_requerimento_junta_medica, 
           rjm.hashed_id,
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
--DROP FUNCTION requerimentos_por_utente(character varying)

-- SELECT requerimentos_por_utente('\xc30d04070302e0cdf869159f804e6ad2330105513bf6227a600bcb38e2bc6d35b73e6d595f8b1b61c092dd8e18cfb0f6b82a96fe5ea9976ae776b2c850064394b22aa059')

