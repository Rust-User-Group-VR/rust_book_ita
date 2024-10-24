# Collezioni Comuni

La libreria standard di Rust include una serie di strutture dati molto utili chiamate *collezioni*. La maggior parte degli altri tipi di dati rappresentano un valore specifico, ma le collezioni possono contenere valori multipli. A differenza dei tipi array e tupla integrati, i dati a cui queste collezioni puntano sono memorizzati nello heap, il che significa che la quantità di dati non deve essere conosciuta a tempo di compilazione e può crescere o ridursi mentre il programma viene eseguito. Ogni tipo di collezione ha capacità e costi diversi, e scegliere quella appropriata per la tua situazione attuale è un'abilità che svilupperai nel tempo. In questo capitolo, discuteremo di tre collezioni che sono molto utilizzate nei programmi Rust:

* Un *vector* ti consente di memorizzare un numero variabile di valori uno accanto all'altro.
* Una *stringa* è una collezione di caratteri. Abbiamo menzionato il tipo `String` in precedenza, ma in questo capitolo ne parleremo in dettaglio.
* Un *hash map* ti permette di associare un valore a una chiave specifica. È un'implementazione particolare della struttura dati più generale chiamata *map*.

Per conoscere gli altri tipi di collezioni fornite dalla libreria standard, consulta [la documentazione][collections].

Discuteremo su come creare e aggiornare vector, stringhe e hash map, oltre a ciò che rende ciascuno speciale.

[collections]: ../std/collections/index.html
