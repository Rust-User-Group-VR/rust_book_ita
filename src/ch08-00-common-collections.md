# Collezioni comuni

La libreria standard di Rust include un numero di strutture dati molto utili chiamate
*collezioni*. La maggior parte degli altri tipi di dati rappresenta un valore specifico, ma
le collezioni possono contenere valori multipli. A differenza dei tipi di array e tuple integrati,
i dati a cui queste collezioni fanno riferimento sono memorizzati nell'heap, il che significa
che la quantità di dati non deve essere nota al momento della compilazione e può crescere o
ridursi durante l'esecuzione del programma. Ogni tipo di collezione ha diverse capacità
e costi, e scegliere quella appropriata per la tua situazione attuale è un
competenza che svilupperai nel tempo. In questo capitolo, discuteremo tre
collezioni che vengono utilizzate molto spesso nei programmi Rust:

* Un *vettore* ti consente di memorizzare un numero variabile di valori uno accanto all'altro.
* Una *stringa* è una collezione di caratteri. Abbiamo citato il tipo `String`
  in precedenza, ma in questo capitolo ne parleremo in profondità.
* Un *hash map* ti consente di associare un valore a una chiave particolare. È un
  implementazione particolare della struttura dati più generale chiamata *map*.

Per conoscere gli altri tipi di collezioni forniti dalla libreria standard,
vedi [la documentazione][collections].

Discuteremo come creare e aggiornare vettori, stringhe e hash map, oltre
a cosa rende ciascuna speciale.

[collezioni]: ../std/collections/index.html
