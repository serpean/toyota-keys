// =====================================================================
//  Botones de repuesto para mando Toyota Avensis (T25, 2003-2009)
//  Llave Valeo de 3 botones (hoja TOY43) - tambien Lexus IS/GS/RX de la época
//
//  El botón es un "tapón": la tapa queda por encima de la goma original,
//  el vástago entra por el agujero roto de la goma, un pequeño reborde
//  (barb) lo retiene por debajo y un pivote (nub) aprieta el pulsador SMD.
//
//  Modelado en posición de USO (z+ = hacia fuera) y girado 180 grados
//  para imprimir con la cara superior apoyada en la cama (acabado liso,
//  sin soportes).
//
//  Pensado para Bambu Lab P2S con boquilla 0.2 mm (PETG / ASA / PLA).
//  TODAS LAS MEDIDAS EN mm. Mide con calibre y ajusta la seccion MEDIDAS.
// =====================================================================

/* [Que exportar] */
// caps = los 3 botones, fit = piezas de prueba de ajuste, one = un boton suelto
part = "caps"; // [caps, fit, one, preview]
// Boton para part="one": 0 = arriba-izq, 1 = UNLOCK (arriba-der), 2 = LOCK (abajo)
which = 1; // [0,1,2]

/* [MEDIDAS - agujeros en la goma] */
// [ancho, alto, radio esquina] de cada agujero de la goma (medidos en la foto, ~+-0.5 mm)
hole_tl = [8.8, 8.6, 1.2];   // arriba-izquierda (sin rotular)
hole_un = [8.8, 9.0, 1.2];   // arriba-derecha  "UNLOCK"
hole_lk = [11.8, 9.2, 1.2];  // abajo          "LOCK"
// Escala global del vastago (usa el resultado de las piezas "fit")
size_scale = 1.00;
// Holgura por lado entre vastago y goma
clearance = 0.15;

/* [MEDIDAS - profundidades] */
// Grosor de la goma en el borde del agujero
membrane_t = 1.6;
// Desde la superficie de la goma hasta la cima del pulsador (medir con la sonda del calibre)
switch_depth = 2.8;
// Holgura del pivote antes de tocar el pulsador (recorrido libre)
nub_gap = 0.20;

/* [Tapa] */
// Cuanto sobresale la tapa sobre la goma alrededor del agujero
cap_overlap = 0.9;
// Altura de la tapa por encima de la goma
cap_h = 1.6;
// Chaflan del borde superior
cap_chamfer = 0.4;

/* [Retencion y pivote] */
// Reborde de retencion por lado (0 = sin reborde, para pegar)
barb = 0.30;
// Altura del reborde
barb_h = 0.6;
// Diametro del pivote que aprieta el pulsador
nub_d = 2.4;

/* [Iconos grabados] */
icon_tl = "none";   // [none, lock, unlock, trunk, dot]
icon_un = "unlock"; // [none, lock, unlock, trunk, dot]
icon_lk = "lock";   // [none, lock, unlock, trunk, dot]
icon_depth = 0.4;
// Ancho de trazo del icono (>= 2 lineas con boquilla 0.2)
icon_line = 0.45;

$fn = 48;
eps = 0.01;

HOLES = [hole_tl, hole_un, hole_lk];
ICONS = [icon_tl, icon_un, icon_lk];

// ---------------------------------------------------------------- 2D
module rrect(w, h, r) {
    rr = min(r, w/2 - eps, h/2 - eps);
    offset(r = rr) square([w - 2*rr, h - 2*rr], center = true);
}

module slab(w, h, r, z0, t) {
    translate([0, 0, z0]) linear_extrude(t) rrect(w, h, r);
}

module icon2d(kind) {
    L = icon_line;
    if (kind == "lock" || kind == "unlock") {
        // cuerpo
        translate([0, -0.9]) difference() {
            square([3.4, 2.6], center = true);
            square([3.4 - 2*L, 2.6 - 2*L], center = true);
        }
        translate([0, -0.9]) circle(d = 0.7, $fn = 16);
        // arco (en "unlock" sube y se desplaza: candado abierto)
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
        // silueta de coche con maletero abierto (simplificada)
        difference() { square([4.4, 1.6], center = true); square([4.4 - 2*L, 1.6 - 2*L], center = true); }
        translate([1.6, 0.8]) rotate(35) square([L, 1.6]);
    } else if (kind == "dot") {
        circle(d = 1.6);
    }
}

// ------------------------------------------------------------ 3D boton
// i: indice del agujero; s: escala; notches: marcas de identificacion; with_nub
module cap(i, s = size_scale, icon = "none", notches = 0, with_nub = true) {
    hw = HOLES[i][0] * s - 2*clearance;
    hh = HOLES[i][1] * s - 2*clearance;
    r  = HOLES[i][2];
    tw = hw + 2*cap_overlap;
    th = hh + 2*cap_overlap;
    tr = r + cap_overlap;
    nub_len = max(switch_depth - nub_gap, membrane_t + barb + barb_h + 0.2);

    difference() {
        union() {
            // tapa con chaflan superior
            hull() {
                slab(tw, th, tr, 0, cap_h - cap_chamfer);
                slab(tw - 2*cap_chamfer, th - 2*cap_chamfer, max(tr - cap_chamfer, 0.3), cap_h - eps, eps);
            }
            // vastago a traves de la goma
            slab(hh > 0 ? hw : 1, hh, r, -membrane_t, membrane_t + eps);
            // reborde de retencion (doble chaflan, imprimible sin soportes)
            if (barb > 0) hull() {
                slab(hw, hh, r, -membrane_t, eps);
                slab(hw + 2*barb, hh + 2*barb, r + barb, -membrane_t - barb, eps);
                slab(hw, hh, r, -membrane_t - barb - barb_h, eps);
            }
            // pivote
            if (with_nub)
                translate([0, 0, -nub_len]) cylinder(d = nub_d, h = nub_len);
        }
        // icono grabado en la cara superior
        if (icon != "none")
            translate([0, 0, cap_h - icon_depth]) linear_extrude(icon_depth + 1)
                scale(min(1, hh / 9)) translate(icon == "unlock" ? [-0.45, -0.35] : [0, 0]) icon2d(icon);
        // muescas de identificacion en el borde (piezas de prueba)
        for (k = [0 : notches - 1]) if (notches > 0)
            translate([-tw/2 + 1.5 + k*1.4, th/2, -1]) cylinder(d = 0.8, h = cap_h + 2, $fn = 12);
    }
}

// girar a orientacion de impresion: cara superior en z = 0
module print_orient() { translate([0, 0, cap_h]) rotate([180, 0, 0]) children(); }

// ------------------------------------------------------------ salidas
if (part == "caps") {
    print_orient() {
        translate([-8, 7, 0])  cap(0, icon = ICONS[0]);
        translate([ 8, 7, 0])  cap(1, icon = ICONS[1]);
        translate([ 0, -7, 0]) cap(2, icon = ICONS[2]);
    }
} else if (part == "one") {
    print_orient() cap(which, icon = ICONS[which]);
} else if (part == "fit") {
    // 5 escalas x 3 agujeros. Muescas: 1=0.94 2=0.97 3=1.00 4=1.03 5=1.06
    scales = [0.94, 0.97, 1.00, 1.03, 1.06];
    print_orient()
        for (i = [0:2]) for (j = [0:4])
            translate([j * 16 - 32, i * 14 - 14, 0])
                cap(i, s = scales[j], notches = j + 1, with_nub = false);
} else {
    // vista previa en posicion de uso
    translate([-8, 7, 0])  cap(0, icon = ICONS[0]);
    translate([ 8, 7, 0])  cap(1, icon = ICONS[1]);
    translate([ 0, -7, 0]) cap(2, icon = ICONS[2]);
}
