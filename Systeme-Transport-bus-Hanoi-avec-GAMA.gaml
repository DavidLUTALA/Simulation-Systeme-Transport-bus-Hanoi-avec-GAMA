
model Systeme_transport_bus

/* Insert your model definition here */


global {
//	declaration des variables globales
	shape_file route_shape_file <- shape_file("../includes/route.shp");
	shape_file maison_shape_file <- shape_file("../includes/batiment.shp");
	shape_file arret_shape_file <- shape_file("../includes/arret.shp");
	shape_file terminus_shape_file <- shape_file("../includes/terminus_a.shp");
	shape_file ward_shape_file <- shape_file("../includes/ward.shp");
	shape_file line_1_shape_file <- shape_file("../includes/line_1.shp");
	shape_file line_2_shape_file <- shape_file("../includes/line_2.shp");
	shape_file line_3_shape_file <- shape_file("../includes/line_3.shp");
	image_file icon <- image_file("../includes/personne.png");
	image_file bus1 <- image_file("../includes/bus.png");
	
	image_file car <- image_file("../includes/car.png");
	
	
	 // Déclaration des graphes qui seront utilisés pour modéliser les réseaux de transport.

	graph road_network;
	graph road_line_1_aller;
	graph road_line_1_retour;
	graph road_line_1;
	graph road_line_2;
	graph road_line_3;
	
	 // Points initiaux pour les bus dans les différents itinéraires.
	 
	point point_bus_1_aller <- {460, 1300};
	point point_bus_1_retour <- {1540, 500};
	point point_3_bus_1 <- {500, 1500}; //600 et 1350
	
	// Enveloppe de la zone couverte par les routes, utilisée pour définir les limites géographiques.
   
	geometry shape <- envelope(route_shape_file);

	init {
		// Création des routes à partir des fichiers de forme spécifiés.
		create road from: route_shape_file;
		
		//creation des agents
		
		      
     
		create terminus from: terminus_shape_file {
			
			 // Création des terminus avec des noms spécifiés, utilisés comme points de départ et d'arrivée des bus.
			 
			list<terminus> the_terminus <- list(terminus);
			if (the_terminus != []) {
				the_terminus[0].terminus_name <- "A";
				the_terminus[1].terminus_name <- "B";
			}

		}
		
// Création des quartiers et attribution des noms aux différents districts.
		create ward from: ward_shape_file {
			list<ward> the_wards <- list(ward);
			if (the_wards != []) {
				the_wards[0].district_name <- "Cau Giay‎";
				the_wards[1].district_name <- "Dong Anh‎";
				the_wards[2].district_name <- "Long Bien‎";
				the_wards[3].district_name <- "Thuong Tin‎";
			}

		}
		// Initialisation des lignes de bus et ajustement de leur position.

		create line_1 from: line_1_shape_file {
			location <- {location.x - 10, location.y + 10};
		}

		create line_2 from: line_2_shape_file {
			location <- {location.x - 10, location.y + 8};
		}

		create line_3 from: line_3_shape_file {
			location <- {location.x - 15, location.y + 5};
		}
 // Création des arrêts de bus et ajustement de leur position géographique.
		create arret from: arret_shape_file {
			list<arret> the_bus_stop <- list(arret);
			//			Ajustement des agents sur la carte Qgis
			the_bus_stop[16].location <- {1040, 240};
			the_bus_stop[12].location <- {965, 1560};
			the_bus_stop[14].location <- {1542, 1420};
			the_bus_stop[1].location <- {664, 826};
			the_bus_stop[2].location <- {1168, 971};
			 // Association des arrêts de bus aux quartiers environnants.
			list<ward> the_wards <- list(ward) where ((each distance_to self <= 5));
			if (the_wards != []) {
				address <- the_wards[0].district_name;
			}
   			// Association des arrêts de bus aux lignes de bus correspondantes.
			list<line_1> the_line_1 <- list(line_1) where ((each distance_to self <= 50));
			list<line_2> the_line_2 <- list(line_2) where ((each distance_to self <= 50));
			list<line_3> the_line_3 <- list(line_3) where ((each distance_to self <= 50));
			if (the_line_1 != []) {
				line_bus <- "line_1";
			} else if (the_line_2 != []) {
				line_bus <- "line_2";
			} else if (the_line_3 != []) {
				line_bus <- "line_3";
			}

			list<arret> the_stop <- list(arret);
		}
			// Création des bus, attribution d'un terminus et définition de la ligne de bus.
		create bus number: 15 {
			list<terminus> the_terminus <- list(terminus);
			if (the_terminus != []) {
			//				the_terminus[0].terminus_name <- "A";
			//				the_terminus[1].terminus_name <- "B";
				location <- the_terminus[0].location;
			}
			//Distribution de la probabilite 
			line <- rnd_choice(["line_1"::0.33, "line_2"::0.33, "line_3"::0.34]);
			if (line = "line_1") {
				couleur <- #red;
			}

			if (line = "line_2") {
				couleur <- #green;
			}

			if (line = "line_3") {
				couleur <- #blue;
			}

		}
			
		// Création des bus, attribution d'un terminus et définition de la ligne de bus.
		
		create vehicules number: 10 {
			list<terminus> the_terminus <- list(terminus);
			if (the_terminus != []) {
			//				the_terminus[0].terminus_name <- "A";
			//				the_terminus[1].terminus_name <- "B";
				location <- the_terminus[0].location;
			}
			//Distribution de la probabilite 
			line <- rnd_choice(["line_1"::0.50, "line_2"::0.25, "line_3"::0.25]);
			if (line = "line_1") {
				couleur <- #yellow;
			}

			if (line = "line_2") {
				couleur <- #green;
			}

			if (line = "line_3") {
				couleur <- #blue;
			}

		}
// Création des résidences et association aux quartiers correspondants.
		create residence from: maison_shape_file {
			list<ward> the_wards <- list(ward) where ((each distance_to self <= 5));
			if (the_wards != []) {
				address <- the_wards[0].district_name;
			}

		}
		
		// Création des personnes et placement dans les résidences.
        // Ici, 90 personnes sont créées et chacune est placée dans une localisation aléatoire d'une des résidences disponibles.

		create people number: 120 {
			location <- any_location_in(one_of(residence));
		}
		//Les routes
		// Construction des graphes des routes pour les simulations de circulation.
        // Ces graphes sont utilisés pour simuler les déplacements sur les différentes routes et lignes de bus.
		road_network <- as_edge_graph(road);
		road_line_1 <- as_edge_graph(line_1);
		road_line_2 <- as_edge_graph(line_2);
		road_line_3 <- as_edge_graph(line_3);
		
		 // Sélection et transformation des segments spécifiques de la ligne 1 en graphes pour représenter les directions aller et retour.
     
		list<line_1> the_lines_1 <- list(line_1);
		road_line_1_aller <- as_edge_graph(the_lines_1[1]);
		road_line_1_retour <- as_edge_graph(the_lines_1[2]);
	} 
}
// Définition de l'espèce 'road' pour représenter les routes dans la simulation.
species road {
    // Définit la couleur des routes comme grise.
    rgb couleur <- #grey;

    // Aspect visuel par défaut pour dessiner les routes.
    aspect default {
        // Dessine la forme de l'agent route avec la couleur définie.
        draw shape color: couleur;
    }
}

// Définition de l'espèce 'terminus' pour représenter les terminus des bus.
species terminus {
    // Définit la couleur des terminus comme verte.
    rgb couleur <- #green;
    // Variable pour stocker le nom du terminus.
    string terminus_name;

    // Aspect visuel par défaut pour dessiner les terminus.
    aspect default {
        // Dessine la forme de l'agent terminus avec la couleur définie.
        draw shape color: couleur;
    }
}

// Définition de l'espèce 'arret' pour représenter les arrêts de bus.
species arret {
    // Définit la couleur des arrêts de bus comme rouge.
    rgb couleur <- #red;
    // Variable pour stocker l'adresse de l'arrêt de bus.
    string address;
    // Variable pour stocker la ligne de bus desservant cet arrêt.
    string line_bus;

    // Aspect visuel par défaut pour dessiner les arrêts de bus.
    aspect default {
        // Dessine un cercle de rayon 15 avec la couleur définie pour représenter l'arrêt.
        draw circle(15) color: couleur;
    }
}

// Définition de l'espèce 'residence' pour représenter les résidences dans la simulation.
species residence {
    // Définit la couleur des résidences comme grise.
    rgb couleur <- #gray;
    // Variable pour stocker l'adresse de la résidence.
    string address;

    // Aspect visuel par défaut pour dessiner les résidences.
    aspect default {
        // Dessine la forme de l'agent résidence avec la couleur définie.
        draw shape color: couleur;
    }
}

// Définition de l'espèce 'ward' pour représenter les quartiers dans la simulation.
species ward {
    // Définit la couleur des quartiers comme gris ardoise foncé.
    rgb couleur <- #darkslategrey;
    // Variable pour stocker le nom du district du quartier.
    string district_name;

    // Aspect visuel par défaut pour dessiner les quartiers.
    aspect default {
        // Dessine la forme de l'agent quartier avec la couleur définie.
        draw shape color: couleur;
    }
}

// Définition de l'espèce 'line_1' pour représenter la première ligne de bus.
species line_1 {
    // Définit la couleur de la ligne 1 comme rouge.
    rgb couleur <- #red;
    // Variable pour stocker le nom du district associé à cette ligne.
    string district_name;

    // Aspect visuel par défaut pour dessiner la ligne 1.
    aspect default {
        // Dessine la forme de l'agent ligne 1 avec la couleur définie.
        draw shape color: couleur width: 2;
    }
}

// Définition de l'espèce 'line_2' pour représenter la deuxième ligne de bus.
species line_2 {
    // Définit la couleur de la ligne 2 comme verte.
    rgb couleur <- #green;
    // Variable pour stocker le nom du district associé à cette ligne.
    string district_name;

    // Aspect visuel par défaut pour dessiner la ligne 2.
    aspect default {
        // Dessine la forme de l'agent ligne 2 avec la couleur définie.
        draw shape color: couleur width: 2;
    }
}

// Définition de l'espèce 'line_3' pour représenter la troisième ligne de bus.
species line_3 {
    // Définit la couleur de la ligne 3 comme bleue.
    rgb couleur <- #blue;
    // Variable pour stocker le nom du district associé à cette ligne.
    string district_name;

    // Aspect visuel par défaut pour dessiner la ligne 3.
    aspect default {
        // Dessine la forme de l'agent ligne 3 avec la couleur définie.
        draw shape color: couleur width: 2;
    }
}
// Définition de l'espèce 'bus' qui possède la capacité de se déplacer.
species bus skills: [moving] {
    // Couleur du bus, variable selon la ligne de bus attribuée.
    rgb couleur;
    // Ligne de bus que le bus est en train de suivre.
    string line;
    // Cible actuelle du bus sur son itinéraire.
    point target <- nil;
    // État actuel du bus (en station, en transit, etc.).
    string state <- "station";
    // Vitesse du bus, définie aléatoirement entre 1.0 et 4.0.
    float speed <- rnd(4.0, 4.0, 3.0);
    // Booléen indiquant si le bus peut se déplacer ou non.
    bool peut_marcher <- true;
    // Temps d'embarquement pour les passagers.
    int temps_embarquement <- 15;
    // Nombre de personnes à l'intérieur du bus.
    int nb_personne_inside <- 0;

   
    // Comportement de déplacement du bus selon son état et sa ligne.
    reflex move_behavior {
        // Comportement spécifique pour la ligne 2.
        if (line = "line_2") {
            // Gestion des transitions d'état pour la ligne 2.
            if (state = "station") {
                target <- {1135, 880};
            }
            if (self distance_to target <= 10 and state = "station") {
                state <- "transit_1";
            }
            if (state = "transit_1") {
                target <- {900, 1200};
                if (self distance_to target <= 10) {
                    state <- "transit_2";
                }
            }
            if (state = "transit_2") {
                target <- {500, 1400};
                if (self distance_to target <= 10) {
                    state <- "transit_3";
                }
            }
            if (state = "transit_3") {
                state <- "station";
            }
            // Déplacement du bus si autorisé.
            if (peut_marcher) {
                do goto target: target on: road_line_2 speed: speed;
            }
        }

        // Comportement spécifique pour la ligne 3.
        if (line = "line_3") {
            if (state = "station") {
                target <- {450, 1320};
            }
            if (self distance_to target <= 10 and state = "station") {
                state <- "transit_1";
            }
            if (state = "transit_1") {
                target <- {500, 1320};
                if (self distance_to target <= 10) {
                    state <- "station";
                }
            }
            if (peut_marcher) {
                do goto target: target on: road_line_3 speed: speed;
            }
        }

        // Comportement spécifique pour la ligne 1.
        if (line = "line_1") {
            if (state = "station") {
                target <- {460, 1300};
            }
            if (self distance_to target <= 10 and state = "station") {
                state <- "transit_1";
            }
            if (state = "transit_1") {
                target <- {1540, 500};
                if (self distance_to target <= 10) {
                    state <- "transit_2";
                }
            }
            if (state = "transit_2") {
                target <- {500, 1500};
                if (self distance_to target <= 10) {
                    state <- "station";
                }
            }
            if (peut_marcher) {
                do goto target: target on: road_line_1 speed: speed;
            }
        }
        
        
        

        // Compte des personnes entrant dans le bus.
        list<people> the_people <- list(people) where ((each.state_to_get_in = "dans le bus") and (each distance_to self <= 10));
        if (the_people != []) {
            nb_personne_inside <- length(the_people);
        }
        
       
    }

    // Aspect visuel du bus, montrant le nombre de personnes à l'intérieur et sa forme.
    aspect default {
    
		        draw "     " + self.nb_personne_inside color: #black;
		       // draw square(50) color: couleur;
		      //draw rectangle(larg,long) color: couleur rotate: heading + 90;
		       
				draw  image_file(bus1) size:(150) rotate:heading+180 color:couleur;
			
		   if(nb_personne_inside>=5){
        	 draw "MAX" color: #black;
        	 write "Ce bus est pein";
        	 draw  image_file(bus1) size:(150) rotate:heading+180 color:couleur;
        }
		
		
    }
}













// Définition de l'espèce 'bus' qui possède la capacité de se déplacer.
species vehicules skills: [moving] {
    // Couleur du bus, variable selon la ligne de bus attribuée.
    rgb couleur;
    // Ligne de bus que le bus est en train de suivre.
    string line;
    // Cible actuelle du bus sur son itinéraire.
    point target <- nil;
    // État actuel du bus (en station, en transit, etc.).
    string state <- "station";
    // Vitesse du bus, définie aléatoirement entre 1.0 et 4.0.
    float speed <- rnd(40);
    // Booléen indiquant si le bus peut se déplacer ou non.
    bool peut_marcher <- true;
    // Temps d'embarquement pour les passagers.
    int temps_embarquement <- 15;
    // Nombre de personnes à l'intérieur du bus.
    int nb_personne_inside <- 0;

   
    // Comportement de déplacement des vehicules selon son l'état et sa ligne.
    reflex move {
        // Comportement spécifique pour la ligne 2.
        if (line = "line_2") {
            // Gestion des transitions d'état pour la ligne 2.
            if (state = "station") {
                target <- {1135, 880};
            }
            if (self distance_to target <= 10 and state = "station") {
                state <- "transit_1";
            }
            if (state = "transit_1") {
                target <- {900, 1200};
                if (self distance_to target <= 10) {
                    state <- "transit_2";
                }
            }
            if (state = "transit_2") {
                target <- {500, 1400};
                if (self distance_to target <= 10) {
                    state <- "transit_3";
                }
            }
            if (state = "transit_3") {
                state <- "station";
            }
            // Déplacement du bus si autorisé.
            if (peut_marcher) {
                do goto target: target on: road_line_2 speed: speed;
            }
        }

        // Comportement spécifique pour la ligne 3.
        if (line = "line_3") {
            if (state = "station") {
                target <- {450, 1320};
            }
            if (self distance_to target <= 10 and state = "station") {
                state <- "transit_1";
            }
            if (state = "transit_1") {
                target <- {500, 1320};
                if (self distance_to target <= 10) {
                    state <- "station";
                }
            }
            if (peut_marcher) {
                do goto target: target on: road_line_3 speed: speed;
            }
        }

        // Comportement spécifique pour la ligne 1.
        if (line = "line_1") {
            if (state = "station") {
                target <- {460, 1300};
            }
            if (self distance_to target <= 10 and state = "station") {
                state <- "transit_1";
            }
            if (state = "transit_1") {
                target <- {1540, 500};
                if (self distance_to target <= 10) {
                    state <- "transit_2";
                }
            }
            if (state = "transit_2") {
                target <- {500, 1500};
                if (self distance_to target <= 10) {
                    state <- "station";
                }
            }
            if (peut_marcher) {
                do goto target: target on: road_line_1 speed: speed;
            }
        }
        
      

        // Compte des personnes entrant dans le bus.
       // list<people> the_people <- list(people) where ((each.state_to_get_in = "dans le bus") and (each distance_to self <= 10));
       // if (the_people != []) {
         //   nb_personne_inside <- length(the_people);
      //  }
    }

    // Aspect visuel du bus, montrant le nombre de personnes à l'intérieur et sa forme.
    aspect basic {
        //draw "     " + self.nb_personne_inside color: #black;
        //draw square(35) color: couleur;
      //draw rectangle(larg,long) color: couleur rotate: heading + 90;
       
		draw  image_file(car) size:(150) rotate:heading+180 color:couleur;
		
		
    }
}























// Définition de l'espèce 'people', représentant les individus dans la simulation.
species people skills: [moving] {
    // Couleur assignée à chaque personne, ici fixée à jaune.
    rgb couleur <- #yellow;
    // Adresse de résidence actuelle de la personne.
    string living_address;
    // Adresse de travail visitée.
    string visiting_address;
    // Temps restant pour dormir, initialisé aléatoirement entre 50 et 100 unités de temps.
    int time_rest <- rnd(50, 100, 2);
    // Temps passé au travail, initialisé aléatoirement entre 40 et 70 unités de temps.
    int time_work <- rnd(40, 70, 2);
    // État initial de la personne, ici "dormant".
    string state <- "sleeping";
    // Cible actuelle de la personne dans le monde de la simulation.
    point his_target;
    // Arrêt de bus le plus proche du lieu de travail.
    arret the_nearest_bus_stop_working;
    // Indicateur si la personne peut marcher.
    bool peut_marcher <- true;
    // Vitesse de déplacement de la personne.
    float vitesse <- 2.0;
    // État pour embarquer dans le bus.
    string state_to_get_in;
    // Ligne de bus que la personne compte prendre.
    string line_bus;
    // Lieu de travail comme type de résidence.
    residence place_working;
    // Indicateur si la personne est déjà montée dans le bus.
    bool deja_entrer <- false;
    float prix_de_base<-800;

    // Comportement pour gérer le sommeil des individus.
    reflex sleeping when: state = "sleeping" {
        time_rest <- time_rest - 1;
        if (time_rest = 0) {
            state <- "go working";  // Change l'état pour aller travailler.
        }
    }
    
  

    // Comportement pour démarrer le trajet vers le travail.
    reflex working when: state = "go working" {
        // Sélectionne aléatoirement un lieu de travail qui n'est pas l'adresse de résidence.
        list<residence> the_residence <- list(residence) where ((each.address != living_address));
        int j <- length(the_residence);
        place_working <- the_residence[rnd(j - 1)];
        // Trouve l'arrêt de bus le plus proche du lieu de travail.
        list<arret> the_bus_stop <- list(arret) where ((each.address = place_working.address));
        the_nearest_bus_stop_working <- first(the_bus_stop sort_by (place_working.location distance_to each));
        // Trouve le point d'embarquement le plus proche pour monter dans le bus.
        list<arret> the_pick_up_point <- list(arret) where ((each.line_bus = the_nearest_bus_stop_working.line_bus));
        arret the_nearest_pickup_point <- first(the_pick_up_point sort_by (self distance_to each));
        his_target <- the_nearest_pickup_point.location;
        line_bus <- the_nearest_pickup_point.line_bus;
        state <- "go take the bus";
         //write "En route pour l'arret bus";
    }
    


    // Comportement pour monter dans le bus.
    reflex get_in_on_the_bus {
        if (state = "go take the bus") {
            int stop_point <- rnd(10, 15, 1);
            if (self distance_to his_target <= stop_point) {
                peut_marcher <- false;
                state_to_get_in <- "arret bus";
            }
            // Trouve le bus correspondant à la ligne et monte dedans.
            list<bus> the_bus <- list(bus) where ((each distance_to self <= 20) and each.line = line_bus);
            if (the_bus != []) {
                his_target <- the_bus[0].location;
                vitesse <- 3.3;
                peut_marcher <- true;
                line_bus <- the_bus[0].line;
                state_to_get_in <- "dans le bus";
                 write "Embarquement des passagers";  
                     float prix <- prix_de_base;
                    write "================>>A payer  "+prix+" " +"VND";
                 //if(flip(0.2)){
 		        //	write "disparaitr";
 			     //  do die;
 		}
                 
                 
                  
                 
                 
            }
            // Détermine si la personne est arrivée à destination.
            if (state_to_get_in = "dans le bus") {
                if (self distance_to the_nearest_bus_stop_working <= 50) {
                    his_target <- place_working.location;
                    
                    write "================>>A destination";
                   
                    // if(flip(0.2)){
 		            //  write "disparaitr";
 			        // do die;
              //  }
            }
        }
    }

    // Comportement de déplacement, exécuté si la personne peut marcher.
    reflex move_behavior when: peut_marcher = true {
        do goto target: his_target speed: vitesse;
    }

    // Aspect visuel par défaut des personnes, représentées par une pyramide et une sphère.

    
    aspect default {
    draw image_file(icon) size:50;
}
    
    
}



// Expérience de simulation pour visualiser la ville en 3D.
experiment Systeme_transport_bus type: gui  {
    output {
        display map type: 3d {
            species road refresh: false;
            species residence;
            species bus;
            species line_1;
            species line_2;
            species line_3;
            species people;
            species arret;
            species vehicules aspect: basic;
            // Éléments graphiques supplémentaires pour marquer des points spécifiques.
            graphics "exit" refresh: false {
                draw sphere(20) at: point_bus_1_aller color: #yellow;
                draw sphere(20) at: point_bus_1_retour color: #green;
                draw sphere(20) at: point_3_bus_1 color: #green;
            }
        }
        
        display chart_display refresh: every(10#cycles)  type: 3d { 
			chart "Road Status" type: series size: {1, 0.5} position: {0, 0} {
				
				
			}
			chart "People Objectif" type: pie style: exploded size: {1, 0.5} position: {0, 0.5}{
				data "Working" value: people count (each.state="working") color: #magenta ;
				data "Resting" value: people count (each.state="resting") color: #blue ;
			}
		}
        
       
    }
}
