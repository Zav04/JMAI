CREATE OR REPLACE FUNCTION get_all_especialidades()
RETURNS TABLE(nome_especialidade VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT especialidade
    FROM Especialidade;
END;
$$ LANGUAGE plpgsql;
