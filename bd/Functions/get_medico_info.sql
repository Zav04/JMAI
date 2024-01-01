CREATE OR REPLACE FUNCTION get_medico_info(p_hashed_id VARCHAR)
RETURNS TABLE(hashed_id VARCHAR, email VARCHAR, nome_medico VARCHAR, num_cedula BIGINT, num_ordem BIGINT, especialidade VARCHAR, contacto VARCHAR, data_nascimento VARCHAR, sexo VARCHAR, pais VARCHAR, distrito VARCHAR, concelho VARCHAR, freguesia VARCHAR, pais_nacionalidade VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT u.hashed_id, u.email, m.nome_medico, m.num_cedula, m.num_ordem, e.especialidade, m.contacto, m.data_nascimento, m.sexo, m.pais, m.distrito, m.concelho, m.freguesia, m.pais_nacionalidade
    FROM Medico m
    JOIN Utilizador u ON m.id_utilizador = u.id_utilizador
    JOIN Especialidade e ON m.id_especialidade = e.id_especialidade
    WHERE u.hashed_id = p_hashed_id;
END;
$$ LANGUAGE plpgsql;



