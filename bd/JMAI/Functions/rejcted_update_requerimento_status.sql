CREATE OR REPLACE FUNCTION rejcted_update_requerimento_status(p_hashed_id VARCHAR)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE RequerimentoJuntaMedica
    SET status = 5
    WHERE hashed_id = p_hashed_id;

    IF FOUND THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

