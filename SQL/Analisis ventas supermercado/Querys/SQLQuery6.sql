SELECT
    anio_salida,
    mercado,
    ROUND(SUM(ventas), 2)                        AS ventas_totales,
    RANK() OVER (
        PARTITION BY anio_salida
        ORDER BY SUM(ventas) DESC
    )                                            AS ranking
FROM ventas
GROUP BY anio_salida, mercado
ORDER BY anio_salida, ranking;
