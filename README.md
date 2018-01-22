# SC2_Expert_System
An expert system that suggests what to build and produce to counter the opponent's strategy given scouted information. It also handles the tech requirements.

**Note:** timings aren't very precise and the rule base is not comprhensive at all.

Here some precisions (in french):

## Extraits du rapport :

### Résumé
Il s'agit d'un système expert analysant un partie en trois temps au travers de trois bases de règles:
Premièrement il donne un direction générale au joueur.
Secondement il précise cette direction, l’adapte à la stratégie adverse en **justifiant** ses choix.
Troisièmement il rend le tout cohérent en gérant les prérequis technologiques de la stratégie choisie.


### Chaînage avant en profondeur
On définit une variable globale *glob_path* afin d’enregistrer le chemin de recherche.
La variable globale *glob_path* est la liste des noms des règles ayant mené à l’état actuel d’exploration.
Pour chaque règle candidate (par rapport à cet état),
  Mise à jour du *glob_path* = chemin actuel + nom nouvelle règle.
  Si la règle n’a pas encore été appliquée, elle est appliquée.
  Démarrage d’une nouvelle exploration avec le chemin mis à jour.
  

### Ordre d’exploration
Les différentes bases de règles (general, strategies, dependences) sont appliquées via le moteur d’inférence à la base de fait dans l’ordre suivant :
Générales → Stratégies → Dépendances
Ainsi, les objectifs établis par la base de règles générales peuvent éventuellement être écrasés par ceux de la base de règles stratégiques en cas de force majeure. 
Agissant en dernier, la base de règles de dépendances s’assure de la cohérence de l'ensemble.

Les règles stratégiques ajoutent la chaîne de décision aux rendu final. En effet, ce sont les seules mesures suceptibles d'être obscures pour le joueur.


