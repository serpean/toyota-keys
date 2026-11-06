"""Dibujo en seccion del montaje del boton v2 (pestaña interior), boton LOCK con medidas reales."""
import sys
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon, Rectangle, FancyArrowPatch

# medidas (mm) - z = 0 superficie exterior de la carcasa
win, clr = 9.7, 0.15
shell_t, depth = 1.8, 3.2
protrude, ch = 0.8, 0.3
ov, ft = 0.5, 0.4
nub_d, gap = 2.4, 0.15

w = win / 2 - clr
z0 = -shell_t + clr
zf = z0 - ov - ft
tip = -(depth - gap)

C_BTN, C_SHELL, C_MOD, C_PCB, C_SW, C_ACT = "#2e9d5b", "#3a3a3a", "#6b6b6b", "#1f6b3a", "#c9c9c9", "#202020"


def button(ax, dz=0.0):
    body = [(-w, z0), (w, z0), (w, protrude - ch), (w - ch, protrude), (-w + ch, protrude), (-w, protrude - ch)]
    flange = [(-w, z0), (w, z0), (w + ov, z0 - ov), (w + ov, zf), (-w - ov, zf), (-w - ov, z0 - ov)]
    for pts in (body, flange):
        ax.add_patch(Polygon([(x, z + dz) for x, z in pts], closed=True, fc=C_BTN, ec="black", lw=1))
    ax.add_patch(Rectangle((-nub_d / 2, tip + dz), nub_d, zf - tip, fc=C_BTN, ec="black", lw=1))


def key(ax):
    half = win / 2
    for x0, x1 in ((-13, -half), (half, 13)):
        ax.add_patch(Rectangle((x0, -shell_t), x1 - x0, shell_t, fc=C_SHELL, ec="black", lw=1))
    sw_top = -depth
    pcb_top = sw_top - 1.6
    # capa negra del modulo con hueco alrededor del pulsador
    for x0, x1 in ((-13, -6.2), (6.2, 13)):
        ax.add_patch(Rectangle((x0, pcb_top), x1 - x0, -shell_t - pcb_top, fc=C_MOD, ec="black", lw=0.8))
    ax.add_patch(Rectangle((-13, pcb_top - 1.0), 26, 1.0, fc=C_PCB, ec="black", lw=1))
    ax.add_patch(Rectangle((-3, pcb_top), 6, 1.3, fc=C_SW, ec="black", lw=1))
    ax.add_patch(Rectangle((-0.8, pcb_top + 1.3), 1.6, sw_top - pcb_top - 1.3, fc=C_ACT, ec="black"))
    for x in (-5.5, 4.0):
        ax.add_patch(Rectangle((x, pcb_top), 1.5, 0.5, fc="#8a6d3b", ec="black", lw=0.6))


def label(ax, txt, xy, xytext):
    ax.annotate(txt, xy=xy, xytext=xytext, fontsize=10, va="center",
                arrowprops=dict(arrowstyle="-", color="#555", lw=0.8))


fig, axes = plt.subplots(1, 2, figsize=(15, 6.4))
for ax, title in zip(axes, ["1. Llave abierta: el botón entra por dentro", "2. Llave cerrada"]):
    ax.set_xlim(-14, 25); ax.set_ylim(-7.8, 5.5); ax.set_aspect("equal"); ax.axis("off")
    ax.set_title(title, fontsize=14, weight="bold")

# panel 1: boton entrando en la ventana desde dentro
ax = axes[0]
half = win / 2
for x0, x1 in ((-13, -half), (half, 13)):
    ax.add_patch(Rectangle((x0, -shell_t), x1 - x0, shell_t, fc=C_SHELL, ec="black", lw=1))
button(ax, dz=-2.6)
ax.add_patch(FancyArrowPatch((0, -7.4), (0, -5.9), arrowstyle="-|>", mutation_scale=22, color="#d33", lw=2))
label(ax, "carcasa delantera (1,8 mm)", (8, -0.9), (14, 3.2))
label(ax, "parte que asoma por la ventana\n(icono hacia fuera)", (w, protrude - 2.6 - 0.5), (14, 0.2))
label(ax, "pestaña: más grande que\nla ventana, no se sale", (w + ov, zf - 2.6 + 0.2), (14, -3.6))
label(ax, "pivote", (nub_d / 2, tip - 2.6 + 0.3), (14, -6.2))

# panel 2: montado
ax = axes[1]
key(ax)
button(ax)
label(ax, "asoma %s mm (lo que pulsas)" % str(protrude).replace(".", ","), (w, protrude / 2), (14, 3.2))
label(ax, "carcasa", (9, -0.9), (14, 1.3))
label(ax, "la pestaña queda\ndebajo de la carcasa", (w + ov, z0 - ov), (14, -1.2))
label(ax, "módulo (capa negra)", (8, -2.8), (14, -3.3))
label(ax, "pivote sobre el pulsador\n(%s mm de holgura)" % str(gap).replace(".", ","), (nub_d / 2, tip + 0.1), (14, -5.3))
label(ax, "circuito", (10, -depth - 2.1), (14, -7.0))

fig.text(0.5, 0.02, "Sección del botón LOCK con las medidas reales (mm): ventana 9,7 × 8,0 · carcasa 1,8 · pulsador a 3,2 de la superficie.",
         ha="center", fontsize=10, color="#444")
plt.tight_layout(rect=(0, 0.04, 1, 1))
out = sys.argv[1] if len(sys.argv) > 1 else "img/montaje.png"
plt.savefig(out, dpi=130)
print(out)
