-- Criação da função
CREATE OR REPLACE FUNCTION recusar_requerimento(p_hashed_id VARCHAR(255))
RETURNS BOOL AS $$
BEGIN
  -- Atualiza o status do requerimento
  UPDATE RequerimentoJuntaMedica
  SET status = 7
  WHERE hashed_id = p_hashed_id;
  RETURN TRUE;
  
END;
$$ LANGUAGE plpgsql;

