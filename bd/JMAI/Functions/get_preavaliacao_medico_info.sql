CREATE OR REPLACE FUNCTION get_preavaliacao_medico_info(p_hashed_id_requerimento VARCHAR)
RETURNS TABLE(
    hashed_id_pre_avaliacao VARCHAR,
    pre_avaliacao VARCHAR,
    observacoes VARCHAR,
    data_pre_avaliacao TIMESTAMP,
    nome_medico VARCHAR,
    especialidade VARCHAR

) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pa.hashed_id, 
        pa.pre_avaliacao::VARCHAR, 
        pa.observacoes, 
        pa.data_pre_avaliacao, 
        m.nome_medico, 
        e.especialidade
    FROM 
        PreAvaliacao pa
    JOIN 
        Medico m ON pa.id_medico = m.id_medico
    JOIN 
        Especialidade e ON m.id_especialidade = e.id_especialidade
    JOIN 
        RequerimentoJuntaMedica rjm ON pa.id_requerimento_junta_medica = rjm.id_requerimento_junta_medica
    WHERE 
        rjm.hashed_id = p_hashed_id_requerimento;
END;
$$ LANGUAGE plpgsql;


SELECT get_preavaliacao_medico_info('\xc30d0407030243c2c7d0cf5c399575d23201e20b18b539687533c28c65744f58d4055a469df0eb1c73624ace6d86a199c8951b025a3db8eebf03c6464699e80d9645ca')
DROP FUNCTION get_preavaliacao_medico_info(character varying)