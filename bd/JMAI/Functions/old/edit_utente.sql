CREATE OR REPLACE FUNCTION edit_utente(
    p_hashed_id VARCHAR(255),
    p_nome_completo VARCHAR(255),
    p_sexo VARCHAR(255),
    p_morada VARCHAR(255),
    p_nr_porta VARCHAR(255),
    p_nr_andar VARCHAR(255),
    p_codigo_postal VARCHAR(255),
    p_data_nascimento VARCHAR(255),
    p_distrito VARCHAR(255),
    p_concelho VARCHAR(255),
    p_freguesia VARCHAR(255),
    p_pais_naturalidade VARCHAR(255),
    p_pais_nacionalidade VARCHAR(255),
    p_tipo_documento_identificacao VARCHAR(255),
    p_numero_documento_identificacao VARCHAR(255),
    p_numero_utente_saude VARCHAR(255),
    p_numero_identificacao_fiscal VARCHAR(255),
    p_numero_seguranca_social VARCHAR(255),
    p_numero_telemovel VARCHAR(255),
    p_id_entidade_responsavel VARCHAR(255),
    p_documento_validade VARCHAR(255),
    p_justvalidate_inputs BOOL
) RETURNS BOOL AS $$
DECLARE
    v_id_entidade_responsavel BIGINT;
    v_tipo_documento_identificacao BIGINT;
BEGIN
    IF p_nome_completo IS NULL OR p_nome_completo = '' THEN
        RAISE EXCEPTION 'Nome Completo é um campo obrigatorio.';
    END IF;
	
	IF p_data_nascimento IS NULL or p_data_nascimento='' THEN
        RAISE EXCEPTION 'Data de Nascimento é um campo obrigatorio.';
    END IF;
	
	IF validate_date_string(p_data_nascimento) IS FALSE THEN
        RAISE EXCEPTION 'Data de Nascimento inválida.';
    END IF;
	
	IF p_numero_telemovel IS NULL or p_numero_telemovel='' THEN
        RAISE EXCEPTION 'Número de telemovel é um campo obrigatorio.';
    END IF;
	
	IF LENGTH(p_numero_telemovel) <> 9 THEN
    RAISE EXCEPTION 'O Número de Telemovel deve conter exatamente 9 dígitos.';
	END IF;
	
	
	IF p_documento_validade IS NULL or p_documento_validade='' THEN
        RAISE EXCEPTION 'Data de validade do Documento de Identificação é um campo obrigatorio.';
    END IF;
	
	IF validate_date_string_validade(p_documento_validade) IS FALSE THEN
        RAISE EXCEPTION 'Data de Validade do Documento de Identificação inválida.';
    END IF;
	
	
	IF p_numero_identificacao_fiscal IS NULL or p_numero_identificacao_fiscal='' THEN
        RAISE EXCEPTION 'O Número de Identificação Fiscal é um campo obrigatorio.';
    END IF;
	
	IF LENGTH(p_numero_identificacao_fiscal) <> 9 THEN
    RAISE EXCEPTION 'O Número de Identificação Fiscal deve conter exatamente 9 dígitos.';
	END IF;
	
	
	IF p_numero_documento_identificacao IS NULL or p_numero_documento_identificacao='' THEN
        RAISE EXCEPTION 'O Número do Documento de Identificação é um campo obrigatorio.';
    END IF;
	
	IF LENGTH(p_numero_documento_identificacao) <> 9 THEN
    RAISE EXCEPTION 'O Número do Documento de Identificação deve conter exatamente 9 dígitos.';
	END IF;
	
	
	IF p_numero_seguranca_social IS NULL or p_numero_seguranca_social='' THEN
        RAISE EXCEPTION 'O Número da Segurança Social é um campo obrigatorio.';
    END IF;
	
	IF LENGTH(p_numero_seguranca_social) <> 11 THEN
    RAISE EXCEPTION 'O Número da Segurança Social deve conter exatamente 11 dígitos.';
	END IF;
	
	IF p_numero_utente_saude IS NULL or p_numero_utente_saude='' THEN
        RAISE EXCEPTION 'O Número de Utente de Saúde é um campo obrigatorio.';
    END IF;
	
	IF LENGTH(p_numero_utente_saude) <> 9 THEN
    RAISE EXCEPTION 'O Número de Utente de Saúde deve conter exatamente 9 dígitos.';
	END IF;
	
	IF p_morada IS NULL or p_morada='' THEN
        RAISE EXCEPTION 'Morada é um campo obrigatorio.';
    END IF;
	
	IF p_nr_porta IS NULL or p_nr_porta='' THEN
        RAISE EXCEPTION 'Número da porta é um campo obrigatorio.';
    END IF;
	
	IF p_nr_porta='0' THEN
        RAISE EXCEPTION 'Número da porta incorreto.';
    END IF;
	
	IF p_nr_andar IS NULL or p_nr_andar='' THEN
        p_nr_andar=NULL;
    END IF;
	
	IF  p_nr_andar!='' AND p_nr_andar='0' THEN
        RAISE EXCEPTION 'Número da piso invalido.';
    END IF;
	
	IF p_codigo_postal IS NULL or p_codigo_postal='-' THEN
        RAISE EXCEPTION 'Codigo de Postal é um campo obrigatorio.';
    END IF;
	
	IF p_codigo_postal='0000-000' or p_codigo_postal NOT SIMILAR TO '[0-9]{4}-[0-9]{3}' THEN
        RAISE EXCEPTION 'Codigo de Postal Invalido.';
    END IF;  
  
	IF p_distrito IS NULL or p_distrito='' THEN
        RAISE EXCEPTION 'Distrito é um campo obrigatorio.';
    END IF;
	
	IF p_concelho IS NULL or p_concelho='' THEN
        RAISE EXCEPTION 'Concelho é um campo obrigatorio.';
    END IF;
	
	IF p_freguesia IS NULL or p_freguesia='' THEN
        RAISE EXCEPTION 'Freguesia é um campo obrigatorio.';
    END IF;
	
	IF 	p_id_entidade_responsavel IS NULL or p_id_entidade_responsavel='' THEN
        RAISE EXCEPTION 'Centro de Saúde é um campo obrigatorio.';
    END IF;

 	IF p_tipo_documento_identificacao = 'CC' THEN
        v_tipo_documento_identificacao := 1;
    ELSIF p_tipo_documento_identificacao = 'Bilhete Indentidade' THEN
        v_tipo_documento_identificacao := 2;
    ELSIF p_tipo_documento_identificacao = 'Cedula Militar' THEN
        v_tipo_documento_identificacao := 3;
    ELSE
        RAISE EXCEPTION 'Tipo de Documento de Identificação inválido.';
    END IF;
	
	
	 IF p_justvalidate_inputs IS TRUE THEN
	
    SELECT id_entidade_responsavel INTO v_id_entidade_responsavel
    FROM EntidadeResponsavel
    WHERE nome = p_id_entidade_responsavel;

    -- Atualizar informações do Utente
    UPDATE Utente
    SET nome_completo = p_nome_completo,
        Sexo = p_sexo,
        morada = p_morada,
        nr_porta = p_nr_porta,
        nr_andar = p_nr_andar,
        codigo_postal = p_codigo_postal,
        data_nascimento = p_data_nascimento::DATE,
        distrito = p_distrito,
        concelho = p_concelho,
        freguesia = p_freguesia,
        naturalidade = p_pais_naturalidade,
        pais_nacionalidade = p_pais_nacionalidade,
        tipo_documento_identificacao = v_tipo_documento_identificacao,
        numero_de_documento_de_identificacao = p_numero_documento_identificacao,
        numero_utente_saude = p_numero_utente_saude,
        numero_de_identificacao_fiscal = p_numero_identificacao_fiscal,
        numero_de_seguranca_social = p_numero_seguranca_social,
        numero_de_telemovel = p_numero_telemovel,
        id_entidade_responsavel = v_id_entidade_responsavel,
        documento_validade = p_documento_validade::DATE
    WHERE hashed_id = p_hashed_id;
	
	END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
