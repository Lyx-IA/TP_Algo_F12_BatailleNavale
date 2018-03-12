{
//ALGO: BatailleNavale
//BUT: Programme de bataille navale sans utilisation de tableau pour la grille et le placement des bateaux.
//ENTREES: Coordonnées, direction, confirmation
//SORTIES:	Affichage grille+bateaux, consignes



CONST
	MaxBoat=5
	max=20
	nbJoueur=2
	
TYPE
	coord=ENREGISTREMENT
		x,y:ENTIER
FIN

TYPE
	bateau=ENREGISTREMENT
		cases:tableau[1..5] DE coord
		taille:ENTIER
FIN

TYPE 
	flotte=ENREGISTREMENT
		boat:tableau[1..MaxBoat] DE bateau
		joueur,restants:ENTIER
FIN

TYPE
	grille:TABLEAU[1..nbJoueur] DE flotte


FONCTION BateauHorsLimites(bateau1:bateau) : BOOLEEN 										
//BUT: Retourne un booléen qui vérifie si le bateau en paramètre est hors limites ou pas
//ENTREES: Bateau 
//SORTIES: Booléen
			VAR
				i:ENTIER
				test:BOOLEEN
						DEBUT
							test<-FAUX											
							POUR i DE 1 A (bateau1.taille) FAIRE							
								SI (bateau1.cases[i].x<1) OU (bateau1.cases[i].y<1) OU (bateau1.cases[i].y>max) OU (bateau1.cases[i].x>max) ALORS
									test<-VRAI
								FIN SI
							FIN POUR
							BateauHorsLimites<-test
						FIN
											
											
FONCTION Comparaison(coord1,coord2:coord) : BOOLEEN
//BUT: Retourne un booléen qui vérifie si deux coordonnées (cellules) sont équivalentes
//ENTREES: Deux coordonnées à comparer
//SORTIES: Booléen
						DEBUT
							Comparaison<-FAUX												
								SI (coord1.x=coord2.x) ET (coord1.y=coord2.y) ALORS		 
									Comparaison<-VRAI										
								FIN SI
						FIN
FONCTION OwnBateau(bateau1:bateau ; coord1:coord) : BOOLEEN
//BUT: Retourne un booléen qui vérifie si la coordoonée en paramètre appartient au bateau en paramètre
//ENTREES: Bateau et coordonnée à comparer
//SORTIES: Booléen
				VAR
					i:ENTIER
						DEBUT
							OwnBateau<-FAUX														
							POUR i DE 1 A (bateau1.taille) FAIRE								
								SI Comparaison(bateau1.cases[i],coord1)=VRAI ALORS		
									OwnBateau<-VRAI												
								FIN SI
							FIN POUR
						FIN
FONCTION OwnFlotte(flotte1:flotte ; coord1:coord) : BOOLEEN									
				VAR
					i:ENTIER
					test:BOOLEEN
						DEBUT
							test<-FAUX														
							POUR i DE 1 A MaxBoat	FAIRE											
								SI (OwnBateau(flotte1.boat[i],coord1)) ALORS
									test<-VRAI												
								FIN SI
							FIN POUR
							OwnFlotte<-test
						FIN
						
FONCTION OwnBatToFlotte(flotte1:flotte ; bateau1:bateau) : BOOLEEN
//BUT: Booléen qui retourne si un bateau appartient à une flotte ( utile pour un bateau qui n'est pas encore distribué, cf:CreBateau)
//ENTREES: flotte, bateau à comparer
//SORTIES: Booléen

				VAR
					i,j:ENTIER
					test:BOOLEEN
						DEBUT
							test<-FAUX
							POUR i DE 1 A MaxBoat FAIRE
								POUR j DE 1 A bateau1.taille FAIRE
									SI (OwnBateau(flotte1.boat[i],bateau1.cases[j]) Alors
										test<-VRAI
									FIN SI
								FIN POUR
							FIN POUR
							OwnBatToFlotte<-test
						FIN
						
PROCEDURE CreaCoord(x,y:ENTIER ; var coord1:coord)
//BUT: Assigner une coordonnée à partir de deux entiers
//ENTREES: x,y, coordonnée à modifier
//SORTIES: Coordonnée 

						DEBUT
							coord1.x<-x
							coord1.y<-y
						FIN
FONCTION CreaBateau(compteur,taille:ENTIER): Bateau
//BUT: Placer correctement un bateau en fonction des coordonnées et de la direction entrées par l'utilisateur
//ENTREES: Valeur compteur représentant le numéro du bateau dans la flotte le possédant, bateau vide, flotte en initialisation
//SORTIES: Affectation des coordonnées de chaque cellule du bateau

				VAR
					i,x,y:ENTIER
					direction:CARACTERE
					stockcoord:coord
					troll:BOOLEEN
					bateau1:bateau
						DEBUT
							REPETER																
								troll<-FAUX 													
								ECRIRE("Entrez les coordonnées de votre bateau de longueur " & taille & " (comprises entre 1 et " & max & ")")	
								ECRIRE("Dans cet ordre: Abscisse, Ordonnée")
								LIRE(x,y)														
								CreaCoord(stockcoord)
								REPETER															
									ECRIRE("Entrez l'orientation de votre bateau")				
									ECRIRE("NORD (N) ; EST (E) ; SUD (S) ; OUEST (O)")
									LIRE(direction)
								JUSQU'A (direction="N") OU (direction="E") OU (direction="S") OU (direction="O")
									POUR i DE 1 A bateau1.taille FAIRE  														
										CAS direction PARMI										
											"S":
												(bateau1.cases[i].x)<-(stockcoord.x)
												(bateau1.cases[i].y)<-(stockcoord.y+i-1)			
											"E":
												(bateau1.cases[i].x)<-(stockcoord.x+i-1) 			
												(bateau1.cases[i].y)<-(stockcoord.y)
											"N":
												(bateau1.cases[i].x)<-(stockcoord.x)		
												(bateau1.cases[i].y)<-(stockcoord.y-i+1)			
											"O":
												(bateau1.cases[i].x)<-(stockcoord.x-i+1)			
												(bateau1.cases[i].y)<-(stockcoord.y)
										FIN CASPARMI
									FIN POUR
								SI (BateauHorsLimites(bateau1)) ALORS
									troll<-VRAI												
									ECRIRE("Bateau hors limites, recommencez")
								SINON
									troll<-FAUX
								FIN SI
							JUSQU'A (i=bateau1.taille) ET (troll=FAUX)
							Creabateau<-bateau1
						FIN

						
PROCEDURE AffichageTableau(flotte1:flotte)														
//BUT: Afficher la grille de jeu avec les axes x,y et les bateaux s'il y en a
//ENTREES: Flotte
//SORTIES: Affichage de la grille avec flotte

				VAR
					i,j:ENTIER
					stockcoord:coord
						DEBUT
							POUR i DE 0 A max FAIRE												
								POUR j DE 0 A max FAIRE											
									stockcoord.x<-j												
									stockcoord.y<-i		
										SI (i=0) ALORS											
											SI (j>9) ALORS										
												ECRIRE(" " & j)
											SINON
												ECRIRE("  " & j)
											FIN SI
										SINON
											SI (j=0) ALORS										
												SI (i>9) ALORS									
													ECRIRE(" ",i," ")
												SINON
													ECRIRE("  ",i," ")
												FIN SI
											SINON
												SI (OwnFlotte(flotte1,stockcoord)=VRAI) ALORS
													ECRIRE(" ",CHR(129)," ")					
												SINON											
													ECRIRE(" . ")
												FIN SI
											FIN SI
										FIN SI
								FIN POUR
								//Retour à la ligne pour affichage
							FIN POUR
	
PROCEDURE InitFlotte (var flotte1:flotte)
//BUT: Assignation d'une flotte 
//ENTREES: Flotte
//SORTIES: Flotte remplie de bateaux positionnés, affichage grille

				VAR
					i,j:ENTIER
					bateau1:bateau
						DEBUT
							POUR i DE 1 A MaxBoat FAIRE												
								CAS i PARMI
									1:flotte1.boat[i].taille<-2								
									2:flotte1.boat[i].taille<-3
								CAS PAR DEFAUT
									flotte1.boat[i].taille<-i
								FIN CAS PARMI
								REPETER
									bateau1<-CreaBateau(i,flotte1.boat[i].taille)
										SI OwnBatToFlotte(flotte1,bateau1) ALORS	
											ECRIRE("Superposition impossible, recommencez")										
								JUSQU'A OwnBatToFlotte(flotte1,bateau1)=FAUX
								flotte1.boat[i]<-bateau1
								AffichageTableau(flotte1)									
							FIN POUR
						FIN
						
FONCTION BateauCoulé(bateau1:bateau) DE ENTIER													
//BUT: Retourner un entier qui permettra de comparer la taille du bateau avec le nombre de ses cellules touchées
//ENTREES: Bateau 
//SORTIES: Entier qui représente le nombre de cellules touchées 

				VAR
					i:ENTIER
					
						DEBUT
							BateauCoulé<-0														
							POUR i DE 1 A bateau1.taille FAIRE									
								SI (bateau1.cases[i].x=0) ET (bateau1.cases[i].y=0) ALORS		
									BateauCoulé<-BateauCoulé+1									
									
								FIN SI
							FIN POUR
						FIN
						
FONCTION Défaite(flotte1:flotte) DE BOOLEEN														
//BUT: Booléen qui vérifie si un joueur a perdu
//ENTREES: Flotte du joueur
//SORTES: Booléen

				VAR
					i,j,stock:ENTIER
						DEBUT
							sotck<-0															
							POUR i DE 1 A MaxBoat FAIRE												
								POUR j DE 1 A flotte1.boat[i].taille FAIRE						
									SI (flotte1.boat[i].cases[j].x=-1) ET (flotte1.boat[i].cases[j].y=-1)	
										stock<-stock+1												
									FIN SI
								FIN POUR
							FIN POUR
								SI (stock=MaxBoat) ALORS													
									Défaite<-VRAI													
									ECRIRE("Le joueur " & flotte1.joueur & " a perdu")
								SINON
									Défaite<-FAUX
								FIN SI
						FIN
			
PROCEDURE TourDeJeu(flotte1:flotte ; var flotte2:flotte)											
				VAR
					i,j:ENTIER
					stockcoord:coord
						DEBUT
							ECRIRE("Voici votre flotte")
							AffichageTableau(flotte1)												
							ECRIRE("Vos ordres " & flotte1.joueur)
							ECRIRE("Entrez les coordonnées de votre tir")
							ECRIRE("Ordre: Abscisse, Ordonnée")
							LIRE(x,y)
							CreaCoord(x,y,stockcoord)																	
								SI OwnFlotte(flotte2,stockcoord)=VRAI Alors										
									ECRIRE("Touché !")
									POUR i DE 1 A MaxBoat FAIRE														
										POUR i DE 1 A flotte2.boat[i].taille FAIRE								
											SI (Comparaison(flotte2.boat[i].cases[j],stockcoord)=VRAI) ALORS	
												flotte2.boat[i].cases[j].x<-0									
												flotte2.boat[i].cases[j].y<-0
											FIN SI
											SI (BateauCoulé(flotte2.boat[i])=flotte2.boat[i].taille) ALORS		
												ECRIRE("Coulé !")
												flotte2.restants<-(flotte2.restants-1)									
												flotte2.boat[i].cases[j].x<- -1									
												flotte2.boat[i].cases[j].y<- -1									
											FIN SI
										FIN POUR
									FIN POUR
								SINON
									ECRIRE("Manqué !")
								FIN SI
							POUR i DE 0 A max FAIRE										
								POUR j DE 0 A max FAIRE									
										SI (i=0) ALORS									
											SI (j>9) ALORS								
												ECRIRE(" " & j)
											SINON
												ECRIRE("  " & j)
											FIN SI
										SINON
											SI (j=0) ALORS								
												SI (i>9) ALORS							
													ECRIRE(" ",i," ")
												SINON
													ECRIRE("  ",i," ")
												FIN SI
											SINON
												SI (stockcoord.x=j) ET stockcoord.y=i) ALORS
													ECRIRE(" ",CHR(64)," ")					
												SINON											
													ECRIRE(" . ")
												FIN SI
											FIN SI
										FIN SI
								FIN POUR
								//Retour à la ligne pour affichage
							FIN POUR
							ECRIRE("Votre adversaire possède encore ",flotte2.restants," bateau(x). Entrez pour continuer")
						FIN
						
VAR
	nGrille:grille
	i,j:ENTIER
	Confirm:STRING
BEGIN
	clrscr
	ECRIRE("Bienvenue dans le programme de bataille navale")
	ECRIRE("Entrez pour commencer la partie")
	POUR i DE 1 A nbJoueur FAIRE																				
		ECRIRE("Joueur " & i & " :")
		InitFlotte(nGrille[i])
		nGrille[i].joueur<-i																		
		nGrille[i].restants<-MaxBoat
		ECRIRE("Entrez "OK" pour confirmer")
		LIRE(Confirm)
	JUSQU'A (Confirm="OK")
	REPETER																							
		TourDeJeu(nGrille[1],nGrille[2])
			SI Defaite(nGrille[1])=FAUX ALORS
				TourDeJeu(nGrille[2],nGrille[1])
			FIN SI
	JUSQU'A Defaite(nGrille[1]) OU Defaite(nGrille[2]) 
	
FIN	
			
}

	
PROGRAM BatNavale;

uses crt;


CONST
	max=14;			//Dimensions
	MaxBoat=5;		//Nombre maximal de bateaux (définit aussi la taille maximale)
	nbJoueur=2;		//Nombre de joueurs

TYPE
	coord=RECORD
		x,y:INTEGER
END;

TYPE
	bateau=RECORD
		cases:ARRAY[1..5] OF coord;
		taille:INTEGER;
END;

TYPE
	flotte=RECORD
		boat:ARRAY[1..MaxBoat] OF bateau;
		joueur,restants:INTEGER;
END;

TYPE grille=ARRAY[1..nbJoueur] OF flotte;								//Une flotte par joueur
	
FUNCTION BateauHorsLimites (bateau1:bateau) : BOOLEAN;								
//BUT: Retourne un booléen qui vérifie si le bateau en paramètres est hors limites ou pas
//ENTREES: Bateau 
//SORTIES: Booléen
					VAR
						i:INTEGER;
						test:BOOLEAN;
								BEGIN
									test:=FALSE;						//Initialisation
									FOR i:=1 TO bateau1.taille DO					//Pour chaque cellule du bateau en paramètre
										BEGIN	
											IF (bateau1.cases[i].x<1) OR (bateau1.cases[i].y<1) OR (bateau1.cases[i].y>max) OR (bateau1.cases[i].x>max) THEN
												//Si les coordonnées du bateau sont en dehors de l'intervalle, alors test retourne VRAI
												test:=TRUE
										END;
									BateauHorsLimites:=test;
								END;
	
	
FUNCTION Comparaison (coord1,coord2:coord) : BOOLEAN;								
//BUT: Retourne un booléen qui vérifie si deux coordonnées (cellules) sont équivalentes
//ENTREES: Deux coordonnées à comparer
//SORTIES: Booléen

								BEGIN
									Comparaison:=FALSE;								// Initialisation
									IF (coord1.x=coord2.x) AND (coord1.y=coord2.y) THEN
										Comparaison:=TRUE							// Si les deux coordonnées sont égales alors la fonction retourne VRAI
								END;
								
FUNCTION OwnBateau (bateau1:bateau ; coord1:coord) : BOOLEAN;						
//BUT: Retourne un booléen qui vérifie si la coordoonée en paramètre appartient à un bateau
//ENTREES: Bateau et coordonnée à comparer
//SORTIES: Booléen

					VAR
						i:INTEGER;
								BEGIN
									OwnBateau:=FALSE;								//Initialisation
									FOR i:=1 TO (bateau1.taille) DO					//Pour chaque cellule du bateau
										IF Comparaison(bateau1.cases[i],coord1)=TRUE THEN//Si les coordonnées en paramètres sont égales à la cellule actuelle du bateau (i), alors la fonction retourne VRAI
												OwnBateau:=TRUE
										
								END;
								
FUNCTION OwnFlotte (flotte1:flotte ; coord1:coord) : BOOLEAN;
//BUT: Retourne un booléen qui vérifie si un bateau de la flotte en paramètre possède les coordonnées entrées 
//ENTREES: Flotte et coordonnée à comparer 
//SORTIES: Booléen
					VAR	
						i:INTEGER;
								BEGIN
									OwnFlotte:=FALSE;								//Initialisation
									FOR i:=1 TO MaxBoat DO								//Pour chaque bateau constituant la flotte
										IF (OwnBateau(flotte1.boat[i],coord1)=TRUE) THEN
											BEGIN
												OwnFlotte:=TRUE;					//Si les coordonées en paramètres appartiennent au bateau actuel (i), alors la fonction retourne VRAI
											END;
								END;
	
FUNCTION OwnBatToFlotte(flotte1:flotte ; bateau1:bateau):BOOLEAN;
//BUT: Booléen qui retourne si un bateau appartient à une flotte ( utile pour un bateau qui n'est pas encore distribué, cf:CreBateau)
//ENTREES: flotte, bateau à comparer
//SORTIES: Booléen

						VAR
							i,j:INTEGER;
							test:BOOLEAN;
								BEGIN
									test:=FALSE;
									FOR i:=1 TO MaxBoat DO
										BEGIN
											FOR j:=1 TO bateau1.taille DO
												BEGIN
													IF (OwnBateau(flotte1.boat[i],bateau1.cases[j])) THEN
														test:=TRUE;
												END;
										END;
									OwnBatToFlotte:=test;
								END;

PROCEDURE CreaCoord(x,y:INTEGER ; var coord1:coord);
//BUT: Assigner une coordonnée à partir de deux entiers
//ENTREES: x,y, coordonnée à modifier
//SORTIES: Coordonnée 
								BEGIN
									coord1.x:=x;
									coord1.y:=y;
								END;
						


FUNCTION CreaBateau (compteur,taille:INTEGER): Bateau;
//BUT: Placer correctement un bateau en fonction des coordonnées et de la direction entrées par l'utilisateur
//ENTREES: Valeur compteur représentant le numéro du bateau dans la flotte le possédant, bateau vide, flotte en initialisation
//SORTIES: Affectation des coordonnées de chaque cellule du bateau
					VAR
						i:INTEGER;
						x,y:1..max;
						direction:CHAR;
						stockcoord:coord;
						troll:BOOLEAN;
						bateau1:bateau;
								BEGIN
									REPEAT															//Répéter la création du bateau jusqu'à ce que son positionnement valide
										troll:=FALSE;												//Initialisation
										writeln('Entrez les coordonnées de votre bateau de longueur ' , taille , ' (comprises entre 1 et ' , max , ')');//Demande à l'utilisateur d'entrer les coordonnées du bateau en fonction de sa taille (compteur) 
										writeln('Ordre: Abscisse, Ordonnée');
										readln(x,y);
										CreaCoord(x,y,stockcoord);											//Lecture des coordonnées entrées par l'utilisateur
										bateau1.taille:=taille;
										REPEAT														//Répéter jusqu'à ce que la valeur soit valide
											writeln('Entrez l''orientation de votre bateau :');		//Demande de l'orientation du bateau actuel à l'utilisateur avec un caractère
											writeln('NORD (N) ; EST (E) ; SUD (S) ; OUEST (O)');
											readln(direction);
										UNTIL (direction='N') OR (direction='E') OR (direction='S') OR  (direction='O');
											FOR i:=1 TO bateau1.taille DO						//Pour chaque cellule de bateau1
												BEGIN
														CASE direction OF							//En fonction de la direction choisie, les coordonnées de la cellule actuelle (i en incrémentation) sont modifiées
															'S':
																BEGIN
																	(bateau1.cases[i].x):=(stockcoord.x);
																	(bateau1.cases[i].y):=(stockcoord.y+i-1);//Vers le bas (+i-1 Pour partir des coordoonées entrées)
																END;
															'E':
																BEGIN
																	(bateau1.cases[i].x):=(stockcoord.x+i-1);//Vers la droite (+i-1 Pour partir des coordoonées entrées)
																	(bateau1.cases[i].y):=(stockcoord.y);
																END;
															'N':
																BEGIN
																	(bateau1.cases[i].x):=(stockcoord.x);
																	(bateau1.cases[i].y):=(stockcoord.y-i+1);//Vers le haut (-i+1 Pour partir des coordoonées entrées)
																END;
															'O':
																BEGIN
																	(bateau1.cases[i].x):=(stockcoord.x-i+1);//Vers la gauche (-i+1 Pour partir des coordoonées entrées)
																	(bateau1.cases[i].y):=(stockcoord.y);
																END;
														END;
														
												END;
										IF BateauHorsLimites(bateau1) THEN
											BEGIN
												troll:=TRUE;								//Si le bateau positionné est hors limite, alors demande de recommencer la saisie et troll2 retourne VRAI
												writeln('Bateau Hors limite, recommencez');
											END
										ELSE
											BEGIN
												troll:=FALSE;
											END;
									UNTIL (i=bateau1.taille) AND (troll=FALSE);	//Nettoyer/Initialiser les cellules de toute la flotte en paramètre
									Creabateau:=bateau1;	
								END;
								





PROCEDURE AffichageTableau(flotte1:flotte);			
//BUT: Afficher la grille de jeu avec les axes x,y et les bateaux s'il y en a
//ENTREES: Flotte
//SORTIES: Affichage de la grille avec flotte
				VAR
					i,j:INTEGER;
					stockcoord:coord;
							BEGIN
								FOR i:=0 TO max DO								//Pour chaque case de la grille y compris 0 (origine)
									BEGIN
											FOR j:=0 TO max DO					//Pour chaque case de la grille y compris 0 (origine)
												BEGIN
												stockcoord.x:=j;				//Stocker les valeurs des compteurs pour les utiliser dans la vérification ci-dessous
												stockcoord.y:=i;
													IF (i=0)THEN				//Pour la première ligne, affichage du numéro des colonnes (j)
														IF j>9 THEN				//Formalité d'affichage pour équilibrer les espaces entre les chiffres et les nombres
															write(' ',j)
														ELSE
															write('  ',j)
													ELSE
														IF (j=0) THEN			//Pour la première colonne, affichage du numéro des lignes (i)
															IF i>9 THEN			//Formalité d'affichage pour équilibrer les espaces entre les chiffres et les nombres
																write(' ',i,' ')
															ELSE
																write('  ',i,' ')
														ELSE
															IF OwnFlotte(flotte1,stockcoord) THEN
																write(' ',CHR(129),' ')//Si aux coordonnées des valeurs actuelles des compteurs (i,j) se trouve un bateau de la flotte, alors affichage d'un carré
															ELSE				//Sinon afficher des points
																write(' . ')
												END;
										writeln;
									END;
										
							END;

PROCEDURE InitFlotte (var flotte1:flotte);
//BUT: Assignation d'une flotte 
//ENTREES: Flotte
//SORTIES: Flotte remplie de bateaux positionnés, affichage grille
					VAR
						i,j:INTEGER;
						bateau1:bateau;
								BEGIN
									FOR i:=1 TO MaxBoat DO// Pour chaque bateau de flotte1, la taille est attribuée en fonction du compteur
										BEGIN
											CASE i OF
												1:flotte1.boat[i].taille:=2;		// Exceptions pour 1 et 2 car il faut 2 bateaux de longueur 3 et le plus petit bateau est de longueur 2
												2:flotte1.boat[i].taille:=3;
											ELSE
												flotte1.boat[i].taille:=i
											END;
											REPEAT
												bateau1:=CreaBateau(i,flotte1.boat[i].taille);
											writeln('ok1');
													IF OwnBatToFlotte(flotte1,bateau1) THEN
														BEGIN
											writeln('ok1');
															writeln('Superposition impossible, recommencez');
														END;
											UNTIL OwnBatToFlotte(flotte1,bateau1)=FALSE;
											writeln('ok1');
											flotte1.boat[i]:=bateau1;
											writeln('ok1');
											AffichageTableau(flotte1);					//Affichage de la grille 
										END;
								END;

FUNCTION BateauCoule(bateau1:bateau) : INTEGER;							
//BUT: Retourner un entier qui permettra de comparer la taille du bateau avec le nombre de ses cellules touchées
//ENTREES: Bateau 
//SORTIES: Entier qui représente le nombre de cellules touchées 

					VAR
						i:INTEGER;
								BEGIN
									BateauCoule:=0;//Initialisation
									FOR i:=1 TO bateau1.taille DO//Pour chaque cellule du bateau en paramètre
										IF (bateau1.cases[i].x=0) AND (bateau1.cases[i].y=0) THEN//Si les coordonnées de la cellule actuelle (i) valent 0, alors incrémentation de BateauCoulé
											BateauCoule:=BateauCoule+1
											//NOTE: Lorsque qu'une cellule est touchée, ses coordonnées sont redéfinies à 0,0 puis -1,-1 (Pour les exclure)
								END;
FUNCTION Defaite(flotte1:flotte): BOOLEAN;				
//BUT: Booléen qui vérifie si un joueur a perdu
//ENTREES: Flotte du joueur
//SORTES: Booléen

					VAR
						i,j,stock:INTEGER;
								BEGIN
									stock:=0;//Initialisation
									FOR i:=1 TO MaxBoat DO										//Pour chaque bateau de la flotte en paramètre
										BEGIN
											FOR j:=1 TO flotte1.boat[i].taille DO//Pour chaque cellule du bateau (i) 
												BEGIN
													IF (flotte1.boat[i].cases[j].x=-1) AND (flotte1.boat[i].cases[j].y=-1) THEN// Si les coordonnées sont -1,-1
														stock:=stock+1//Incrémentation du stock 
												END;
										END;
									IF stock=MaxBoat THEN // Si le stock s'est incrémenté 5 fois, autant que le nombre de bateaux dans la flotte en question
										BEGIN
											Defaite:=TRUE;// Alors Défaite retourne VRAI et le joueur en question a perdu
											writeln('Le joueur ',flotte1.joueur,' a perdu');
										END
									ELSE
											Defaite:=FALSE
								END;
								
PROCEDURE TourDeJeu(flotte1:flotte ; var flotte2:flotte);
//Lire les coordonnées du tir du joueur et agir en conséquence
//ENTREES: Flotte du joueur attaquant, flotte du joueur attaqué
//SORTIES: Affichage statut de la case (Touché, coulé ou manqué), exclusion des cellules touchées par un tir, affichage tir
					VAR
						i,j:INTEGER;
						stockcoord:coord;
						x,y:1..max;
						
								BEGIN
										writeln('Voici votre flotte');
										AffichageTableau(flotte1);																//Afficher la grille de la flotte du joueur qui joue son tour (Lui montrer ce qu'il lui reste)
										writeln('Ordres du joueur ',flotte1.joueur);
										writeln('Entrez les coordonnées de votre tir');
										writeln('Ordre: Abscisse, Ordonnée');
										readln(x,y);
										CreaCoord(x,y,stockcoord);																			//Lire les coordonnées
										clrscr;
													IF OwnFlotte(flotte2,stockcoord)=TRUE THEN										// Si les coordonnées touchent un bateau de la flotte ennemie alors
														BEGIN
															writeln('Touché !');
															FOR i:=1 TO MaxBoat DO														//Relancement du même genre de boucle pour stocker le numéro bateau touché.		 Pour chaque bateau de cette flotte
																BEGIN
																	FOR j:=1 TO flotte2.boat[i].taille DO							//Pour chaque cellule du bateau actuel (i)
																		BEGIN
																			IF (Comparaison(flotte2.boat[i].cases[j],stockcoord)) THEN//Lorsque le bateau concerné est atteint dans la boucle
																				BEGIN
																					flotte2.boat[i].cases[j].x:=0;					//Réattribution de ses coordonnées en 0,0
																					flotte2.boat[i].cases[j].y:=0;
																				END;
																			IF (BateauCoule(flotte2.boat[i])=flotte2.boat[i].taille) THEN// Si la fonction BateauCoulé retourne la même valeur que la taille du bateau concerné, alors
																				BEGIN
																					writeln('Coulé !');
																					flotte2.restants:=(flotte2.restants-1);			//Décrémenter le nombre restant de bateaux
																					flotte2.boat[i].cases[j].x:=-1;
																					flotte2.boat[i].cases[j].y:=-1; 				// Attrbution des coord du bateau coulé en valeurs négatives pour ne pas qu'elles confirment une deuxième fois le booléen d'un bateau coulé
																				END;
																		END;
																END;
														END
													ELSE
														BEGIN
															writeln('Manqué !');
														END;
												FOR i:=0 TO max DO
													BEGIN
														FOR j:=0 TO max DO
															BEGIN
																IF (i=0)THEN
																	IF j>9 THEN
																			write(' ',j)
																		ELSE
																			write('  ',j)
																ELSE
																	IF (j=0) THEN
																		IF i>9 THEN
																			write(' ',i,' ')
																		ELSE
																			write('  ',i,' ')
																	ELSE
																		IF (stockcoord.x=j) AND (stockcoord.y=i) THEN//Ecrire aux coordonnées du tir du joueur sur la grille un caractère spécifique pour signaler l'emplacement de son tir
																			write(' ',CHR(64),' ')
																		ELSE 
																			write(' . ')//Sinon afficher des points
															END;
														writeln;
													END;
												writeln('Votre adversaire possède encore ',flotte2.restants,' bateau(x). Entrez pour continuer');
												readln;		
													
										END;

VAR
	nGrille:grille;
	i,j:INTEGER;
	Confirm:STRING;
BEGIN
	clrscr;
	writeln('Bienvenue dans le programme de bataille navale');
	writeln('Entrez pour commencer la partie');
	readln;
	clrscr;
	FOR i:=1 TO nbJoueur DO												//Répéter l'initialisation de la flotte du joueur i jusqu'à ce qu'il confirme
		BEGIN
			REPEAT
				writeln;
				writeln('Joueur ' , i ,' :');
				InitFlotte(nGrille[i]);
				nGrille[i].joueur:=i;			//Joueur i
				nGrille[i].restants:=MaxBoat;
				writeln('Entrez "OK" pour confirmer');
				readln(Confirm);
			UNTIL (Confirm='OK');
			clrscr;
		END;
	REPEAT														//Répéter un tour de jeu jusqu'à ce qu'un des deux joueurs perde
		TourDeJeu(nGrille[1],nGrille[2]);	
		clrscr;
			IF Defaite(nGrille[1])=FALSE THEN
				BEGIN
					TourDeJeu(nGrille[2],nGrille[1]);
					clrscr;
				END;
	UNTIL (Defaite(nGrille[1])) OR (Defaite(nGrille[2]));
	readln;
	
END.

{


	JEU D'ESSAI

		Affichage grille
		Entrée

	ENTREES
		x<-9
		y<- -1
	SORTIE
		"Erreur"
		
	ENTREES
		x<-9
		y<-50
	SORTIE
		"Erreur"
		
	ENTREES
		x<-14
		y<-2
		direction<-E
	SORTIE
		"Bateau hors limite, recommencez"
	ENTREES
		x<-12
		y<-2
		direction<-E
	SORTIE
		"Superposition impossible"
	
	....
	
	SORTIE
		"Entrez "OK" pour confirmer"
	ENTREES
		"Iceberg"
	---> Boucle relancée}