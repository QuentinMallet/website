+++
title = "Phishing take-home assignments"
date = 2026-07-24
description = "le devoir maison dans le recrutement n'a pas besoin d'être vecteur de risque pour le candidat"
+++

Mini post bonus!


Hier je parlais du recrutement comme problème d'évaluation. Aujourd'hui, le même processus vu comme surface d'attaque.


Parmi le bestiaire des APT, on sait depuis quelques années maintenant que la Corée du Nord aime bien attaquer les développeurs via de faux process de recrutement.


Je suis tombé sur un [bon article](https://citizendot.github.io/articles/fake-job-interview-git-hook-malware/) montrant une tentative pour un développeur Python.


TL;DR devoir maison d'évaluation envoyé sous forme d'un fichier zip contenant des infos et un dépôt git. Le malware est dans les git hooks du dépôt (des petits programmes qui s'exécutent lors de certaines actions git, par exemple pour faire tourner un linter avant d'accepter les commits). Rien de très original là-dessus, on a un stager obfusqué, qui installe quand même Node.js (!) sur la machine victime.


Si ça marche c'est que ça ne choque pas!


Le candidat est un cas intéressant du point de vue de la gestion des identités :

- extérieur à l'organisation
- peut avoir besoin de droits d'accès spécifiques
- a un cycle de vie court avec de multiples points de sortie


Ce que je vois très rarement et qui pourrait éliminer le côté "réaliste" d'envoyer un dépôt git serait d'intégrer proprement les candidats dans l'infra de gestion des identités.


Dans ce scénario, la victime c'est le candidat : l'organisation voit son identité usurpée sans émission d'un signal facile à surveiller. Impossible à bloquer réactivement, par contre on peut rendre ça plus difficile : si tout le monde sait que chez nous les devoirs maison passent par notre forge, un zip qui arrive par un autre canal aura beaucoup moins de crédibilité.


Prenons par exemple le cas d'un recrutement développeur. Si c'est dans la culture de l'entreprise de donner des devoirs maison :

- fédération des identités avec whitelist => passage d'une étape dans le processus de recrutement autorise l'authentification sociale (parce que si le candidat doit créer un compte dédié, l'ajouter à son gestionnaire de mots de passe, configurer le TOTP... friction pas nécessaire, et un IdP tiers est toujours mieux que des comptes temporaires mal sécurisés qui s'amoncellent)
- défense en profondeur :
  - en cas de sortie du process de recrutement, suppression du compte et désactivation de la fédération pour celui-ci => ceinture
  - nettoyage automatique des identités mode ramasse-miettes réglé sur la politique de rendu des devoirs maison => bretelles
- SCIM outbound / hook / script écoutant les evenements de création de compte  => à la création du compte avec les métadonnées appropriées, création d'un compte dans une forge de code séparée et isolée avec un fork du dépôt de référence du devoir maison


Les gains sont significatifs :

- traçabilité pendant le process de recrutement
- sécurisation pour tout le monde
- tâche rendue culturellement plus difficile pour les attaquants qui veulent spear phisher des candidats
