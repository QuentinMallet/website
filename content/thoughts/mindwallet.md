+++
title = "mind wallet: une idée couteuse, dangereuse mais divertissante"
date = 2026-08-20
description = "Dérivations de clés, tous les oeufs dans le même panier que les lingots"
+++

Dans le cadre d'un projet encore en stealth mode, j'explore le sujet de la dérivation de clés.

Combien de choses peut-on sécuriser avec un seul mot de passe ?

Beaucoup, en fait. et cela sans s'écarter des bonnes pratiques mais:
- le choix des outils est important
- la sécurité de l'ensemble reste plafonnée par celle du mot de passe => une librairie ne vas pas créer de l'entropie ex-nihilo

Le problème: comment passer d'un mot de passe à des types de clés hétérogènes, et quels sont les risques d'une entropie trop faible.

Aujourd'hui, on va dériver à partir d'un meme mot de passe:
- une clé pour un onion service  sur le réseau Tor
- un portefeuille de cryptomonnaies Monero

Ouvrons le capot : Ed25519 (avec des formats de sortie différents)  dans les deux cas! Le point de départ est toujours une KDF : une fonction qui transforme un secret en bits utilisables comme clé.

La KDF, comme la scie sauteuse, se manipule avec prudence et respect. Caveat emptor : dans ce qui suit, la mesure de sécurité principale (le sel) est absente. N'utilisez pas ce service en prod, ne stockez pas de fonds dans ce wallet, je vous renvoie à l'épitaphe de l'approche (Courtois, Song & Castellucci, 2016 ; cf. Brainflayer).

Ici : Argon2id, paramètres fixes. Sans cela, pas de régénération déterministe.

Tout d'abord: la sécurité d'une clé dérivée est bornée par l'entropie du mot de passe, pas par la longueur de sortie de la KDF. Une clé Ed25519 de 256 bits dérivée d'un mot de passe à 30 bits vaut 30 bits.

Aparté : si vous exigez 12 caractères, majuscules, minuscules, sanskrit et 3 chiffres en quipu inca, mais refusez une passphrase de 30 caractères pour "manque de sécurité" et gardez des questions secrètes accessibles sans authentification, vous vous y prenez mal. Ce n'est pas (que) moi qui le dit : NIST SP 800-63B.

Côté Tor, c'est court : le hostname se forme à partir de la clé publique, mkp224o avec une seed suffit.

Côté Monero, c'est plus complexe. J'ai écrit un petit CLI en Rust qui dérive un wallet depuis un mot de passe. Même code source compilé en WASM, testable dans votre navigateur : https://mind-wallet.mstratsec.biz

Attention => outil gourmand de viande! Cette implémentation n'a pas pour but de stocker des XMR : ni le navigateur du quotidien, ni la démarche elle-même ne conviennent, la littérature est sans ambiguïté là-dessus.
