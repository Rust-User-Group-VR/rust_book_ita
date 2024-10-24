## Percorsi per Riferirsi a un Elemento nell'Albero dei Moduli

Per mostrare a Rust dove trovare un elemento in un albero dei moduli, usiamo un percorso allo stesso modo in cui usiamo un percorso quando navighiamo un filesystem. Per chiamare una funzione, dobbiamo conoscere il suo percorso.

Un percorso può assumere due forme:

* Un *percorso assoluto* è il percorso completo a partire dalla radice del crate; per il codice proveniente da un crate esterno, il percorso assoluto inizia con il nome del crate, mentre per il codice proveniente dal crate corrente, inizia con il letterale `crate`.
* Un *percorso relativo* inizia dal modulo corrente e utilizza `self`, `super` o un identificatore nel modulo corrente.

Sia i percorsi assoluti che quelli relativi sono seguiti da uno o più identificatori separati da doppi due punti (`::`).

Tornando a Listato 7-1, diciamo che vogliamo chiamare la funzione `add_to_waitlist`. Questo è lo stesso che chiedere: qual è il percorso della funzione `add_to_waitlist`? Il Listato 7-3 contiene il Listato 7-1 con alcuni moduli e funzioni rimossi.

Mostreremo due modi per chiamare la funzione `add_to_waitlist` da una nuova funzione, `eat_at_restaurant`, definita nella radice del crate. Questi percorsi sono corretti, ma c'è un altro problema rimanente che impedirà a questo esempio di compilare così com'è. Spiegheremo il perché tra un attimo.

La funzione `eat_at_restaurant` fa parte dell'API pubblica del nostro crate di libreria, quindi la contrassegniamo con la parola chiave `pub`. Nella sezione [“Esposizione dei Percorsi con la Parola Chiave `pub`”][pub]<!-- ignore -->, entreremo più nel dettaglio su `pub`.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-03/src/lib.rs}}
```

<span class="caption">Listato 7-3: Chiamare la funzione `add_to_waitlist` usando percorsi assoluti e relativi</span>

La prima volta che chiamiamo la funzione `add_to_waitlist` in `eat_at_restaurant`, utilizziamo un percorso assoluto. La funzione `add_to_waitlist` è definita nello stesso crate di `eat_at_restaurant`, il che significa che possiamo usare la parola chiave `crate` per iniziare un percorso assoluto. Includiamo poi ciascuno dei moduli successivi fino a raggiungere `add_to_waitlist`. Puoi immaginare un filesystem con la stessa struttura: specificheremmo il percorso `/front_of_house/hosting/add_to_waitlist` per eseguire il programma `add_to_waitlist`; utilizzare il nome `crate` per iniziare dalla radice del crate è come utilizzare `/` per iniziare dalla radice del filesystem nella tua shell.

La seconda volta che chiamiamo `add_to_waitlist` in `eat_at_restaurant`, utilizziamo un percorso relativo. Il percorso inizia con `front_of_house`, il nome del modulo definito allo stesso livello dell'albero dei moduli di `eat_at_restaurant`. Qui l'equivalente del filesystem sarebbe utilizzare il percorso `front_of_house/hosting/add_to_waitlist`. Iniziare con un nome di modulo significa che il percorso è relativo.

Scegliere se utilizzare un percorso relativo o assoluto è una decisione che prenderai basandoti sul tuo progetto e dipenderà dal fatto che sia più probabile che tu sposti il codice di definizione degli elementi separatamente o insieme al codice che utilizza l'elemento. Per esempio, se spostassimo il modulo `front_of_house` e la funzione `eat_at_restaurant` in un modulo chiamato `customer_experience`, dovremmo aggiornare il percorso assoluto a `add_to_waitlist`, ma il percorso relativo sarebbe ancora valido. Tuttavia, se spostassimo la funzione `eat_at_restaurant` separatamente in un modulo chiamato `dining`, il percorso assoluto per la chiamata a `add_to_waitlist` rimarrebbe lo stesso, ma il percorso relativo dovrebbe essere aggiornato. La nostra preferenza in generale è specificare percorsi assoluti perché è più probabile che vogliamo spostare le definizioni del codice e le chiamate degli elementi indipendentemente l'una dall'altra.

Proviamo a compilare il Listato 7-3 e scopriamo perché non compila ancora! Gli errori che otteniamo sono mostrati nel Listato 7-4.

```console
{{#include ../listings/ch07-managing-growing-projects/listing-07-03/output.txt}}
```

<span class="caption">Listato 7-4: Errori del compilatore dalla costruzione del codice nel Listato 7-3</span>

I messaggi di errore indicano che il modulo `hosting` è privato. In altre parole, abbiamo i percorsi corretti per il modulo `hosting` e la funzione `add_to_waitlist`, ma Rust non ci permette di usarli perché non ha accesso alle sezioni private. In Rust, tutti gli elementi (funzioni, metodi, struct, enum, moduli e costanti) sono privati per i moduli genitori per impostazione predefinita. Se vuoi rendere privato un elemento come una funzione o una struct, lo metti in un modulo.

Gli elementi in un modulo genitore non possono usare gli elementi privati all'interno di moduli figli, ma gli elementi nei moduli figli possono usare gli elementi nei loro moduli antenato. Questo perché i moduli figli avvolgono e nascondono i loro dettagli di implementazione, ma i moduli figli possono vedere il contesto in cui sono definiti. Per continuare con la nostra metafora, pensa alle regole di privacy come all'ufficio amministrativo di un ristorante: ciò che avviene lì è privato per i clienti del ristorante, ma i gestori dell'ufficio possono vedere e fare tutto nel ristorante che gestiscono.

Rust ha scelto di far funzionare il sistema di moduli in questo modo in modo che nascondere i dettagli interni dell'implementazione sia l'impostazione predefinita. In questo modo, si sa quali parti del codice interno si possono cambiare senza rompere il codice esterno. Tuttavia, Rust ti dà l'opzione di esporre le parti interne del codice dei moduli figli ai moduli antenato esterni usando la parola chiave `pub` per rendere un elemento pubblico.

### Esposizione dei Percorsi con la Parola Chiave `pub`

Torniamo all'errore nel Listato 7-4 che ci diceva che il modulo `hosting` è privato. Vogliamo che la funzione `eat_at_restaurant` nel modulo genitore abbia accesso alla funzione `add_to_waitlist` nel modulo figlio, quindi contrassegniamo il modulo `hosting` con la parola chiave `pub`, come mostrato nel Listato 7-5.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-05/src/lib.rs}}
```

<span class="caption">Listato 7-5: Dichiarazione del modulo `hosting` come `pub` per usarlo da `eat_at_restaurant`</span>

Sfortunatamente, il codice nel Listato 7-5 ancora risulta in errori del compilatore, come mostrato nel Listato 7-6.

```console
{{#include ../listings/ch07-managing-growing-projects/listing-07-05/output.txt}}
```

<span class="caption">Listato 7-6: Errori del compilatore dalla costruzione del codice nel Listato 7-5</span>

Cos'è successo? Aggiungere la parola chiave `pub` davanti a `mod hosting` rende il modulo pubblico. Con questo cambiamento, se possiamo accedere a `front_of_house`, possiamo accedere a `hosting`. Ma i *contenuti* di `hosting` sono ancora privati; rendere pubblico il modulo non rende pubblici i suoi contenuti. La parola chiave `pub` su un modulo consente solo al codice nei suoi moduli antenato di riferirsi a esso, non di accedere al suo codice interno. Poiché i moduli sono contenitori, non c'è molto che possiamo fare solo rendendo il modulo pubblico; dobbiamo andare oltre e scegliere di rendere pubblici anche uno o più degli elementi all'interno del modulo.

Gli errori nel Listato 7-6 dicono che la funzione `add_to_waitlist` è privata. Le regole di privacy si applicano a struct, enum, funzioni e metodi così come ai moduli.

Rendiamo anche la funzione `add_to_waitlist` pubblica aggiungendo la parola chiave `pub` prima della sua definizione, come nel Listato 7-7.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-07/src/lib.rs}}
```

<span class="caption">Listato 7-7: Aggiunta della parola chiave `pub` a `mod hosting` e `fn add_to_waitlist` ci consente di chiamare la funzione da `eat_at_restaurant`</span>

Ora il codice compilerà! Per capire perché aggiungere la parola chiave `pub` ci consente di utilizzare questi percorsi in `eat_at_restaurant` rispetto alle regole di privacy, esaminiamo i percorsi assoluto e relativo.

Nel percorso assoluto, iniziamo con `crate`, la radice dell'albero dei moduli del nostro crate. Il modulo `front_of_house` è definito nella radice del crate. Anche se `front_of_house` non è pubblico, poiché la funzione `eat_at_restaurant` è definita nello stesso modulo di `front_of_house` (cioè, `eat_at_restaurant` e `front_of_house` sono fratelli), possiamo riferirci a `front_of_house` da `eat_at_restaurant`. Successivamente c'è il modulo `hosting` contrassegnato con `pub`. Possiamo accedere al modulo genitore di `hosting`, quindi possiamo accedere a `hosting`. Infine, la funzione `add_to_waitlist` è contrassegnata con `pub` e possiamo accedere al suo modulo genitore, quindi questa chiamata alla funzione funziona!

Nel percorso relativo, la logica è la stessa del percorso assoluto tranne che per il primo passo: anziché iniziare dalla radice del crate, il percorso inizia da `front_of_house`. Il modulo `front_of_house` è definito all'interno dello stesso modulo di `eat_at_restaurant`, quindi il percorso relativo che inizia dal modulo in cui `eat_at_restaurant` è definito funziona. Poi, poiché `hosting` e `add_to_waitlist` sono contrassegnati con `pub`, il resto del percorso funziona, e questa chiamata alla funzione è valida!

Se hai intenzione di condividere il tuo crate di libreria affinché altri progetti possano utilizzare il tuo codice, la tua API pubblica è il tuo contratto con gli utenti del tuo crate che determina come possono interagire con il tuo codice. Ci sono molte considerazioni sulla gestione dei cambiamenti alla tua API pubblica per renderlo più facile alle persone dipendere dal tuo crate. Queste considerazioni sono al di fuori dell'ambito di questo libro; se sei interessato a questo argomento, vedi [Le Linee Guida API di Rust][api-guidelines].

> #### Migliori pratiche per i Pacchetti con un Binario e una Libreria
>
> Abbiamo menzionato che un pacchetto può contenere sia una radice del crate binario in *src/main.rs* sia una radice del crate di libreria in *src/lib.rs*, e entrambi i crate avranno il nome del pacchetto per impostazione predefinita. Tipicamente, i pacchetti con questo modello di contenere sia una libreria che un crate binario avranno solo codice sufficiente nel crate binario per avviare un eseguibile che chiama codice all'interno del crate di libreria. Questo consente ad altri progetti di beneficiare della maggior parte delle funzionalità che il pacchetto fornisce perché il codice del crate di libreria può essere condiviso.
>
> L'albero dei moduli dovrebbe essere definito in *src/lib.rs*. Poi, qualsiasi elemento pubblico può essere usato nel crate binario iniziando i percorsi con il nome del pacchetto. Il crate binario diventa un utente del crate di libreria proprio come un crate completamente esterno userebbe il crate di libreria: può solo usare l'API pubblica. Questo ti aiuta a progettare una buona API; non solo sei l'autore, sei anche un cliente!
>
> Nel [Capitolo 12][ch12]<!-- ignore -->, dimostreremo questa pratica organizzativa con un programma da linea di comando che conterrà sia un crate binario che un crate di libreria.

### Iniziare Percorsi Relativi con `super`

Possiamo costruire percorsi relativi che iniziano nel modulo genitore, anziché nel modulo corrente o nella radice del crate, usando `super` all'inizio del percorso. Questo è come iniziare un percorso di filesystem con la sintassi `..`. Usare `super` ci consente di riferirci a un elemento che sappiamo essere nel modulo genitore, il che può semplificare la riorganizzazione dell'albero dei moduli quando il modulo è strettamente correlato al genitore ma il genitore potrebbe essere spostato altrove nell'albero dei moduli un giorno.

Considera il codice nel Listato 7-8 che modella la situazione in cui uno chef sistema un ordine errato e personalmente lo porta al cliente. La funzione `fix_incorrect_order` definita nel modulo `back_of_house` chiama la funzione `deliver_order` definita nel modulo genitore specificando il percorso a `deliver_order`, iniziando con `super`.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-08/src/lib.rs}}
```

<span class="caption">Listato 7-8: Chiamare una funzione usando un percorso relativo che inizia con `super`</span>

La funzione `fix_incorrect_order` è nel modulo `back_of_house`, quindi possiamo usare `super` per andare al modulo genitore di `back_of_house`, che in questo caso è `crate`, la radice. Da lì, cerchiamo `deliver_order` e lo troviamo. Successo! Pensiamo che il modulo `back_of_house` e la funzione `deliver_order` probabilmente rimarranno nella stessa relazione tra loro e verranno spostati insieme nel caso decidessimo di riorganizzare l'albero dei moduli del crate. Pertanto, abbiamo usato `super` così avremo meno posti dove aggiornare il codice in futuro se questo codice verrà spostato in un modulo diverso.

### Rendere Pubbliche le Struct e gli Enum

Possiamo anche usare `pub` per designare struct ed enum come pubblici, ma ci sono alcuni dettagli aggiuntivi nell'uso di `pub` con struct ed enum. Se usiamo `pub` prima di una definizione di struct, rendiamo la struct pubblica, ma i campi della struct saranno ancora privati. Possiamo rendere ogni campo pubblico o meno caso per caso. Nel Listato 7-9, abbiamo definito una struct pubblica `back_of_house::Breakfast` con un campo `toast` pubblico ma un campo `seasonal_fruit` privato. Questo modella il caso in un ristorante in cui il cliente può scegliere il tipo di pane che accompagna un pasto, ma il cuoco decide quale frutta accompagna il pasto in base a ciò che è di stagione e in stock. La frutta disponibile cambia rapidamente, quindi i clienti non possono scegliere la frutta né vedere quale frutta riceveranno.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-09/src/lib.rs}}
```

<span class="caption">Listato 7-9: Una struct con alcuni campi pubblici e alcuni campi privati</span>

Poiché il campo `toast` nella struct `back_of_house::Breakfast` è pubblico, in `eat_at_restaurant` possiamo scrivere e leggere nel campo `toast` usando la notazione punto. Nota che non possiamo usare il campo `seasonal_fruit` in `eat_at_restaurant`, perché `seasonal_fruit` è privato. Prova a decommentare la linea che modifica il valore del campo `seasonal_fruit` per vedere quale errore ottieni!

Inoltre, nota che poiché `back_of_house::Breakfast` ha un campo privato, la struct deve fornire una funzione associata pubblica che costruisce un'istanza di `Breakfast` (l'abbiamo chiamata `summer` qui). Se `Breakfast` non avesse una tale funzione, non potremmo creare un'istanza di `Breakfast` in `eat_at_restaurant` perché non potremmo impostare il valore del campo privato `seasonal_fruit` in `eat_at_restaurant`.

Al contrario, se rendiamo pubblico un enum, tutte le sue varianti diventano pubbliche. Abbiamo bisogno solo di `pub` prima della parola chiave `enum`, come mostrato nel Listato 7-10.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-10/src/lib.rs}}
```

<span class="caption">Listato 7-10: Designare un enum come pubblico rende tutte le sue varianti pubbliche</span>

Poiché abbiamo reso pubblico l'enum `Appetizer`, possiamo utilizzare le varianti `Soup` e `Salad` in `eat_at_restaurant`.

Gli enum non sono molto utili a meno che le loro varianti siano pubbliche; sarebbe fastidioso dover annotare tutte le varianti degli enum con `pub` in ogni caso, quindi il default per le varianti degli enum è di essere pubbliche. Le struct sono spesso utili senza che i loro campi siano pubblici, quindi i campi delle struct seguono la regola generale di tutto essere privati per impostazione predefinita a meno che non siano annotati con `pub`.

C'è un'altra situazione che coinvolge `pub` che non abbiamo coperto, e quella è la nostra ultima caratteristica del sistema di moduli: la parola chiave `use`. Copriremo `use` da sola prima, e poi mostreremo come combinare `pub` e `use`.

[pub]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html#exposing-paths-with-the-pub-keyword
[api-guidelines]: https://rust-lang.github.io/api-guidelines/
[ch12]: ch12-00-an-io-project.html
