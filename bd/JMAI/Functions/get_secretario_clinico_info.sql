CREATE OR REPLACE FUNCTION get_secretario_clinico_info(p_hashed_id VARCHAR)
RETURNS TABLE(hashed_id VARCHAR, email VARCHAR, nome_secreatario_clinico VARCHAR, contacto BIGINT, data_nascimento DATE, sexo VARCHAR, pais VARCHAR, distrito VARCHAR, concelho VARCHAR, freguesia VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT u.hashed_id, u.email, sc.nome_secreatario_clinico, sc.contacto, sc.data_nascimento, sc.sexo, sc.pais, sc.distrito, sc.concelho, sc.freguesia
    FROM Secretarios_Clinicos sc
    JOIN Utilizador u ON sc.id_utilizador = u.id_utilizador
    WHERE u.hashed_id = p_hashed_id;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION get_secretario_clinico_info(character varying)
SELECT get_secretario_clinico_info('\xc30d04070302e74e3c57856d974f73d2330160b3aa506bd9e6ed5e240b1aaf6569ceead25b39bcba3461eb217bbd4fe6a862f58b366dc6417fd04fe102fff90ce3e3da45')