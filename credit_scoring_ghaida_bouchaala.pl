/* Définition des faits*/

/* Profil Client */

client(rose).
client(paige).
client(sam).

age(rose,24).
age(paige,35).
age(sam,50).

activité(rose,secteur_privé).
activité(paige,secteur_public).
activité(sam,secteur_privé).

historique_de_paiement(rose,pas_d_historique).
historique_de_paiement(paige,non_régulier).
historique_de_paiement(sam,régulier).

situation_à_emploi(rose, période_de_test).
situation_à_emploi(paige, titulaire).
situation_à_emploi(sam, titulaire).

/* Ancienneté à emploi actuel en année */ 
ancienneté_à_emploi_actuel(rose,0.5).
ancienneté_à_emploi_actuel(paige,9).
ancienneté_à_emploi_actuel(sam,17).

/* Situation financière du Client */ 

/* Ancienneté à emploi actuel en milles dinars */ 
salaire(rose,0.7).
salaire(paige,3.5).
salaire(sam,5).

situation_logement(rose,locataire).
situation_logement(paige,propriétaire).
situation_logement(sam,propriétaire).

/* Informations liées au garantie | crédit en cours */

/* Crédit en cours de paiement en milles dinars par mois */ 
crédit_en_cours_de_paiement(rose,0).
crédit_en_cours_de_paiement(paige,0).
crédit_en_cours_de_paiement(sam,0.7).

mois_restant_pour_crédit_en_cours(rose,0).
mois_restant_pour_crédit_en_cours(paige,0).
mois_restant_pour_crédit_en_cours(sam,24).

/* montant_garanties en milles dinars */ 

montant_garanties(rose,20).
montant_garanties(paige,150).
montant_garanties(sam,100).

/* Informations liées à l'emprunt en milles dinars */

montant_emprunt(rose,32).
montant_emprunt(paige,1).
montant_emprunt(sam,180).

durée_emprunt(rose,60).
durée_emprunt(paige,12).
durée_emprunt(sam,120).

/* Définition des régles */

/* Bon client */

rembourser_crédit(X) :- (historique_de_paiement(X,régulier);historique_de_paiement(X,pas_d_historique)),
    					activité(X,secteur_privé),situation_à_emploi(X,titulaire),salaire(X,S),
                        crédit_en_cours_de_paiement(X,C),montant_garanties(X,G),montant_emprunt(X,E),
                        durée_emprunt(X,D),mois_restant_pour_crédit_en_cours(X,R),
    					(E<G;E + C*R < S*0.4*D).

couvrir_logement_avec_credit(X):- crédit_en_cours_de_paiement(X,C), situation_logement(X,locataire), salaire(X,S),
                  			      montant_emprunt(X,E),durée_emprunt(X,D), C+E/D < S*0.3.

bon_client(X):- rembourser_crédit(X),couvrir_logement_avec_credit(X).


/* Mauvais client */

mauvais_client(X):- historique_de_paiement(X,non_régulier), situation_logement(X,locataire),
    				(situation_à_emploi(X,stagiaire);situation_à_emploi(X, période_de_test)),
    				ancienneté_à_emploi_actuel(X,A),crédit_en_cours_de_paiement(X,C),
                    salaire(X,S),activité(X,secteur_privé),montant_garanties(X,G),montant_emprunt(X,E),
                    durée_emprunt(X,D),age(X,N),mois_restant_pour_crédit_en_cours(X,R),
    				(E>G; (E + C*R > S*0.4*D )),(A < 1),(N+(R+D)/12 < 65).


/* Client incertain */

client_incertain(X) :- historique_de_paiement(X,pas_d_historique),situation_logement(X,locataire),
    				   ancienneté_à_emploi_actuel(X,A),crédit_en_cours_de_paiement(X,C),montant_garanties(X,G),
    				   montant_emprunt(X,E), A<2, C>0, G<E.
  

    