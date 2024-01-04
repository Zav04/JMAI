-- Criação da função
CREATE OR REPLACE FUNCTION validar_requerimento(p_hashed_id VARCHAR(255))
RETURNS BOOL AS $$
BEGIN
  -- Atualiza o status do requerimento
  UPDATE RequerimentoJuntaMedica
  SET status = 1
  WHERE RequerimentoJuntaMedica.hashed_id = validar_requerimento.p_hashed_id;
RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION validar_requerimento(character varying)


