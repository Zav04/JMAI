CREATE OR REPLACE FUNCTION get_user_info(user_email VARCHAR)
RETURNS TABLE(hashed_id VARCHAR, cargo_name VARCHAR, nss BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT u.hashed_id, c.cargo, ut.numero_utente_saude
    FROM Utilizador AS u
    JOIN Cargo AS c ON u.id_cargo = c.id_cargo
    LEFT JOIN Utente AS ut ON u.id_utilizador = ut.id_utilizador
    WHERE u.email = user_email;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION get_user_info(character varying)

--SELECT get_user_info('bruno.bx04@gmail.com')