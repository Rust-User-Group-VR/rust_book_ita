## Memorizzazione delle Chiavi con Valori Associati in Hash Maps

L'ultimo delle nostre collezioni comuni è la *hash map*. Il tipo `HashMap<K, V>`
memorizza una mappatura di chiavi di tipo `K` a valori di tipo `V` utilizzando una *funzione di hashing*, che determina come posiziona queste chiavi e valori in memoria. Molti linguaggi di programmazione supportano questo tipo di struttura dati, ma spesso usano un nome diverso, come *hash*, *map*, *oggetto*, *hash table*, *dictionary*, o *array associativo*, solo per citarne alcuni.

Le hash map sono utili quando vuoi cercare dati non utilizzando un indice, come puoi fare con i vettori, ma utilizzando una chiave che può essere di qualsiasi tipo. Ad esempio, in un gioco, potresti tenere traccia del punteggio di ogni squadra in una hash map in cui ogni chiave è il nome di una squadra e i valori sono il punteggio di ciascuna squadra. Dato un nome di squadra, puoi recuperare il suo punteggio.

Esamineremo l'API di base delle hash map in questa sezione, ma molte più funzioni sono nascoste nelle funzioni definite su `HashMap<K, V>` dalla libreria standard. Come sempre, controlla la documentazione della libreria standard per maggiori informazioni.

### Creazione di una Nuova Hash Map

Un modo per creare una hash map vuota è utilizzare `new` e aggiungere elementi con `insert`. Nella Listato 8-20, stiamo tenendo traccia dei punteggi di due squadre i cui nomi sono *Blue* e *Yellow*. La squadra Blue inizia con 10 punti e la squadra Yellow inizia con 50.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-20/src/main.rs:here}}
```

<span class="caption">Listato 8-20: Creazione di una nuova hash map e inserimento di alcune chiavi e valori</span>

Nota che dobbiamo prima `use` la `HashMap` dalla parte delle collezioni della libreria standard. Delle nostre tre collezioni comuni, questa è la meno utilizzata, quindi non è inclusa nelle funzionalità portate automaticamente nello Scope nel prelude. Le hash map hanno anche meno supporto dalla libreria standard; non c'è, ad esempio, una macro integrata per costruirle.

Proprio come i vettori, le hash map memorizzano i loro dati nello heap. Questa `HashMap` ha chiavi di tipo `String` e valori di tipo `i32`. Come i vettori, le hash map sono omogenee: tutte le chiavi devono avere lo stesso tipo e tutti i valori devono avere lo stesso tipo.

### Accesso ai Valori in una Hash Map

Possiamo ottenere un valore dalla hash map fornendo la sua chiave al metodo `get`, come mostrato nel Listato 8-21.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-21/src/main.rs:here}}
```

<span class="caption">Listato 8-21: Accesso al punteggio per la squadra Blue memorizzato nella hash map</span>

Qui, `score` avrà il valore associato alla squadra Blue, e il risultato sarà `10`. Il metodo `get` restituisce un `Option<&V>`; se non c'è un valore per quella chiave nella hash map, `get` restituirà `None`. Questo programma gestisce l'`Option` chiamando `copied` per ottenere un `Option<i32>` anziché un `Option<&i32>`, quindi `unwrap_or` per impostare `score` su zero se `scores` non ha una voce per la chiave.

Possiamo iterare su ogni coppia chiave–valore in una hash map in modo simile a come facciamo con i vettori, usando un `for` loop:

```rust
{{#rustdoc_include ../listings/ch08-common-collections/no-listing-03-iterate-over-hashmap/src/main.rs:here}}
```

Questo codice stamperà ogni coppia in un ordine arbitrario:

```text
Yellow: 50
Blue: 10
```

### Hash Maps e Ownership

Per i tipi che implementano il `Copy` trait, come `i32`, i valori vengono copiati nella hash map. Per i valori di proprietà come `String`, i valori saranno spostati e la hash map sarà il propriorario di quei valori, come dimostrato nel Listato 8-22.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-22/src/main.rs:here}}
```

<span class="caption">Listato 8-22: Mostrare che le chiavi e i valori sono di proprietà della hash map una volta inseriti</span>

Non siamo in grado di usare le variabili `field_name` e `field_value` dopo che sono state spostate nella hash map con la chiamata a `insert`.

Se inseriamo riferimenti a valori nella hash map, i valori non verranno spostati nella hash map. I valori a cui i riferimenti puntano devono essere validi per almeno quanto la hash map è valida. Parleremo più approfonditamente di questi problemi nella sezione [“Validare i Riferimenti con i Lifetimes”][validating-references-with-lifetimes]<!-- ignore --> nel Capitolo 10.

### Aggiornamento di una Hash Map

Anche se il numero di coppie chiave-valore è espandibile, ogni chiave unica può avere solo un valore associato alla volta (ma non viceversa: ad esempio, sia la squadra Blue che la squadra Yellow potrebbero avere il valore `10` memorizzato nella hash map `scores`).

Quando vuoi cambiare i dati in una hash map, devi decidere come gestire il caso in cui una chiave ha già un valore assegnato. Potresti sostituire il vecchio valore con il nuovo valore, ignorando completamente il vecchio valore. Potresti mantenere il vecchio valore e ignorare il nuovo valore, aggiungendo solo il nuovo valore se la chiave *non* ha già un valore. Oppure potresti combinare il vecchio valore e il nuovo valore. Vediamo come fare ciascuno di questi!

#### Sovrascrivere un Valore

Se inseriamo una chiave e un valore in una hash map e poi inseriamo quella stessa chiave con un valore diverso, il valore associato a quella chiave sarà sostituito. Anche se il codice nel Listato 8-23 chiama `insert` due volte, la hash map conterrà solo una coppia chiave-valore perché stiamo inserendo il valore per la chiave della squadra Blue entrambe le volte.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-23/src/main.rs:here}}
```

<span class="caption">Listato 8-23: Sostituzione di un valore memorizzato con una particolare chiave</span>

Questo codice stamperà `{"Blue": 25}`. Il valore originale di `10` è stato sovrascritto.

<!-- Vecchie intestazioni. Non rimuoverle o i collegamenti potrebbero rompersi. -->
<a id="only-inserting-a-value-if-the-key-has-no-value"></a>

#### Aggiungere una Chiave e un Valore Solo se una Chiave Non è Presente

È comune verificare se una particolare chiave esiste già nella hash map con un valore e quindi compiere le seguenti azioni: se la chiave esiste nella hash map, il valore esistente dovrebbe rimanere tale; se la chiave non esiste, inserirla e assegnargli un valore.

Le hash map hanno un'API speciale per questo chiamata `entry` che prende la chiave che vuoi controllare come parametro. Il valore restituito dal metodo `entry` è un enum chiamato `Entry` che rappresenta un valore che potrebbe o non potrebbe esistere. Diciamo di voler controllare se la chiave per la squadra Yellow ha un valore associato. Se non ce l'ha, vogliamo inserire il valore `50`, e lo stesso per la squadra Blue. Usando l'API `entry`, il codice appare come nel Listato 8-24.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-24/src/main.rs:here}}
```

<span class="caption">Listato 8-24: Utilizzo del metodo `entry` per inserire solo se la chiave non ha già un valore</span>

Il metodo `or_insert` su `Entry` è definito per restituire un riferimento mutable al valore per la chiave `Entry` corrispondente se quella chiave esiste, e se non esiste, inserisce il parametro come nuovo valore per questa chiave e restituisce un riferimento mutable al nuovo valore. Questa tecnica è molto più pulita rispetto a scrivere la logica noi stessi e, inoltre, funziona meglio con il borrow checker.

Eseguire il codice nel Listato 8-24 stamperà `{"Yellow": 50, "Blue": 10}`. La prima chiamata a `entry` inserirà la chiave per la squadra Yellow con il valore `50` perché la squadra Yellow non ha già un valore. La seconda chiamata a `entry` non cambierà la hash map perché la squadra Blue ha già il valore `10`.

#### Aggiornamento di un Valore Basato sul Vecchio Valore

Un altro caso d'uso comune per le hash map è cercare il valore di una chiave e poi aggiornarlo basandosi sul vecchio valore. Ad esempio, il Listato 8-25 mostra codice che conta quante volte appare ciascuna parola in un testo. Utilizziamo una hash map con le parole come chiavi e incrementiamo il valore per tenere traccia di quante volte abbiamo visto quella parola. Se è la prima volta che vediamo una parola, inseriremo prima il valore `0`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-25/src/main.rs:here}}
```

<span class="caption">Listato 8-25: Contare le occorrenze delle parole usando una hash map che memorizza parole e conteggi</span>

Questo codice stamperà `{"world": 2, "hello": 1, "wonderful": 1}`. Potresti vedere le stesse coppie chiave-valore stampate in un ordine diverso: ricorda dalla sezione [“Accesso ai Valori in una Hash Map”][access]<!-- ignore --> che iterare su una hash map avviene in un ordine arbitrario.

Il metodo `split_whitespace` restituisce un iteratore su sottostringe, separate da spazi bianchi, del valore in `text`. Il metodo `or_insert` restituisce un riferimento mutable (`&mut V`) al valore per la chiave specificata. Qui, memorizziamo quel riferimento mutable nella variabile `count`, quindi per assegnare a quel valore, dobbiamo prima dereferenziare `count` usando l'asterisco (`*`). Il riferimento mutable esce dallo Scope alla fine del `for` loop, quindi tutte queste modifiche sono sicure e consentite dalle regole del borrowing.

### Funzioni di Hashing

Di default, `HashMap` utilizza una funzione di hashing chiamata *SipHash* che può fornire resistenza contro attacchi di tipo denial-of-service (DoS) che coinvolgono le tabelle hash[^siphash]<!-- ignore -->. Questo non è l'algoritmo di hashing più veloce disponibile, ma il trade-off per una sicurezza migliore che viene con il calo delle prestazioni ne vale la pena. Se profili il tuo codice e scopri che la funzione hash predefinita è troppo lenta per i tuoi scopi, puoi passare a un'altra funzione specificando un hasher diverso. Un *hasher* è un tipo che implementa il `BuildHasher` trait. Parleremo di trait e di come implementarli nel [Capitolo 10][traits]<!-- ignore -->. Non è necessario implementare il proprio hasher da zero; [crates.io](https://crates.io/)<!-- ignore --> ha librerie condivise da altri utenti Rust che forniscono hashers che implementano molti algoritmi di hashing comuni.

[^siphash]: [https://en.wikipedia.org/wiki/SipHash](https://en.wikipedia.org/wiki/SipHash)

## Sommario

I vettori, le stringhe e le hash map forniranno una grande quantità di funzionalità necessarie nei programmi quando hai bisogno di memorizzare, accedere e modificare i dati. Ecco alcuni esercizi che dovresti ora essere attrezzato per risolvere:

1. Dato un elenco di numeri interi, usa un vettore e restituisci il valore mediano (quando ordinata, il valore nella posizione centrale) e la moda (il valore che si verifica più spesso; una hash map sarà utile qui) dell'elenco.
2. Converti stringhe in pig latin. La prima consonante di ogni parola viene spostata alla fine della parola e viene aggiunto *ay*, quindi *first* diventa *irst-fay*. Le parole che iniziano con una vocale hanno *hay* aggiunto alla fine invece (*apple* diventa *apple-hay*). Tieni a mente i dettagli sulla codifica UTF-8!
3. Usando una hash map e i vettori, crea un'interfaccia testuale per consentire a un utente di aggiungere nominativi di dipendenti a un dipartimento in un'azienda; ad esempio, "Add Sally to Engineering" o "Add Amir to Sales." Poi lascia che l'utente recuperi un elenco di tutte le persone in un dipartimento o tutte le persone nell'azienda per dipartimento, ordinate alfabeticamente.

La documentazione dell'API della libreria standard descrive i metodi che i vettori, le stringhe e le hash map hanno che saranno utili per questi esercizi!

Stiamo entrando in programmi più complessi in cui le operazioni possono fallire, quindi è un momento perfetto per discutere della gestione degli errori. Lo faremo davvero il prossimo!

[validating-references-with-lifetimes]:
ch10-03-lifetime-syntax.html#validating-references-with-lifetimes
[access]: #accessing-values-in-a-hash-map
[traits]: ch10-02-traits.html
