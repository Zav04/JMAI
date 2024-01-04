CREATE OR REPLACE FUNCTION get_utente_info(p_hashed_id VARCHAR)
RETURNS TABLE(
    hashed_id VARCHAR, 
    email VARCHAR, 
    nome_completo VARCHAR, 
    sexo VARCHAR, 
    morada VARCHAR, 
    nr_porta VARCHAR,
    nr_andar VARCHAR, 
    codigo_postal VARCHAR,
    data_nascimento DATE,
    distrito VARCHAR, 
    concelho VARCHAR, 
    freguesia VARCHAR, 
    naturalidade VARCHAR, 
    pais_nacionalidade VARCHAR, 
    tipo_documento_identificacao BIGINT,
    numero_de_documento_de_identificacao VARCHAR, 
    numero_utente_saude VARCHAR, 
    numero_identificacao_fiscal VARCHAR, 
    numero_seguranca_social VARCHAR, 
    documento_validade DATE, 
    numero_telemovel VARCHAR, 
    nome_entidade_responsavel VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT ut.hashed_id, u.email, ut.nome_completo, ut.Sexo, ut.morada, ut.nr_porta,
           ut.nr_andar, ut.codigo_postal, ut.data_nascimento, ut.distrito, ut.concelho,
           ut.freguesia, ut.naturalidade, ut.pais_nacionalidade, ut.tipo_documento_identificacao, 
           ut.numero_de_documento_de_identificacao, ut.numero_utente_saude, ut.numero_de_identificacao_fiscal, 
           ut.numero_de_seguranca_social, ut.documento_validade, ut.numero_de_telemovel, er.nome
    FROM Utente ut
    INNER JOIN Utilizador u ON ut.id_utilizador = u.id_utilizador
    LEFT JOIN EntidadeResponsavel er ON ut.id_entidade_responsavel = er.id_entidade_responsavel
    WHERE u.hashed_id = p_hashed_id;
END;
$$ LANGUAGE plpgsql;


