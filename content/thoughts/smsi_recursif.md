+++
title = "Du SMSI comme structure récursive"
date = 2026-06-16
description = "Le SMSI est cyclique et fractal. La qualité par la récursion!"
+++

> "Le SMSI est cyclique et fractal"
Didier Spella


J'ai eu récemment le privilège de participer à un audit ISO27001 aux cotés d'un responsable d'audit expérimenté et grand pédagogue. Lors de cet audit de surveillance la phrase citée en début de ce post est revenue à de nombreuses reprises.

En tant qu'auditeurs nous sommes des photographes. Nous capturons une image à un point donné dans le temps, cette image reflète des pratiques, une maturité, une vision du monde et de l'environnement mais aussi des méthodologies pour évoluer et s'adapter aux changements de celui-ci.

Un des points les plus complexes à aborder dans la conception et l'implémentation d'un SMSI respectant l'esprit autant que la lettre de la norme ISO27001 est l'amélioration continue. Mon appétence pour la technique et pour des stack standardisées où l'observabilité est by-design me pousse à toujours associer des indicateurs automatisés aux controles de sécurité et opter pour la meme suite (opentelemetry, prometheus, grafana) que pour les controles de production.

Ce à quoi je n'avais pas apporté autant d'attention concerne les indicateurs du SMSI lui meme: la boucle de rétroaction permettant de l'adapter de manière systématisée. Par exemple: la politique d'évaluation des risques tierces parties peut, plutot que de se baser uniquement sur la criticité, aussi prendre en compte les résultats d'audits et moduler le rythme de ceux-ci basés sur l'historique de conformité et les obligations sectorielles. Concrètement, un partenaire commercial qui démontre un haut niveau de maturité, pourra etre audité moins souvent s'il démontre dans la durée une conformité constante et en amélioration continue.

Plutot que d'isoler la notion d'amélioration continue dans une partie dédiée du SMSI où elle peut etre "oubliée" au quotidien et seulement ressortie en revue documentaire préalable à l'audit de surveillance, la mentionner dans chaque composant du SMSI. Cela invite à se poser la question: au sein de ce composant là, comment pouvons nous l'améliorer.

L'ISO27004 n'est ni un bréviaire ni un cale-porte: ne le feuilleter que pendant les cérémonies ou le laisser prendre la poussière est un gaspillage. Cet audit a été une véritable Masterclass sur la déclinaison opérationnelle de l'instrumentation d'un SMSI: la meme rigueur que celle qui permet de veiller au respect des SLA en production doit fournir cadre et force motrice à l'amélioration continue du SMSI. Le SMSI doit donc, de mon point de vue, etre une structure récursive et contenir des méta-indicateurs suivis avec la meme importance en revue de direction que ceux qui instrumentent le périmètre de la déclaration d'applicabilité. Instrumenter l'instrumentation pour qu'elle demeure claire, appropriée et alignée sur les priorités stratégiques de l'organisation.

Merci Didier!
