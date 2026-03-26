SELECT
    mercado,
    ROUND(SUM(ventas), 2)            AS ventas_totales,
    ROUND(SUM(utilidad), 2)          AS utilidad_total,
    ROUND(AVG(utilidad), 2)          AS utilidad_promedio,
    ROUND(SUM(utilidad) / 
          SUM(ventas) * 100, 2)      AS margen_porcentual,
    COUNT(*)                         AS num_transacciones
FROM ventas
GROUP BY mercado
ORDER BY margen_porcentual DESC;