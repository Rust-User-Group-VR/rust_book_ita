## Memorizzare elenchi di valori con Vettori

Il primo tipo di raccolta che esamineremo è `Vec<T>`, noto anche come *vettore*. I Vettori ti permettono di memorizzare più di un valore in una singola struttura dati che mette tutti i valori uno accanto all'altro nella memoria. I Vettori possono memorizzare solo valori dello stesso tipo. Sono utili quando hai un elenco di elementi, come le righe di testo in un file o i prezzi degli articoli in un carrello della spesa.

### Creare un nuovo Vettore

Per creare un nuovo vettore vuoto, chiamiamo la funzione `Vec::new`, come mostrato in Listing 8-1.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-01/src/main.rs:here}}
```

<span class="caption">Listing 8-1: Creare un nuovo vettore vuoto per contenere valori di tipo `i32`</span>

Nota che abbiamo aggiunto un'annotazione di tipo qui. Poiché non stiamo inserendo alcun valore in questo vettore, Rust non sa quale tipo di elementi intendiamo memorizzare. Questo è un punto importante. I Vettori sono implementati utilizzando generics; tratteremo come usare i generics con i tuoi tipi nel Capitolo 10. Per ora, sappi che il tipo `Vec<T>` fornito dalla libreria standard può contenere qualsiasi tipo. Quando creiamo un vettore per contenere un tipo specifico, possiamo specificare il tipo tra parentesi angolari. Nel Listing 8-1, abbiamo detto a Rust che il `Vec<T>` in `v` conterrà elementi di tipo `i32`.

Più spesso, creerai un `Vec<T>` con valori iniziali e Rust dedurrà il tipo di valore che vuoi memorizzare, quindi raramente hai bisogno di fare questa annotazione di tipo. Rust fornisce convenientemente la macro `vec!`, che creerà un nuovo vettore che contiene i valori che gli passi. Il Listing 8-2 crea un nuovo `Vec<i32>` che contiene i valori `1`, `2` e `3`. Il tipo intero è `i32` perché è il tipo intero predefinito, come abbiamo discusso nella sezione [“Tipi di dati”][data-types]<!-- ignore --> del Capitolo 3.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-02/src/main.rs:here}}
```

<span class="caption">Listing 8-2: Creare un nuovo vettore contenente valori</span>

Dal momento che abbiamo fornito valori iniziali `i32`, Rust può dedurre che il tipo di `v` è `Vec<i32>`, e l'annotazione di tipo non è necessaria. Successivamente, vedremo come modificare un vettore.

### Aggiornare un Vettore

Per creare un vettore e poi aggiungere elementi, possiamo usare il metodo `push`, come mostrato in Listing 8-3.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-03/src/main.rs:here}}
```

<span class="caption">Listing 8-3: Usare il metodo `push` per aggiungere valori a un vettore</span>

Come con qualsiasi variabile, se vogliamo essere in grado di cambiarne il valore, dobbiamo renderla mutabile utilizzando la parola chiave `mut`, come discusso nel Capitolo 3. I numeri che inseriamo all'interno sono tutti di tipo `i32`, e Rust lo deduce dai dati, quindi non abbiamo bisogno dell'annotazione `Vec<i32>`.

### Leggere gli elementi dei Vettori

Ci sono due modi per fare riferimento a un valore memorizzato in un vettore: tramite l'indicizzazione o utilizzando il metodo `get`. Negli esempi seguenti, abbiamo annotato i tipi dei valori che vengono restituiti da queste funzioni per maggiore chiarezza.

Il Listing 8-4 mostra entrambi i metodi di accesso a un valore in un vettore, con la sintassi di indicizzazione e il metodo `get`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-04/src/main.rs:here}}
```

<span class="caption">Listing 8-4: Usare la sintassi di indicizzazione e il metodo `get` per accedere a un elemento in un vettore</span>

Nota alcuni dettagli qui. Usiamo il valore di indice `2` per ottenere il terzo elemento perché i vettori sono indicizzati a partire da zero. Usare `&` e `[]` ci fornisce un riferimento all'elemento al valore dell'indice. Quando utilizziamo il metodo `get` con l'indice passato come argomento, otteniamo un `Option<&T>` che possiamo usare con `match`.

Rust fornisce questi due modi per fare riferimento a un elemento in modo che tu possa scegliere come il programma si comporta quando provi a utilizzare un valore di indice al di fuori del range di elementi esistenti. Per esempio, vediamo cosa succede quando abbiamo un vettore di cinque elementi e poi proviamo ad accedere a un elemento all'indice 100 con ciascuna tecnica, come mostrato nel Listing 8-5.

```rust,should_panic,panics
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-05/src/main.rs:here}}
```

<span class="caption">Listing 8-5: Tentativo di accesso all'elemento all'indice 100 in un vettore contenente cinque elementi</span>

Quando eseguiamo questo codice, il primo metodo `[]` farà andare in *Panic* il programma perché fa riferimento a un elemento inesistente. Questo metodo è più adatto quando vuoi che il tuo programma si arresti se c'è un tentativo di accedere a un elemento oltre la fine del vettore.

Quando al metodo `get` viene passato un indice che è al di fuori del vettore, restituisce `None` senza provocare un *Panic*. Utilizzeresti questo metodo se l'accesso a un elemento oltre il range del vettore può accadere occasionalmente in circostanze normali. Il tuo codice avrà quindi la logica per gestire `Some(&element)` o `None`, come discusso nel Capitolo 6. Per esempio, l'indice potrebbe provenire da una persona che inserisce un numero. Se inseriscono accidentalmente un numero troppo grande e il programma ottiene un valore `None`, potresti dirgli quanti elementi ci sono nel vettore corrente e dare loro un'altra possibilità di inserire un valore valido. Sarebbe più user-friendly che far arrestare il programma per un errore di battitura!

Quando il programma ha un riferimento valido, il *Borrow Checker* fa rispettare le regole di "Ownership" e "Borrowing" (coperte nel Capitolo 4) per garantire che questo riferimento e qualsiasi altro riferimento ai contenuti del vettore rimangano validi. Ricorda la regola che afferma che non puoi avere riferimenti mutabili e imutabili nello stesso Scope. Questa regola si applica nel Listing 8-6, dove manteniamo un riferimento imutabile al primo elemento di un vettore e proviamo ad aggiungere un elemento alla fine. Questo programma non funzionerà se provassimo anche a riferirci a quell'elemento successivamente nella funzione.

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-06/src/main.rs:here}}
```

<span class="caption">Listing 8-6: Tentativo di aggiungere un elemento a un vettore mantenendo un riferimento a un elemento</span>

Compilare questo codice produrrà questo errore:

```console
{{#include ../listings/ch08-common-collections/listing-08-06/output.txt}}
```

Il codice nel Listing 8-6 potrebbe sembrare che dovrebbe funzionare: perché dovrebbe interessarsi a un riferimento al primo elemento riguardo a cambiamenti alla fine del vettore? Questo errore è dovuto al modo in cui funzionano i vettori: poiché i vettori mettono i valori uno accanto all'altro nella memoria, aggiungere un nuovo elemento alla fine del vettore potrebbe richiedere di allocare nuova memoria e copiare gli elementi vecchi nello nuovo spazio, se non c'è abbastanza spazio per mettere tutti gli elementi uno accanto all'altro dove il vettore è attualmente memorizzato. In quel caso, il riferimento al primo elemento punterebbe a memoria deallocata. Le regole di "Borrowing" impediscono ai programmi di finire in quella situazione.

> Nota: Per ulteriori dettagli sull'implementazione del tipo `Vec<T>`, consulta [“The Rustonomicon”][nomicon].

### Iterare sui valori in un Vettore

Per accedere a ciascun elemento in un vettore a turno, itereremmo su tutti gli elementi piuttosto che utilizzare indici per accedervi uno alla volta. Il Listing 8-7 mostra come utilizzare un `for` loop per ottenere riferimenti imutabili a ciascun elemento in un vettore di valori `i32` e stamparli.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-07/src/main.rs:here}}
```

<span class="caption">Listing 8-7: Stampare ciascun elemento in un vettore iterando sugli elementi utilizzando un `for` loop</span>

Possiamo anche iterare su riferimenti mutabili a ciascun elemento in un vettore mutabile al fine di apportare modifiche a tutti gli elementi. Il `for` loop nel Listing 8-8 aggiungerà `50` a ciascun elemento.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-08/src/main.rs:here}}
```

<span class="caption">Listing 8-8: Iterare su riferimenti mutabili agli elementi in un vettore</span>

Per modificare il valore a cui si riferisce il riferimento mutabile, dobbiamo usare l'operatore di dereferenziazione `*` per ottenere il valore in `i` prima di poter usare l'operatore `+=`. Parleremo di più dell'operatore di dereferenziazione nella sezione [“Seguire il puntatore al valore con l'operatore di dereferenziazione”][deref]<!-- ignore --> del Capitolo 15.

Iterare su un vettore, che sia in modo imutabile o mutabile, è sicuro grazie alle regole del *Borrow Checker*. Se provassimo a inserire o rimuovere elementi nei corpi dei `for` loop nei Listing 8-7 e 8-8, otterremmo un errore del compilatore simile a quello che abbiamo ottenuto con il codice nel Listing 8-6. Il riferimento al vettore che il `for` loop detiene impedisce la modifica simultanea di tutto il vettore.

### Usare un Enum per memorizzare tipi multipli

I Vettori possono memorizzare solo valori che sono dello stesso tipo. Questo può essere scomodo; ci sono sicuramente casi d'uso in cui è necessario memorizzare un elenco di elementi di tipi diversi. Fortunatamente, le varianti di un enum sono definite sotto lo stesso tipo enum, quindi quando abbiamo bisogno di un tipo per rappresentare elementi di tipi diversi, possiamo definire e usare un enum!

Per esempio, diciamo di voler ottenere valori da una riga in un foglio di calcolo in cui alcune colonne nella riga contengono numeri interi, alcuni numeri in virgola mobile e alcune stringhe. Possiamo definire un enum le cui varianti conterranno i diversi tipi di valore, e tutte le varianti enum saranno considerate dello stesso tipo: quello dell'enum. Poi possiamo creare un vettore per contenere quell'enum e quindi, in ultima analisi, contenere tipi diversi. Abbiamo dimostrato questo nel Listing 8-9.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-09/src/main.rs:here}}
```

<span class="caption">Listing 8-9: Definire un `enum` per memorizzare valori di diversi tipi in un unico vettore</span>

Rust ha bisogno di sapere quali tipi ci saranno nel vettore a tempo di compilazione in modo che sappia esattamente quanta memoria sullo heap sarà necessaria per memorizzare ciascun elemento. Dobbiamo anche essere espliciti su quali tipi sono consentiti in questo vettore. Se Rust permettesse a un vettore di contenere qualsiasi tipo, ci sarebbe la possibilità che uno o più tipi causino errori con le operazioni eseguite sugli elementi del vettore. Usare un enum più un'espressione `match` significa che Rust garantirà a tempo di compilazione che ogni caso possibile sia gestito, come discusso nel Capitolo 6.

Se non conosci l'insieme esaustivo di tipi che un programma riceverà a runtime per memorizzare in un vettore, la tecnica dell'enum non funzionerà. Invece, puoi usare un trait object, che copriremo nel Capitolo 17.

Ora che abbiamo discusso alcuni dei modi più comuni per usare i vettori, assicurati di rivedere [la documentazione API][vec-api]<!-- ignore --> per tutti i molti metodi utili definiti su `Vec<T>` dalla libreria standard. Per esempio, oltre a `push`, un metodo `pop` rimuove e restituisce l'ultimo elemento.

### Rilasciare un Vettore rilascia i suoi elementi

Come qualsiasi altro `struct`, un vettore viene liberato quando esce dallo Scope, come annotato nel Listing 8-10.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-10/src/main.rs:here}}
```

<span class="caption">Listing 8-10: Mostrare dove il vettore e i suoi elementi vengono rilasciati</span>

Quando il vettore viene rilasciato, anche tutti i suoi contenuti vengono rilasciati, il che significa che gli interi che contiene verranno puliti. Il *Borrow Checker* garantisce che eventuali riferimenti ai contenuti di un vettore siano utilizzati solo mentre il vettore stesso è valido.

Passiamo al prossimo tipo di raccolta: `String`!

[data-types]: ch03-02-data-types.html#data-types
[nomicon]: ../nomicon/vec/vec.html
[vec-api]: ../std/vec/struct.Vec.html
[deref]: ch15-02-deref.html#following-the-pointer-to-the-value-with-the-dereference-operator
