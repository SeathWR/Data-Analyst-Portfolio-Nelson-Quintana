SELECT TOP 5
    país,
    COUNT(*)                                     AS total_transacciones,
    SUM(CASE WHEN resultado_venta = 'PERDIDA' 
             THEN 1 ELSE 0 END)                  AS transacciones_perdida,
    ROUND(SUM(CASE WHEN resultado_venta = 'PERDIDA'
             THEN 1 ELSE 0 END) * 100.0
             / COUNT(*), 2)                      AS pct_perdida,
    ROUND(SUM(CASE WHEN resultado_venta = 'PERDIDA'
             THEN utilidad ELSE 0 END), 2)       AS perdida_acumulada
FROM ventas
GROUP BY país
HAVING COUNT(*) > 100
ORDER BY pct_perdida DESC;
