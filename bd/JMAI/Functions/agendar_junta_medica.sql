CREATE OR REPLACE FUNCTION agendar_junta_medica(p_data_hora VARCHAR, p_hashed_id_requerimento VARCHAR)
RETURNS void AS $$
DECLARE
    v_id_pre_avaliacao BIGINT;
    v_data_hora TIMESTAMP;
    v_existente BOOLEAN;
BEGIN

    v_data_hora := to_timestamp(p_data_hora, 'DD-MM-YYYY HH24:MI');

    SELECT TRUE INTO v_existente
    FROM Agendamento_JuntaMedica
    WHERE data = v_data_hora;

    IF v_existente IS TRUE THEN
        RAISE EXCEPTION 'Já existe uma marcação para essa data e hora.';
    END IF;

    -- Atualiza o status do requerimento para 3 (agendado)
    UPDATE RequerimentoJuntaMedica
    SET status = 3
    WHERE hashed_id = p_hashed_id_requerimento;

    -- Obtém o id para pre avaliação associado ao requerimento
    SELECT id_pre_avaliacao INTO v_id_pre_avaliacao
    FROM PreAvaliacao
    WHERE id_requerimento_junta_medica = (SELECT id_requerimento_junta_medica FROM RequerimentoJuntaMedica WHERE hashed_id = p_hashed_id_requerimento);

    -- Cria o agendamento na tabela Agendamento_JuntaMedica com status 1
    INSERT INTO Agendamento_JuntaMedica(id_pre_avaliacao, data, status)
    VALUES (v_id_pre_avaliacao, v_data_hora, 1);
END;
$$ LANGUAGE plpgsql;
