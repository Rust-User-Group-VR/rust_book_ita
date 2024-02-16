<!-- Intestazione vecchia. Non rimuovere o i link potrebbero interrompersi. -->
<a id="the-match-control-flow-operator"></a>
## The `match` Control Flow Construct

Rust ha un costrutto di controllo del flusso estremamente potente chiamato `match` che
ti permette di confrontare un valore con una serie di pattern e poi eseguire
del codice basato su quale pattern corrisponde. I pattern possono essere composti da valori letterali,
nomi di variabili, caratteri jolly, e molte altre cose; [Capitolo
18][ch18-00-patterns]<!-- ignore --> copre tutti i diversi tipi di pattern
e cosa fanno. La potenza di `match` deriva dall'espressività dei
pattern e dal fatto che il compilatore conferma che tutti i casi possibili sono gestiti.

Pensa a un'espressione `match` come se fosse una macchina conta-monete: le monete scivolano
lungo una pista con fori di varie dimensioni lungo il percorso, e ogni moneta cade attraverso
il primo foro in cui riesce ad entrare. Allo stesso modo, i valori passano
attraverso ogni pattern in un `match`, e al primo pattern in cui il valore "si inserisce,"
il valore cade nel blocco di codice associato per essere utilizzato durante l'esecuzione.

Parlando di monete, usiamone alcune come esempio per usare `match`! Possiamo scrivere una
funzione che prende una moneta statunitense (US) sconosciuta e, in modo simile al contatore
di monete, determina quale moneta è e restituisce il suo valore in centesimi, come mostrato
nella Listing 6-3.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-03/src/main.rs:here}}
```

<span class="caption">Listing 6-3: Un enum e un'espressione `match` che ha
le varianti dell'enum come suoi patterns</span>

Decomponiamo il `match` nella funzione `value_in_cents`. Per primo elenchiamo
la parola chiave `match` seguita da un'espressione, che in questo caso è il valore
`coin`. Questo sembra molto simile a un'espressione condizionale usata con `if`, ma
c'è una grande differenza: con `if`, la condizione deve valutare a un
valore Booleano, ma qui può essere di qualsiasi tipo. Il tipo di `coin` in questo esempio
è l'enum `Coin` che abbiamo definito sulla prima linea.

Successivamente ci sono le braccia `match`. Un braccio ha due parti: un pattern e un poco di codice. Il
primo braccio qui ha un pattern che è il valore `Coin::Penny` e poi l'operatore `=>`
che separa il pattern e il codice da eseguire. Il codice in questo caso
è solo il valore `1`. Ogni braccio è separato dal successivo con una virgola.

Quando l'espressione `match` si esegue, confronta il valore risultante contro
il pattern di ogni braccio, in ordine. Se un pattern corrisponde al valore, il codice
associato con quel pattern viene eseguito. Se quel pattern non corrisponde al
valore, l'esecuzione continua al braccio successivo, molto come in una macchina conta-monete.
Possiamo avere quante braccia vogliamo: nella Listing 6-3, il nostro `match` ha quattro braccia.

Il codice associato con ogni braccio è un'espressione, e il valore risultante dell'
espressione nel braccio corrispondente è il valore che viene restituito per l'
intera espressione `match`.

Di solito non usiamo le parentesi graffe se il codice del braccio del match è corto, come lo è
nella Listing 6-3 dove ogni braccio restituisce solo un valore. Se vuoi eseguire più
linee di codice in un braccio del match, devi usare le parentesi graffe, e la virgola
seguente al braccio è poi opzionale. Per esempio, il seguente codice stampa
"Lucky penny!" ogni volta che il metodo viene chiamato con un `Coin::Penny`, ma comunque
restituisce l'ultimo valore del blocco, `1`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-08-match-arm-multiple-lines/src/main.rs:here}}
```

### Patterns That Bind to Values

Un'altra caratteristica utile delle braccia del match è che possono collegarsi alle parti dei
valori che corrispondono al pattern. Questo è il modo in cui possiamo estrarre i valori fuori dalle varianti enum.

Come esempio, modifichiamo una delle nostre varianti enum per contenere dati al suo interno.
Dal 1999 al 2008, gli Stati Uniti hanno coniato quarti con disegni diversi per ciascuno dei 50 stati su un lato. Nessuna altra moneta ottenne i disegni degli stati, quindi solo i quarti hanno questo valore aggiuntivo. Possiamo aggiungere queste informazioni al nostro `enum` modificando la variante `Quarter` per includere un valore `UsState`
conservato dentro di essa, come abbiamo fatto nella Listing 6-4.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-04/src/main.rs:here}}
```

<span class="caption">Listing 6-4: Un `Coin` enum in cui la variante `Quarter`
contiene anche un valore `UsState`</span>

Immaginiamo che un amico stia cercando di collezionare tutti e 50 i quarti degli stati. Mentre
classifichiamo il nostro spicciolo per tipo di moneta, chiameremo anche ad alta voce il nome dello
stato associato a ciascun quarto in modo che, se è uno che il nostro amico non ha,
possano aggiungerlo alla loro collezione.

Nell'espressione match per questo codice, aggiungiamo una variabile chiamata `state` al
pattern che corrisponde ai valori della variante `Coin::Quarter`. Quando un
`Coin::Quarter` corrisponde, la variabile `state` si collegherà al valore dello
stato di quel quarto. Quindi possiamo usare `state` nel codice per quel braccio, come questo:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-09-variable-in-pattern/src/main.rs:here}}
```

Se dovessimo chiamare `value_in_cents(Coin::Quarter(UsState::Alaska))`, `coin`
sarebbe `Coin::Quarter(UsState::Alaska)`. Quando confrontiamo quel valore con ciascuno
delle braccia del match, nessuno di loro corrisponde fino a quando raggiungiamo `Coin::Quarter(state)`. A
quel punto, il collegamento per `state` sarà il valore `UsState::Alaska`. Possiamo
quindi utilizzare quel collegamento nell'espressione `println!`, ottenendo così il valore interno
della moneta dello stato fuori dalla variante enum `Coin` per `Quarter`.

### Matching with `Option<T>`

Nella sezione precedente, volevamo ottenere il valore interno `T` fuori dal caso `Some`
quando utilizzavamo `Option<T>`; possiamo anche gestire `Option<T>` usando `match`, come
abbiamo fatto con l'enum `Coin`! Invece di confrontare le monete, confronteremo le
varianti di `Option<T>`, ma il modo in cui l'espressione `match` funziona rimane lo
stesso.

Diciamo che vogliamo scrivere una funzione che prende un `Option<i32>` e, se
c'è un valore dentro, aggiunge 1 a quel valore. Se non c'è un valore dentro,
la funzione dovrebbe restituire il valore `None` e non tentare di effettuare alcuna
operazione.

Questa funzione è molto facile da scrivere, grazie a `match`, e assomiglierà
alla Listing 6-5.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-05/src/main.rs:here}}
```

<span class="caption">Listing 6-5: Una funzione che usa un'espressione `match` su
un `Option<i32>`</span>

Esaminiamo la prima esecuzione di `plus_one` in modo più dettagliato. Quando chiamiamo
`plus_one(five)`, la variabile `x` nel corpo di `plus_one` avrà il
valore `Some(5)`. Quindi lo confrontiamo con ciascuna braccio del match:

```rust,ignore
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-05/src/main.rs:first_arm}}
```

Il valore `Some(5)` non corrisponde al pattern `None`, quindi continuiamo al
prossimo braccio:

```rust,ignore
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-05/src/main.rs:second_arm}}
```

`Some(5)` corrisponde a `Some(i)`? Lo fa! Abbiamo la stessa variante. Il `i`
si lega al valore contenuto in `Some`, quindi `i` assume il valore `5`. Viene poi eseguito il codice nel match arm, quindi aggiungiamo 1 al valore di `i` e creiamo un
nuovo valore `Some` con il nostro totale `6` all'interno.

Ora consideriamo la seconda chiamata di `plus_one` in Listato 6-5, dove `x` è
`None`. Entriamo nel `match` e confrontiamo con il primo braccio:

```rust,ignore
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-05/src/main.rs:first_arm}}
```

Corrisponde! Non c'è alcun valore da aggiungere, quindi il programma si interrompe e restituisce il
valore `None` sul lato destro di `=>`. Poiché il primo braccio ha corrisposto, non viene confrontato nessun altro braccio.

Combinare `match` e enum è utile in molte situazioni. Vedrai questo
schema spesso nel codice Rust: `match` contro un enum, lega una variabile ai
dati all'interno e poi esegui il codice in base ad esso. All'inizio è un po' complicato, ma
una volta che ti ci abitui, vorresti averlo in tutti i linguaggi. È
costantemente un preferito dagli utenti.

### I Match Sono esaustivi

C'è un altro aspetto di `match` che dobbiamo discutere: i pattern delle braccia devono
coprire tutte le possibilità. Considera questa versione della nostra funzione `plus_one`,
che ha un bug e non si compilerà:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-10-non-exhaustive-match/src/main.rs:here}}
```

Non abbiamo gestito il caso `None`, quindi questo codice causerà un bug. Per fortuna, è
un bug che Rust sa come catturare. Se proviamo a compilare questo codice, otterremo questo
errore:

```console
{{#include ../listings/ch06-enums-and-pattern-matching/no-listing-10-non-exhaustive-match/output.txt}}
```

Rust sa che non abbiamo coperto ogni possibile caso, e sa anche quale
modello ci siamo dimenticati! I match in Rust sono *esaustivi*: dobbiamo esaurire ogni ultima
possibilità affinché il codice sia valido. Specialmente nel caso di
`Option<T>`, quando Rust ci impedisce di dimenticare di gestire esplicitamente il
caso `None`, ci protegge dall'assumere che abbiamo un valore quando potremmo avere un null, rendendo così impossibile l'errore da un miliardo di dollari di cui abbiamo discusso prima.

### Modelli Catch-all e il Segnaposto `_`

Utilizzando gli enum, possiamo anche intraprendere azioni speciali per alcuni valori particolari, ma
per tutti gli altri valori prendere un'azione predefinita. Immagina che stiamo implementando un gioco in cui, se ottieni un 3 lanciando un dado, il tuo giocatore non si muove, ma invece
ottiene un nuovo cappello di fantasia. Se ottieni un 7, il tuo giocatore perde un cappello di fantasia. Per tutti
gli altri valori, il tuo giocatore si muove quel numero di spazi sulla scacchiera. Ecco
un `match` che implementa quella logica, con il risultato del lancio del dado
hardcoded piuttosto che un valore casuale, e con tutta l'altra logica rappresentata da
funzioni senza corpi perché implementarle effettivamente è fuori dallo scopo per
questo esempio:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-15-binding-catchall/src/main.rs:here}}
```

Per le prime due armi, i pattern sono i valori letterali `3` e `7`. Per
l'ultima arm che copre ogni altro possibile valore, il pattern è il
variabile che abbiamo scelto di chiamare `other`. Il codice che corre per l'arm `other`
usa la variabile passandola alla funzione `move_player`.

Questo codice si compila, anche se non abbiamo elencato tutti i possibili valori a
`u8` può avere, perché l'ultimo modello corrisponderà a tutti i valori non specificamente
elencati. Questo pattern catch-all soddisfa il requisito che `match` deve essere
esaustivo. Nota che dobbiamo mettere l'arm catch-all alla fine perché i
pattern vengono valutati in ordine. Se mettessimo l'arm catch-all prima, le altre
armi non funzionerebbero mai, quindi Rust ci avvertirà se aggiungiamo armi dopo un catch-all!

Rust ha anche un pattern che possiamo usare quando vogliamo un catch-all ma non vogliamo
*usare* il valore nel pattern catch-all: `_` è un pattern speciale che corrisponde
a qualsiasi valore e non si lega a quel valore. Questo dice a Rust che non vedremo
usare il valore, quindi Rust non ci avviserà circa una variabile inutilizzata.

Cambiare le regole del gioco: ora, se ottieni qualcosa diverso da un 3 o
un 7, devi lanciare di nuovo il dado. Non abbiamo più bisogno di usare il valore catch-all, quindi
possiamo cambiare il nostro codice per usare `_` invece della variabile chiamata `other`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-16-underscore-catchall/src/main.rs:here}}
```

Anche questo esempio soddisfa il requisito di esaustività perché stiamo esplicitamente
ignorando tutti gli altri valori nell'ultimo braccio; non abbiamo dimenticato nulla.

Infine, cambieremo le regole del gioco ancora una volta in modo che nulla altro
accade nel tuo turno se ottieni qualcosa diverso da un 3 o un 7. Possiamo esprimere
che usando il valore unità (il tipo di tupla vuota che abbiamo menzionato nella [“Il Tipo Tupla”][tuples] <!-- ignore --> sezione) come il codice che va con l'arm `_`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-17-underscore-unit/src/main.rs:here}}
```

Qui, stiamo dicendo a Rust esplicitamente che non useremo nessun altro valore
che non corrisponde a un pattern in un braccio precedente, e non vogliamo eseguire alcuna
codice in questo caso.

C'è di più sui pattern e sui matching che copriremo nel [Capitolo
18][ch18-00-patterns]<!-- ignore -->. Per ora, passeremo alla
sintassi `if let`, che può essere utile in situazioni in cui l'espressione `match`
è un po' prolisso.

[tuples]: ch03-02-data-types.html#the-tuple-type
[ch18-00-patterns]: ch18-00-patterns.html

