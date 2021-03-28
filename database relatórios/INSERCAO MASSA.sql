USE TCC
GO

BEGIN TRY
BEGIN TRANSACTION INSERCAO_MASSA
  IF EXISTS (SELECT TOP 1 NULL FROM INDICADORES)
    RAISERROR('O script de inserção de dados só pode ser executado com a base vazia', 15, 1)

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
  INSERT INTO FONTE 
  SELECT FONTE_CITADA FROM #BULK_TRATADO GROUP BY FONTE_CITADA
  INSERT INTO RELATORIO 
  SELECT REL_ANO, REL_TRIMESTRE FROM #BULK_TRATADO GROUP BY REL_ANO, REL_TRIMESTRE
  
  INSERT INTO INDICADORES
  SELECT   
    RELATORIO.ID ,                                                                                  /* RELATORIO_ID */
    SECAO.ID     ,                                                                                  /* SECAO_ID     */
    SUBSECAO.ID  ,                                                                                  /* SUBSECAO_ID  */
    INFORMACAO.ID,                                                                                  /* INFORMACAO_ID*/
    ROW_NUMBER() OVER(PARTITION BY RELATORIO.ID , SECAO.ID, SUBSECAO.ID, INFORMACAO.ID     
                      ORDER BY PAGINA_INI, COALESCE(PAGINA_FIM, PAGINA_INI)),                       /* SEQ          */
    FONTE.ID     ,                                                                                  /* FONTE_ID     */
    PAGINA_INI   ,                                                                                  /* PAGINA_INI   */
    COALESCE(PAGINA_FIM, PAGINA_INI),                                                               /* PAGINA_FIM   */
    IND_TEXTO    ,                                                                                  /* IND_TEXTO    */
    OBS          ,                                                                                  /* OBS          */
    LINK         ,                                                                                  /* LINK         */
    COM_REL                                                                                         /* COM_REL     */
  FROM                                                                                              
    #BULK_TRATADO 
    INNER JOIN SECAO      ON SECAO        = SECAO.DESCRICAO
    INNER JOIN SUBSECAO   ON SUBSECAO     = SUBSECAO. DESCRICAO
    INNER JOIN INFORMACAO ON INFORMACAO   = INFORMACAO.DESCRICAO
    INNER JOIN FONTE      ON FONTE_CITADA = FONTE.DESCRICAO
    INNER JOIN RELATORIO  ON (REL_ANO = ANO  AND REL_TRIMESTRE = TRIMESTRE)
    
  DROP TABLE #BULK_TRATADO

COMMIT TRANSACTION INSERCAO_MASSA
END TRY
BEGIN CATCH
  SELECT @@ERROR, ERROR_MESSAGE()
  ROLLBACK TRANSACTION INSERCAO_MASSA
END CATCH