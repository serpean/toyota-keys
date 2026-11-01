"""Dibujo en seccion del montaje del boton (medidas por defecto del .scad, boton UNLOCK)."""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon, Rectangle, FancyArrowPatch

# medidas (mm), z = 0 superficie de la goma
hole, clr, ov = 8.8, 0.15, 0.9
mt, cap_h, ch = 1.6, 1.6, 0.4
barb, barb_h = 0.30, 0.6
nub_d, sw_depth, gap = 2.4, 2.8, 0.2
w = hole / 2 - clr          # medio ancho del vastago
W = w + ov                  # medio ancho de la tapa
nub_len = max(sw_depth - gap, mt + barb + barb_h + 0.2)

C_BTN, C_RUB, C_PCB, C_SW, C_ACT = "#2e9d5b", "#3a3a3a", "#1f6b3a", "#c9c9c9", "#202020"

def button(ax, dz=0.0):
    cap = [(-W, 0), (W, 0), (W, cap_h - ch), (W - ch, cap_h), (-W + ch, cap_h), (-W, cap_h - ch)]
    stem = [(-w, 0), (w, 0), (w, -mt), (w + barb, -mt - barb), (w, -mt - barb - barb_h),
            (-w, -mt - barb - barb_h), (-w - barb, -mt - barb), (-w, -mt)]
    for pts in (cap, stem):
        ax.add_patch(Polygon([(x, z + dz) for x, z in pts], closed=True, fc=C_BTN, ec="black", lw=1))
    ax.add_patch(Rectangle((-nub_d / 2, -nub_len + dz), nub_d, nub_len - mt - barb - barb_h + 0.01,
                           fc=C_BTN, ec="black", lw=1))

def key(ax):
    half = hole / 2
    for x0 in (-12, half):
        ax.add_patch(Rectangle((x0, -mt), 12 - half, mt, fc=C_RUB, ec="black", lw=1))
    pcb_top = -sw_depth - 1.8   # cima del pulsador = -sw_depth
    ax.add_patch(Rectangle((-12, pcb_top - 1.0), 24, 1.0, fc=C_PCB, ec="black", lw=1))
    ax.add_patch(Rectangle((-3, pcb_top), 6, 1.5, fc=C_SW, ec="black", lw=1))          # cuerpo pulsador
    ax.add_patch(Rectangle((-0.8, pcb_top + 1.5), 1.6, -sw_depth - (pcb_top + 1.5), fc=C_ACT, ec="black"))
    for x in (-6.5, 5.0):                                                               # componentes SMD
        ax.add_patch(Rectangle((x, pcb_top), 1.5, 0.5, fc="#8a6d3b", ec="black", lw=0.6))

def label(ax, txt, xy, xytext):
    ax.annotate(txt, xy=xy, xytext=xytext, fontsize=10, va="center",
                arrowprops=dict(arrowstyle="-", color="#555", lw=0.8))

fig, axes = plt.subplots(1, 2, figsize=(14, 6.2))
for ax, title in zip(axes, ["1. Antes de montar", "2. Montado"]):
    ax.set_xlim(-13, 22); ax.set_ylim(-6.2, 9.5); ax.set_aspect("equal"); ax.axis("off")
    ax.set_title(title, fontsize=14, weight="bold")
    key(ax)

# panel 1: boton encima, flecha hacia el agujero
ax = axes[0]
button(ax, dz=5.0)
ax.add_patch(FancyArrowPatch((0, 2.6), (0, 0.4), arrowstyle="-|>", mutation_scale=22, color="#d33", lw=2))
label(ax, "TAPA: cara lisa hacia fuera\n(la que tocó la cama)", (W, 5 + cap_h / 2), (12.5, 7.6))
label(ax, "VÁSTAGO: parte pequeña,\nva hacia dentro", (w, 5 - mt / 2), (12.5, 4.3))
label(ax, "reborde de retención", (w + barb, 5 - mt - barb), (12.5, 2.3))
label(ax, "pivote (solo botones\ndefinitivos)", (nub_d / 2, 5 - nub_len + 0.3), (12.5, 0.4))
label(ax, "agujero roto de la goma", (hole / 2, -mt / 2), (12.5, -1.6))
label(ax, "micropulsador", (1.5, -3.6), (12.5, -3.6))
label(ax, "circuito (PCB)", (8, -5.1), (12.5, -5.4))

# panel 2: montado
ax = axes[1]
button(ax)
label(ax, "tapa: sobresale %.1f mm\n(lo que pulsas)" % cap_h, (W, cap_h / 2), (12.5, 4.5))
label(ax, "goma de la llave", (8, -mt / 2), (12.5, 1.6))
label(ax, "el reborde queda por\ndebajo de la goma: no se sale", (w + barb, -mt - barb), (12.5, -1.2))
label(ax, "el pivote empuja\nel micropulsador", (nub_d / 2, -nub_len + 0.1), (12.5, -4.2))

fig.text(0.5, 0.02, "Sección del botón UNLOCK con las medidas por defecto (mm). Las piezas de prueba son iguales pero sin pivote.",
         ha="center", fontsize=10, color="#444")
plt.tight_layout(rect=(0, 0.04, 1, 1))
out = __import__("sys").argv[1] if len(__import__("sys").argv) > 1 else "img/montaje.png"
plt.savefig(out, dpi=130)
print(out)
