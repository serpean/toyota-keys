// =====================================================================
//  Botones de repuesto para mando Toyota Avensis (T25, 2003-2009)
//  Llave Valeo de 3 botones (hoja TOY43) - tambien Lexus IS/GS/RX de la época
//
//  v2 - BOTON CON PESTAÑA INTERIOR (como el original de goma)
//
//        ┌──────┐          <- asoma por la ventana (protrude)
//   ═════╡      ╞═════     <- carcasa (shell_t)
//      ◢─┘      └─◣        <- pestaña: mas grande que la ventana, no se sale
//      └────┬┬────┘
//           └┘             <- pivote: aprieta el micropulsador
//   ─────[pulsador]─────
//
//  Se monta DESDE DENTRO con la llave abierta: botón en su ventana,
//  módulo encima y cerrar. No necesita pegamento.
//
//  Modelado en posición de USO (z = 0 superficie exterior de la carcasa,
//  z+ hacia fuera) y girado 180 grados para imprimir con la cara del
//  icono contra la cama. Sin soportes: la pestaña tiene chaflán a 45°.
//
//  Pensado para Bambu Lab P2S con boquilla 0.2 mm (PETG / ASA).
//  TODAS LAS MEDIDAS EN mm, tomadas con calibre en la llave real.
// =====================================================================

/* [Que exportar] */
// caps = 3 botones; fit = 3 juegos con distinta holgura (1, 2 y 3 puntos); one = uno suelto
part = "caps"; // [caps, top, fit, fit_top, one, preview]
// Boton para part="one": 0 = arriba-izq, 1 = UNLOCK, 2 = LOCK
which = 2; // [0,1,2]

/* [MEDIDAS de la llave (calibre)] */
// [ancho, alto, radio esquina] de las ventanas de la carcasa
win_tl = [7.9, 8.0, 1.5];   // arriba-izquierda (8,3 medido no entraba: 7,9 = juego de 1 punto de la prueba de ancho)
win_un = [7.9, 8.0, 1.5];   // arriba-derecha "UNLOCK" (idem)
win_lk = [9.7, 8.0, 1.0];   // abajo "LOCK"
// Profundidad desde la superficie de la carcasa hasta la cima del pulsador (llave cerrada)
depth_tl = 3.65;
depth_un = 3.35;
depth_lk = 3.20;
// Grosor de la carcasa en el borde de la ventana
shell_t = 1.8;

/* [Prueba de ancho para los botones de arriba (part="fit_top")] */
// Anchos de ventana a probar (1, 2, 3 y 4 puntos)
fit_top_widths = [7.9, 7.6, 7.3, 7.0];
// Radio de esquina para la prueba (mas redondeado por si la ventana lo es)
fit_top_radius = 1.5;

/* [Ajuste] */
// Holgura por lado entre boton y ventana (part="caps"/"one")
clearance = 0.15;
// Holguras de los 3 juegos de part="fit" (1, 2 y 3 puntos grabados)
fit_clearances = [0.10, 0.15, 0.22];
// Cuanto asoma el boton por fuera de la carcasa
protrude = 1.5;
// Chaflan del borde exterior
top_chamfer = 0.3;

/* [Pestaña y pivote] */
// Cuanto sobresale la pestaña por cada lado de la ventana
flange_ov = 0.5;
// Grosor de la parte plana de la pestaña
flange_t = 0.4;
// Diametro del pivote
nub_d = 2.4;
// Holgura entre pivote y pulsador en reposo
nub_gap = 0.15;

/* [Iconos grabados] */
icon_tl = "none";   // [none, lock, unlock, trunk, dot]
icon_un = "unlock"; // [none, lock, unlock, trunk, dot]
icon_lk = "lock";   // [none, lock, unlock, trunk, dot]
icon_depth = 0.4;
// Ancho de trazo (>= 2 lineas con boquilla 0.2)
icon_line = 0.45;

$fn = 48;
eps = 0.01;

WINS   = [win_tl, win_un, win_lk];
DEPTHS = [depth_tl, depth_un, depth_lk];
ICONS  = [icon_tl, icon_un, icon_lk];

// ---------------------------------------------------------------- 2D
module rrect(w, h, r) {
    rr = max(0.05, min(r, w/2 - eps, h/2 - eps));
    offset(r = rr) square([w - 2*rr, h - 2*rr], center = true);
}

module slab(w, h, r, z0, t) {
    translate([0, 0, z0]) linear_extrude(t) rrect(w, h, r);
}

module icon2d(kind) {
    L = icon_line;
    if (kind == "lock" || kind == "unlock") {
        translate([0, -0.9]) difference() {
            square([3.4, 2.6], center = true);
            square([3.4 - 2*L, 2.6 - 2*L], center = true);
        }
        translate([0, -0.9]) circle(d = 0.7, $fn = 16);
        dx = (kind == "unlock") ? 0.9 : 0;
        dy = (kind == "unlock") ? 0.7 : 0;
        translate([dx, 0.4 + dy]) difference() {
            circle(r = 1.2);
            circle(r = 1.2 - L);
            translate([-2, -2]) square([4, 2]);
        }
        if (kind == "unlock")
            translate([dx + 1.2 - L, 0.3]) square([L, dy + 0.1]);
    } else if (kind == "trunk") {
        difference() { square([4.4, 1.6], center = true); square([4.4 - 2*L, 1.6 - 2*L], center = true); }
        translate([1.6, 0.8]) rotate(35) square([L, 1.6]);
    } else if (kind == "dot") {
        circle(d = 1.6);
    }
}

// ------------------------------------------------------------ 3D boton
module button(i, clr = clearance, icon = "none", dots = 0, win = undef) {
    wv = (win == undef) ? WINS[i] : win;
    w = wv[0] - 2*clr;
    h = wv[1] - 2*clr;
    r = wv[2];
    z0 = -shell_t + clr;                      // donde el chaflan toca el borde de la ventana
    zf = z0 - flange_ov - flange_t;           // cara inferior de la pestaña
    tip = -(DEPTHS[i] - nub_gap);             // punta del pivote
    nub_len = zf - tip;
    if (nub_len < 0.2)
        echo(str("AVISO boton ", i, ": pivote muy corto (", nub_len, " mm). Revisa depth/shell_t."));

    difference() {
        union() {
            // cuerpo que atraviesa la ventana y asoma por fuera
            hull() {
                slab(w, h, r, z0, protrude - z0 - top_chamfer);
                slab(w - 2*top_chamfer, h - 2*top_chamfer, r - top_chamfer, protrude - eps, eps);
            }
            // pestaña interior con chaflan a 45 grados (imprimible sin soportes)
            hull() {
                slab(w, h, r, z0, eps);
                slab(w + 2*flange_ov, h + 2*flange_ov, r + flange_ov, zf, flange_t);
            }
            // pivote
            if (nub_len > 0)
                translate([0, 0, tip]) cylinder(d = nub_d, h = nub_len + eps);
        }
        // icono grabado
        if (icon != "none")
            translate([0, 0, protrude - icon_depth]) linear_extrude(icon_depth + 1)
                translate(icon == "unlock" ? [-0.45, -0.35] : [0, 0]) icon2d(icon);
        // puntos de identificacion (part="fit") en la esquina superior izquierda
        for (k = [0 : max(dots - 1, 0)]) if (dots > 0)
            translate([-w/2 + 1.0 + k*0.9, h/2 - 1.0, protrude - 0.3])
                cylinder(d = 0.6, h = 1, $fn = 12);
    }
}

// girar a orientacion de impresion: cara exterior en z = 0
module print_orient() { translate([0, 0, protrude]) rotate([180, 0, 0]) children(); }

module set3(clr, dots = 0) {
    translate([-6, 6, 0]) button(0, clr, ICONS[0], dots);
    translate([ 6, 6, 0]) button(1, clr, ICONS[1], dots);
    translate([ 0, -6, 0]) button(2, clr, ICONS[2], dots);
}

// ------------------------------------------------------------ salidas
if (part == "caps") {
    print_orient() set3(clearance);
} else if (part == "one") {
    print_orient() button(which, clearance, ICONS[which]);
} else if (part == "top") {
    // solo los dos botones de arriba
    print_orient() {
        translate([-6, 0, 0]) button(0, clearance, ICONS[0]);
        translate([ 6, 0, 0]) button(1, clearance, ICONS[1]);
    }
} else if (part == "fit_top") {
    // en el laminador (tras girar): fila de delante = arriba-izquierda, fila de atras = UNLOCK
    print_orient() for (j = [0:3]) for (i = [0:1])
        translate([(j - 1.5) * 12, (i == 0 ? 6 : -6), 0])
            button(i, clearance, ICONS[i], j + 1, [fit_top_widths[j], WINS[i][1], fit_top_radius]);
} else if (part == "fit") {
    print_orient() for (j = [0:2]) translate([(j - 1) * 28, 0, 0]) set3(fit_clearances[j], j + 1);
} else {
    set3(clearance);
}
