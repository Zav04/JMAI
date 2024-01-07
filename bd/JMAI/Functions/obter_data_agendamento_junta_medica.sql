CREATE OR REPLACE FUNCTION obter_data_agendamento_junta_medica(p_hashed_id_requerimento VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    v_id_requerimento_junta_medica BIGINT;
    v_id_pre_avaliacao BIGINT;
    v_data_agendamento TIMESTAMP;
BEGIN
    -- Encontrar o ID do requerimento da junta médica
    SELECT id_requerimento_junta_medica INTO v_id_requerimento_junta_medica
    FROM RequerimentoJuntaMedica
    WHERE hashed_id = p_hashed_id_requerimento;

    -- Verificar se o requerimento foi encontrado
    IF v_id_requerimento_junta_medica IS NULL THEN
        RAISE EXCEPTION 'Requerimento não encontrado.';
    END IF;

    -- Encontrar o ID de pré-avaliação associado ao requerimento
    SELECT id_pre_avaliacao INTO v_id_pre_avaliacao
    FROM PreAvaliacao
    WHERE id_requerimento_junta_medica = v_id_requerimento_junta_medica;

    -- Verificar se a pré-avaliação foi encontrada
    IF v_id_pre_avaliacao IS NULL THEN
        RAISE EXCEPTION 'Pré-avaliação não encontrada para o requerimento.';
    END IF;

    -- Encontrar a data de agendamento da junta médica
    SELECT data INTO v_data_agendamento
    FROM Agendamento_JuntaMedica
    WHERE id_pre_avaliacao = v_id_pre_avaliacao;

    -- Verificar se a data de agendamento foi encontrada
    IF v_data_agendamento IS NULL THEN
        RAISE EXCEPTION 'Data de agendamento não encontrada.';
    END IF;

    RETURN v_data_agendamento::VARCHAR;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION obter_data_agendamento_junta_medica(character varying)
