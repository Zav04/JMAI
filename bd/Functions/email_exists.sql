--Validar se existe email na base de dados
CREATE OR REPLACE FUNCTION email_exists(input_email VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
    exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM Utilizador WHERE email = input_email) INTO exists;
    RETURN exists;
END;
$$ LANGUAGE plpgsql;

	--SELECT email_exists('bruno.bx04@gmail.com')


	--DELETE FROM Utente;
	--DELETE FROM Utilizador;
	--WHERE email = 'bruno.bx04@gmail.com';