CREATE OR REPLACE FUNCTION insert_utente(
    p_id_utilizador BIGINT, 
    p_nome_completo VARCHAR, 
    p_sexo VARCHAR, 
    p_rua VARCHAR, 
    p_numero VARCHAR, 
    p_andar VARCHAR, 
    p_codigo_postal VARCHAR, 
    p_data_nascimento VARCHAR, 
    p_pais VARCHAR, 
    p_distrito VARCHAR, 
    p_concelho VARCHAR, 
    p_freguesia VARCHAR, 
    p_naturalidade VARCHAR, 
    p_pais_nacionalidade VARCHAR, 
    p_tipo_documento_identificacao BIGINT, 
    p_numero_de_documento_de_identificacao BIGINT, 
    p_numero_utente_saude BIGINT, 
    p_numero_de_identificacao_fiscal BIGINT, 
    p_numero_de_seguranca_social BIGINT, 
    p_numero_de_telemovel BIGINT, 
    p_obito BOOLEAN, 
    p_id_entidade_responsavel BIGINT
) RETURNS void AS $$
DECLARE
    v_hashed_id VARCHAR;
    v_morada VARCHAR;
BEGIN
    -- Gerar hashed_id (aqui você precisa definir como quer gerar este id, poderia ser um UUID por exemplo)
    v_hashed_id := md5(random()::text || clock_timestamp()::text); -- exemplo simples

    -- Concatenação da morada
    v_morada := p_rua || ', ' || p_numero || COALESCE(', ' || p_andar, '') || ', ' || p_codigo_postal;

    -- Validações (exemplo simples de validação)
    IF p_nome_completo IS NULL OR p_nome_completo = '' THEN
        RAISE EXCEPTION 'O nome completo é obrigatório.';
    END IF;

    IF p_sexo IS NULL OR p_sexo NOT IN ('Masculino', 'Feminino', 'Outro') THEN
        RAISE EXCEPTION 'Sexo inválido.';
    END IF;

    -- Adicionar mais validações conforme necessário

    -- Inserção na tabela Utente
    INSERT INTO Utente (
        hashed_id, 
        id_utilizador, 
        nome_completo, 
        Sexo, 
        morada, 
        data_nascimento, 
        pais, 
        distrito, 
        concelho, 
        freguesia, 
        naturalidade, 
        pais_nacionalidade, 
        tipo_documento_identificacao, 
        numero_de_documento_de_identificacao, 
        numero_utente_saude, 
        numero_de_identificacao_fiscal, 
        numero_de_seguranca_social, 
        numero_de_telemovel, 
        obito, 
        id_entidade_responsavel
    ) VALUES (
        v_hashed_id, 
        p_id_utilizador, 
        p_nome_completo, 
        p_sexo, 
        v_morada, 
        p_data_nascimento, 
        p_pais, 
        p_distrito, 
        p_concelho, 
        p_freguesia, 
        p_naturalidade, 
        p_pais_nacionalidade, 
        p_tipo_documento_identificacao, 
        p_numero_de_documento_de_identificacao, 
        p_numero_utente_saude, 
        p_numero_de_identificacao_fiscal, 
        p_numero_de_seguranca_social, 
        p_numero_de_telemovel, 
        p_obito, 
        p_id_entidade_responsavel
    );

    -- Você pode querer retornar algo ou definir a função para retornar VOID.
END;
$$ LANGUAGE plpgsql;
