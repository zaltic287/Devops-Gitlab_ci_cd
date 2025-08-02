# GITLAB : 13 - Merge Request

* Pour faire un commit avec un titre et une description:

```
git add nom_du_fichier
git commit -m "developpement du panier
>création du panier
>ajout d'une code pour la validation du panier"

````

* Ajout d'un tag pour le versionning de la branche master 

git tag -a v1.0.0 -m "commentaire"
git push -u origin master


* pour le merge Request

je developpe une feature et je la pousse dans la branche de developpement
  et je me rend compte que j'ai ouboie quelque chose
    je me met dans la branche de dev et je cree une nouvelle branche exemple xp_feature
	   git checkout -b xp_feature
	     vim file.txt
		 git add file.txt
		 git commit -m " developpement de la page de validation
		 >valider le panier
		 >choix des articles"
		 git push origin xp_feature
	   
pour faire le merge Request, un lien est disponible sur l'ecran
si on a fait plusieurs commit, on  peut les regrouper au moment de creer la Request Merge avec l'option de squash commits

Aprés la création du Merge Request, la personne en chage de la branche de dev, verifie les changements apportés et decide de merger ou pas
