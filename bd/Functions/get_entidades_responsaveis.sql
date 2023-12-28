CREATE OR REPLACE FUNCTION get_entidades_responsaveis()
RETURNS TABLE (nomes varchar(255))
AS $$
BEGIN
  RETURN QUERY
  SELECT nome FROM EntidadeResponsavel;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE Utilizador
DROP password

--SELECT get_entidades_responsaveis()