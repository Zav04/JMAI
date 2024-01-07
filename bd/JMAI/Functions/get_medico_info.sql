CREATE OR REPLACE FUNCTION get_medico_info(p_hashed_id VARCHAR)
RETURNS TABLE(hashed_id VARCHAR, email VARCHAR, nome_medico VARCHAR, num_cedula BIGINT, num_ordem BIGINT, especialidade VARCHAR, contacto VARCHAR, data_nascimento DATE, sexo VARCHAR, pais VARCHAR, distrito VARCHAR, concelho VARCHAR, freguesia VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT m.hashed_id, u.email, m.nome_medico, m.num_cedula, m.num_ordem, e.especialidade, m.contacto, m.data_nascimento, m.sexo, m.pais, m.distrito, m.concelho, m.freguesia
    FROM Medico m
    JOIN Utilizador u ON m.id_utilizador = u.id_utilizador
    JOIN Especialidade e ON m.id_especialidade = e.id_especialidade
    WHERE u.hashed_id = p_hashed_id;
END;
$$ LANGUAGE plpgsql;


--SELECT get_medico_info('\xc30d04070302c4c985d5d9362e0274d233017e43db911261544d3b215006c91f1e3be0629c62686e2ecaf37c45d6a6e037b623c5fe79ea6ec2fce48f8297f671e80fdc6c')
--DROP FUNCTION get_medico_info(character varying)