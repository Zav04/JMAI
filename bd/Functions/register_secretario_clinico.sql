CREATE OR REPLACE FUNCTION register_secretario_clinico(
    p_nome_completo VARCHAR(255),
    p_data_nascimento VARCHAR(255),
    p_numero_telemovel VARCHAR(255),
    p_sexo VARCHAR(255),
    p_pais_nacionalidade VARCHAR(255),
    p_distrito VARCHAR(255),
    p_concelho VARCHAR(255),
    p_freguesia VARCHAR(255),
    p_email VARCHAR(255),
    p_password VARCHAR(255),
    p_justvalidate_input BOOL
) RETURNS BOOL AS $$
DECLARE
    v_id_utilizador BIGINT;
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
	
	IF p_distrito IS NULL or p_distrito='' THEN
        RAISE EXCEPTION 'Distrito é um campo obrigatorio.';
    END IF;
	
	IF p_concelho IS NULL or p_concelho='' THEN
        RAISE EXCEPTION 'Concelho é um campo obrigatorio.';
    END IF;
	
	IF p_freguesia IS NULL or p_freguesia='' THEN
        RAISE EXCEPTION 'Freguesia é um campo obrigatorio.';
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
	
	IF  LENGTH(p_password) < 6 THEN
        RAISE EXCEPTION 'Password tem de ter no minimo 6 carateres.';
    END IF;

    IF p_justvalidate_input IS TRUE THEN
        -- Inserir dados na tabela de utilizadores
        INSERT INTO Utilizador(email, id_cargo)
        VALUES (p_email, 2)
        RETURNING id_utilizador INTO v_id_utilizador;

        -- Inserir dados na tabela de Secretários Clínicos
        INSERT INTO Secretarios_Clinicos(
            id_utilizador,
            nome_secreatario_clinico,
            sexo,
			pais,
            data_nascimento,
            distrito,
            concelho,
            freguesia,
            pais_nacionalidade,
            contacto
        ) VALUES (
            v_id_utilizador,
            p_nome_completo,
            p_sexo,
			'Portugal',
            p_data_nascimento,
            p_distrito,
            p_concelho,
            p_freguesia,
            p_pais_nacionalidade,
            p_numero_telemovel
        );
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

