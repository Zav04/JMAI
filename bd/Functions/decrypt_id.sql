CREATE OR REPLACE FUNCTION decrypt_id(encrypted_value BYTEA)
RETURNS TEXT AS $$
DECLARE
  secret_key TEXT := 'JMAI_CRYPT';
BEGIN
  RETURN pgp_sym_decrypt(encrypted_value, secret_key);
END;
$$ LANGUAGE plpgsql;


--SELECT decrypt_id(
--'\xc30d0407030241f6d4d4bd0cd8437fd23201d87e5f0dcaa116d468993e99899e1d82147b2fa7f4edeb0cbb194e4f29e6aa71ba6916c7ba6e0508d8037e24bd0d7b7908')