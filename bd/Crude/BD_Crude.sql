  CREATE TABLE Utente (
  id_utente                             BIGSERIAL NOT NULL, 
  hashed_id                             VARCHAR(255) UNIQUE, 
  id_utilizador                         BIGINT NOT NULL UNIQUE, 
  nome_completo                         VARCHAR(255) NOT NULL, 
  Sexo                                  VARCHAR(255) NOT NULL, 
  morada                                VARCHAR(255) NOT NULL, 
  data_nascimento                       VARCHAR(255) NOT NULL, 
  pais                                  VARCHAR(255) NOT NULL, 
  distrito                             VARCHAR(255) NOT NULL UNIQUE, 
  concelho                             VARCHAR(255) NOT NULL UNIQUE, 
  freguesia                            VARCHAR(255) NOT NULL UNIQUE, 
  naturalidade                          VARCHAR(255) NOT NULL, 
  pais_nacionalidade                    VARCHAR(255) NOT NULL, 
  tipo_documento_identificacao          BIGINT NOT NULL, 
  numero_de_documento_de_identificacao  VARCHAR(255) NOT NULL, 
  numero_utente_saude                   VARCHAR(255) NOT NULL, 
  numero_de_identificacao_fiscal        VARCHAR(255) NOT NULL, 
  numero_de_seguranca_social            VARCHAR(255) NOT NULL, 
  numero_de_telemovel                   VARCHAR(255) NOT NULL, 
  obito                                 BOOLEAN NOT NULL, 
  id_entidade_responsavel               BIGINT NOT NULL UNIQUE, 
  PRIMARY KEY (id_utente)
);
  
  
CREATE TABLE Utilizador (
  id_utilizador BIGSERIAL NOT NULL, 
  hashed_id     VARCHAR(255) UNIQUE, 
  email         VARCHAR(255) NOT NULL UNIQUE, 
  id_cargo      BIGINT NOT NULL, 
  PRIMARY KEY (id_utilizador));
  
  
CREATE TABLE Secretarios_Clinicos (
  id_secretarios_clinicos  BIGSERIAL NOT NULL, 
  hashed_id                VARCHAR(255) UNIQUE, 
  id_utilizador            BIGINT NOT NULL UNIQUE, 
  nome_secreatario_clinico VARCHAR(255) NOT NULL, 
  contacto                 VARCHAR(255) NOT NULL, 
  data_nascimento          VARCHAR(255) NOT NULL, 
  sexo                     VARCHAR(255) NOT NULL, 
  pais                     VARCHAR(255) NOT NULL, 
  distrito                 VARCHAR(255) NOT NULL, 
  concelho                 VARCHAR(255) NOT NULL, 
  freguesia                VARCHAR(255) NOT NULL, 
  pais_nacionalidade       VARCHAR(255) NOT NULL, 
  PRIMARY KEY (id_secretarios_clinicos));
  
  
CREATE TABLE Agendamento_JuntaMedica (
  id_agendamento_junta_medica BIGSERIAL NOT NULL, 
  hashed_id                   VARCHAR(255) UNIQUE, 
  id_pre_avaliacao            BIGINT NOT NULL UNIQUE, 
  data                        date NOT NULL, 
  status                      BIGINT NOT NULL, 
  PRIMARY KEY (id_agendamento_junta_medica));
  
  
CREATE TABLE RequerimentoJuntaMedica (
  id_requerimento_junta_medica BIGSERIAL NOT NULL, 
  hashed_id                    VARCHAR(255) UNIQUE, 
  id_utente                    BIGINT NOT NULL UNIQUE, 
  data_submissao               date NOT NULL, 
  documentos                   VARCHAR(255), 
  status                       BIGINT NOT NULL, 
  observacoes                  VARCHAR(255), 
  type                         BIGINT NOT NULL, 
  PRIMARY KEY (id_requerimento_junta_medica));
  
  
CREATE TABLE PreAvaliacao (
  id_pre_avaliacao             BIGSERIAL NOT NULL, 
  hashed_id                    VARCHAR(255) UNIQUE, 
  id_medico                    BIGINT NOT NULL UNIQUE, 
  id_requerimento_junta_medica BIGINT NOT NULL UNIQUE, 
  pre_avaliacao                float4 NOT NULL, 
  observacoes                  VARCHAR(255), 
  data_pre_avaliacao           date NOT NULL, 
  PRIMARY KEY (id_pre_avaliacao));
  
  
CREATE TABLE JuntaMedica (
  id_junta_medica             BIGSERIAL NOT NULL, 
  hashed_id                   VARCHAR(255) UNIQUE, 
  id_agendamento_junta_medica BIGINT NOT NULL UNIQUE, 
  resultado                   float4 NOT NULL, 
  observacoes                 VARCHAR(255), 
  PRIMARY KEY (id_junta_medica));
  
  
CREATE TABLE Medicos_JuntaMedica (
  id_medicos_junta_medica BIGSERIAL NOT NULL, 
  id_medico               BIGINT NOT NULL UNIQUE, 
  id_junta_medica         BIGINT NOT NULL UNIQUE, 
  PRIMARY KEY (id_medicos_junta_medica));
  
  
CREATE TABLE Cargo (
  id_cargo  SERIAL NOT NULL, 
  hashed_id VARCHAR(255) UNIQUE, 
  cargo     VARCHAR(255) NOT NULL UNIQUE, 
  PRIMARY KEY (id_cargo));
  
  
CREATE TABLE Especialidade (
  id_especialidade BIGSERIAL NOT NULL, 
  hashed_id        VARCHAR(255) UNIQUE, 
  especialidade    VARCHAR(255) NOT NULL, 
  PRIMARY KEY (id_especialidade));
  
  
CREATE TABLE Medico (
  id_medico          BIGSERIAL NOT NULL, 
  hashed_id          VARCHAR(255) UNIQUE, 
  id_utilizador      BIGINT NOT NULL, 
  nome_medico        VARCHAR(255) NOT NULL, 
  num_cedula         BIGINT NOT NULL, 
  num_ordem          BIGINT NOT NULL, 
  id_especialidade   BIGINT NOT NULL UNIQUE, 
  contacto           VARCHAR(255) NOT NULL, 
  data_nascimento    VARCHAR(255) NOT NULL, 
  sexo               VARCHAR(255) NOT NULL, 
  pais               VARCHAR(255) NOT NULL, 
  distrito           VARCHAR(255) NOT NULL, 
  concelho           VARCHAR(255) NOT NULL, 
  freguesia          VARCHAR(255) NOT NULL, 
  pais_nacionalidade VARCHAR(255) NOT NULL, 
  PRIMARY KEY (id_medico));
  
  
CREATE TABLE EntidadeResponsavel (
  id_entidade_responsavel BIGSERIAL NOT NULL, 
  hashed_id               VARCHAR(255) UNIQUE, 
  nome                    VARCHAR(255) NOT NULL, 
  codigo                  BIGINT NOT NULL, 
  descricao               VARCHAR(255), 
  pais                    VARCHAR(255) NOT NULL, 
  PRIMARY KEY (id_entidade_responsavel));
  
ALTER TABLE Utente ADD COLUMN documento_validade DATE;
ALTER TABLE PreAvaliacao ADD CONSTRAINT FKPreAvaliac576859 FOREIGN KEY (id_requerimento_junta_medica) REFERENCES RequerimentoJuntaMedica (id_requerimento_junta_medica);
ALTER TABLE Agendamento_JuntaMedica ADD CONSTRAINT FKAgendament432865 FOREIGN KEY (id_pre_avaliacao) REFERENCES PreAvaliacao (id_pre_avaliacao);
ALTER TABLE Utilizador ADD CONSTRAINT FKUtilizador366594 FOREIGN KEY (id_cargo) REFERENCES Cargo (id_cargo);
ALTER TABLE Utente ADD CONSTRAINT FKUtente144280 FOREIGN KEY (id_utilizador) REFERENCES Utilizador (id_utilizador);
ALTER TABLE RequerimentoJuntaMedica ADD CONSTRAINT FKRequerimen659813 FOREIGN KEY (id_utente) REFERENCES Utente (id_utente);
ALTER TABLE Secretarios_Clinicos ADD CONSTRAINT FKSecretario86786 FOREIGN KEY (id_utilizador) REFERENCES Utilizador (id_utilizador);
ALTER TABLE PreAvaliacao ADD CONSTRAINT FKPreAvaliac965856 FOREIGN KEY (id_medico) REFERENCES Medico (id_medico);
ALTER TABLE Medico ADD CONSTRAINT FKMedico335597 FOREIGN KEY (id_especialidade) REFERENCES Especialidade (id_especialidade);
ALTER TABLE Medico ADD CONSTRAINT FKMedico65659 FOREIGN KEY (id_utilizador) REFERENCES Utilizador (id_utilizador);
ALTER TABLE JuntaMedica ADD CONSTRAINT FKJuntaMedic393260 FOREIGN KEY (id_agendamento_junta_medica) REFERENCES Agendamento_JuntaMedica (id_agendamento_junta_medica);
ALTER TABLE Medicos_JuntaMedica ADD CONSTRAINT FKMedicos_Ju90807 FOREIGN KEY (id_medico) REFERENCES Medico (id_medico);
ALTER TABLE Medicos_JuntaMedica ADD CONSTRAINT FKMedicos_Ju832814 FOREIGN KEY (id_junta_medica) REFERENCES JuntaMedica (id_junta_medica);
ALTER TABLE Utente ADD CONSTRAINT FKUtente771484 FOREIGN KEY (id_entidade_responsavel) REFERENCES EntidadeResponsavel (id_entidade_responsavel);
