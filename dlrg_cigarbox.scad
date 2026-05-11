$fn = 30;

zigarre_durchmesser = 20;
zigarre_laenge = 140;
anzahl_zigarren = 3;
wand_dicke_aussen = 2.6;
wand_dicke_innen = 0.8;
gap_oben_unten = 0.5;
hoehe_oben_aussen = 60;
hoehe_oben_innen = 45;
zigarren_compacting = 1.;


translate_pack_y = (zigarre_durchmesser/2)-((anzahl_zigarren*zigarre_durchmesser)/2);

module zylinderabgerundet(hoehe, radius_zylinder, radius)
{
    translate([0,0,hoehe - radius]) cylinder(radius, r = radius_zylinder - radius);
    cylinder(hoehe - radius, r = radius_zylinder);
    translate([0,0, hoehe - radius]) rotate_extrude() translate([radius_zylinder - radius,0 ,0]) circle(radius);
}


module zigarreneinzel(laenge, durchmesser){
    zylinderabgerundet(laenge/2, durchmesser / 2, 2);
    rotate([180,0,0]) zylinderabgerundet(laenge/2, durchmesser / 2, 2);
}

module zigarrenpack(){
    for(cnt = [1 : anzahl_zigarren]){
        translate([0,(zigarre_durchmesser-zigarren_compacting)*(cnt-1),0]) zigarreneinzel(zigarre_laenge,zigarre_durchmesser);
    }
}

module aussen_aussen(){
    for(cnt = [1 : anzahl_zigarren]){
        translate([0,(zigarre_durchmesser-zigarren_compacting)*(cnt-1),0]) zigarreneinzel(zigarre_laenge+2*wand_dicke_aussen,zigarre_durchmesser+2*wand_dicke_aussen);
    }
}

module aussen_innen(){
    for(cnt = [1 : anzahl_zigarren]){
        translate([0,(zigarre_durchmesser-zigarren_compacting)*(cnt-1),0]) zigarreneinzel(zigarre_laenge+2*wand_dicke_innen,zigarre_durchmesser+2*wand_dicke_innen);
    }
}

module aussen_innen_oben(){
    for(cnt = [1 : anzahl_zigarren]){
        translate([0,(zigarre_durchmesser-zigarren_compacting)*(cnt-1),0]) zigarreneinzel(zigarre_laenge+2*wand_dicke_innen,zigarre_durchmesser+2*(wand_dicke_innen+gap_oben_unten));
    }
}

module abzug_oben_aussen(){
    translate([0,0,zigarre_laenge/2-hoehe_oben_aussen/2+2]) cube([zigarre_durchmesser+2*wand_dicke_aussen,anzahl_zigarren*zigarre_durchmesser+2*wand_dicke_aussen*1.1,hoehe_oben_aussen+4],center=true);
}

module abzug_unten_aussen(){
    translate([0,0,(-(zigarre_laenge-hoehe_oben_aussen)/2)+zigarre_laenge/2-hoehe_oben_aussen-2]) cube([zigarre_durchmesser+2*wand_dicke_aussen,anzahl_zigarren*zigarre_durchmesser+2*wand_dicke_aussen*1.1,zigarre_laenge-hoehe_oben_aussen+4],center=true);
}

module abzug_oben_innen(){
    translate([0,0,zigarre_laenge/2-hoehe_oben_innen/2+2]) cube([zigarre_durchmesser+2*wand_dicke_aussen,anzahl_zigarren*zigarre_durchmesser+2*wand_dicke_aussen*1.1,hoehe_oben_innen+4],center=true);
}

module abzug_unten_innen(){
    translate([0,0,(-(zigarre_laenge-hoehe_oben_innen)/2)+zigarre_laenge/2-hoehe_oben_innen-2]) cube([zigarre_durchmesser+2*wand_dicke_aussen,anzahl_zigarren*zigarre_durchmesser+2*wand_dicke_aussen*1.1,zigarre_laenge-hoehe_oben_innen+4],center=true);
}

module zigarren(){
    color("brown") translate([0,translate_pack_y,0])zigarrenpack();
}

module aussen_unten(){
    difference(){
        color("red") translate([0,translate_pack_y,0])aussen_aussen();
        zigarren();
        abzug_oben_aussen();
    }  
}

module aussen_oben(){
    difference(){
        color("red") translate([0,translate_pack_y,0])aussen_aussen();
        color("red") translate([0,translate_pack_y,0])aussen_innen_oben();
        zigarren();
        abzug_unten_aussen();
    }  
}

module innen_unten(){
    difference(){
        color("red") translate([0,translate_pack_y,0])aussen_innen();
        zigarren();
        abzug_oben_innen();
    }  
}

module innen_oben(){
    difference(){
        color("red") translate([0,translate_pack_y,0])aussen_innen_oben();
        zigarren();
        abzug_oben_innen();
    }  
}

module zigarrenbox_oben(){
    aussen_oben();
}

module zigarrenbox_unten(){
    aussen_unten();
    innen_unten();
}



module dbg_schnitt(){
    difference(){
        union(){
            zigarrenbox_unten();
            zigarrenbox_oben();
            //color("brown") zigarren();
        }
        translate([-15,0,-100]) cube([30,20,200], center=false);
    }   
}

zigarrenbox_unten();
//zigarrenbox_oben();



