+++
title = "LLMs, audits, grc: mensonges et réalité"
date = 2026-07-02
description = "outils et approche dans un monde de génération documentaire à coût négligeable"
+++

> "On attrape plus vite un menteur qu'un boiteux"
  Proverbe

Précédemment j'avais commencé la discussion de ce que les LLMs changent dans les audits de gouvernance. Aujourd'hui entrons dans le vif du sujet: concrètement, ce qui bouge.

Il est fort compliqué de mentir efficacement à un auditeur, si tant est qu'il approche l'audit comme une démarche de découverte épistémologique et pas comme une liste de courses. 
Paradoxalement on pourrait penser que la capacité des LLMs a produire de manière industrielle des documents abaisse le cout du mensonge mais il s'agit là d'un colosse aux pieds d'argile: l'existence d'un document n'est gage que d'elle meme, cette apparente tautologie a tout de meme une vertu: vérifier l'investissement minimum dans la réalisation du corpus. Un corpus produit en masse est mieux que pas de corpus du tout du point de vue de la norme, mais il indique un investissement faible et doit attirer l'attention de l'auditeur. La valeur ajoutée de l'auditeur est dans la vérification: la réalité concrète manifeste-t-elle les démarches décrites par la documentation?

Je considère que le cout de construction d'un mensonge croit de manière superlinéaire par rapport au nombre de sources dont il est nécessaire d'assurer la cohérence. Il devient très vite largement supérieur à celui de l'implémentation d'une mesure. Par exemple pour un controle comme la bonne conduite d'un PRA la recherche de preuve doit se décliner de la manière suivante:

- preuves soumises en amont de l'audit
- analyse des effets de bord sur l'infrastructure en live => votre rapport montre l'execution d'un test de PRA daté du XX, vous m'avez détaillé votre pipeline de centralisation des logs, maintenant montrez moi les logs afférents à votre test de PRA. Montrez moi sur le serveur concerné le fichier de définition du service Y impacté par le test de PRA et ses informations de dernière execution

La semaine prochaine: division du travail et effets de levier.
