/* Définition des faits*/

/* Profil Client */

client(rose).
client(paige).
client(sam).
client(hanna).
client(leith).

age(rose,24).
age(paige,40).
age(sam,50).
age(hanna,30).
age(leith,45).

activité(rose,secteur_privé).
activité(paige,secteur_public).
activité(sam,secteur_privé).
activité(hanna,secteur_privé).
activité(leith,secteur_privé).

historique_de_paiement(rose,pas_d_historique).
historique_de_paiement(paige,non_régulier).
historique_de_paiement(sam,régulier).
historique_de_paiement(hanna,non_régulier).
historique_de_paiement(leith,régulier).

situation_à_emploi(rose, période_de_test).
situation_à_emploi(paige, période_de_test).
situation_à_emploi(sam, titulaire).
situation_à_emploi(hanna, stagiaire).
situation_à_emploi(leith, titulaire).

/* Ancienneté à emploi actuel en année */ 
ancienneté_à_emploi_actuel(rose,0.5).
ancienneté_à_emploi_actuel(paige,1).
ancienneté_à_emploi_actuel(sam,17).
ancienneté_à_emploi_actuel(hanna,1).
ancienneté_à_emploi_actuel(leith,35).

/* Situation financière du Client */ 

/* Salaire à emploi actuel en milles dinars */ 
salaire(rose,0.7).
salaire(paige,3.5).
salaire(sam,5).
salaire(hanna,2.5).
salaire(leith,10).

situation_logement(rose,locataire).
situation_logement(paige,locataire).
situation_logement(sam,propriétaire).
situation_logement(hanna,locataire).
situation_logement(leith,propriétaire).

/* Informations liées au garantie | crédit en cours */

/* Crédit en cours de paiement en milles dinars par mois */ 
crédit_en_cours_de_paiement(rose,0.3).
crédit_en_cours_de_paiement(paige,0).
crédit_en_cours_de_paiement(sam,0.7).
crédit_en_cours_de_paiement(hanna,0).
crédit_en_cours_de_paiement(leith,1).

mois_restant_pour_crédit_en_cours(rose,6).
mois_restant_pour_crédit_en_cours(paige,0).
mois_restant_pour_crédit_en_cours(sam,24).
mois_restant_pour_crédit_en_cours(hanna,0).
mois_restant_pour_crédit_en_cours(leith,6).

/* montant_garanties en milles dinars */ 

montant_garanties(rose,20).
montant_garanties(paige,150).
montant_garanties(sam,100).
montant_garanties(hanna,250).
montant_garanties(leith,1000).

/* Informations liées à l'emprunt en milles dinars */

montant_emprunt(rose,32).
montant_emprunt(paige,200).
montant_emprunt(sam,180).
montant_emprunt(hanna,300).
montant_emprunt(leith,50).

durée_emprunt(rose,60).
durée_emprunt(paige,120).
durée_emprunt(sam,120).
durée_emprunt(hanna,180).
durée_emprunt(leith,240).

/* Définition des régles */

/* Bon client */

rembourser_crédit(X) :- (historique_de_paiement(X,régulier);historique_de_paiement(X,pas_d_historique)),
    			activité(X,secteur_privé),situation_à_emploi(X,titulaire),salaire(X,S),situation_logement(X,propriétaire),
                        crédit_en_cours_de_paiement(X,C),montant_garanties(X,G),montant_emprunt(X,E),
                        durée_emprunt(X,D),mois_restant_pour_crédit_en_cours(X,R),
    					(E<G;E + C*R < S*0.4*D).

couvrir_logement_avec_credit(X):- crédit_en_cours_de_paiement(X,C), situation_logement(X,locataire), salaire(X,S),
                  	          montant_emprunt(X,E),durée_emprunt(X,D), C+E/D < S*0.3,!.
bon_client(X):- rembourser_crédit(X);( rembourser_crédit(X),  couvrir_logement_avec_credit(X)).


/* Mauvais client */

mauvais_client(X):- historique_de_paiement(X,non_régulier), situation_logement(X,locataire),
    		    (situation_à_emploi(X,stagiaire);situation_à_emploi(X, période_de_test)),
    	            ancienneté_à_emploi_actuel(X,A),crédit_en_cours_de_paiement(X,C),
                    salaire(X,S),activité(X,secteur_privé),montant_garanties(X,G),montant_emprunt(X,E),
                    durée_emprunt(X,D),age(X,N),mois_restant_pour_crédit_en_cours(X,R),
    				(E>G; (E + C*R > S*0.4*D );(N+(R+D)/12 > 65)),(A < 1.5).


/* Client incertain */

client_incertain(X) :- historique_de_paiement(X,pas_d_historique),situation_logement(X,locataire),
    ancienneté_à_emploi_actuel(X,A),crédit_en_cours_de_paiement(X,C),montant_garanties(X,G),
               	       montant_emprunt(X,E), A<2, C>0, G<E.
    		       