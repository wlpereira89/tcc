USE TCC
GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SPLIT_CSV'))
  DROP FUNCTION dbo.SPLIT_CSV
GO

CREATE FUNCTION dbo.SPLIT_CSV (
  -------------------------------------------------------------------------------*/
  @ENT_DS_STRING   VARCHAR(MAX),  /* String                                      */
  @ENT_DS_SEPARA   VARCHAR(20),   /* Separador                                   */
  @ENT_NR_INDICE   NUMERIC(9)     /* �ndice que ser� retornado                   */
)
  RETURNS VARCHAR(MAX)
AS
BEGIN  
  DECLARE 
    @DS_STRTOT  VARCHAR(MAX),
    @DS_STRATU  VARCHAR(MAX),
    @I          NUMERIC(9)

  SELECT @DS_STRTOT = @ENT_DS_STRING
  SELECT @I = 0
  
  WHILE LEN(@DS_STRTOT) > 0
  BEGIN
    IF CHARINDEX(@ENT_DS_SEPARA, @DS_STRTOT) <= 0
    BEGIN
      SELECT @DS_STRATU = @DS_STRTOT
      SELECT @DS_STRTOT = ''
    END
    ELSE
      BEGIN
        SELECT @DS_STRATU = SUBSTRING(@DS_STRTOT, 1, CHARINDEX(@ENT_DS_SEPARA, @DS_STRTOT) - 1)
        SELECT @DS_STRTOT = SUBSTRING(@DS_STRTOT, CHARINDEX(@ENT_DS_SEPARA, @DS_STRTOT) + LEN(@ENT_DS_SEPARA + '.') - 1, LEN(@DS_STRTOT))
      END

    SELECT @I = @I + 1
    IF @I = @ENT_NR_INDICE
      RETURN(REPLACE(@DS_STRATU, '"', ''))
  END

  RETURN NULL
END
GO
