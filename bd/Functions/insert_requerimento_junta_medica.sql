CREATE OR REPLACE FUNCTION insert_requerimento_junta_medica(
    p_hashed_id VARCHAR, 
    p_documentos JSON, 
    p_observacoes VARCHAR, 
    p_type BIGINT
)
RETURNS void AS $$
DECLARE
    v_id_utente BIGINT;
BEGIN
    -- Buscar o id_utente com base no hashed_id
    SELECT id_utente INTO v_id_utente
    FROM Utente
    WHERE hashed_id = p_hashed_id;

    -- Verifica se encontrou o utente
    IF v_id_utente IS NULL THEN
        RAISE EXCEPTION 'Utente não encontrado com o hashed_id fornecido.';
    END IF;

    -- Insere o novo registro na tabela RequerimentoJuntaMedica
    INSERT INTO RequerimentoJuntaMedica (
        id_utente, 
        data_submissao, 
        documentos, 
        status, 
        observacoes, 
        type
    )
    VALUES (
        v_id_utente, 
        CURRENT_DATE,
        p_documentos::JSON,
        0,
        p_observacoes, 
        p_type
    );
END;
$$ LANGUAGE plpgsql;


-- SELECT insert_requerimento_junta_medica(
--     '\\xc30d04070302e0cdf869159f804e6ad2330105513bf6227a600bcb38e2bc6d35b73e6d595f8b1b61c092dd8e18cfb0f6b82a96fe5ea9976ae776b2c850064394b22aa059',
--     '[ ''https://firebasestorage.googleapis.com/v0/b/jmai-9a89a.appspot.com/o/docs%2FIA_BrunoOliveira_n15566__DiogoFernandes_n24017.docx?alt=media&token=3e14131c-9146-4fbc-826a-6d295cde4e6a'', ''https://firebasestorage.googleapis.com/v0/b/jmai-9a89a.appspot.com/o/docs%2FIA_BrunoOliveira_n15566__DiogoFernandes_n24017.pdf?alt=media&token=5f83b762-692c-4250-b7c7-2db599c42c9b0'' ]',
--     'Junta Medica Multioso',
--     1
-- );

