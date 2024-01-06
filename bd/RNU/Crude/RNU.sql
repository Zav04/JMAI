CREATE TABLE RNU (
  id_utente                            BIGSERIAL NOT NULL, 
  nome_completo                        varchar(255) NOT NULL, 
  Sexo                                 varchar(255) NOT NULL, 
  morada                               varchar(255) NOT NULL, 
  nr_porta                             varchar(255) NOT NULL, 
  nr_andar                             varchar(255) NOT NULL, 
  codigo_postal                        varchar(255) NOT NULL, 
  data_nascimento                      date NOT NULL, 
  pais                                 varchar(255) NOT NULL, 
  distrito                             varchar(255) NOT NULL, 
  concelho                             varchar(255) NOT NULL, 
  freguesia                            varchar(255) NOT NULL, 
  tipo_documento_identificacao         BIGINT NOT NULL, 
  documento_validade                   date NOT NULL, 
  numero_de_documento_de_identificação BIGINT NOT NULL, 
  numero_utente_saude                  BIGINT NOT NULL, 
  numero_de_identificacao_fiscal       BIGINT NOT NULL, 
  numero_de_segurança_social           BIGINT NOT NULL, 
  numero_de_telemovel                  BIGINT NOT NULL, 
  obito                                bool NOT NULL, 
  id_entidade_responsavel              BIGINT NOT NULL, 
  PRIMARY KEY (id_utente));


CREATE TABLE EntidadeResponsavel (
  id_entidade_responsavel BIGSERIAL NOT NULL, 
  nome                    varchar(255) NOT NULL, 
  codigo                  BIGINT NOT NULL, 
  descricao               varchar(255), 
  pais                    varchar(255) NOT NULL, 
  PRIMARY KEY (id_entidade_responsavel));
  
 
ALTER TABLE RNU
ADD FOREIGN KEY (id_entidade_responsavel) REFERENCES EntidadeResponsavel(id_entidade_responsavel);
