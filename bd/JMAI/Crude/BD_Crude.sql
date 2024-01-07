CREATE TABLE Utente (
  id_utente           BIGSERIAL NOT NULL, 
  hashed_id           varchar(255) UNIQUE, 
  id_utilizador       BIGINT NOT NULL UNIQUE, 
  numero_utente_saude BIGINT NOT NULL UNIQUE, 
  PRIMARY KEY (id_utente));


CREATE TABLE Utilizador (
  id_utilizador BIGSERIAL NOT NULL, 
  hashed_id     varchar(255) UNIQUE, 
  email         varchar(255) NOT NULL UNIQUE, 
  id_cargo      BIGINT NOT NULL, 
  PRIMARY KEY (id_utilizador));


CREATE TABLE Secretario_Clinico (
  id_secretarios_clinicos  BIGSERIAL NOT NULL, 
  hashed_id                varchar(255) UNIQUE, 
  id_utilizador            BIGINT NOT NULL UNIQUE, 
  nome_secreatario_clinico varchar(255) NOT NULL, 
  contacto                 BIGINT NOT NULL, 
  data_nascimento          date NOT NULL, 
  sexo                     varchar(255) NOT NULL, 
  distrito                 varchar(255) NOT NULL, 
  concelho                 varchar(255) NOT NULL, 
  freguesia                varchar(255) NOT NULL, 
  pais                     varchar(255) NOT NULL, 
  PRIMARY KEY (id_secretarios_clinicos));


CREATE TABLE Agendamento_JuntaMedica (
  id_agendamento_junta_medica BIGSERIAL NOT NULL, 
  hashed_id                   varchar(255) UNIQUE, 
  id_pre_avaliacao            BIGINT NOT NULL UNIQUE, 
  data                        date NOT NULL, 
  status                      BIGINT NOT NULL, 
  resultado                   float4, 
  observacoes                 varchar(255), 
  PRIMARY KEY (id_agendamento_junta_medica));


CREATE TABLE RequerimentoJuntaMedica (
  id_requerimento_junta_medica BIGSERIAL NOT NULL, 
  hashed_id                    varchar(255) UNIQUE, 
  id_utente                    BIGINT, 
  data_submissao               date NOT NULL, 
  documentos                   JSON, 
  status                       BIGINT NOT NULL, 
  type                         BIGINT NOT NULL, 
  nunca_submetido              bool, 
  submetido                    bool, 
  data_submetido               date, 
  numero_utente_saude_by_SNS   BIGINT, 
  PRIMARY KEY (id_requerimento_junta_medica));


CREATE TABLE PreAvaliacao (
  id_pre_avaliacao             BIGSERIAL NOT NULL, 
  hashed_id                    varchar(255) UNIQUE, 
  id_medico                    BIGINT NOT NULL, 
  id_requerimento_junta_medica BIGINT NOT NULL, 
  pre_avaliacao                float4 NOT NULL, 
  observacoes                  varchar(255), 
  data_pre_avaliacao           TIMESTAMP NOT NULL, 
  PRIMARY KEY (id_pre_avaliacao));


CREATE TABLE Cargo (
  id_cargo  SERIAL NOT NULL, 
  hashed_id varchar(255) UNIQUE, 
  cargo     varchar(255) NOT NULL UNIQUE, 
  PRIMARY KEY (id_cargo));


CREATE TABLE Especialidade (
  id_especialidade BIGSERIAL NOT NULL, 
  hashed_id        varchar(255) UNIQUE, 
  especialidade    varchar(255) NOT NULL, 
  PRIMARY KEY (id_especialidade));


CREATE TABLE Medico (
  id_medico        BIGSERIAL NOT NULL, 
  hashed_id        varchar(255) UNIQUE, 
  id_utilizador    BIGINT NOT NULL UNIQUE, 
  nome_medico      varchar(255) NOT NULL, 
  num_cedula       BIGINT NOT NULL, 
  num_ordem        BIGINT NOT NULL, 
  id_especialidade BIGINT NOT NULL, 
  contacto         varchar(255) NOT NULL, 
  data_nascimento  date NOT NULL, 
  sexo             varchar(255) NOT NULL, 
  distrito         varchar(255) NOT NULL, 
  concelho         varchar(255) NOT NULL, 
  freguesia        varchar(255) NOT NULL, 
  pais             varchar(255) NOT NULL, 
  PRIMARY KEY (id_medico));


CREATE TABLE JuntaMedica (
  id_medico                   BIGINT NOT NULL, 
  id_agendamento_junta_medica BIGINT NOT NULL, 
  hashed_id                   varchar(255) UNIQUE, 
  PRIMARY KEY (id_medico, 
  id_agendamento_junta_medica));


ALTER TABLE PreAvaliacao ADD CONSTRAINT FKPreAvaliac FOREIGN KEY (id_requerimento_junta_medica) REFERENCES RequerimentoJuntaMedica (id_requerimento_junta_medica);
ALTER TABLE Agendamento_JuntaMedica ADD CONSTRAINT FKAgendament FOREIGN KEY (id_pre_avaliacao) REFERENCES PreAvaliacao (id_pre_avaliacao);
ALTER TABLE Utente ADD CONSTRAINT FKUtente FOREIGN KEY (id_utilizador) REFERENCES Utilizador (id_utilizador);
ALTER TABLE RequerimentoJuntaMedica ADD CONSTRAINT FKRequerimen FOREIGN KEY (id_utente) REFERENCES Utente (id_utente);
ALTER TABLE Secretario_Clinico ADD CONSTRAINT FKSecretario FOREIGN KEY (id_utilizador) REFERENCES Utilizador (id_utilizador);
ALTER TABLE PreAvaliacao ADD CONSTRAINT FKPreAvaliac2 FOREIGN KEY (id_medico) REFERENCES Medico (id_medico);
ALTER TABLE Medico ADD CONSTRAINT FKMedico FOREIGN KEY (id_utilizador) REFERENCES Utilizador (id_utilizador);
ALTER TABLE Utilizador ADD CONSTRAINT FKUtilizador FOREIGN KEY (id_cargo) REFERENCES Cargo (id_cargo);
ALTER TABLE Medico ADD CONSTRAINT FKMedico2 FOREIGN KEY (id_especialidade) REFERENCES Especialidade (id_especialidade);
ALTER TABLE JuntaMedica ADD CONSTRAINT FKJuntaMedic FOREIGN KEY (id_medico) REFERENCES Medico (id_medico);
ALTER TABLE JuntaMedica ADD CONSTRAINT FKJuntaMedic2 FOREIGN KEY (id_agendamento_junta_medica) REFERENCES Agendamento_JuntaMedica (id_agendamento_junta_medica);
