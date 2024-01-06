CREATE OR REPLACE FUNCTION obter_dados_utente(numero_utente BIGINT)
RETURNS TABLE(
    nome_completo VARCHAR, 
    Sexo VARCHAR, 
    morada VARCHAR, 
    nr_porta VARCHAR, 
    nr_andar VARCHAR, 
    codigo_postal VARCHAR, 
    data_nascimento DATE, 
    pais VARCHAR, 
    distrito VARCHAR, 
    concelho VARCHAR, 
    freguesia VARCHAR, 
    tipo_documento_identificacao BIGINT, 
    documento_validade DATE, 
    numero_de_documento_de_identificação BIGINT, 
    numero_utente_saude BIGINT, 
    numero_de_identificacao_fiscal BIGINT, 
    numero_de_segurança_social BIGINT, 
    numero_de_telemovel BIGINT, 
    obito BOOLEAN, 
    nome_entidade_responsavel VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        R.nome_completo, 
        R.Sexo, 
        R.morada, 
        R.nr_porta, 
        R.nr_andar, 
        R.codigo_postal, 
        R.data_nascimento, 
        R.pais, 
        R.distrito, 
        R.concelho, 
        R.freguesia, 
        R.tipo_documento_identificacao, 
        R.documento_validade, 
        R.numero_de_documento_de_identificação, 
        R.numero_utente_saude, 
        R.numero_de_identificacao_fiscal, 
        R.numero_de_segurança_social, 
        R.numero_de_telemovel, 
        R.obito, 
        ER.nome
    FROM RNU R
    LEFT JOIN EntidadeResponsavel ER ON R.id_entidade_responsavel = ER.id_entidade_responsavel
    WHERE R.numero_utente_saude = numero_utente;
END;
$$ LANGUAGE plpgsql;


--SELECT obter_dados_utente(123456789)