--CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION hash_id()
RETURNS TRIGGER AS $$
DECLARE
  primary_key_name TEXT;
  primary_key_value BIGINT;
  secret_key TEXT := 'JMAI_CRYPT'; -- Esta é a chave de criptografia
BEGIN
  primary_key_name := TG_ARGV[0]; -- Obtém o nome da coluna da chave primária como argumento

  -- Obtém o valor da chave primária diretamente de NEW
  EXECUTE format('SELECT ($1).%I', primary_key_name)
  INTO primary_key_value
  USING NEW;


  -- Atualiza o encrypted_id com base no valor da chave primária
  EXECUTE format('UPDATE %I SET hashed_id = %L WHERE %I = $1',
                 TG_TABLE_NAME,
                 pgp_sym_encrypt(primary_key_value::text, secret_key),
                 primary_key_name)
  USING primary_key_value;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE TRIGGER hash_id_before_insert_medico
AFTER INSERT ON Medico
FOR EACH ROW EXECUTE FUNCTION hash_id('id_medico');

CREATE OR REPLACE TRIGGER hash_id_before_insert_utilizador
AFTER INSERT ON Utilizador
FOR EACH ROW EXECUTE FUNCTION hash_id('id_utilizador');

CREATE OR REPLACE TRIGGER hash_id_before_insert_secretarios_clinicos
AFTER INSERT ON Secretarios_Clinicos
FOR EACH ROW EXECUTE FUNCTION hash_id('id_secretarios_clinicos');

CREATE OR REPLACE TRIGGER hash_id_before_insert_Agendamento_JuntaMedica
AFTER INSERT ON Agendamento_JuntaMedica
FOR EACH ROW EXECUTE FUNCTION hash_id('id_agendamento_junta_medica');

CREATE OR REPLACE TRIGGER hash_id_before_insert_RequerimentoJuntaMedica
AFTER INSERT ON RequerimentoJuntaMedica
FOR EACH ROW EXECUTE FUNCTION hash_id('id_requerimento_junta_medica');

CREATE OR REPLACE TRIGGER hash_id_before_insert_PreAvaliacao
AFTER INSERT ON PreAvaliacao
FOR EACH ROW EXECUTE FUNCTION hash_id('id_pre_avaliacao');

CREATE OR REPLACE TRIGGER hash_id_before_insert_JuntaMedica
AFTER INSERT ON JuntaMedica
FOR EACH ROW EXECUTE FUNCTION hash_id('id_junta_medica');

CREATE OR REPLACE TRIGGER hash_id_before_insert_Cargo
AFTER INSERT ON Cargo
FOR EACH ROW EXECUTE FUNCTION hash_id('id_cargo');

CREATE OR REPLACE TRIGGER hash_id_before_insert_Especialidade
AFTER INSERT ON Especialidade
FOR EACH ROW EXECUTE FUNCTION hash_id('id_especialidade');

CREATE OR REPLACE TRIGGER hash_id_before_entidade_responsavel
AFTER INSERT ON EntidadeResponsavel
FOR EACH ROW EXECUTE FUNCTION hash_id('id_entidade_responsavel');
