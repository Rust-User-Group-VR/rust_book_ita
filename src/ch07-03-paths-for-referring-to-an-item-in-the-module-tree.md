## Percorsi per fare riferimento ad un elemento nell'albero dei moduli

Per mostrare a Rust dove trovare un elemento in un albero dei moduli, usiamo un percorso nello stesso modo in cui lo usiamo quando navigiamo in un filesystem. Per chiamare una funzione, abbiamo bisogno di conoscere il suo percorso.

Un percorso può assumere due forme:

* Un *percorso assoluto* è il percorso completo a partire dalla radice di un Crate; per il codice proveniente da un Crate esterno, il percorso assoluto inizia con il nome del Crate, e per il codice proveniente dal Crate corrente, inizia con il letterale `crate`.
* Un *percorso relativo* parte dal modulo corrente e usa `self`, `super`, o un identificatore nel modulo corrente.

Sia i percorsi assoluti che quelli relativi sono seguiti da uno o più identificatori separati da doppie due punti (`::`).

Tornando all'Elenco 7-1, diciamo che vogliamo chiamare la funzione `add_to_waitlist`. Questo è lo stesso di chiedere: qual è il percorso della funzione `add_to_waitlist`? L'elenco 7-3 contiene l'elenco 7-1 con alcuni dei moduli e delle funzioni rimossi.

Mostreremo due modi per chiamare la funzione `add_to_waitlist` da una nuova funzione `eat_at_restaurant` definita nella radice del Crate. Questi percorsi sono corretti, ma c'è un altro problema rimanente che impedirà a questo esempio di essere compilato così com'è. Lo spiegheremo tra poco.

La funzione `eat_at_restaurant` fa parte dell'API pubblica del nostro Crate di libreria, quindi la segnamo con la parola chiave `pub`. Nella sezione ["Esposizione dei Percorsi con la parola chiave `pub`"][pub]<!-- ignore -->, entreremo più nel dettaglio su `pub`.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-03/src/lib.rs}}
```

<span class="caption">Elenco 7-3: Chiamata della funzione `add_to_waitlist` utilizzando percorsi assoluti e relativi</span>

La prima volta che chiamiamo la funzione `add_to_waitlist` in `eat_at_restaurant`, usiamo un percorso assoluto. La funzione `add_to_waitlist` è definita nello stesso Crate di `eat_at_restaurant`, il che significa che possiamo usare la parola chiave `crate` per iniziare un percorso assoluto. Quindi includiamo tutti i successivi moduli fino a quando non arriviamo a `add_to_waitlist`. Potete immaginare un filesystem con la stessa struttura: specificheremmo il percorso `/front_of_house/hosting/add_to_waitlist` per eseguire il programma `add_to_waitlist`; usare il nome `crate` per iniziare dalla radice del Crate è come usare `/` per iniziare dalla radice del filesystem nel vostro shell.

La seconda volta che chiamiamo `add_to_waitlist` in `eat_at_restaurant`, usiamo un percorso relativo. Il percorso inizia con `front_of_house`, il nome del modulo definito allo stesso livello dell'albero dei moduli di `eat_at_restaurant`. Qui l'equivalente del filesystem sarebbe utilizzare il percorso `front_of_house/hosting/add_to_waitlist`. Iniziare con un nome di modulo significa che il percorso è relativo.

Scegliere se utilizzare un percorso relativo o assoluto è una decisione che farete in base al vostro progetto, e dipende da se è più probabile che spostiate il codice di definizione degli elementi separatamente o insieme al codice che utilizza l'elemento. Ad esempio, se spostiamo il modulo `front_of_house` e la funzione `eat_at_restaurant` in un modulo chiamato `customer_experience`, avremmo bisogno di aggiornare il percorso assoluto a `add_to_waitlist`, ma il percorso relativo sarebbe ancora valido. Tuttavia, se spostassimo la funzione `eat_at_restaurant` separatamente in un modulo chiamato `dining`, il percorso assoluto alla chiamata `add_to_waitlist` rimarrebbe lo stesso, ma il percorso relativo dovrebbe essere aggiornato. In generale, preferiamo specificare percorsi assoluti perché è più probabile che vogliamo spostare definizioni di codice e chiamate di oggetti indipendentemente l'uno dall'altro.

Proviamo a compilare l'Elenco 7-3 e scopriamo perché non può ancora essere compilato! L'errore che otteniamo è mostrato nell'Elenco 7-4.

```console
{{#include ../listings/ch07-managing-growing-projects/listing-07-03/output.txt}}
```

<span class="caption">Elenco 7-4: Errori del compilatore dalla compilazione del codice in Elenco 7-3</span>

I messaggi di errore dicono che il modulo `hosting` è privato. In altre parole, abbiamo i percorsi corretti per il modulo `hosting` e la funzione `add_to_waitlist`, ma Rust non ci permette di usarli perché non ha accesso alle sezioni private. In Rust, tutti gli elementi (funzioni, metodi, strutture, enumerazioni, moduli e costanti) sono privati per i moduli genitori per impostazione predefinita. Se si desidera rendere privato un elemento come una funzione o una struttura, lo si inserisce in un modulo.

Gli elementi in un modulo genitore non possono utilizzare gli elementi privati all'interno dei moduli figli, ma gli elementi nei moduli figli possono utilizzare gli elementi nei loro moduli antenati. Questo perché i moduli figli avvolgono e nascondono i loro dettagli di implementazione, ma i moduli figli possono vedere il contesto in cui sono definiti. Per continuare con la nostra metafora, pensa alle regole della privacy come al retro dell'ufficio di un ristorante: quello che succede lì è privato per i clienti del ristorante, ma i manager dell'ufficio possono vedere e fare tutto nel ristorante che gestiscono.

Rust ha scelto di avere il sistema dei moduli funzionare in questo modo in modo che nascondere i dettagli interni dell'implementazione sia l'impostazione predefinita. In questo modo, sai quali parti del codice interno puoi cambiare senza rompere il codice esterno. Tuttavia, Rust ti dà la possibilità di esporre le parti interne del codice dei moduli figli ai moduli antenati esterni usando la parola chiave `pub` per rendere un elemento pubblico.

### Esposizione dei percorsi con la parola chiave `pub`

Torniamo all'errore nell'Elenco 7-4 che ci diceva che il modulo `hosting` è privato. Vogliamo che la funzione `eat_at_restaurant` nel modulo genitore abbia accesso alla funzione `add_to_waitlist` nel modulo figlio, quindi segnamo il modulo `hosting` con la parola chiave `pub`, come mostrato nell'Elenco 7-5.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-05/src/lib.rs}}
```

<span class="caption">Elenco 7-5: Dichiarazione del modulo `hosting` come `pub` per usarlo da `eat_at_restaurant`</span>

Sfortunatamente, il codice nell'Elenco 7-5 risulta ancora in un errore, come mostrato nell'Elenco 7-6.

```console
{{#include ../listings/ch07-managing-growing-projects/listing-07-05/output.txt}}
```

<span class="caption">Elenco 7-6: Errori del compilatore dalla compilazione del codice in Elenco 7-5</span>

Cosa è successo? Aggiungere la parola chiave `pub` davanti a `mod hosting` rende il modulo pubblico. Con questo cambiamento, se possiamo accedere a `front_of_house`, possiamo accedere a `hosting`. Ma i *contenuti* di `hosting` sono ancora privati; rendere il modulo pubblico non rende pubblici i suoi contenuti. La parola chiave `pub` su un modulo permette solo al codice nei suoi moduli antenati di farvi riferimento, non di accedere al suo codice interno. Poiché i moduli sono contenitori, non c'è molto che possiamo fare solo rendendo il modulo pubblico; dobbiamo andare oltre e scegliere di rendere pubblico uno o più degli elementi all'interno del modulo.

Gli errori nell'Elenco 7-6 dicono che la funzione `add_to_waitlist` è privata. Le regole sulla privacy si applicano a strutture, enumerazioni, funzioni e metodi oltre che ai moduli.

Facciamo anche la funzione `add_to_waitlist` pubblica aggiungendo la parola chiave `pub` prima della sua definizione, come nell'Elenco 7-7.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-07/src/lib.rs}}
```

<span class="caption">Listing 7-7: Aggiungendo la keyword `pub` a `mod hosting`
e `fn add_to_waitlist` ci permette di chiamare la funzione da
`eat_at_restaurant`</span>

Ora il codice sarà compilato! Per capire perché l'aggiunta della keyword `pub` ci permetta di usare
questi percorsi in `add_to_waitlist` rispettando le regole sulla privacy, diamo un'occhiata 
ai percorsi assoluti e relativi.

Nel percorso assoluto, iniziamo con `crate`, la radice dell'albero dei moduli del nostro crate. 
Il modulo `front_of_house` è definito nella radice del crate. Anche se
`front_of_house` non è pubblico, dato che la funzione `eat_at_restaurant` è
definita nello stesso modulo di `front_of_house` (cioè `eat_at_restaurant`
e `front_of_house` sono fratelli), possiamo fare riferimento a `front_of_house` da
`eat_at_restaurant`. Il prossimo è il modulo `hosting` contrassegnato con `pub`. Possiamo
accedere al modulo padre di `hosting`, quindi possiamo accedere a `hosting`. Infine, la
funzione `add_to_waitlist` è contrassegnata con `pub` e possiamo accedere al suo modulo padre,
quindi questa chiamata funziona!

Nel percorso relativo, la logica è la stessa del percorso assoluto eccetto per il 
primo passaggio: invece di partire dalla radice del crate, il percorso inizia da
`front_of_house`. Il modulo `front_of_house` è definito all'interno dello stesso modulo
di `eat_at_restaurant`, quindi il percorso relativo che parte dal modulo in cui
`eat_at_restaurant` è definito funziona. Poi, dato che `hosting` e
`add_to_waitlist` sono contrassegnati con `pub`, il resto del percorso funziona, e questa
chiamata di funzione è valida!

Se pianifichi di condividere la tua crate di libreria affinché altri progetti possano utilizzare il tuo codice,
la tua API pubblica è il tuo contratto con gli utenti della tua crate che determina come
loro possono interagire con il tuo codice. Ci sono molte considerazioni sulla gestione
dei cambiamenti della tua API pubblica per renderla più facile per le persone dipendenti dalla tua
crate. Queste considerazioni sono fuori dallo scopo di questo libro; se sei 
interessato in questo argomento, vedi [Le Linee Guida dell' API Rust][api-guidelines].

> #### Pratiche migliori per pacchetti con un binario e una libreria
>
> Abbiamo accennato che un pacchetto può contenere sia una radice *src/main.rs* di crate binario, 
> come anche una radice *src/lib.rs* di crate di libreria, e entrambi i crate avranno
> il nome del pacchetto per default. Tipicamente, i pacchetti con questo modello di contenere 
> sia una libreria che un crate binario avranno soltanto abbastanza codice nel crate
> binario per far partire un eseguibile che chiama il codice con il crate di libreria. Questo
> permette ad altri progetti di beneficiare la maggior parte delle funzionalità che il pacchetto
> fornisce, perché il codice della crate di libreria può essere condiviso.
>
> L'albero dei moduli dovrebbe essere definito in *src/lib.rs*. Poi, tutti gli elementi pubblici possono 
> essere utilizzati nel crate binario iniziando i percorsi con il nome del pacchetto.
> Il crate binario diventa un utente del crate di libreria come se fosse un crate 
> esterno che utilizza il crate di libreria: può soltanto utilizzare la API pubblica.
> Questo ti aiuta a progettare una buona API; non solo sei l'autore, sei anche un
> cliente!
>
> Nel [Capitolo 12][ch12]<!-- ignora -->, dimostreremo questa pratica organizzativa
> con un programma a riga di comando che conterrà sia un crate binario
> che un crate di libreria.

### Iniziare i Percorsi Relativi con `super`

Possiamo costruire percorsi relativi che iniziano nel modulo genitore, piuttosto che 
nel modulo corrente o nella radice del crate, utilizzando `super` all'inizio del
percorso. Questo è come iniziare un percorso del filesystem con la sintassi `..`. Utilizzare
`super` ci permette di fare riferimento ad un elemento che sappiamo essere nel modulo genitore, 
il che può semplificare il riarrangiamento dell'albero dei moduli quando il modulo è strettamente
relazionato al genitore, ma il genitore potrebbe essere spostato altrove nell'albero dei moduli un giorno.

Considera il codice nell'Elenco 7-8 che modella la situazione in cui un cuoco
corregge un ordine errato e lo porta personalmente al cliente. La
funzione `fix_incorrect_order` definita nel modulo `back_of_house` chiama la
funzione `deliver_order` definita nel modulo genitore specificando il percorso a
`deliver_order` iniziando con `super`:

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-08/src/lib.rs})}
```

<span class="caption">Listing 7-8: Chiama una funzione utilizzando un percorso relativo
che inizia con `super`</span>

La funzione `fix_incorrect_order` si trova nel modulo `back_of_house`, quindi possiamo
usare `super` per andare al modulo genitore di `back_of_house`, che in questo caso
è `crate`, la radice. Da lì, cerchiamo `deliver_order` e lo troviamo.
Successo! Pensiamo che il modulo `back_of_house` e la funzione `deliver_order`
probabilmente rimarranno nella stessa relazione l'uno con l'altro e verranno spostati 
insieme nel caso decidessimo di riorganizzare l'albero dei moduli del crate. Pertanto, abbiamo
utilizzato `super` così avremo meno posti in cui aggiornare il codice in futuro se questo 
codice verrà spostato in un modulo diverso.

### Rendere Structs e Enums Pubblici

Possiamo anche utilizzare `pub` per designare strutture ed enum come pubblici, ma ci sono alcuni 
dettagli in più riguardo all’uso di `pub` con strutture ed enums. Se usiamo `pub`
prima d una definizione di struttura, rendiamo la struttura pubblica, ma i campi della struttura 
rimarranno comunque privati. Possiamo rendere ogni campo pubblico o meno caso per caso. Nell'Elenco 7-9, abbiamo
definito una struttura `back_of_house::Breakfast` pubblica
con un campo `toast` pubblico ma un campo `seasonal_fruit` privato. Questo modella
il caso di un ristorante in cui il cliente può scegliere il tipo di pane che 
accompagna un pasto, ma il cuoco decide quale frutta accompagna il pasto in base a
quale frutta è di stagione e disponibile. La frutta disponibile cambia rapidamente, quindi
i clienti non possono scegliere la frutta o nemmeno vedere quale frutta otterranno.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-09/src/lib.rs}}
```

<span class="caption">Listing 7-9: Una struttura con alcuni campi pubblici e altri 
campi privati</span>

Dato che il campo `toast` nella struct `back_of_house::Breakfast` è pubblico,
in `eat_at_restaurant` possiamo scrivere e leggere il campo `toast` utilizzando la 
notazione del punto. Nota che non possiamo utilizzare il campo `seasonal_fruit` in
`eat_at_restaurant` perché `seasonal_fruit` è privato. Prova a decommentare la 
linea che modifica il valore di campo `seasonal_fruit` per vedere quale errore ottieni!

Inoltre, nota che dato che `back_of_house::Breakfast` ha un campo privato, la
struttura deve fornire una funzione associata pubblica che costruisce una instanza di `Breakfast` 
(qui l'abbiamo chiamata `summer`). Se `Breakfast` non avesse 
avuto una tale funzione, non avremmo potuto creare un'instanza di `Breakfast` in
`eat_at_restaurant` perché non avremmo potuto impostare il valore del campo privato 
`seasonal_fruit` in `eat_at_restaurant`.

Al contrario, se rendiamo un enum pubblico, tutte le sue varianti saranno poi pubbliche. Abbiamo 
bisogno solo di `pub` prima della keyword `enum`, come mostrato nell'Elenco 7-10.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-10/src/lib.rs}}
```
<span class="caption">Elenco 7-10: Designare un enum come pubblico rende tutte le sue
varianti pubbliche</span>

Poiché abbiamo reso l'enum `Appetizer` pubblico, possiamo usare le varianti `Soup` e `Salad`
in `eat_at_restaurant`.

Gli enum non sono molto utili a meno che le loro varianti non siano pubbliche; sarebbe fastidioso
dover annotare tutte le varianti enum con `pub` in ogni caso, quindi il predefinito
per le varianti enum è essere pubblici. Spesso gli Struct sono utili senza che i loro
campi siano pubblici, quindi i campi struct seguono la regola generale di tutto
essere privato per default a meno che non sia annotato con `pub`.

C'è un'altra situazione che coinvolge `pub` che non abbiamo ancora trattato, ed è 
l'ultima caratteristica del sistema di moduli: la parola chiave `use`. Tratteremo `use` da solo
prima, e poi mostreremo come combinare `pub` e `use`.

[pub]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html#exposing-paths-with-the-pub-keyword
[api-guidelines]: https://rust-lang.github.io/api-guidelines/
[ch12]: ch12-00-an-io-project.html

