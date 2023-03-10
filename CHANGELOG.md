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