WITH tb_transacoes AS (
    SELECT  
        IdTransacao,
        IdCliente,
        QtdePontos,
        DATETIME(SUBSTR(DtCriacao, 1, 19)) AS dtCriacao,
        JULIANDAY('NOW') - JULIANDAY(SUBSTR(DtCriacao, 1, 10)) AS diffDate
    FROM transacoes 
),
tb_cliente AS (
SELECT
    idCliente,
    DATETIME(SUBSTR(DtCriacao, 1, 19)) AS dtCriacao,
    JULIANDAY('NOW') - JULIANDAY(SUBSTR(DtCriacao, 1, 10)) AS idadeBase
FROM clientes
),
tb_sumario_transacoes AS (
SELECT 
    IdCliente,

    COUNT(*) AS qtdeTransacoesVida,
    COUNT(CASE WHEN diffDate <= 56 THEN IdTransacao END) AS qtdeTransacoes56,
    COUNT(CASE WHEN diffDate <= 28 THEN IdTransacao END) AS qtdeTransacoes28,
    COUNT(CASE WHEN diffDate <= 14 THEN IdTransacao END) AS qtdeTransacoes14,
    COUNT(CASE WHEN diffDate <= 7 THEN IdTransacao END) AS qtdeTransacoes7,

    SUM(QtdePontos) AS saldoPontos,

    MIN(diffDate) AS diasUltimaInteracao,

    SUM(CASE WHEN qtdePontos > 0 THEN qtdePontos ELSE 0 END) AS qtdePontosPosVida,

    SUM(CASE WHEN qtdePontos > 0 AND diffDate <= 56  THEN qtdePontos ELSE 0 END) AS qtdePontosPos56,
    SUM(CASE WHEN qtdePontos > 0 AND diffDate <= 28 THEN qtdePontos ELSE 0 END) AS qtdePontosPos28,
    SUM(CASE WHEN qtdePontos > 0 AND diffDate <= 14 THEN qtdePontos ELSE 0 END) AS qtdePontosPos14,
    SUM(CASE WHEN qtdePontos > 0 AND diffDate <= 8 THEN qtdePontos ELSE 0 END) AS qtdePontosPos7
    

 FROM tb_transacoes 
 GROUP BY IdCliente
 )
SELECT 
    t1.*,
    t2.idadeBase
FROM tb_sumario_transacoes AS t1 
LEFT JOIN tb_cliente AS t2 
ON t1.idCliente = t2.idCliente