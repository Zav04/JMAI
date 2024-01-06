CREATE OR REPLACE FUNCTION verificar_requerimento_existente(p_hashed_id VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
    v_id_utente BIGINT;
BEGIN
    -- Encontrar o id_utente correspondente ao hashed_id fornecido
    SELECT id_utente INTO v_id_utente
    FROM Utente
    WHERE hashed_id = p_hashed_id;

    -- Se o id_utente foi encontrado, verifica se existem requerimentos com status 0, 1, 2 ou 3
    IF v_id_utente IS NOT NULL THEN
        RETURN EXISTS (
            SELECT 1
            FROM RequerimentoJuntaMedica
            WHERE id_utente = v_id_utente AND status IN (0, 1, 2, 3)
        );
    ELSE
        -- Se o id_utente não for encontrado, retorna FALSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;
