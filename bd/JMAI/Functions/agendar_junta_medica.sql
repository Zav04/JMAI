CREATE OR REPLACE FUNCTION agendar_junta_medica(p_data_hora VARCHAR, p_hashed_id_requerimento VARCHAR)
RETURNS BOOL AS $$
DECLARE
    v_id_pre_avaliacao BIGINT;
    v_data_hora TIMESTAMP;
    v_existente BOOLEAN;
BEGIN
    v_data_hora := to_timestamp(p_data_hora, 'YYYY-MM-DD HH24:MI');

    SELECT EXISTS (
        SELECT 1 FROM Agendamento_JuntaMedica ajm
        WHERE ajm.data = v_data_hora
    ) INTO v_existente;

    IF v_existente THEN
        RAISE EXCEPTION 'Já existe uma marcação para essa data e hora. Por Favor escolha outra data';
    END IF;


    UPDATE RequerimentoJuntaMedica
    SET status = 3
    WHERE hashed_id = p_hashed_id_requerimento;

    -- Obter o id para pré-avaliação associado ao requerimento
    SELECT id_pre_avaliacao INTO v_id_pre_avaliacao
    FROM PreAvaliacao
    WHERE id_requerimento_junta_medica = (
        SELECT id_requerimento_junta_medica 
        FROM RequerimentoJuntaMedica 
        WHERE hashed_id = p_hashed_id_requerimento
    );

    -- Verificar se o id para pré-avaliação foi encontrado
    IF v_id_pre_avaliacao IS NULL THEN
        RAISE EXCEPTION 'Pré-avaliação não encontrada para o requerimento fornecido.';
    END IF;

    -- Criar o agendamento na tabela Agendamento_JuntaMedica com status 1
    INSERT INTO Agendamento_JuntaMedica(id_pre_avaliacao, data, status)
    VALUES (v_id_pre_avaliacao, v_data_hora, 1);
	
    -- Retornar TRUE para indicar sucesso
	RETURN TRUE;
	
END;
$$ LANGUAGE plpgsql;
