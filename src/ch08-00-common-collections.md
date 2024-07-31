# Collezioni Comuni

La libreria standard di Rust include una serie di strutture dati molto utili chiamate *collezioni*. La maggior parte degli altri tipi di dati rappresenta un valore specifico, ma le collezioni possono contenere più valori. A differenza dei tipi di array e tuple incorporati, i dati a cui queste collezioni puntano sono memorizzati nello heap, il che significa che la quantità di dati non deve essere conosciuta al momento della compilazione e può crescere o diminuire mentre il programma è in esecuzione. Ogni tipo di collezione ha capacità e costi differenti, e scegliere quella appropriata per la tua situazione corrente è una competenza che svilupperai nel tempo. In questo capitolo, discuteremo tre collezioni che sono molto utilizzate nei programmi Rust:

* Un *vector* ti consente di memorizzare un numero variabile di valori uno accanto all'altro.
* Una *string* è una collezione di caratteri. Abbiamo menzionato il tipo `String` in precedenza, ma in questo capitolo ne parleremo in dettaglio.
* Un *hash map* ti permette di associare un valore a una chiave specifica. È un'implementazione particolare della struttura dati più generica chiamata *map*.

Per saperne di più sugli altri tipi di collezioni fornite dalla libreria standard, consulta [la documentazione][collections].

Discuteremo come creare e aggiornare vector, string e hash map, nonché cosa rende ciascuno di essi speciale.

[collections]: ../std/collections/index.html
