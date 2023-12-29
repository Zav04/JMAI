CREATE OR REPLACE FUNCTION validate_date_string(date_string VARCHAR) RETURNS BOOLEAN AS $$
DECLARE
  v_day INT;
  v_month INT;
  v_year INT;
BEGIN
  -- Verificar o formato usando expressão regular
  IF date_string ~ '^\d{2}-\d{2}-\d{4}$' THEN
    -- Extrair dia, mês e ano da string
    v_day := CAST(SPLIT_PART(date_string, '-', 1) AS INT);
    v_month := CAST(SPLIT_PART(date_string, '-', 2) AS INT);
    v_year := CAST(SPLIT_PART(date_string, '-', 3) AS INT);

    -- Verificar se os valores de dia, mês e ano estão dentro dos intervalos permitidos
    IF v_day >= 1 AND v_day <= 31 AND v_month >= 1 AND v_month <= 12 AND v_year <= 2110 THEN
      -- Verificar se a data é válida (considerando meses com 30 dias, fevereiro e ano bissexto)
      RETURN (v_month IN (1, 3, 5, 7, 8, 10, 12) OR
             (v_month IN (4, 6, 9, 11) AND v_day <= 30) OR
             (v_month = 2 AND v_day <= 28) OR
             (v_month = 2 AND v_day = 29 AND ((v_year % 4 = 0 AND v_year % 100 <> 0) OR v_year % 400 = 0)));
    END IF;
  END IF;

  -- Se o formato não corresponder ou os valores estiverem fora dos intervalos
  RETURN FALSE;
END;
$$ LANGUAGE plpgsql;
