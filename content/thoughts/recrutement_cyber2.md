+++
title = "Recrutement cyber: pistes de solution"
date = 2026-07-23
description = "impacts de la diversité des expériences"
+++

Précédemment j'ai glosé ici sur le mésusage des interviews dans les recrutements de profils senior en cybersécurité. J'y ai posé une opinion, que chacun étayera par son expérience (YMMV).

Lors d'un recrutement on voit parfois des cibles d'expérience risibles (5 ans d'expérience dans un framework dont la première release date d'un an), ce que ça traduit à mon sens c'est plus une crainte de sous-performance et un désir d'utiliser l'expérience dans un domaine comme proxy de la vélocité.

Sauf que cela ne protège pas des cas pathologiques suivants :

- dev c++ : le langage est tellement grand que deux développeurs seniors peuvent avoir travaillé chacun avec des sous-sets différents et donc avoir un temps de ramp-up significatif s'ils ne tombent pas près de leur sphère de familiarité
- outillage maison : l'entreprise a développé ses propres solutions d'infrastructures (api gateways, load balancers, ...) pour répondre à ses problèmes spécifiques. Développeurs et Ops auront un temps de ramp up significatif
- environnement à forte vélocité d'évolution : IA, librairies en alpha de grandes entités (expérience personnelle de développement contre la crate windows-rs en 2020) : tout bouge tellement vite que l'apprentissage est continu

Dans un domaine comme la cybersécurité (voir mon post sur les environnements VUCA), ces cas pathologiques sont la règle et pas l'exception :

- espace sémantique large : ISO27001, SOC2, RGPD, NIS2... un professionnel peut grandir dans un environnement qui implémente les même exigences qu'un autre mais via une taxonomie totalement différente
- outillage maison : les SMSI ne sont pas standardisés. Fichiers PDF dans un sharepoint, tableaux excel, grafana, GED... autant d'infra que d'environnements et de culture
- vélocité : dès que le portefeuille client commence à inclure du transfrontalier ou des entités à haute maturité/exigences (eg : banque, finances, assurance) le cycle d'audit doit aller au-delà des exigences de base de la certification pour intégrer l'attendu TPRM de tout le graph de client derrière chaque contrat.

10 ans d'expérience en ISO27001 c'est bien, si c'est tout dans la même boutique ça l'est moins.

Mon approche :

- en tant que freelance : un onboarding de découverte mutuelle : on vérifie ensemble que les quick wins sont concrétisables. Des clauses de sortie sans pénalité + portabilité du travail, pour que le match se teste sincèrement.
- en tant que recruteur/conseil : les taches make-or-break => comment co-construire la reconnaissance de valeur, sujet du prochain post !

