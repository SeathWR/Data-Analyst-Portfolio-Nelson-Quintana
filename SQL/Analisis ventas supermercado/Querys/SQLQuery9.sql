WITH resumen_mercado AS (
    SELECT
        mercado,
        ROUND(SUM(ventas), 2)                         AS ventas_totales,
        ROUND(SUM(utilidad), 2)                       AS utilidad_total,
        ROUND(SUM(utilidad) / SUM(ventas) * 100, 2)   AS margen_pct,
        COUNT(*)                                       AS transacciones,
        SUM(CASE WHEN resultado_venta = 'PERDIDA'
                 THEN 1 ELSE 0 END)                   AS transacciones_perdida,
        ROUND(SUM(CASE WHEN resultado_venta = 'PERDIDA'
                 THEN 1 ELSE 0 END) * 100.0
                 / COUNT(*), 2)                       AS pct_perdida
    FROM ventas
    GROUP BY mercado
)
SELECT
    mercado,
    ventas_totales,
    utilidad_total,
    margen_pct,
    transacciones,
    transacciones_perdida,
    pct_perdida,
    RANK() OVER (ORDER BY ventas_totales DESC)        AS ranking_ventas,
    RANK() OVER (ORDER BY margen_pct DESC)            AS ranking_margen
FROM resumen_mercado
ORDER BY ranking_ventas;