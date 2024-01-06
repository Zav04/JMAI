CREATE OR REPLACE FUNCTION register_medico(
    p_nome_completo VARCHAR(255),
    p_data_nascimento VARCHAR(255),
    p_numero_telemovel VARCHAR(255),
    p_sexo VARCHAR(255),
    p_pais_nacionalidade VARCHAR(255),
    p_distrito VARCHAR(255),
    p_concelho VARCHAR(255),
    p_freguesia VARCHAR(255),
    p_especialidade VARCHAR(255),
    p_num_cedula VARCHAR(255),
    p_num_ordem VARCHAR(255),
    p_email VARCHAR(255),
    p_password VARCHAR(255),
    p_justvalidate_inputs BOOL
) RETURNS BOOL AS $$
DECLARE
    v_id_utilizador BIGINT;
	 v_id_especialidade BIGINT;
	 v_p_num_cedula BIGINT;
	 v_p_num_ordem BIGINT;
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
	
	IF p_num_cedula IS NULL or p_num_cedula='' THEN
        RAISE EXCEPTION 'Número da Cedula de Médico é um campo obrigatorio.';
    END IF;
	
	IF LENGTH(p_num_cedula) <> 9 THEN
    RAISE EXCEPTION 'O Número da Cedula de Médico deve conter exatamente 9 dígitos.';
	END IF;
	
	IF p_num_ordem IS NULL or p_num_ordem='' THEN
        RAISE EXCEPTION 'Número da Ordem de Médico é um campo obrigatorio.';
    END IF;
	
	IF LENGTH(p_num_ordem) <> 5 THEN
    RAISE EXCEPTION 'O Número da Ordem de Médico deve conter exatamente 5 dígitos.';
	END IF;
	
	IF p_especialidade IS NULL or p_especialidade='' THEN
        RAISE EXCEPTION 'Especialidade é um campo obrigatorio.';
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
	
	IF LENGTH(p_password) < 6 THEN
    	RAISE EXCEPTION 'Password tem de ter no minimo 6 caracteres.';
	END IF;
	
	 IF p_justvalidate_inputs IS FALSE THEN
	v_p_num_cedula:=p_num_cedula::BIGINT;
	v_p_num_ordem:=p_num_ordem::BIGINT;
	
-- Procurar o id da especialidade pelo nome
    SELECT id_especialidade INTO v_id_especialidade
    FROM Especialidade
    WHERE especialidade = p_especialidade;


    -- Inserir o usuário na tabela de usuários
    INSERT INTO Utilizador(email, id_cargo)
    VALUES (p_email, 3) -- assumindo que o id_cargo para médicos seja 3
    RETURNING id_utilizador INTO v_id_utilizador;

        -- Inserir o médico na tabela de médicos
       INSERT INTO Medico(
    id_utilizador,
    nome_medico,
    num_cedula,
    num_ordem,
    id_especialidade,
    contacto,
    data_nascimento,
    sexo,
    pais,
    distrito,
    concelho,
    freguesia,
    pais_nacionalidade
) VALUES (
    v_id_utilizador,
    p_nome_completo,
    v_p_num_cedula,
    v_p_num_ordem,
    v_id_especialidade,
    p_numero_telemovel,
    p_data_nascimento,
    p_sexo,
    'Portugal', -- Supondo que o campo 'pais' seja sempre Portugal
    p_distrito,
    p_concelho,
    p_freguesia,
    p_pais_nacionalidade
);
    END IF;
    -- Retornar verdadeiro se a inserção for bem-sucedida
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


