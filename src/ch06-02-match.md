<!-- Old heading. Do not remove or links may break. -->
<a id="the-match-control-flow-operator"></a>
## Il Costrutto di Flusso di Controllo `match`

Rust ha un costrutto di flusso di controllo estremamente potente chiamato `match` che
ti permette di confrontare un valore con una serie di pattern e poi eseguire
il codice basato su quale pattern corrisponde. I pattern possono essere costituiti da valori letterali,
nomi di variabili, jolly e molte altre cose; [Capitolo
18][ch18-00-patterns]<!-- ignore --> copre tutti i diversi tipi di pattern
e cosa fanno. La potenza di `match` deriva dall'espressività dei
pattern e dal fatto che il compilatore conferma che tutti i casi possibili sono
gestiti.

Pensa a un'espressione `match` come a una macchina selezionatrice di monete: le monete scivolano
giù su una pista con buchi di varie dimensioni, e ogni moneta cade attraverso
il primo buco che incontra e che è adatto alla sua dimensione. Allo stesso modo, i valori percorrono
ogni pattern in un `match`, e al primo pattern che il valore “adatta”, 
il valore cade nel blocco di codice associato per essere utilizzato durante l'esecuzione.

Parlando di monete, usiamole come esempio usando `match`! Possiamo scrivere una
funzione che prende una moneta statunitense sconosciuta e, in modo simile a una macchina per contare,
determina quale moneta è e ne restituisce il valore in centesimi, come mostrato
nell'Elenco 6-3.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-03/src/main.rs:here}}
```

<span class="caption">Elenco 6-3: un enum e un'espressione `match` che ha
le varianti dell'enum come suoi pattern</span>

Analizziamo il `match` nella funzione `value_in_cents`. Prima elenchiamo
la parola chiave `match` seguita da un'espressione, che in questo caso è il valore
`coin`. Questo sembra molto simile a un'espressione condizionale usata con `if`, ma
c'è una grande differenza: con `if`, la condizione deve essere valutata come
valore booleano, ma qui può essere di qualsiasi tipo. Il tipo di `coin` in questo esempio
è l'enum `Coin` che abbiamo definito nella prima riga.

Successivamente ci sono i bracci del `match`. Un braccio ha due parti: un pattern e un po' di codice. Il
primo braccio qui ha un pattern che è il valore `Coin::Penny` e poi l'operatore `=>`
che separa il pattern e il codice da eseguire. Il codice in questo caso
è solo il valore `1`. Ogni braccio è separato dal successivo con una virgola.

Quando l'espressione `match` viene eseguita, confronta il valore risultante con
il pattern di ogni braccio, in ordine. Se un pattern corrisponde al valore,
il codice associato a quel pattern viene eseguito. Se quel pattern non corrisponde
al valore, l'esecuzione continua verso il braccio successivo, come in una macchina selezionatrice di monete.
Possiamo avere quanti bracci vogliamo: nell'Elenco 6-3, il nostro `match` ha quattro bracci.

Il codice associato a ogni braccio è un'espressione, e il valore risultante
dell'espressione nel braccio corrispondente è il valore che viene restituito per l'intera
espressione `match`.

Di solito non usiamo le parentesi graffe se il codice del braccio del match è breve, come nel
caso dell'Elenco 6-3 dove ogni braccio restituisce solo un valore. Se vuoi eseguire più
righe di codice in un braccio del match, devi usare le parentesi graffe, e la virgola
successiva al braccio diventa facoltativa. Ad esempio, il seguente codice stampa
“Penny fortunato!” ogni volta che il metodo viene chiamato con un `Coin::Penny`, ma ritorna comunque 
l'ultimo valore del blocco, `1`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-08-match-arm-multiple-lines/src/main.rs:here}}
```

### Pattern che Si Legano ai Valori

Un'altra caratteristica utile dei bracci del match è che possono legarsi alle parti dei
valori che corrispondono al pattern. Questo è il modo in cui possiamo estrarre valori dalle varianti dell'enum.

Come esempio, cambiamo una delle nostre varianti dell'enum per includere dati all’interno.
Dal 1999 al 2008, gli Stati Uniti hanno coniato quarti di dollaro con diversi
design per ciascuno dei 50 stati su un lato. Nessun'altra moneta ha avuto design statali, 
quindi solo i quarti di dollaro hanno questo valore extra. Possiamo aggiungere questa informazione al
nostro `enum` cambiando la variante `Quarter` per includere un valore `UsState`
memorizzato all'interno, come abbiamo fatto nell'Elenco 6-4.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-04/src/main.rs:here}}
```

<span class="caption">Elenco 6-4: un `Coin` enum in cui la variante `Quarter`
contiene anche un valore `UsState`</span>

Immaginiamo che un amico stia cercando di raccogliere tutti i 50 quarti di stato. Mentre
ordiniamo il nostro resto per tipo di moneta, annunceremo anche il nome dello
stato associato a ciascun quarto in modo che, se non l'ha ancora,
possa aggiungerlo alla sua collezione.

Nell'espressione match per questo codice, aggiungiamo una variabile chiamata `state` al pattern
che corrisponde ai valori della variante `Coin::Quarter`. Quando un
`Coin::Quarter` corrisponde, la variabile `state` si legherà al valore dello
stato di quel quarto di dollaro. Poi possiamo utilizzare `state` nel codice per quel braccio, come segue:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-09-variable-in-pattern/src/main.rs:here}}
```

Se dovessimo chiamare `value_in_cents(Coin::Quarter(UsState::Alaska))`, `coin`
sarebbe `Coin::Quarter(UsState::Alaska)`. Quando confrontiamo quel valore con ciascuno
dei bracci del match, nessuno di loro corrisponde finché non raggiungiamo `Coin::Quarter(state)`. 
A quel punto, l'associazione per `state` sarà il valore `UsState::Alaska`. Possiamo
poi utilizzare tale associazione nell'espressione `println!`, ottenendo quindi il valore 
interno dello stato dalla variante dell'enum `Coin` per `Quarter`.

### Matching con `Option<T>`

Nella sezione precedente, volevamo ottenere il valore interno `T` dal caso `Some`
quando usavamo `Option<T>`; possiamo anche gestire `Option<T>` usando `match`, come
abbiamo fatto con l'enum `Coin`! Invece di confrontare le monete, confronteremo
le varianti di `Option<T>`, ma il modo in cui funziona l'espressione `match` rimane lo stesso.

Supponiamo di voler scrivere una funzione che prende un `Option<i32>` e, se
c'è un valore all'interno, aggiunge 1 a quel valore. Se non c'è un valore all'interno,
la funzione dovrebbe restituire il valore `None` e non tentare di eseguire nessuna
operazione.

Questa funzione è molto facile da scrivere, grazie a `match`, e apparirà come
nell'Elenco 6-5.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-05/src/main.rs:here}}
```

<span class="caption">Elenco 6-5: una funzione che utilizza un'espressione `match` su
un `Option<i32>`</span>

Esaminiamo la prima esecuzione di `plus_one` in dettaglio. Quando chiamiamo
`plus_one(five)`, la variabile `x` nel corpo di `plus_one` avrà il
valore `Some(5)`. Poi confrontiamo questo valore con ciascun braccio del match:

```rust,ignore
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-05/src/main.rs:first_arm}}
```

Il valore `Some(5)` non corrisponde al pattern `None`, quindi continuiamo al
braccio successivo:

```rust,ignore
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-05/src/main.rs:second_arm}}
```

Il valore `Some(5)` corrisponde a `Some(i)`? Sì, corrisponde! Abbiamo la stessa variante.
La variabile `i` si lega al valore contenuto in `Some`, quindi `i` prende il valore 
`5`. Il codice nel braccio del match viene poi eseguito, quindi aggiungiamo 1 al valore di
`i` e creiamo un nuovo valore `Some` con il nostro totale `6` all'interno.

Ora consideriamo la seconda chiamata di `plus_one` nell'Elenco 6-5, dove `x` è
`None`. Entriamo nel `match` e confrontiamo con il primo braccio:

```rust,ignore
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-05/src/main.rs:first_arm}}
```

Corrisponde! Non c'è valore a cui aggiungere, quindi il programma si ferma e restituisce il
valore `None` sul lato destro di `=>`. Poiché il primo braccio ha corrisposto, nessun altro
braccio viene confrontato.

Combinare `match` e enum è utile in molte situazioni. Vedrai spesso
questo pattern nel codice Rust: `match` contro un enum, associare una variabile ai dati
interni e poi eseguire del codice basato su di esso. È un po' complicato all'inizio, ma
una volta che ti ci abitui, desidererai averlo in tutti i linguaggi. È
costantemente un favorito degli utenti.

### I Match sono Esaustivi

C'è un altro aspetto di `match` di cui dobbiamo discutere: i pattern dei bracci devono
coprire tutte le possibilità. Considera questa versione della nostra funzione `plus_one`,
che ha un bug e non compilerà:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-10-non-exhaustive-match/src/main.rs:here}}
```

Non abbiamo gestito il caso `None`, quindi questo codice causerà un bug. Fortunatamente, è
un bug che Rust sa come catturare. Se proviamo a compilare questo codice, otterremo questo
errore:

```console
{{#include ../listings/ch06-enums-and-pattern-matching/no-listing-10-non-exhaustive-match/output.txt}}
```

Rust sa che non abbiamo coperto tutti i casi possibili, e sa persino quale
pattern abbiamo dimenticato! I match in Rust sono *esaustivi*: dobbiamo esaurire ogni ultima 
possibilità affinché il codice sia valido. Soprattutto nel caso
di `Option<T>`, quando Rust ci impedisce di dimenticare di gestire esplicitamente il caso
`None`, ci protegge dall'assumere di avere un valore quando potremmo avere null,
rendendo così impossibile l'errore miliardario di cui abbiamo parlato prima.

### Pattern Generici e il Segnaposto `_`

Usando gli enum, possiamo anche intraprendere azioni speciali per alcuni valori
particolari, ma per tutti gli altri valori intraprendere un'azione predefinita. Immagina di
stare implementando un gioco in cui, se tiri 3 con un dado, il tuo giocatore non si muove,
ma riceve invece un nuovo cappello elegante. Se tiri un 7, il tuo giocatore perde un
cappello elegante. Per tutti gli altri valori, il tuo giocatore si muove di quel numero di
spazi sul tabellone. Ecco un `match` che implementa quella logica, con il risultato del 
tiro di dado codificato anziché un valore casuale, e tutta l'altra logica rappresentata da
funzioni senza corpi perché implementarle realmente è fuori dal nostro scopo:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-15-binding-catchall/src/main.rs:here}}
```

Per i primi due bracci, i pattern sono i valori letterali `3` e `7`. Per 
l'ultimo braccio che copre ogni altro valore possibile, il pattern è la
variabile che abbiamo scelto di chiamare `other`. Il codice che viene eseguito per il braccio
`other` utilizza la variabile passandola alla funzione `move_player`.

Questo codice compila, anche se non abbiamo elencato tutti i possibili valori che un
`u8` può avere, perché l'ultimo pattern catturerà tutti i valori non specificamente
elencati. Questo pattern generico soddisfa il requisito che il `match` debba essere
esaustivo. Nota che dobbiamo mettere l'ultimo braccio generico perché i
pattern vengono valutati in ordine. Se mettessimo il braccio generico prima, gli altri
bracci non verrebbero mai eseguiti, quindi Rust ci avviserà se aggiungiamo bracci dopo un catch-all!

Rust ha anche un pattern che possiamo utilizzare quando vogliamo un catch-all ma non vogliamo
*utilizzare* il valore nel pattern catch-all: `_` è un pattern speciale che corrisponde
a qualsiasi valore e non si lega a tale valore. Questo dice a Rust che non useremo
il valore, quindi Rust non ci avviserà riguardo a una variabile non utilizzata.

Cambiamo le regole del gioco: ora, se tiri qualcosa diverso da un 3 o un 7,
devi tirare di nuovo il dado. Non abbiamo più bisogno di utilizzare il valore generico,
quindi possiamo cambiare il nostro codice per usare `_` invece della variabile chiamata `other`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-16-underscore-catchall/src/main.rs:here}}
```

Questo esempio soddisfa anche il requisito di esaustività perché stiamo esplicitamente
ignorando tutti gli altri valori nell'ultimo braccio; non abbiamo dimenticato nulla.

Infine, cambieremo ancora una volta le regole del gioco così che non succeda
nulla nel tuo turno se tiri qualcosa diverso da un 3 o 7. Possiamo esprimere
questo usando il valore unitario (il tipo di tuple vuoto di cui abbiamo parlato nella [“Il tipo 
Tuple”][tuples]<!-- ignore -->) come il codice che segue il braccio `_`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-17-underscore-unit/src/main.rs:here}}
```

Qui, stiamo dicendo a Rust esplicitamente che non useremo nessun altro valore che non
corrisponde a un pattern in un braccio precedente, e non vogliamo eseguire
alcun codice in questo caso.

Parleremo più in dettaglio di pattern e match nel [Capitolo
18][ch18-00-patterns]<!-- ignore -->. Per ora, passeremo alla sintassi `if let`, che può essere utile in 
situazioni in cui l'espressione `match` è un po' prolissa.

[tuples]: ch03-02-data-types.html#the-tuple-type
[ch18-00-patterns]: ch18-00-patterns.html

