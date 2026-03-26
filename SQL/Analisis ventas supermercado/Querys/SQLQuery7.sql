
SELECT
    anio_salida,
    categoria,
    ROUND(SUM(ventas), 2)                              AS ventas_totales,
    ROUND(LAG(SUM(ventas)) OVER (
        PARTITION BY categoria
        ORDER BY anio_salida
    ), 2)                                              AS ventas_anio_anterior,
    ROUND((SUM(ventas) - LAG(SUM(ventas)) OVER (
        PARTITION BY categoria
        ORDER BY anio_salida)) * 100.0
        / NULLIF(LAG(SUM(ventas)) OVER (
        PARTITION BY categoria
        ORDER BY anio_salida), 0), 2)                  AS variacion_pct
FROM ventas
GROUP BY anio_salida, categoria
ORDER BY categoria, anio_salida;