CREATE OR REPLACE FUNCTION register_utente(
  p_email VARCHAR(255),
p_password VARCHAR(255),
  p_nome_completo VARCHAR(255),
  p_sexo VARCHAR(255),
  p_morada VARCHAR(255),
	p_nr_porta VARCHAR(255),
	p_nr_andar VARCHAR(255),
	p_codigo_postal VARCHAR(255),
  p_data_nascimento VARCHAR(255),
  p_pais VARCHAR(255),
  p_distrito VARCHAR(255),
  p_concelho VARCHAR(255),
  p_freguesia VARCHAR(255),
  p_naturalidade VARCHAR(255),
  p_pais_nacionalidade VARCHAR(255),
  p_tipo_documento_identificacao VARCHAR(255),
  p_numero_de_documento_de_identificacao VARCHAR(255),
  p_numero_utente_saude VARCHAR(255),
  p_numero_de_identificacao_fiscal VARCHAR(255),
  p_numero_de_seguranca_social VARCHAR(255),
  p_numero_de_telemovel VARCHAR(255),
  p_id_entidade_responsavel VARCHAR(255),
  p_documento_validade VARCHAR(255)
) RETURNS BOOL AS $$
DECLARE
  v_id_utilizador BIGINT;
  v_morada_completa TEXT;
  v_id_entidade_responsavel BIGINT;
BEGIN


	IF p_nome_completo IS NULL OR p_nome_completo = '' THEN
        RAISE EXCEPTION 'Nome é um campo obrigatorio.';
    END IF;
	
	IF p_data_nascimento IS NULL or p_data_nascimento='' THEN
        RAISE EXCEPTION 'Data de Nascimento é um campo obrigatorio.';
    END IF;
	
	IF validate_date_string(p_data_nascimento) IS FALSE THEN
        RAISE EXCEPTION 'Data de Nascimento inválida.';
    END IF;
	
	IF p_numero_de_telemovel IS NULL or p_numero_de_telemovel='' THEN
        RAISE EXCEPTION 'Número de telemovel é um campo obrigatorio.';
    END IF;
	
	IF LENGTH(p_numero_de_telemovel) <> 9 THEN
    RAISE EXCEPTION 'O Número de Telemovel deve conter exatamente 9 dígitos.';
	END IF;
	
	
	IF p_documento_validade IS NULL or p_documento_validade='' THEN
        RAISE EXCEPTION 'Data de validade do Documento de Identificação é um campo obrigatorio.';
    END IF;
	
	IF validate_date_string(p_documento_validade) IS FALSE THEN
        RAISE EXCEPTION 'Data de Validade do Documento de Identificação inválida.';
    END IF;
	
	
	IF p_numero_de_identificacao_fiscal IS NULL or p_numero_de_identificacao_fiscal='' THEN
        RAISE EXCEPTION 'O Número de Identificação Fiscal é um campo obrigatorio.';
    END IF;
	
	IF LENGTH(p_numero_de_identificacao_fiscal) <> 9 THEN
    RAISE EXCEPTION 'O Número de Identificação Fiscal deve conter exatamente 9 dígitos.';
	END IF;
	
	
	IF p_numero_de_documento_de_identificacao IS NULL or p_numero_de_documento_de_identificacao='' THEN
        RAISE EXCEPTION 'O Número do Documento de Identificação é um campo obrigatorio.';
    END IF;
	
	IF LENGTH(p_numero_de_documento_de_identificacao) <> 9 THEN
    RAISE EXCEPTION 'O Número do Documento de Identificação deve conter exatamente 9 dígitos.';
	END IF;
	
	
	IF p_numero_de_seguranca_social IS NULL or p_numero_de_seguranca_social='' THEN
        RAISE EXCEPTION 'O Número da Segurança Social é um campo obrigatorio.';
    END IF;
	
	IF LENGTH(p_numero_de_seguranca_social) <> 11 THEN
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
	
	IF p_nr_porta IS NULL THEN
        RAISE EXCEPTION 'Número da porta é um campo obrigatorio.';
    END IF;
	
	IF p_nr_porta=0 THEN
        RAISE EXCEPTION 'Número da porta incorreto.';
    END IF;
	
	IF p_nr_andar IS NULL THEN
        p_nr_andar=NULL;
    END IF;
	
	IF p_nr_andar <> NULL AND p_nr_andar=0 THEN
        RAISE EXCEPTION 'Número da piso invalido.';
    END IF;
	
	IF p_codigo_postal IS NULL or p_codigo_postal='-' THEN
        RAISE EXCEPTION 'Codigo de Postal é um campo obrigatorio.';
    END IF;
	
	IF p_codigo_postal='0000-000' or p_codigo_postal NOT SIMILAR TO '[0-9]{4}-[0-9]{3}' THEN
        RAISE EXCEPTION 'Codigo de Postal Invalido.';
    END IF;
	
v_morada_completa := CONCAT_WS(' ',
    NULLIF(p_morada, ''),        
    NULLIF(p_nr_porta, ''),
    NULLIF(p_nr_andar, ''),
    NULLIF(p_codigo_postal, '')
  );
  
  
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

	
	IF is_email_valid(p_email) IS FALSE THEN
        RAISE EXCEPTION 'Email não é valido';
    END IF;
	
	    -- Verifica se os email é valido
    IF email_exists(p_email) IS TRUE THEN
        RAISE EXCEPTION 'Email já está registado';
    END IF;

    IF p_password IS NULL OR p_password = '' THEN
        RAISE EXCEPTION 'Password é um campo obrigatorio.';
    END IF;


  INSERT INTO Utilizador(email, id_cargo)
  VALUES (p_email, 1) 
  RETURNING id_utilizador INTO v_id_utilizador;
  
  
  
  
  -- Procurar o id da entidade responsável pelo nome
  SELECT id_entidade_responsavel INTO v_id_entidade_responsavel
  FROM EntidadeResponsavel
  WHERE nome = p_nome_entidade_responsavel;
  
  INSERT INTO Utente(
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
    id_entidade_responsavel,
    obito,
    documento_validade
  ) VALUES (
    v_id_utilizador,
    p_nome_completo,
    p_sexo,
    p_morada,
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
    v_id_entidade_responsavel,
    FALSE, 
    p_documento_validade
  );

RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
