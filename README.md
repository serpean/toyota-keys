# Botones 3D para el mando Toyota Avensis 2005 (3 botones)

Botones de repuesto imprimibles para la llave **Valeo de 3 botones (hoja TOY43)** del
Toyota Avensis T25 (2003‑2009). La misma carcasa la usan Lexus IS/GS/RX de la época.

![Llave original](img/llave_original.jpg)

La goma original se rompe justo encima de cada pulsador y deja el circuito al aire.
Este proyecto **no sustituye la goma entera**: hace un *botón tapón* que se encaja en cada
agujero de la goma.

![Vista previa](img/preview.png)
![Vista inferior](img/abajo.png)

```
        ┌──────────────┐   ← tapa (1.6 mm, apoyada sobre la goma, icono grabado)
   ═════╡              ╞═════  ← goma original (≈1.6 mm)
        │   vástago    │
        ◢──────────────◣   ← reborde de retención (0.3 mm, sujeta por debajo de la goma)
               ▮           ← pivote Ø2.4 que aprieta el micropulsador
   ─────────[pulsador]───────  PCB
```

## Archivos

| Archivo | Para qué |
|---|---|
| `3mf/prueba_ajuste.3mf` (o `stl/prueba_ajuste.stl`) | **Imprimir primero.** 15 tapones (3 formas × 5 tamaños) para elegir el ajuste. |
| `3mf/avensis_3_botones.3mf` (o `.stl`) | Los 3 botones listos para imprimir. |
| `stl/boton_lock.stl`, `stl/boton_unlock.stl`, `stl/boton_arriba_izq.stl` | Botones sueltos. |
| `3mf/` | Los mismos modelos en 3MF, cada botón como objeto separado (recomendado para Bambu Studio). |
| `scad/avensis_botones.scad` | Modelo paramétrico (OpenSCAD o el *Parametric Model Maker* de MakerWorld). |

## Paso 1 – Medir (calibre)

No hay planos públicos de este mando y las medidas por defecto salen de la foto
(error ±0.5 mm). Antes de imprimir los definitivos, mide y corrige en el `.scad`:

| Parámetro | Qué medir | Valor por defecto |
|---|---|---|
| `hole_tl` | ancho × alto del agujero arriba‑izquierda | 8.8 × 8.6 |
| `hole_un` | agujero UNLOCK | 8.8 × 9.0 |
| `hole_lk` | agujero LOCK | 11.8 × 9.2 |
| `membrane_t` | grosor de la goma en el borde del agujero | 1.6 |
| `switch_depth` | profundidad desde la superficie de la goma hasta la cima del pulsador (sonda de profundidad del calibre) | 2.8 |

Si el pivote no llega al pulsador, sube `switch_depth`; si el botón queda pulsado
permanentemente, bájalo (o sube `nub_gap`).

## Paso 2 – Prueba de ajuste

Imprime `3mf/prueba_ajuste.3mf` (≈10 min, placa de unos 77 × 39 mm con **15 piezas**).
Vista desde arriba en Bambu Studio:

- **Fila de arriba:** botón arriba‑izquierda (sin rotular).
- **Fila del medio:** botón UNLOCK.
- **Fila de abajo:** botón LOCK (los más anchos).
- **De izquierda a derecha:** de más pequeño a más grande. Las **muescas del borde** indican la escala:

| Muescas | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|
| `size_scale` | 0.94 | 0.97 | 1.00 | 1.03 | 1.06 |

Elige el que entra con un poco de presión y "clic" al pasar el reborde, pon ese valor en
`size_scale` y exporta de nuevo (`part = "caps"`).

## Paso 3 – Imprimir en Bambu Lab P2S, boquilla 0.2 mm

Los botones se imprimen **boca abajo** (la cara del icono contra la cama): sin soportes y con
la superficie superior lisa (o texturizada si usas la placa PEI texturizada, que da buen tacto).

| Ajuste en Bambu Studio | Valor |
|---|---|
| Impresora / boquilla | Bambu Lab P2S – 0.2 mm |
| Perfil de proceso | `0.08mm High Quality @BBL P2S 0.2 nozzle` (o 0.10 Standard) |
| Material | **PETG** o **ASA** (aguantan el calor del coche). PLA vale para probar, se puede deformar al sol |
| Paredes | 3–4 |
| Relleno | 100 % (piezas diminutas) |
| Soportes | No |
| Borde (brim) | No (si se despegan: brim 2 mm) |
| Placa | PEI texturizada (o Smooth PEI con pegamento para PETG) |
| Ironing (planchado) | Opcional, en la cara superior no es necesario porque va contra la cama |

> **TPU:** Bambu no recomienda TPU con boquilla 0.2 (atasca). Si quieres botones blandos,
> cambia a la boquilla 0.4 y usa TPU 95A por la bobina externa; el modelo es el mismo.

## Paso 4 – Montaje

![Montaje](img/montaje.png)

La **tapa** (parte grande, cara lisa que tocó la cama) va hacia fuera; el **vástago** (parte pequeña) entra en el agujero de la goma.

1. Limpia los restos de goma rota alrededor del agujero con un cúter.
2. Comprueba que el mando funciona pulsando el micropulsador con un palillo.
3. Mete el vástago en el agujero y aprieta hasta que el reborde pase por debajo de la goma.
4. Opcional: una gota de pegamento flexible (tipo silicona, Loctite Super Glue Power Flex o
   E6000) en el reborde de la tapa, **sin** que llegue al pulsador.

Si la goma está muy deshecha, pon `barb = 0` y simplemente pega las tapas, o compra la goma
de repuesto (≈2‑8 €, busca "Toyota Avensis rubber pad 3 button").

## Exportar desde OpenSCAD

```sh
openscad -o stl/avensis_3_botones.stl -D 'part="caps"' -D size_scale=1.00 scad/avensis_botones.scad
openscad -o stl/prueba_ajuste.stl     -D 'part="fit"'  scad/avensis_botones.scad
```

Iconos disponibles por botón (`icon_tl`, `icon_un`, `icon_lk`): `none`, `lock`, `unlock`,
`trunk`, `dot`.

## Referencias

- Goma de repuesto Avensis 2004‑2009 / Lexus (3 botones): https://autonavaimet.fi/en/tuotteet/TRKS27
- Botones Toyota imprimibles (otros mandos): https://www.printables.com/model/593394-toyota-key-fob-spare-buttons
- Carcasa Toyota 3 botones para reutilizar la goma: https://stlfinder.com/model/toyota-key-fob-enclosure-3-button-9OZYcGmd/6544212
