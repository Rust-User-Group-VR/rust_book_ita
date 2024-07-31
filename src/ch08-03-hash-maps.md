## Memorizzare Chiavi con Valori Associati in Hash Map

L'ultima delle nostre collezioni comuni è l'*hash map*. Il tipo `HashMap<K, V>`
memorizza una mappatura di chiavi di tipo `K` con valori di tipo `V` utilizzando una *funzione di hashing*,
che determina come collocare queste chiavi e valori in memoria.
Molti linguaggi di programmazione supportano questo tipo di struttura dati, ma spesso utilizzano un nome diverso, come *hash*, *map*, *object*, *hash table*, *dictionary* o *array associativo*, solo per citarne alcuni.

Le hash map sono utili quando si desidera cercare i dati non utilizzando un indice, come si fa con i vettori, ma utilizzando una chiave che può essere di qualsiasi tipo. Ad esempio, in un gioco, si potrebbe tenere traccia del punteggio di ogni squadra in una hash map in cui ogni chiave è il nome di una squadra e i valori sono i punteggi di ogni squadra. Dato un nome di squadra, si può recuperare il suo punteggio.

In questa sezione esamineremo l'API di base delle hash map, ma molte altre funzionalità sono nascoste nelle funzioni definite su `HashMap<K, V>` dalla libreria standard. Come sempre, consultare la documentazione della libreria standard per ulteriori informazioni.

### Creare una Nuova Hash Map

Un modo per creare una hash map vuota è utilizzare `new` e aggiungere elementi con `insert`. Nel Listato 8-20, stiamo tenendo traccia dei punteggi di due squadre i cui nomi sono *Blue* e *Yellow*. La squadra Blue inizia con 10 punti e la squadra Yellow inizia con 50 punti.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-20/src/main.rs:here}}
```

<span class="caption">Listato 8-20: Creare una nuova hash map e inserire alcune chiavi e valori</span>

Nota che dobbiamo prima `use` `HashMap` dalla parte delle collezioni della libreria standard. Delle nostre tre collezioni comuni, questa è la meno utilizzata, quindi non è inclusa nelle funzionalità portate automaticamente nel scope nel prelude. Anche le hash map hanno meno supporto dalla libreria standard; ad esempio, non c'è una macro incorporata per costruirle.

Come i vettori, le hash map memorizzano i loro dati nell'heap. Questa `HashMap` ha chiavi di tipo `String` e valori di tipo `i32`. Come i vettori, anche le hash map sono omogenee: tutte le chiavi devono avere lo stesso tipo e tutti i valori devono avere lo stesso tipo.

### Accesso ai Valori in una Hash Map

Possiamo ottenere un valore dalla hash map fornendo la sua chiave al metodo `get`, come mostrato nel Listato 8-21.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-21/src/main.rs:here}}
```

<span class="caption">Listato 8-21: Accedere al punteggio per la squadra Blue memorizzato nella hash map</span>

Qui, `score` avrà il valore associato alla squadra Blue, e il risultato sarà `10`. Il metodo `get` restituisce un `Option<&V>`; se non c'è valore per quella chiave nella hash map, `get` restituirà `None`. Questo programma gestisce l'`Option` chiamando `copied` per ottenere un `Option<i32>` anziché un `Option<&i32>`, quindi `unwrap_or` per impostare `score` a zero se `scores` non ha una voce per la chiave.

Possiamo iterare su ogni coppia chiave-valore in una hash map in modo simile a come facciamo con i vettori, usando un `for` loop:

```rust
{{#rustdoc_include ../listings/ch08-common-collections/no-listing-03-iterate-over-hashmap/src/main.rs:here}}
```

Questo codice stamperà ogni coppia in un ordine arbitrario:

```text
Yellow: 50
Blue: 10
```

### Hash Map e Ownership

Per i tipi che implementano il `Copy` trait, come `i32`, i valori vengono copiati nella hash map. Per i valori posseduti come `String`, i valori verranno spostati e la hash map diventerà il proprietario di questi valori, come dimostrato nel Listato 8-22.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-22/src/main.rs:here}}
```

<span class="caption">Listato 8-22: Mostrare che chiavi e valori sono posseduti dalla hash map una volta inseriti</span>

Non siamo in grado di usare le variabili `field_name` e `field_value` dopo che sono state spostate nella hash map con la chiamata a `insert`.

Se inseriamo riferimenti a valori nella hash map, i valori non verranno spostati nella hash map. I valori ai quali i riferimenti puntano devono essere validi per almeno tutto il tempo in cui la hash map è valida. Parleremo più di queste problematiche nella sezione [“Validating References with Lifetimes”][validating-references-with-lifetimes] nel Capitolo 10.

### Aggiornare una Hash Map

Sebbene il numero di coppie chiave-valore sia espandibile, ogni chiave unica può avere solo un valore associato alla volta (ma non viceversa: ad esempio, sia la squadra Blue che la squadra Yellow potrebbero avere il valore `10` memorizzato nella hash map `scores`).

Quando si desidera modificare i dati in una hash map, è necessario decidere come gestire il caso in cui una chiave ha già un valore assegnato. Si potrebbe sostituire il vecchio valore con il nuovo valore, ignorando completamente il vecchio valore. Si potrebbe mantenere il vecchio valore e ignorare il nuovo valore, aggiungendo il nuovo valore solo se la chiave *non* ha già un valore. Oppure si potrebbe combinare il vecchio valore e il nuovo valore. Vediamo come fare ognuna di queste cose!

#### Sovrascrivere un Valore

Se inseriamo una chiave e un valore in una hash map e poi inseriamo quella stessa chiave con un valore diverso, il valore associato a quella chiave verrà sostituito. Anche se il codice nel Listato 8-23 chiama `insert` due volte, la hash map conterrà solo una coppia chiave-valore perché stiamo inserendo il valore per la chiave della squadra Blue entrambe le volte.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-23/src/main.rs:here}}
```

<span class="caption">Listato 8-23: Sostituire un valore memorizzato con una chiave particolare</span>

Questo codice stamperà `{"Blue": 25}`. Il valore originale di `10` è stato sovrascritto.

<!-- Old headings. Do not remove or links may break. -->
<a id="only-inserting-a-value-if-the-key-has-no-value"></a>

#### Aggiungere una Chiave e un Valore Solo Se una Chiave Non è Presente

È comune verificare se una particolare chiave esiste già nella hash map con un valore e quindi intraprendere le seguenti azioni: se la chiave esiste nella hash map, il valore esistente deve rimanere com'è; se la chiave non esiste, inserirla con un valore.

Le hash map hanno un'API speciale per questo chiamata `entry` che prende la chiave che si desidera verificare come parametro. Il valore restituito del metodo `entry` è un enum chiamato `Entry` che rappresenta un valore che potrebbe o non potrebbe esistere. Diciamo che vogliamo verificare se la chiave per la squadra Yellow ha un valore associato. Se non lo ha, vogliamo inserire il valore `50`, e lo stesso per la squadra Blue. Utilizzando l'API `entry`, il codice appare come nel Listato 8-24.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-24/src/main.rs:here}}
```

<span class="caption">Listato 8-24: Utilizzo del metodo `entry` per inserire solo se la chiave non ha già un valore</span>

Il metodo `or_insert` su `Entry` è definito per restituire un riferimento mutabile al valore per la chiave `Entry` corrispondente se quella chiave esiste, e se non esiste, inserisce il parametro come nuovo valore per questa chiave e restituisce un riferimento mutabile al nuovo valore. Questa tecnica è molto più pulita che scrivere la logica da soli e, inoltre, si combina meglio con il borrow checker.

Eseguendo il codice nel Listato 8-24 verrà stampato `{"Yellow": 50, "Blue": 10}`. La prima chiamata a `entry` inserirà la chiave per la squadra Yellow con il valore `50` perché la squadra Yellow non ha già un valore. La seconda chiamata a `entry` non cambierà la hash map perché la squadra Blue ha già il valore `10`.

#### Aggiornare un Valore Basato sul Vecchio Valore

Un altro caso d'uso comune per le hash map è cercare il valore di una chiave e poi aggiornarlo basato sul vecchio valore. Ad esempio, il Listato 8-25 mostra il codice che conta quante volte ogni parola appare in un testo. Utilizziamo una hash map con le parole come chiavi e incrementiamo il valore per tenere traccia di quante volte abbiamo visto quella parola. Se è la prima volta che vediamo una parola, inseriremo il valore `0`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-25/src/main.rs:here}}
```

<span class="caption">Listato 8-25: Contare le occorrenze di parole utilizzando una hash map che memorizza parole e conteggi</span>

Questo codice stamperà `{"world": 2, "hello": 1, "wonderful": 1}`. Si potrebbe vedere la stessa coppia chiave-valore in un ordine diverso: ricordate dalla sezione [“Accesso ai Valori in una Hash Map”][access] che iterare su una hash map avviene in un ordine arbitrario.

Il metodo `split_whitespace` restituisce un iteratore su sub-slice, separati da spazi bianchi, del valore in `text`. Il metodo `or_insert` restituisce un riferimento mutabile (`&mut V`) al valore per la chiave specificata. Qui, memorizziamo tale riferimento mutabile nella variabile `count`, quindi per assegnare a quel valore, dobbiamo prima dereferenziare `count` utilizzando l'asterisco (`*`). Il riferimento mutabile esce dallo scope alla fine del ciclo `for`, quindi tutti questi cambiamenti sono sicuri e consentiti dalle regole di borrowing.

### Funzioni di Hashing

Per impostazione predefinita, `HashMap` utilizza una funzione di hashing chiamata *SipHash* che può offrire resistenza agli attacchi di denial-of-service (DoS) che coinvolgono le hash table[^siphash]<!-- ignore -->. Questo non è l'algoritmo di hashing più veloce disponibile, ma il compromesso per una migliore sicurezza che viene con la riduzione delle prestazioni vale la pena. Se si profila il proprio codice e si scopre che la funzione di hash predefinita è troppo lenta per i propri scopi, è possibile passare a un'altra funzione specificando un altro hasher. Un *hasher* è un tipo che implementa il trait `BuildHasher`. Parleremo di trait e come implementarli nel [Capitolo 10][traits]<!-- ignore -->. Non è necessariamente necessario implementare il proprio hasher da zero; [crates.io](https://crates.io/)<!-- ignore --> ha librerie condivise da altri utenti di Rust che forniscono hashers per implementare molti algoritmi di hashing comuni.

[^siphash]: [https://en.wikipedia.org/wiki/SipHash](https://en.wikipedia.org/wiki/SipHash)

## Riepilogo

I vettori, le stringhe e le hash map forniranno una grande quantità di funzionalità necessarie nei programmi quando è necessario memorizzare, accedere e modificare i dati. Ecco alcuni esercizi che dovresti ora essere in grado di risolvere:

1. Data una lista di interi, usa un vettore e restituisci la mediana (quando ordinata, il valore nella posizione centrale) e la moda (il valore che si verifica più frequentemente; una hash map sarà utile qui) della lista.
1. Converti le stringhe in pig latin. La prima consonante di ogni parola viene spostata alla fine della parola e viene aggiunto *ay*, quindi *first* diventa *irst-fay*. Le parole che iniziano con una vocale hanno *hay* aggiunto alla fine (*apple* diventa *apple-hay*). Tieni presente i dettagli sulla codifica UTF-8!
1. Utilizzando una hash map e vettori, crea un'interfaccia testuale per consentire a un utente di aggiungere nomi di dipendenti a un dipartimento in un'azienda; ad esempio, “Aggiungi Sally all'Ingegneria” o “Aggiungi Amir alle Vendite”. Quindi consenti all'utente di recuperare un elenco di tutte le persone in un dipartimento o tutte le persone nell'azienda per dipartimento, ordinate alfabeticamente.

La documentazione dell'API della libreria standard descrive i metodi che i vettori, le stringhe e le hash map hanno che saranno utili per questi esercizi!

Stiamo entrando in programmi più complessi in cui le operazioni possono fallire, quindi è il momento perfetto per discutere la gestione degli errori. Ne parleremo prossimamente!

[validating-references-with-lifetimes]:
ch10-03-lifetime-syntax.html#validating-references-with-lifetimes
[access]: #accessing-values-in-a-hash-map
[traits]: ch10-02-traits.html

