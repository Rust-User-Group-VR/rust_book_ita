## Memorizzazione di elenchi di valori con Vectors

Il primo tipo di collezione che vedremo è `Vec<T>`, anche noto come *vector*. I Vectors ti permettono di memorizzare più di un valore in una singola struttura di dati che mette tutti i valori uno accanto all'altro in memoria. I Vectors possono memorizzare solo valori dello stesso tipo. Sono utili quando hai un elenco di elementi, come le righe di testo in un file o i prezzi degli articoli in un carrello della spesa.

### Creazione di un nuovo Vector

Per creare un nuovo vector vuoto, chiamiamo la funzione `Vec::new`, come mostrato nel Listing 8-1.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-01/src/main.rs:here}}
```

<span class="caption">Listing 8-1: Creazione di un nuovo vector vuoto per contenere valori
del tipo `i32`</span>

Nota che qui abbiamo aggiunto un'annotazione di tipo. Poiché non stiamo inserendo valori in questo vector, Rust non sa che tipo di elementi intendiamo memorizzare. Questo è un punto importante. I Vectors sono implementati utilizzando i generici; vedremo come usare i generici con i tuoi tipi nel Capitolo 10. Per ora, sappi che il tipo `Vec<T>` fornito dalla libreria standard può contenere qualsiasi tipo. Quando creiamo un vector per contenere un tipo specifico, possiamo specificare il tipo all'interno di parentesi angolari. Nel Listing 8-1, abbiamo detto a Rust che il `Vec<T>` in `v` conterrà elementi del tipo `i32`.

Più spesso, creerai un `Vec<T>` con valori iniziali e Rust dedurrà il tipo di valore che vuoi memorizzare, quindi raramente hai bisogno di fare questa annotazione di tipo. Rust fornisce convenientemente la macro `vec!`, che creerà un nuovo vector che contiene i valori che gli dai. Il Listing 8-2 crea un nuovo `Vec<i32>` che contiene i valori `1`, `2` e `3`. Il tipo di intero è `i32` perché è il tipo di intero predefinito, come abbiamo discusso nella sezione [“Data Types”][data-types]<!-- ignore --> del Capitolo 3.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-02/src/main.rs:here}}
```

<span class="caption">Listing 8-2: Creazione di un nuovo vector contenente
valori</span>

Poiché abbiamo dato valori iniziali `i32`, Rust può dedurre che il tipo di `v`
è `Vec<i32>`, e l'annotazione di tipo non è necessaria. Successivamente vedremo come
modificare un vector.

### Aggiornamento di un Vector

Per creare un vector e poi aggiungere elementi, possiamo usare il metodo `push`,
come mostrato nel Listing 8-3.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-03/src/main.rs:here}}
```

<span class="caption">Listing 8-3: Uso del metodo `push` per aggiungere valori a un
vector</span>

Come con qualsiasi variabile, se vogliamo essere in grado di cambiarne il valore, dobbiamo renderla mutabile usando la parola chiave `mut`, come discusso nel Capitolo 3. I numeri
che mettiamo dentro sono tutti di tipo `i32`, e Rust lo deduce dai dati, quindi non
abbiamo bisogno dell'annotazione `Vec<i32>`.

### Lettura degli elementi dei Vectors

Ci sono due modi per fare riferimento a un valore memorizzato in un vector: tramite indice o utilizzando il metodo `get`. Nei seguenti esempi, abbiamo annotato i tipi dei
valori che vengono restituiti da queste funzioni per maggiore chiarezza.

Il Listing 8-4 mostra entrambi i metodi di accesso a un valore in un vector, con sintassi di indicizzazione e il metodo `get`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-04/src/main.rs:here}}
```

<span class="caption">Listing 8-4: Uso della sintassi di indicizzazione e del metodo `get`
per accedere a un elemento in un vector</span>

Nota alcuni dettagli qui. Usiamo il valore di indice `2` per ottenere il terzo elemento
perché i vectors sono indicizzati per numero, iniziando da zero. Usare `&` e `[]`
ci dà un riferimento all'elemento al valore di indice. Quando usiamo il metodo `get`
con l'indice passato come argomento, otteniamo un `Option<&T>` che possiamo
usare con `match`.

Rust fornisce questi due modi di fare riferimento a un elemento in modo che tu possa scegliere come deve comportarsi il programma quando provi a usare un valore di indice fuori dal range degli elementi esistenti. Come esempio, vediamo cosa succede quando abbiamo un vector di cinque elementi e poi proviamo ad accedere a un elemento all'indice 100 con ciascuna tecnica, come mostrato nel Listing 8-5.

```rust,should_panic,panics
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-05/src/main.rs:here}}
```

<span class="caption">Listing 8-5: Tentativo di accesso all'elemento all'indice
100 in un vector contenente cinque elementi</span>

Quando eseguiamo questo codice, il primo metodo `[]` farà andare il programma in panic
perché fa riferimento a un elemento inesistente. Questo metodo è meglio utilizzato quando vuoi che il tuo programma si blocchi se c'è un tentativo di accesso a un elemento oltre la fine del vector.

Quando il metodo `get` riceve un indice che è fuori dal vector, restituisce `None`
senza andare in panic. Utilizzeresti questo metodo se l'accesso a un elemento
oltre il range del vector può accadere occasionalmente in circostanze normali. Il tuo codice avrà quindi la logica per gestire l'avere `Some(&element)` o `None`, come discusso nel Capitolo 6. Per esempio, l'indice potrebbe provenire da una persona che inserisce
un numero. Se inseriscono accidentalmente un numero troppo grande e il programma ottiene un valore `None`, potresti dire all'utente quanti elementi ci sono nel vector corrente e dargli un'altra possibilità di inserire un valore valido. Questo sarebbe più amichevole per l'utente rispetto a far bloccare il programma per un errore di battitura!

Quando il programma ha un riferimento valido, il borrow checker impone le regole
di ownership e borrowing (coperte nel Capitolo 4) per garantire che questo riferimento
e qualsiasi altro riferimento ai contenuti del vector rimangano validi. Ricorda la regola che dice che non puoi avere riferimenti mutabili e immutabili nello stesso scope.
Questa regola si applica nel Listing 8-6, dove teniamo un riferimento immutabile
al primo elemento in un vector e proviamo ad aggiungere un elemento alla fine. Questo programma non funzionerà se proviamo anche a fare riferimento a quell'elemento più tardi
nella funzione.

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-06/src/main.rs:here}}
```

<span class="caption">Listing 8-6: Tentativo di aggiungere un elemento a un vector
mentre si tiene un riferimento a un elemento</span>

Compilare questo codice risulterà in questo errore:

```console
{{#include ../listings/ch08-common-collections/listing-08-06/output.txt}}
```

Il codice nel Listing 8-6 potrebbe sembrare che dovrebbe funzionare: perché un riferimento
al primo elemento dovrebbe preoccuparsi dei cambiamenti alla fine del vector? Questo errore è dovuto al modo in cui funzionano i vectors: poiché i vectors mettono i valori uno accanto all'altro in memoria, aggiungere un nuovo elemento alla fine del vector potrebbe richiedere l'allocazione di nuova memoria e la copia dei vecchi elementi nello spazio nuovo, se non c'è abbastanza spazio per mettere tutti gli elementi uno accanto all'altro dove il vector è attualmente memorizzato. In tal caso, il riferimento al primo elemento punterebbe a memoria deallocata. Le regole di borrowing impediscono ai programmi di trovarsi in quella situazione.

> Nota: Per maggiori dettagli sull'implementazione del tipo `Vec<T>`, consulta [“The
> Rustonomicon”][nomicon].

### Iterazione sui valori in un Vector

Per accedere a ogni elemento in un vector a turno, itereremmo attraverso tutti gli
elementi piuttosto che usare indici per accedervi uno alla volta. Il Listing 8-7 mostra come usare un ciclo `for` per ottenere riferimenti immutabili a ciascun elemento in un vector di valori `i32` e stamparli.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-07/src/main.rs:here}}
```

<span class="caption">Listing 8-7: Stampa di ciascun elemento in un vector iterando
sugli elementi utilizzando un ciclo `for`</span>

Possiamo anche iterare sui riferimenti mutabili a ciascun elemento in un vector mutabile per apportare modifiche a tutti gli elementi. Il ciclo `for` nel Listing 8-8
aggiungerà `50` a ciascun elemento.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-08/src/main.rs:here}}
```

<span class="caption">Listing 8-8: Iterazione sui riferimenti mutabili agli
elementi in un vector</span>

Per cambiare il valore a cui si riferisce il riferimento mutabile, dobbiamo usare
l'operatore di dereferenza `*` per accedere al valore in `i` prima di poter usare l'operatore `+=`. Parleremo di più dell'operatore di dereferenza nella sezione [“Following the
Pointer to the Value with the Dereference Operator”][deref]<!-- ignore --> del Capitolo 15.

Iterare su un vector, sia in modo immutabile che mutabile, è sicuro grazie alle regole del borrow checker. Se tentassimo di inserire o rimuovere elementi nei corpi del ciclo `for` nel Listing 8-7 e nel Listing 8-8, otterremmo un errore del compilatore simile a quello che abbiamo ottenuto con il codice nel Listing 8-6. Il riferimento al vector che il ciclo `for` tiene impedisce la modifica simultanea dell'intero vector.

### Uso di un Enum per memorizzare più tipi

I Vectors possono memorizzare solo valori dello stesso tipo. Questo può essere
inconveniente; ci sono sicuramente casi d'uso in cui è necessario memorizzare un elenco
di elementi di tipi diversi. Fortunatamente, i varianti di un enum sono definiti
sotto lo stesso tipo di enum, quindi quando abbiamo bisogno di un tipo per rappresentare elementi di tipi diversi, possiamo definire e usare un enum!

Per esempio, supponiamo di voler ottenere valori da una riga in un foglio di calcolo in cui alcune delle colonne della riga contengono interi, alcuni numeri a virgola mobile, e alcune stringhe. Possiamo definire un enum le cui varianti contengono i diversi tipi di valore, e tutte le varianti dell'enum saranno considerate dello stesso tipo: quello dell'enum. Poi possiamo creare un vector per contenere quell'enum e quindi, in ultima analisi, contenere tipi diversi. Abbiamo dimostrato questo nel Listing 8-9.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-09/src/main.rs:here}}
```

<span class="caption">Listing 8-9: Definizione di un `enum` per memorizzare valori di
tipi diversi in un unico vector</span>

Rust ha bisogno di sapere quali tipi saranno nel vector al momento della compilazione
così sa esattamente quanta memoria sullo heap sarà necessaria per memorizzare ciascun elemento. Dobbiamo anche essere espliciti su quali tipi sono consentiti in questo vector.
Se Rust permettesse a un vector di contenere qualsiasi tipo, ci sarebbe la possibilità
che uno o più tipi causino errori con le operazioni eseguite sugli elementi del vector. Usare un enum più un'espressione `match` significa che Rust assicurerà al momento della
compilazione che ogni caso possibile venga gestito, come discusso nel Capitolo 6.

Se non conosci l'insieme esaustivo di tipi che un programma otterrà al momento dell'esecuzione per memorizzare in un vector, la tecnica dell'enum non funzionerà. Invece, puoi usare un trait object, che copriremo nel Capitolo 17.

Ora che abbiamo discusso alcuni dei modi più comuni di usare i vectors, assicuriamoci di rivedere [la documentazione dell'API][vec-api]<!-- ignore --> per tutti i molti metodi utili definiti su `Vec<T>` dalla libreria standard. Per esempio, oltre a `push`, un metodo `pop` rimuove e restituisce l'ultimo elemento.

### Eliminazione di un Vector elimina i suoi elementi

Come qualsiasi altro `struct`, un vector viene liberato quando esce dal suo scope,
come annotato nel Listing 8-10.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-10/src/main.rs:here}}
```

<span class="caption">Listing 8-10: Mostra dove il vector e i suoi elementi
vengono eliminati</span>

Quando il vector viene eliminato, anche tutti i suoi contenuti vengono eliminati,
significando che gli interi che contiene verranno puliti. Il borrow checker garantisce
che eventuali riferimenti ai contenuti di un vector siano utilizzati solo mentre il vector stesso è valido.

Passiamo al prossimo tipo di collezione: `String`!

[data-types]: ch03-02-data-types.html#data-types
[nomicon]: ../nomicon/vec/vec.html
[vec-api]: ../std/vec/struct.Vec.html
[deref]: ch15-02-deref.html#following-the-pointer-to-the-value-with-the-dereference-operator
