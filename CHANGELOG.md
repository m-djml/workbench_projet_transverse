<h1> CHANGELOG </h1>
</br>
<h2> Pour le 10 mars </h2>
<br>
<h3> À faire : </h3>
<ol> 
<li> Optimiser l'implémentation de l'algorithme de pyjamask, tester sur le board initial (stm32 nucleo) :</li>
<ul> <li> Faire <code> arm-none-eabi-objdump ciphers/pyjamask.elf -t </code> pour avoir l'affichage du code en assembleur de pyjamask si besoin. </li> </ul>
<li> Faire fonctionner le code sur un autre board : stm32l100c-discovery et généraliser le Makefile et d'autres fichiers si besoin pour qu'il fonctionne sur tous les boards </li>
</ol>
<br>
<h3> Avancement : </h3>
<ol> 
<li> Optimisation </li>
<ul><li> On a essayé de modifier le code de pyjamask pour les benchmarks. btableau </li></ul>
<li> Modif Makefile </li>
<ul> <li> Le nouveau board n'était pas reconnu par mon ordinateur (Ubuntu) mais il a fonctionné après avoir suivi les instructions sur cette page : https://freeelectron.ro/installing-st-link-v2-to-flash-stm32-targets-on-linux 
</li>
<li> Il faut remplacer dans le Makefile et serial.sh le fichier de configuration du board pour openocd. Voici le chemin du fichier pour le board stm32l100c-discovery : /usr/share/openocd/scripts/board/stm32ldiscovery.cfg
</li>
</li> </ul>
</ol>
<br>
<h3> Problèmes rencontrés : </h3>
<ol> 
<li> Optimisation </li>
<ul> <li> Rien pour l'instant. </li> </ul>
<li> Modif Makefile </li>
<ul> <li> pourquoi il efface le fichier .hex --> pb réglé en modifiant le makefile, reste à savoir pourquoi il ne charge pas le fichier hex dans la mémoire du board, essai de débug avec l'option "-d" pour openocd mais le debug est très long sur le terminal il faut trouver un moyen de rediriger le debug dans un fichier pour mieux lire.
--> redirection du débug dans le fichier openocd.log réussi, il faut maintenant comprendre ce qui ne va pas a partir de ce fichier.
</li>
<li> <code>arm-none-eabi-objdump $BINARY -t | grep bench_lens | cut -f 1 -d  ' '</code> ne renvoie rien car le champ bench_lens n'existe pas dans le code assembleur de pyajamask, il n'ya que bench_speed.
</li>
<li> Un problème très gênant est apparu: <code> Warn : no flash bank found for address 0x00000000</code> lors de l'exécution d'un make ciphers/pyjamask.upload, alors que je n'ai rien modifié, et je n'ai pas touché aux fichiers de config, tout s'exécutait bien et tout d'un coup il y a ce warning qui semble empêcher l'exécution du reste du programme (la led du board clignote moins longtemps).
</li>
</li> </ul>
</ol>

# Nouvelles taches

1. Comparer les résultats obtenus avec le code de la branche main avec ceux obtenus avec celui de la branche mem (pas urgent)
2. Réussir à se connecter sur le port gdb pour débugger le code uploadé dans le board. (GDB outil pour embarqu", port JTAG permet de connaître tout le contenu de la mémoire/système, inspecter les registres)
3. Simplifier le programme (morceaux de librairies qui servent à faire des interactions avec le port série qui sont inutiles), utiliser les librairies C des boards (par exemple, stmicroelectronics). Le board n'utilise pas de temps, plutôt des cycles : le board tourne à 32MHz. Chaque section de code enregistre des cycles dans un tableau -> récupérer un tableau.
4. Apprendre à utiliser Git : faire de "git-nastique". Fork de workbench -> branche mem dans la source usubalang/workbench: mem.
5. Créer plusieurs target pour tous les boards dans le Makefile, par exemple pour le %.log (évite de changer le nom du fichier de config à chaque fois qu'on change de board). Le Makefile ne sert à rien, il faut créer le fichier hex avec objcopy, upload avec openocd (avec les commandes nécessaires) et créer le fichier .log avec serial.sh.
6. Optimiser code C (implémentation de l'algorithme de pyjamask) : regarder le code assembleur .
7. Penser à une autre possibilité d'approcher le problème : prendre l'algorithme de Dahmun et l'écrire en langage assembleur (?????)

# Avancement :

# Pour le 17 mars :
1. On a réussi à faire marcher le code de pyjamask sur le nouveau board STM32L100C-DISCO, on a des valeurs autour de 25730 cycles par octet chiffré.

Voici les étapes de notre raisonnement pour trouver pourquoi le code précédent le fonctionnait pas sur le nouveau board :
- on se rend compte qu'énormément de fichiers de librairies C et autres fichiers ne correspondent pas au modèle de notre nouveau board.
- on a installé stm32cubeMx pour essayer d'installer/générer les fichiers et librairies nécessaires pour le nouveau board (stm32l100c-disco)
- on a généré les fichiers nécessaires pour tous les modèles stm32l1xx, il faut voir comment intégrer le code de pyjamask au nouveau projet ainsi créé
- on modifie un peu le Makefile pour intégrer la cible pour le fichier .log


2. Il reste encore des problèmes dans l'optimisation de l'implémentation de l'algo pyjamask il y a un problème avec la fonction qui compte les cycles 