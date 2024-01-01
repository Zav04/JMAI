CREATE OR REPLACE FUNCTION get_secretario_clinico_info(p_hashed_id VARCHAR)
RETURNS TABLE(hashed_id VARCHAR, email VARCHAR, nome_secreatario_clinico VARCHAR, contacto VARCHAR, data_nascimento VARCHAR, sexo VARCHAR, pais VARCHAR, distrito VARCHAR, concelho VARCHAR, freguesia VARCHAR, pais_nacionalidade VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT u.hashed_id, u.email, sc.nome_secreatario_clinico, sc.contacto, sc.data_nascimento, sc.sexo, sc.pais, sc.distrito, sc.concelho, sc.freguesia, sc.pais_nacionalidade
    FROM Secretarios_Clinicos sc
    JOIN Utilizador u ON sc.id_utilizador = u.id_utilizador
    WHERE u.hashed_id = p_hashed_id;
END;
$$ LANGUAGE plpgsql;
