CREATE OR REPLACE FUNCTION verificar_utente_existente(numero_utente BIGINT)
RETURNS BOOLEAN AS $$
DECLARE
    existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM Utente WHERE numero_utente_saude = numero_utente) INTO existe;

    RETURN existe;
END;
$$ LANGUAGE plpgsql;


