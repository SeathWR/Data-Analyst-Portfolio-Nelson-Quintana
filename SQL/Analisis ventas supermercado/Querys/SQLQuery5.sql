SELECT
    categoria,
    subcategoria,
    COUNT(*)                        AS transacciones,
    ROUND(AVG(utilidad), 2)         AS utilidad_promedio,
    ROUND(SUM(utilidad), 2)         AS utilidad_total,
    ROUND(AVG(descuento) * 100, 2)  AS descuento_promedio_pct
FROM ventas
GROUP BY categoria, subcategoria
HAVING AVG(utilidad) < 0
ORDER BY utilidad_promedio ASC;

