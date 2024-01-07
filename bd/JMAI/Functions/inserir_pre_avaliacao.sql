CREATE OR REPLACE FUNCTION inserir_pre_avaliacao(
    p_hashed_id_requerimento VARCHAR,
    p_hashed_id_medico VARCHAR,
    p_pre_avaliacao float4,
    p_observacoes VARCHAR
) RETURNS void AS $$
DECLARE
    v_id_requerimento BIGINT;
    v_id_medico BIGINT;
BEGIN
    -- Encontrar o id_requerimento_junta_medica
    SELECT id_requerimento_junta_medica INTO v_id_requerimento
    FROM RequerimentoJuntaMedica
    WHERE hashed_id = p_hashed_id_requerimento;

    IF v_id_requerimento IS NULL THEN
        RAISE EXCEPTION 'RequerimentoJuntaMedica não encontrado para o hashed_id: %', p_hashed_id_requerimento;
    END IF;

    -- Encontrar o id_medico
    SELECT id_medico INTO v_id_medico
    FROM Medico
    WHERE hashed_id = p_hashed_id_medico;

    IF v_id_medico IS NULL THEN
        RAISE EXCEPTION 'Medico não encontrado para o hashed_id: %', p_hashed_id_medico;
    END IF;

    -- Inserir uma nova pré-avaliação
    INSERT INTO PreAvaliacao (
        id_medico,
        id_requerimento_junta_medica,
        pre_avaliacao,
        observacoes,
        data_pre_avaliacao
    ) VALUES (
        v_id_medico,
        v_id_requerimento,
        p_pre_avaliacao,
        p_observacoes,
        CURRENT_TIMESTAMP
    );

    -- Atualizar o status do requerimento para 2
    UPDATE RequerimentoJuntaMedica
    SET status = 2
    WHERE id_requerimento_junta_medica = v_id_requerimento;
END;
$$ LANGUAGE plpgsql;
