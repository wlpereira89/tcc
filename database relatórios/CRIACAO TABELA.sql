USE TCC
GO

/*Se��o,Sub se��o,Informa��o,Fonte Citada,Pagina,S� texto,Relat�rio,Observa��o,Link,Coment�rio relat�rio,Aberta,,,,,,,,,,,,,,,,,*/

/*
  DROP TABLE INDICADORES
  DROP TABLE INFORMACAO_SINOMIMOS
  DROP TABLE INFORMACAO_SINOMIMOS_Levenshtein
  DROP TABLE INFORMACAO_SINOMIMOS_SOUNDEX 
  DROP TABLE INFORMACAO_SINOMIMOS_Levenshtein_SOUNDEX
  DROP TABLE SECAO_SINOMIMOS
  DROP TABLE SECAO_SINOMIMOS_Levenshtein
  DROP TABLE SECAO_SINOMIMOS_SOUNDEX 
  DROP TABLE SECAO_SINOMIMOS_Levenshtein_SOUNDEX
  DROP TABLE SUBSECAO_SINOMIMOS
  DROP TABLE SUBSECAO_SINOMIMOS_Levenshtein
  DROP TABLE SUBSECAO_SINOMIMOS_SOUNDEX 
  DROP TABLE SUBSECAO_SINOMIMOS_Levenshtein_SOUNDEX
  DROP TABLE SECAO
  DROP TABLE SUBSECAO
  DROP TABLE INFORMACAO 
  DROP TABLE FONTE
  DROP TABLE RELATORIO
*/
CREATE TABLE SECAO (
  ID            INT IDENTITY(1, 1) PRIMARY KEY,
  DESCRICAO     VARCHAR(MAX)
)

CREATE TABLE SECAO_SINOMIMOS (
  ID1 INT,
  ID2 INT,
  PRIMARY KEY(ID1, ID2),
  FOREIGN KEY (ID1) REFERENCES SECAO (ID),
  FOREIGN KEY (ID2) REFERENCES SECAO (ID)
)

CREATE TABLE SECAO_SINOMIMOS_Levenshtein (
  ID1 INT,
  ID2 INT,
  PRIMARY KEY(ID1, ID2),
  FOREIGN KEY (ID1) REFERENCES SECAO (ID),
  FOREIGN KEY (ID2) REFERENCES SECAO (ID)
)

CREATE TABLE SECAO_SINOMIMOS_SOUNDEX (
  ID1 INT,
  ID2 INT,
  PRIMARY KEY(ID1, ID2),
  FOREIGN KEY (ID1) REFERENCES SECAO (ID),
  FOREIGN KEY (ID2) REFERENCES SECAO (ID)
)

CREATE TABLE SECAO_SINOMIMOS_Levenshtein_SOUNDEX (
  ID1 INT,
  ID2 INT,
  PRIMARY KEY(ID1, ID2),
  FOREIGN KEY (ID1) REFERENCES SECAO (ID),
  FOREIGN KEY (ID2) REFERENCES SECAO (ID)
)

CREATE TABLE SUBSECAO (
  ID            INT IDENTITY(1, 1) PRIMARY KEY,
  DESCRICAO     VARCHAR(MAX)
)

CREATE TABLE SUBSECAO_SINOMIMOS (
  ID1 INT,
  ID2 INT,
  CONSTRAINT PK_SUBSECAO_SINOMIMOS PRIMARY KEY(ID1, ID2),
  CONSTRAINT FK_SUBSECAO_SINOMIMOS1 FOREIGN KEY (ID1) REFERENCES SUBSECAO (ID),
  CONSTRAINT FK_SUBSECAO_SINOMIMOS2 FOREIGN KEY (ID2) REFERENCES SUBSECAO (ID)
)

CREATE TABLE SUBSECAO_SINOMIMOS_Levenshtein (
  ID1 INT,
  ID2 INT,
  PRIMARY KEY(ID1, ID2),
  FOREIGN KEY (ID1) REFERENCES SUBSECAO (ID),
  FOREIGN KEY (ID2) REFERENCES SUBSECAO (ID)
)

CREATE TABLE SUBSECAO_SINOMIMOS_SOUNDEX (
  ID1 INT,
  ID2 INT,
  PRIMARY KEY(ID1, ID2),
  FOREIGN KEY (ID1) REFERENCES SUBSECAO (ID),
  FOREIGN KEY (ID2) REFERENCES SUBSECAO (ID)
)

CREATE TABLE SUBSECAO_SINOMIMOS_Levenshtein_SOUNDEX (
  ID1 INT,
  ID2 INT,
  PRIMARY KEY(ID1, ID2),
  FOREIGN KEY (ID1) REFERENCES SUBSECAO (ID),
  FOREIGN KEY (ID2) REFERENCES SUBSECAO (ID)
)

CREATE TABLE INFORMACAO (
  ID            INT IDENTITY(1, 1) PRIMARY KEY,
  DESCRICAO     VARCHAR(MAX)
)

CREATE TABLE INFORMACAO_SINOMIMOS (
  ID1 INT,
  ID2 INT,
  PRIMARY KEY(ID1, ID2),
  FOREIGN KEY (ID1) REFERENCES INFORMACAO (ID),
  FOREIGN KEY (ID2) REFERENCES INFORMACAO (ID)
)

CREATE TABLE INFORMACAO_SINOMIMOS_Levenshtein (
  ID1 INT,
  ID2 INT,
  PRIMARY KEY(ID1, ID2),
  FOREIGN KEY (ID1) REFERENCES INFORMACAO (ID),
  FOREIGN KEY (ID2) REFERENCES INFORMACAO (ID)
)

CREATE TABLE INFORMACAO_SINOMIMOS_SOUNDEX (
  ID1 INT,
  ID2 INT,
  PRIMARY KEY(ID1, ID2),
  FOREIGN KEY (ID1) REFERENCES INFORMACAO (ID),
  FOREIGN KEY (ID2) REFERENCES INFORMACAO (ID)
)

CREATE TABLE INFORMACAO_SINOMIMOS_Levenshtein_SOUNDEX (
  ID1 INT,
  ID2 INT,
  PRIMARY KEY(ID1, ID2),
  FOREIGN KEY (ID1) REFERENCES INFORMACAO (ID),
  FOREIGN KEY (ID2) REFERENCES INFORMACAO (ID)
)

CREATE TABLE FONTE (
  ID            INT IDENTITY(1, 1) PRIMARY KEY,
  DESCRICAO     VARCHAR(MAX)
)

CREATE TABLE RELATORIO (
  ID            INT IDENTITY(1, 1) PRIMARY KEY,
  ANO           NUMERIC(4),
  QUADRIMESTRE  NUMERIC(1)
)

CREATE TABLE INDICADORES (
  RELATORIO_ID  INT,
  SECAO_ID      INT,
  SUBSECAO_ID   INT,
  INFORMACAO_ID INT,
  SEQ           INT,
  FONTE_ID      INT,
  PAGINA_INI    INT,
  PAGINA_FIM    INT,
  IND_TEXTO     VARCHAR(1),
  OBS           VARCHAR(MAX),
  LINK          VARCHAR(MAX),
  COM_REL       VARCHAR(MAX),
  CONSTRAINT PK_INDICADORES PRIMARY KEY(RELATORIO_ID, SECAO_ID, SUBSECAO_ID, INFORMACAO_ID, SEQ),
  CONSTRAINT FK_INDICADORES_RELATORIO  FOREIGN KEY (RELATORIO_ID ) REFERENCES RELATORIO  (ID),
  CONSTRAINT FK_INDICADORES_SECAO      FOREIGN KEY (SECAO_ID     ) REFERENCES SECAO      (ID),
  CONSTRAINT FK_INDICADORES_SUBSECAO   FOREIGN KEY (SUBSECAO_ID  ) REFERENCES SUBSECAO   (ID),
  CONSTRAINT FK_INDICADORES_INFORMACAO FOREIGN KEY (INFORMACAO_ID) REFERENCES INFORMACAO (ID),
  CONSTRAINT FK_INDICADORES_FONTE      FOREIGN KEY (FONTE_ID)      REFERENCES FONTE      (ID)
)