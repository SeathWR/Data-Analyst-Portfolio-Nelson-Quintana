# 🗄️ Análisis de Ventas con SQL — Supermercado Global 2011–2014
### Consultas analíticas sobre ventas, rentabilidad y logística usando SQL Server

---

## 📌 Objetivo

Responder preguntas de negocio reales sobre el comportamiento de ventas, rentabilidad por mercado y eficiencia logística de un supermercado global, utilizando exclusivamente SQL Server. El análisis cubre desde consultas de agregación básica hasta window functions avanzadas.

---

## 📂 Estructura del repositorio

```
analisis-ventas-sql/
│
├── queries/
│   ├── 01_analisis_basico.sql         # Top productos, utilidad por mercado, pérdidas por categoría
│   ├── 02_analisis_intermedio.sql     # HAVING, CASE WHEN, subcategorías con pérdida
│   ├── 03_window_functions.sql        # RANK(), LAG(), SUM() OVER()
│   └── 04_resumen_ejecutivo.sql       # CTE + window functions combinadas
│
├── results/
│   ├── 01_top_productos.png
│   ├── 02_utilidad_mercado.png
│   ├── 03_perdidas_categoria.png
│   ├── 04_paises_perdidas.png
│   ├── 05_subcategorias_negativas.png
│   ├── 06_ranking_mercados.png
│   ├── 07_variacion_anual.png
│   ├── 08_acumulado_ventas.png
│   └── 09_resumen_ejecutivo.png
│
└── README.md
```

---

## 🗂️ Dataset

| Característica | Detalle |
|---|---|
| Fuente | Dataset público de supermercado global |
| Registros | 51.290 transacciones |
| Período | 2011 – 2014 |
| Herramienta | SQL Server + SQL Server Management Studio (SSMS) |

---

## 🔧 Herramientas utilizadas

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![SSMS](https://img.shields.io/badge/SSMS-CC2927?style=for-the-badge&logo=microsoft&logoColor=white)

- **SQL Server** — motor de base de datos
- **SSMS** — entorno de consultas
- **Conceptos aplicados** — JOINs, GROUP BY, HAVING, CASE WHEN, subconsultas, CTEs, window functions

---

## 📐 Metodología

1. **Importación y limpieza** — carga del dataset, renombrado de columnas y validación de tipos de dato
2. **Análisis básico** — agregaciones, rankings y conteos condicionales
3. **Análisis intermedio** — filtros avanzados con HAVING, cálculo de ratios y detección de subcategorías no rentables
4. **Window functions** — rankings anuales, variación año a año y acumulados mensuales
5. **Resumen ejecutivo** — CTE combinada con múltiples window functions para visión global

---

## 🔍 Consultas desarrolladas

### Nivel básico

**1. Top 10 productos por ingresos**
```sql
SELECT TOP 10
    nombre_producto,
    ROUND(SUM(ventas), 2)    AS ingresos_totales,
    ROUND(SUM(utilidad), 2)  AS utilidad_total,
    COUNT(*)                 AS num_transacciones
FROM ventas
GROUP BY nombre_producto
ORDER BY ingresos_totales DESC;
```
![Resultado](results/01_top_productos.png)

---

**2. Utilidad promedio y margen por mercado**
```sql
SELECT
    mercado,
    ROUND(SUM(ventas), 2)           AS ventas_totales,
    ROUND(SUM(utilidad), 2)         AS utilidad_total,
    ROUND(AVG(utilidad), 2)         AS utilidad_promedio,
    ROUND(SUM(utilidad) /
          SUM(ventas) * 100, 2)     AS margen_porcentual,
    COUNT(*)                        AS num_transacciones
FROM ventas
GROUP BY mercado
ORDER BY margen_porcentual DESC;
```
![Resultado](results/02_utilidad_mercado.png)

---

**3. Transacciones en pérdida por categoría**
```sql
SELECT
    categoria,
    COUNT(*)                                    AS total_transacciones,
    SUM(CASE WHEN resultado_venta = 'PERDIDA'
             THEN 1 ELSE 0 END)                 AS transacciones_perdida,
    ROUND(SUM(CASE WHEN resultado_venta = 'PERDIDA'
             THEN 1 ELSE 0 END) * 100.0
             / COUNT(*), 2)                     AS pct_perdida,
    ROUND(SUM(CASE WHEN resultado_venta = 'PERDIDA'
             THEN utilidad ELSE 0 END), 2)      AS perdida_acumulada
FROM ventas
GROUP BY categoria
ORDER BY pct_perdida DESC;
```
![Resultado](results/03_perdidas_categoria.png)

---

### Nivel intermedio

**4. Top 5 países con mayor ratio de pérdidas**
```sql
SELECT TOP 5
    pais,
    COUNT(*)                                     AS total_transacciones,
    SUM(CASE WHEN resultado_venta = 'PERDIDA'
             THEN 1 ELSE 0 END)                  AS transacciones_perdida,
    ROUND(SUM(CASE WHEN resultado_venta = 'PERDIDA'
             THEN 1 ELSE 0 END) * 100.0
             / COUNT(*), 2)                      AS pct_perdida,
    ROUND(SUM(CASE WHEN resultado_venta = 'PERDIDA'
             THEN utilidad ELSE 0 END), 2)       AS perdida_acumulada
FROM ventas
GROUP BY pais
HAVING COUNT(*) > 100
ORDER BY pct_perdida DESC;
```
![Resultado](results/04_paises_perdidas.png)

---

**5. Subcategorías con utilidad negativa en promedio**
```sql
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
```
![Resultado](results/05_subcategorias_negativas.png)

---

### Nivel avanzado — Window Functions

**6. Ranking de mercados por ventas anuales**
```sql
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
```
![Resultado](results/06_ranking_mercados.png)

---

**7. Variación porcentual de ventas año a año por categoría**
```sql
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
```
![Resultado](results/07_variacion_anual.png)

---

**8. Acumulado de ventas por mes dentro de cada año**
```sql
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
```
![Resultado](results/08_acumulado_ventas.png)

---

**9. Resumen ejecutivo — CTE + Window Functions**
```sql
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
```
![Resultado](results/09_resumen_ejecutivo.png)

---

## 📈 Hallazgos principales

- 🇨🇦 **Canada tiene el mejor margen porcentual** a pesar de ser el mercado con menor volumen de ventas — APAC lidera en volumen pero con un margen de solo 12.18%
- 🪑 **Tables es la subcategoría más crítica** — utilidad promedio de -74.43 y pérdida acumulada de -64.083, con un descuento promedio del 25% que destruye rentabilidad sistemáticamente
- 📦 **Furniture concentra el mayor porcentaje de transacciones en pérdida** entre las tres categorías
- 📅 **El último trimestre concentra el mayor crecimiento de ventas** en todos los años analizados — patrón consistente de estacionalidad
- 📊 **El período 2012–2013 registró el mayor crecimiento porcentual** de ventas año a año
- 🏆 **APAC mantiene el primer lugar en ventas** y Canada el séptimo en todos los años — la estructura de mercado es estable durante todo el período

---

## 💡 Conclusiones y recomendaciones

1. **Eliminar o rediseñar la subcategoría Tables** — con pérdidas acumuladas de más de $64.000 y descuentos promedio del 25%, esta subcategoría requiere una revisión urgente de política de precios
2. **Revisar la estrategia de descuentos en Furniture** — es la categoría con mayor ratio de pérdidas, directamente correlacionado con descuentos excesivos
3. **Estudiar el modelo de Canada** — siendo el mercado más eficiente en margen, sus prácticas comerciales pueden replicarse en mercados de mayor volumen
4. **Reforzar inventario y capacidad en Q4** — el último trimestre concentra el pico de ventas de forma consistente, lo que requiere planificación logística anticipada

---

## 👤 Autor

**Nelson David Quintana Vargas**
Analista de Datos | Business Intelligence

[![GitHub](https://img.shields.io/badge/GitHub-SeathWR-181717?style=flat&logo=github)](https://github.com/SeathWR)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Conectar-0077B5?style=flat&logo=linkedin)](https://linkedin.com/in/)

---

*Proyecto desarrollado como parte del portafolio de análisis de datos — 2025*
