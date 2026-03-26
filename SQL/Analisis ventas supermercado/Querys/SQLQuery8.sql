SELECT
    anio_salida,
    mes_salida,
    ROUND(SUM(ventas), 2)                        AS ventas_mes,
    ROUND(SUM(SUM(ventas)) OVER (
        PARTITION BY anio_salida
        ORDER BY mes_salida
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ), 2)                                        AS ventas_acumuladas
FROM ventas
GROUP BY anio_salida, mes_salida
ORDER BY anio_salida, mes_salida;