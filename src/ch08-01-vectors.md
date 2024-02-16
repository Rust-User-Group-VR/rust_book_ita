## Memorizzare elenchi di valori con vettori

Il primo tipo di collezione che esamineremo è `Vec<T>`, noto anche come *vettore*.
I vettori ti permettono di memorizzare più di un valore in una singola struttura dati che
mette tutti i valori uno accanto all'altro in memoria. I vettori possono memorizzare solo valori
dello stesso tipo. Sono utili quando hai un elenco di elementi, come le
righe di testo in un file o i prezzi degli articoli in un carrello della spesa.

### Creare un nuovo vettore

Per creare un nuovo vettore vuoto, chiamiamo la funzione `Vec::new`, come mostrato in
Listing 8-1.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-01/src/main.rs:here}}
```

<span class="caption">Listing 8-1: Creazione di un nuovo vettore vuoto per memorizzare i valori
di tipo `i32`</span>

Nota che abbiamo aggiunto un'annotazione di tipo qui. Poiché non stiamo inserendo alcun
valore in questo vettore, Rust non sa che tipo di elementi intendiamo
memorizzare. Questo è un punto importante. I vettori sono implementati usando i generici;
copriremo come usare i generici con i tuoi tipi nel Capitolo 10. Per ora,
sappi che il tipo `Vec<T>` fornito dalla libreria standard può contenere qualsiasi tipo.
Quando creiamo un vettore per contenere un tipo specifico, possiamo specificare il tipo all'interno
di parentesi angolari. Nel Listing 8-1, abbiamo detto a Rust che il `Vec<T>` in `v` potrà
contenere elementi di tipo `i32`.

Più spesso, creerai un `Vec<T>` con valori iniziali e Rust dedurrà
il tipo di valore che vuoi memorizzare, quindi raramente avrai bisogno di fare questa annotazione di tipo.
Rust fornisce in modo molto comodo la macro `vec!`, che creerà un nuovo vettore che contiene i valori che gli dai.
Il Listing 8-2 crea un nuovo `Vec<i32>` che contiene i valori `1`, `2` e `3`. Il tipo intero è `i32`
perché è il tipo intero predefinito, come abbiamo discusso nella sezione [“Data
Types”][data-types]<!-- ignore --> del Capitolo 3.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-02/src/main.rs:here}}
```

<span class="caption">Listing 8-2: Creazione di un nuovo vettore contenente
valori</span>

Poiché abbiamo fornito valori iniziali `i32`, Rust può dedurre che il tipo di `v`
è `Vec<i32>`, e l'annotazione di tipo non è necessaria. Successivamente, vedremo come
modificare un vettore.

### Aggiornare un vettore

Per creare un vettore e poi aggiungere elementi ad esso, possiamo usare il metodo `push`,
come mostrato nel Listing 8-3.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-03/src/main.rs:here}}
```

<span class="caption">Listing 8-3: Utilizzo del metodo `push` per aggiungere valori a un
vettore</span>

Come per qualsiasi variabile, se vogliamo essere in grado di cambiarne il valore, dobbiamo
renderla mutabile usando la parola chiave `mut`, come discusso nel Capitolo 3. I numeri
che inseriamo sono tutti di tipo `i32`, e Rust lo deduce dai dati, quindi
non abbiamo bisogno dell'annotazione `Vec<i32>`.

### Leggere gli elementi dei vettori

Ci sono due modi per fare riferimento a un valore memorizzato in un vettore: tramite indicizzazione o
usando il metodo `get`. Nei seguenti esempi, abbiamo annotato i tipi di
valori che vengono restituiti da queste funzioni per una maggiore chiarezza.

Il Listing 8-4 mostra entrambi i metodi per accedere a un valore in un vettore, con sintassi di indicizzazione
e il metodo `get`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-04/src/main.rs:here}}
```

<span class="caption">Listing 8-4: Uso della sintassi di indicizzazione o del metodo `get` per
accedere a un elemento in un vettore</span>

Nota alcuni dettagli qui. Usiamo il valore dell'indice `2` per ottenere il terzo elemento
perché i vettori sono indicizzati per numero, partendo da zero. Usando `&` e `[]`
ci dà un riferimento all'elemento al valore dell'indice. Quando usiamo il metodo `get`
con l'indice passato come argomento, otteniamo un `Option<&T>` che possiamo
usare con `match`.

Il motivo per cui Rust fornisce questi due modi per fare riferimento a un elemento è in modo da poter
scegliere come il programma si comporta quando si cerca di usare un valore di indice al di fuori dell'intervallo degli elementi esistenti. Ad esempio, vediamo cosa succede quando abbiamo
un vettore di cinque elementi e poi proviamo ad accedere a un elemento all'indice 100
con ciascuna tecnica, come mostrato nel Listing 8-5.

```rust,should_panic,panics
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-05/src/main.rs:here}}
```

<span class="caption">Listing 8-5: Tentativo di accedere all'elemento all'indice
100 in un vettore che contiene cinque elementi</span>

Quando eseguiamo questo codice, il primo metodo `[]` farà sì che il programma panichi
perché fa riferimento a un elemento inesistente. Questo metodo è il migliore quando vuoi
che il tuo programma si blocchi se c'è un tentativo di accedere a un elemento oltre la
fine del vettore.

Quando il metodo `get` viene passato con un indice che è al di fuori del vettore, restituisce
`None` senza panico. Useresti questo metodo se accedere a un elemento
oltre l'intervallo del vettore può accadere occasionalmente in circostanze normali.
Il tuo codice avrà quindi una logica per gestire l'aver sia
`Some(&element)` o `None`, come discusso nel Capitolo 6. Ad esempio, l'indice
potrebbe provenire da una persona che inserisce un numero. Se per errore inseriscono un
numero troppo grande e il programma ottiene un valore `None`, potresti dire all'utente quanti elementi ci sono
nel vettore attuale e dargli un'altra possibilità di
inserire un valore valido. Questo sarebbe più user-friendly che far bloccare il programma
a causa di un errore di battitura!

Quando il programma ha un riferimento valido, il controllore di prestito fa rispettare le
regole di proprietà e di prestito (coperte nel Capitolo 4) per garantire che questo riferimento
e qualsiasi altro riferimento al contenuto del vettore rimangano validi. Ricordiamo la
regola che afferma che non si possono avere riferimenti mutabili e immutabili nello stesso
scope. Questa regola si applica nel Listing 8-6, dove manteniamo un riferimento immutabile
al primo elemento in un vettore e proviamo ad aggiungere un elemento alla fine. Questo
programma non funzionerà se proviamo anche a fare riferimento a quell'elemento più avanti nella
funzione:


```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-06/src/main.rs:here}}
```

<span class="caption">Listing 8-6: Tentativo di aggiungere un elemento a un vettore
mentre si tiene un riferimento ad un elemento</span>

Compilando questo codice si otterrà questo errore:


```console
{{#include ../listings/ch08-common-collections/listing-08-06/output.txt}}
```

Il codice nel Listing 8-6 potrebbe sembrare che dovrebbe funzionare: perché un riferimento
al primo elemento dovrebbe preoccuparsi dei cambiamenti alla fine del vettore? Questo errore è
dovuto al modo in cui funzionano i vettori: poiché i vettori mettono i valori uno accanto all'altro
in memoria, aggiungendo un nuovo elemento alla fine del vettore potrebbe richiedere
l'allocazione di nuova memoria e la copia dei vecchi elementi nello spazio nuovo, se non c'è
abbastanza spazio per mettere tutti gli elementi uno accanto all'altro dove il vettore
è attualmente memorizzato. In quel caso, il riferimento al primo elemento sarebbe
puntato alla memoria deallocata. Le regole di prestito impediscono ai programmi di
finire in quella situazione.

> Nota: Per ulteriori dettagli sull'implementazione del tipo `Vec<T>`, vedi [“The
> Rustonomicon”][nomicon].

### Iterazione sui valori in un vettore


Per accedere a ciascun elemento di un vettore di volta in volta, itereremmo attraverso tutti gli
elementi piuttosto che utilizzare gli indici per accedervi uno alla volta. L'elenco 8-7 mostra come
utilizzare un ciclo `for` per ottenere riferimenti immutabili a ciascun elemento di un vettore di
valori `i32` e stamparli.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-07/src/main.rs:here}}
```

<span class="caption">Elenco 8-7: Stampa di ciascun elemento in un vettore attraverso l'iterazione
sugli elementi utilizzando un ciclo `for`</span>

Possiamo anche iterare su riferimenti mutabili a ciascun elemento in un vettore mutabile
al fine di apportare modifiche a tutti gli elementi. Il ciclo `for` nell'elenco 8-8
aggiungerà `50` a ciascun elemento.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-08/src/main.rs:here}}
```

<span class="caption">Elenco 8-8: Iterazione su riferimenti mutabili agli
elementi in un vettore</span>

Per cambiare il valore a cui il riferimento mutabile fa riferimento, dobbiamo usare il
operatore di dereferenziazione `*` per arrivare al valore in `i` prima che possiamo usare l'operatore `+=`. Parleremo di più sull'operatore dereference nel [“Following the
Pointer to the Value with the Dereference Operator”][deref]<!-- ignore -->
sezione del Capitolo 15.

Iterare su un vettore, sia in modo immutabile che mutabile, è sicuro a causa delle
regole del borrow checker. Se avessimo cercato di inserire o rimuovere elementi nei cicli `for`
nei corpi di Elenco 8-7 e Elenco 8-8, avremmo ottenuto un errore del compilatore
simile a quello che abbiamo ottenuto con il codice nell'Elenco 8-6. Il riferimento al
vettore che il ciclo `for` mantiene impedisce la modifica simultanea dell'intero vettore.

### Utilizzare un Enum per memorizzare più tipi

I vettori possono memorizzare solo valori che sono dello stesso tipo. Questo può essere scomodo;
ci sono sicuramente casi in cui si ha bisogno di memorizzare un elenco di elementi di
tipi diversi. Fortunatamente, le varianti di un enum sono definite sotto lo stesso tipo enum, quindi quando abbiamo bisogno di un tipo per rappresentare elementi di tipi diversi, possiamo definire e utilizzare un enum!

Ad esempio, diciamo che vogliamo ottenere valori da una riga di un foglio di calcolo in cui
alcune delle colonne della riga contengono interi, alcuni numeri a virgola mobile,
e alcune stringhe. Possiamo definire un enum le cui varianti conterranno i diversi
tipi di valori, e tutte le varianti enum saranno considerate dello stesso tipo: quello
dell'enum. Quindi possiamo creare un vettore per contenere quell'enum e quindi, alla fine,
contiene diversi tipi. Lo abbiamo dimostrato nell'Elenco 8-9.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-09/src/main.rs:here}}
```

<span class="caption">Elenco 8-9: Definizione di un `enum` per memorizzare valori di
tipi diversi in un unico vettore</span>

Rust ha bisogno di sapere quali tipi saranno nel vettore al momento della compilazione in modo da sapere
esattamente quanto spazio in memoria sul heap sarà necessario per memorizzare ogni elemento. Noi
dobbiamo anche essere espliciti su quali tipi sono ammessi in questo vettore. Se Rust
permettesse a un vettore di contenere qualsiasi tipo, ci sarebbe la possibilità che uno o più dei
i tipi causerebbero errori con le operazioni eseguite sugli elementi del vettore. Utilizzare un enum più un `match` significa che Rust garantirà
al momento della compilazione che ogni possibile caso è gestito, come discusso nel Capitolo 6.

Se non conosci l'insieme esaustivo di tipi che un programma otterrà al momento dell'esecuzione per
memorizzare in un vettore, la tecnica enum non funzionerà. Invece, è possibile utilizzare un oggetto trait,
di cui parleremo nel Capitolo 17.

Ora che abbiamo discusso alcuni dei modi più comuni per utilizzare i vettori, assicurati
di rivedere [la documentazione API][vec-api]<!-- ignore --> per tutti i molti
metodi utili definiti su `Vec<T>` dalla libreria standard. Ad esempio, oltre a `push`, un metodo `pop` rimuove e restituisce l'ultimo elemento.

### Sganciare un Vettore cade i suoi Elementi

Come qualsiasi altro `struct`, un vettore viene liberato quando esce dallo scope, come
annotato nell'Elenco 8-10.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-10/src/main.rs:here}}
```

<span class="caption">Elenco 8-10: Mostra dove il vettore e i suoi elementi
sono sganciati</span>

Quando il vettore viene sganciato, tutti i suoi contenuti vengono anche sganciati, il  che significa che
interi che contiene saranno puliti. Il borrow checker assicura che qualsiasi
i riferimenti al contenuto di un vettore vengono utilizzati solo mentre il vettore stesso è
valido.

Passiamo ora al prossimo tipo di collezione: `String`!

[data-types]: ch03-02-data-types.html#data-types
[nomicon]: ../nomicon/vec/vec.html
[vec-api]: ../std/vec/struct.Vec.html
[deref]: ch15-02-deref.html#following-the-pointer-to-the-value-with-the-dereference-operator

