CREATE OR REPLACE FUNCTION get_user_info(user_email VARCHAR)
RETURNS TABLE(hashed_id VARCHAR, cargo_name VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT u.hashed_id, c.cargo
    FROM Utilizador AS u
    JOIN Cargo AS c ON u.id_cargo = c.id_cargo
    WHERE u.email = user_email;
END;
$$ LANGUAGE plpgsql;