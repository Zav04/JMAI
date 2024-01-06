CREATE OR REPLACE FUNCTION validate_date_string_validade(date_string VARCHAR) RETURNS BOOLEAN AS $$
DECLARE
  v_day INT;
  v_month INT;
  v_year INT;
  v_input_date DATE;
  v_today DATE := CURRENT_DATE;
  v_min_date DATE := v_today + INTERVAL '30 days';
BEGIN
  -- Verificar o formato usando expressão regular
  IF date_string ~ '^\d{2}-\d{2}-\d{4}$' THEN
    -- Extrair dia, mês e ano da string
    v_day := CAST(SPLIT_PART(date_string, '-', 1) AS INT);
    v_month := CAST(SPLIT_PART(date_string, '-', 2) AS INT);
    v_year := CAST(SPLIT_PART(date_string, '-', 3) AS INT);

    -- Verificação imediata dos valores extraídos
    IF v_day < 1 OR v_day > 31 THEN
      RAISE EXCEPTION 'Validade Identificação - Dia inválido: %.', v_day;
    ELSIF v_month < 1 OR v_month > 12 THEN
      RAISE EXCEPTION 'Validade Identificação - Mês inválido: %.', v_month;
    ELSIF v_year > 2110 THEN
      RAISE EXCEPTION 'Validade Identificação - Ano inválido: %.', v_year;
    END IF;

    -- Converter string para data
    v_input_date := TO_DATE(date_string, 'DD-MM-YYYY');

    -- Verificação adicional de consistência da data
    IF NOT (v_month IN (1, 3, 5, 7, 8, 10, 12) AND v_day <= 31 OR
            v_month IN (4, 6, 9, 11) AND v_day <= 30 OR
            v_month = 2 AND v_day <= 28 OR
            v_month = 2 AND v_day = 29 AND v_year % 4 = 0 AND (v_year % 100 <> 0 OR v_year % 400 = 0)) THEN
      RAISE EXCEPTION 'A Data Validade Identificação inválida: %.', date_string;
    END IF;

    -- Verificar se a data é pelo menos 30 dias após a data atual
    IF v_input_date < v_min_date THEN
      RAISE EXCEPTION 'A data Validade Identificação deve ser no mínimo 30 dias após a data atual.';
    END IF;

    RETURN TRUE;
  ELSE
    RAISE EXCEPTION 'Formato de data Validade Identificação inválido: %.', date_string;
  END IF;
END;
$$ LANGUAGE plpgsql;

--SELECT validate_date_string('42-02-2025')
