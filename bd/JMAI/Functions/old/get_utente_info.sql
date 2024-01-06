CREATE OR REPLACE FUNCTION get_utente_info(p_hashed_id VARCHAR)
RETURNS TABLE(
    hashed_id VARCHAR, 
    email VARCHAR, 
    numero_utente_saude BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT ut.hashed_id, u.email, ut.numero_utente_saude
    FROM Utente ut
    INNER JOIN Utilizador u ON ut.id_utilizador = u.id_utilizador
    WHERE u.hashed_id = p_hashed_id;
END;
$$ LANGUAGE plpgsql;

