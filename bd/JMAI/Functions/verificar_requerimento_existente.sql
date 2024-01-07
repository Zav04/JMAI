CREATE OR REPLACE FUNCTION verificar_requerimento_existente(p_hashed_id VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
    v_id_utente BIGINT;
BEGIN
    SELECT id_utente INTO v_id_utente
    FROM Utente
    WHERE hashed_id = p_hashed_id;

    IF v_id_utente IS NOT NULL THEN
        RETURN EXISTS (
            SELECT 1
            FROM RequerimentoJuntaMedica
            WHERE id_utente = v_id_utente AND status IN (0, 1, 2, 3, 6)
        );
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;
