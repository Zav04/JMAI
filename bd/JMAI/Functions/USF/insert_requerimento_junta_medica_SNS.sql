CREATE OR REPLACE FUNCTION insert_requerimento_junta_medica_SNS(
    p_id_utilizador BIGINT,
    p_documentos JSON, 
    p_type BIGINT,
    p_nunca_submitido BOOL,
    p_submetido BOOL,
    p_data_submissao VARCHAR DEFAULT NULL
)
RETURNS BOOL AS $$
DECLARE
    v_id_utente BIGINT;
    v_data DATE DEFAULT NULL;
BEGIN

    IF p_data_submissao != '' THEN
        v_data = p_data_submissao::DATE;
    END IF;

    -- Busca o id do Utente a partir da tabela Utilizador usando o email fornecido
    SELECT id_utente INTO v_id_utente
    FROM Utente
    WHERE id_utilizador = p_id_utilizador;

    -- Verifica se o id foi encontrado
    IF v_id_utente IS NULL THEN
        RAISE EXCEPTION 'Utilizador com email % não encontrado.', p_email;
    END IF;
    
    -- Insere o novo registro na tabela RequerimentoJuntaMedica
    INSERT INTO RequerimentoJuntaMedica (
        id_utente, 
        data_submissao, 
        documentos, 
        status, 
        type,
        nunca_submetido,
        submetido,
        data_submetido
    )
    VALUES (
        v_id_utente, 
        CURRENT_DATE,
        p_documentos,
        1, 
        p_type,
        p_nunca_submitido,
        p_submetido,
        v_data
    );
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


SELECT insert_requerimento_junta_medica_SNS(65,'[]',1,TRUE, FALSE, '')
--DROP FUNCTION insert_requerimento_junta_medica_sns(bigint,json,bigint,boolean,boolean,character varying)
