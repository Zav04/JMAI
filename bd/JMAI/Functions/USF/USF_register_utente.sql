CREATE OR REPLACE FUNCTION USF_register_utente(
p_email VARCHAR(255),
p_password VARCHAR(255),
p_numero_utente_saude VARCHAR(255),
p_justvalidation_inputs BOOL
) RETURNS BIGINT AS $$
DECLARE
  v_id_utilizador BIGINT;
  v_morada_completa TEXT;
  v_id_entidade_responsavel BIGINT;
  v_tipo_documento_identificacao BIGINT;
  v_numero_utente_NSS BIGINT;
BEGIN
	
	IF p_numero_utente_saude IS NULL or p_numero_utente_saude='' THEN
        RAISE EXCEPTION 'O Número de Utente de Saúde é um campo obrigatorio.';
    END IF;
	
	IF LENGTH(p_numero_utente_saude) <> 9 THEN
    RAISE EXCEPTION 'O Número de Utente de Saúde deve conter exatamente 9 dígitos.';
	END IF;
	
	v_numero_utente_NSS:=p_numero_utente_saude::BIGINT;

	IF verificar_numero_utente_existente(v_numero_utente_NSS) THEN
	   RAISE EXCEPTION 'O Número de Utente de Saúde ja esta registada.';
    END IF;
	
	IF is_email_valid(p_email) IS FALSE THEN
        RAISE EXCEPTION 'Email não é valido';
    END IF;
	
    IF email_exists(p_email) IS TRUE THEN
        RAISE EXCEPTION 'Email já está registado';
    END IF;

    IF p_password IS NULL OR p_password = '' THEN
        RAISE EXCEPTION 'Password é um campo obrigatorio.';
    END IF;
	
	IF  LENGTH(p_password) < 6 THEN
        RAISE EXCEPTION 'Password tem de ter no minimo 6 carateres.';
    END IF;
	
	
  IF p_justvalidation_inputs= FALSE THEN
  INSERT INTO Utilizador(email, id_cargo)
  VALUES (p_email, 1) 
  RETURNING id_utilizador INTO v_id_utilizador;
  
    INSERT INTO Utente(
    id_utilizador,
    numero_utente_saude       
  ) VALUES (
    v_id_utilizador,
    v_numero_utente_NSS
  );
 END IF;

RETURN v_id_utilizador;
END;
$$ LANGUAGE plpgsql;