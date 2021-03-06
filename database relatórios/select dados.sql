select 
  RELATORIO.ANO                  ,
  RELATORIO.TRIMESTRE            ,
  SECAO.DESCRICAO      SECAO     ,
  SUBSECAO.DESCRICAO   SUBSECAO  ,
  INFORMACAO.DESCRICAO INFORMACAO,
  PAGINA_INI                     ,
  PAGINA_FIM                     ,
  FONTE.DESCRICAO      FONTE     ,
  IND_TEXTO                      ,
  OBS                            ,
  LINK                           ,
  COM_REL      
from
  INDICADORES
  INNER JOIN SECAO      ON INDICADORES.SECAO_ID      = SECAO.ID
  INNER JOIN SUBSECAO   ON INDICADORES.SUBSECAO_ID   = SUBSECAO.ID
  INNER JOIN INFORMACAO ON INDICADORES.INFORMACAO_ID = INFORMACAO.ID
  INNER JOIN FONTE      ON INDICADORES.FONTE_ID      = FONTE.ID
  INNER JOIN RELATORIO  ON INDICADORES.RELATORIO_ID  = RELATORIO.ID
ORDER BY 
  RELATORIO.ANO      ,
  RELATORIO.TRIMESTRE,
  PAGINA_INI         ,
  PAGINA_FIM         
  
  