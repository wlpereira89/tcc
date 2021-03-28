use TCC
GO

CREATE TABLE #TB_BULK (
  LINHA VARCHAR(MAX)
)

BULK INSERT #TB_BULK FROM 'D:\Arquivos\Wagner\TCC\database relatórios\Mapa Fontes revisado sem header.csv' WITH (CODEPAGE = '65001')

SELECT 
  DBO.SPLIT_CSV(LINHA, ';', 1)  SECAO,
  DBO.SPLIT_CSV(LINHA, ';', 2)  SUBSECAO,
  DBO.SPLIT_CSV(LINHA, ';', 3)  INFORMACAO,
  DBO.SPLIT_CSV(LINHA, ';', 4)  FONTE_CITADA,
  DBO.SPLIT_CSV(DBO.SPLIT_CSV(LINHA, ';', 5), '-', 1)  PAGINA_INI   ,
  DBO.SPLIT_CSV(DBO.SPLIT_CSV(LINHA, ';', 5), '-', 2)  PAGINA_FIM   ,
  DBO.SPLIT_CSV(LINHA, ';', 6)  IND_TEXTO    ,
  '20' + DBO.SPLIT_CSV(DBO.SPLIT_CSV(LINHA, ';', 7), '-', 1)  REL_ANO,
  DBO.SPLIT_CSV(DBO.SPLIT_CSV(LINHA, ';', 7), '-', 2)  REL_TRIMESTRE,
  DBO.SPLIT_CSV(LINHA, ';', 8) OBS          ,
  DBO.SPLIT_CSV(LINHA, ';', 9) LINK         ,
  DBO.SPLIT_CSV(LINHA, ';', 10) COM_REL      
INTO #BULK_TRATADO
FROM 
  #TB_BULK
 WHERE 
  DBO.SPLIT_CSV(LINHA, ';', 5) <> ''

DROP TABLE #TB_BULK

INSERT INTO SECAO 
SELECT SECAO FROM #BULK_TRATADO GROUP BY SECAO
INSERT INTO SUBSECAO 
SELECT SUBSECAO FROM #BULK_TRATADO GROUP BY SUBSECAO
INSERT INTO INFORMACAO 
SELECT INFORMACAO FROM #BULK_TRATADO GROUP BY INFORMACAO

INSERT INTO INDICADORES
SELECT 
  REL_ANO      ,                                                                                  /* REL_ANO      */
  REL_TRIMESTRE,                                                                                  /* REL_TRIMESTRE*/
  SECAO_ID     ,                                                                                  /* SECAO_ID     */
  SUBSECAO_ID  ,                                                                                  /* SUBSECAO_ID  */
  INFORMACAO_ID,                                                                                  /* INFORMACAO_ID*/
  ROW_NUMBER() OVER(PARTITION BY REL_ANO, REL_TRIMESTRE, SECAO_ID, SUBSECAO_ID, INFORMACAO_ID     
                    ORDER BY PAGINA_INI, COALESCE(PAGINA_FIM, PAGINA_INI)),                       /* SEQ          */
  FONTE_CITADA ,                                                                                  /* FONTE_CITADA */
  PAGINA_INI   ,                                                                                  /* PAGINA_INI   */
  COALESCE(PAGINA_FIM, PAGINA_INI),                                                               /* PAGINA_FIM   */
  IND_TEXTO    ,                                                                                  /* IND_TEXTO    */
  OBS          ,                                                                                  /* OBS          */
  LINK         ,                                                                                  /* LINK         */
  COM_REL                                                                                         /* COM_REL     */
FROM                                                                                              
  #BULK_TRATADO 
  INNER JOIN SECAO ON #BULK_TRATADO.SECAO = SECAO.SECAO
  INNER JOIN SUBSECAO ON #BULK_TRATADO.SUBSECAO = SUBSECAO.SUBSECAO
  INNER JOIN INFORMACAO ON #BULK_TRATADO.INFORMACAO = INFORMACAO.INFORMACAO
  
DROP TABLE #BULK_TRATADO