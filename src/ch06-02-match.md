<!-- Old heading. Do not remove or links may break. -->
<a id="the-match-control-flow-operator"></a>
## Il Costrutto di Flusso di Controllo `match`

Rust ha un costrutto di flusso di controllo estremamente potente chiamato `match` che ti permette di confrontare un valore con una serie di pattern e poi eseguire il codice in base al pattern che si abbina. I pattern possono essere costituiti da valori letterali, nomi di variabili, caratteri jolly e molte altre cose; [Capitolo 18][ch18-00-patterns]<!-- ignore --> copre tutti i diversi tipi di pattern e cosa fanno. La potenza di `match` deriva dall'espressività dei pattern e dal fatto che il compilatore conferma che tutti i casi possibili sono gestiti.

Pensa a un'espressione `match` come a una macchina che ordina monete: le monete scorrono lungo un percorso con fori di varie dimensioni lungo di esso, e ciascuna moneta cade attraverso il primo foro che incontra in cui può entrare. Allo stesso modo, i valori passano attraverso ciascun pattern in un `match`, e al primo pattern in cui il valore "si adatta", il valore cade nel blocco di codice associato per essere usato durante l'esecuzione.

Parlando di monete, usiamole come esempio utilizzando `match`! Possiamo scrivere una funzione che prende una moneta USA sconosciuta e, in modo simile alla macchina di conteggio, determina quale moneta sia e restituisce il suo valore in centesimi, come mostrato in Listing 6-3.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-03/src/main.rs:here}}
```

<span class="caption">Listing 6-3: Un `enum` e un'espressione `match` che ha le varianti del `enum` come suoi pattern</span>

Analizziamo il `match` nella funzione `value_in_cents`. Prima elenchiamo la parola chiave `match` seguita da un'espressione, che in questo caso è il valore `coin`. Questo sembra molto simile a un'espressione condizionale usata con `if`, ma c'è una grande differenza: con `if`, la condizione deve essere valutata come un valore Booleano, ma qui può essere di qualsiasi tipo. Il tipo di `coin` in questo esempio è l'`enum` `Coin` che abbiamo definito nella prima riga.

Successivamente ci sono i `Rami` del `match`. Un ramo ha due parti: un pattern e del codice. Il primo ramo qui ha un pattern che è il valore `Coin::Penny` e poi l'operatore `=>` che separa il pattern e il codice da eseguire. Il codice in questo caso è solo il valore `1`. Ogni ramo è separato dal successivo con una virgola.

Quando l'espressione `match` viene eseguita, confronta il valore risultante con il pattern di ciascun ramo, in ordine. Se un pattern si abbina al valore, il codice associato a quel pattern viene eseguito. Se quel pattern non si abbina al valore, l'esecuzione continua al ramo successivo, proprio come in una macchina che ordina monete. Possiamo avere quanti rami ci servono: nel Listing 6-3, il nostro `match` ha quattro rami.

Il codice associato a ciascun ramo è un'espressione, e il valore risultante dell'espressione nel ramo che si abbina è il valore che viene restituito per l'intera espressione `match`.

Di solito non usiamo parentesi graffe se il codice del ramo `match` è breve, come nel Listing 6-3 dove ciascun ramo restituisce solo un valore. Se vuoi eseguire più righe di codice in un ramo `match`, devi usare le parentesi graffe, e la virgola che segue il ramo è quindi opzionale. Ad esempio, il seguente codice stampa “Lucky penny!” ogni volta che il metodo viene chiamato con un `Coin::Penny`, ma restituisce comunque l'ultimo valore del blocco, `1`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-08-match-arm-multiple-lines/src/main.rs:here}}
```

### Pattern che Si Legano ai Valori

Un'altra caratteristica utile dei rami `match` è che possono legarsi alle parti dei valori che coincidono con il pattern. Questo è il modo in cui possiamo estrarre valori dalle varianti dell'`enum`.

Come esempio, cambiamo una delle nostre varianti dell'`enum` per contenere dati al suo interno. Dal 1999 al 2008, gli Stati Uniti hanno coniato quarti con disegni diversi per ciascuno dei 50 stati su un lato. Nessun'altra moneta ha avuto disegni statali, quindi solo i quarti hanno questo valore aggiuntivo. Possiamo aggiungere queste informazioni al nostro `enum` cambiando la variante `Quarter` per includere un valore `UsState` memorizzato al suo interno, cosa che abbiamo fatto nel Listing 6-4.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-04/src/main.rs:here}}
```

<span class="caption">Listing 6-4: Un `enum` `Coin` in cui la variante `Quarter` contiene anche un valore `UsState`</span>

Immaginiamo che un amico stia cercando di collezionare tutti i 50 quarti degli stati. Mentre ordiniamo i nostri spiccioli per tipo di moneta, annunceremo anche il nome dello stato associato a ciascun quarto in modo che, se è uno che il nostro amico non ha, possa aggiungerlo alla sua collezione.

Nell'espressione `match` per questo codice, aggiungiamo una variabile chiamata `state` al pattern che coincide con i valori della variante `Coin::Quarter`. Quando un `Coin::Quarter` si abbina, la variabile `state` si legherà al valore dello stato di quel quarto. Possiamo quindi usare `state` nel codice per quel ramo, in questo modo:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-09-variable-in-pattern/src/main.rs:here}}
```

Se dovessimo chiamare `value_in_cents(Coin::Quarter(UsState::Alaska))`, `coin` sarebbe `Coin::Quarter(UsState::Alaska)`. Quando confrontiamo quel valore con ciascuno dei rami del match, nessuno di loro si abbina fino a che non raggiungiamo `Coin::Quarter(state)`. A quel punto, il legame per `state` sarà il valore `UsState::Alaska`. Possiamo quindi usare quel legame nell'espressione `println!`, ottenendo così il valore interno dello stato dalla variante `enum` `Coin` per `Quarter`.

### L'uso di `match` con `Option<T>`

Nella sezione precedente, volevamo ottenere il valore interno `T` dal caso `Some` quando usavamo `Option<T>`; possiamo anche gestire `Option<T>` usando `match`, come abbiamo fatto con l'`enum` `Coin`! Invece di confrontare monete, confronteremo le varianti di `Option<T>`, ma il modo in cui l'espressione `match` funziona rimane lo stesso.

Supponiamo di voler scrivere una funzione che prenda un `Option<i32>` e, se c'è un valore dentro, aggiunga 1 a quel valore. Se non c'è un valore dentro, la funzione dovrebbe restituire il valore `None` e non tentare di effettuare operazioni.

Questa funzione è molto semplice da scrivere, grazie a `match`, e sembrerà come nel Listing 6-5.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-5/src/main.rs:here}}
```

<span class="caption">Listing 6-5: Una funzione che usa un'espressione `match` su un `Option<i32>`</span>

Esaminiamo la prima esecuzione di `plus_one` in modo più dettagliato. Quando chiamiamo `plus_one(five)`, la variabile `x` nel Blocco di `plus_one` avrà il valore `Some(5)`. Poi confrontiamo quello con ciascun ramo del match:

```rust,ignore
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-5/src/main.rs:first_arm}}
```

Il valore `Some(5)` non corrisponde al pattern `None`, quindi continuiamo al ramo successivo:

```rust,ignore
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-5/src/main.rs:second_arm}}
```

`Some(5)` corrisponde a `Some(i)`? Sì! Abbiamo la stessa variante. `i` si lega al valore contenuto in `Some`, quindi `i` assume il valore `5`. Il codice nel ramo del match viene quindi eseguito, quindi aggiungiamo 1 al valore di `i` e creiamo un nuovo valore `Some` con il nostro totale `6` dentro.

Ora consideriamo la seconda chiamata di `plus_one` nel Listing 6-5, dove `x` è `None`. Entriamo nel `match` e confrontiamo con il primo ramo:

```rust,ignore
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-5/src/main.rs:first_arm}}
```

Si abbina! Non c'è alcun valore da aggiungere, quindi il programma si ferma e restituisce il valore `None` sul lato destro di `=>`. Poiché il primo ramo si è abbinato, nessun altro ramo viene confrontato.

Combinare `match` ed `enum` è utile in molte situazioni. Vedrai spesso questo pattern nel codice Rust: `match` su un `enum`, lega una variabile ai dati all'interno, e poi esegui il codice in base a esso. All'inizio è un po' complesso, ma una volta che ci si abitua, si desidera averlo in tutti i linguaggi. È costantemente uno dei preferiti dagli utenti.

### I Match sono Esaustivi

C'è un altro aspetto di `match` di cui dobbiamo discutere: i pattern dei rami devono coprire tutte le possibilità. Considera questa versione della nostra funzione `plus_one`, che ha un bug e non verrà compilata:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-10-non-exhaustive-match/src/main.rs:here}}
```

Non abbiamo gestito il caso `None`, quindi questo codice causerà un bug. Per fortuna, è un bug che Rust sa come rilevare. Se proviamo a compilare questo codice, otterremo questo errore:

```console
{{#include ../listings/ch06-enums-and-pattern-matching/no-listing-10-non-exhaustive-match/output.txt}}
```

Rust sa che non abbiamo coperto ogni caso possibile e sa anche quale pattern abbiamo dimenticato! I match in Rust sono *esaustivi*: dobbiamo esaurire ogni ultima possibilità affinché il codice sia valido. Specialmente nel caso di `Option<T>`, quando Rust ci impedisce di dimenticare di gestire esplicitamente il caso `None`, ci protegge dall'assumere che abbiamo un valore quando potremmo avere null, rendendo quindi impossibile l'errore del miliardo di dollari discusso prima.

### Pattern di Riferimento Generico e il Segnaposto `_`

Usando gli `enum`, possiamo anche intraprendere azioni speciali per alcuni valori particolari, ma per tutti gli altri valori fare un'azione predefinita. Immagina che stiamo implementando un gioco in cui, se tiri un 3 con un dado, il tuo giocatore non si muove, ma ottiene invece un nuovo cappello elegante. Se tiri un 7, il tuo giocatore perde un cappello elegante. Per tutti gli altri valori, il tuo giocatore si muove di quel numero di spazi sul tabellone. Ecco un `match` che implementa quella logica, con il risultato del lancio del dado codificato come valore fisso piuttosto che come valore casuale, e tutta l'altra logica rappresentata da funzioni senza blocchi poiché implementarle è fuori dal contesto di questo esempio:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-15-binding-catchall/src/main.rs:here}}
```

Per i primi due rami, i pattern sono i valori letterali `3` e `7`. Per l'ultimo ramo che copre ogni altro possibile valore, il pattern è la variabile che abbiamo scelto di chiamare `other`. Il codice che viene eseguito per il ramo `other` usa la variabile passandola alla funzione `move_player`.

Questo codice viene compilato, anche se non abbiamo elencato tutti i valori possibili che un `u8` può avere, perché l'ultimo pattern abbinerà tutti i valori non specificamente elencati. Questo pattern di riferimento generico soddisfa il requisito che il `match` deve essere esaustivo. Nota che dobbiamo mettere l'ultimo ramo per il pattern generico perché i pattern vengono valutati in ordine. Se mettiamo il ramo generico prima, gli altri rami non verrebbero mai eseguiti, quindi Rust ci avviserà se aggiungiamo rami dopo un pattern generico!

Rust ha anche un pattern che possiamo usare quando vogliamo un riferimento generico ma non vogliamo *usare* il valore nel pattern generico: `_` è un pattern speciale che corrisponde a qualsiasi valore e non si lega a quel valore. Questo dice a Rust che non useremo il valore, quindi Rust non ci avviserà di una variabile inutilizzata.

Cambiamo le regole del gioco: ora, se tiri qualcosa di diverso da un 3 o un 7, devi tirare di nuovo. Non abbiamo più bisogno di usare il valore di riferimento generico, quindi possiamo cambiare il nostro codice per usare `_` invece della variabile chiamata `other`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-16-underscore-catchall/src/main.rs:here}}
```

Questo esempio soddisfa anche il requisito di esaustività perché stiamo ignorando esplicitamente tutti gli altri valori nell'ultimo ramo; non abbiamo dimenticato nulla.

Infine, cambiamo un'ultima volta le regole del gioco in modo che, se tiri qualcosa di diverso da un 3 o un 7, non succeda nient'altro nel tuo turno. Possiamo esprimere ciò usando il valore unitario (il tipo di tupla vuota menzionato nella [sezione “Il Tipo Tupla”][tuples]<!-- ignore -->) come il codice che va con il ramo `_`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-17-underscore-unit/src/main.rs:here}}
```

Qui, stiamo dicendo a Rust esplicitamente che non useremo alcun altro valore che non corrisponda a un pattern in un ramo precedente, e non vogliamo eseguire alcun codice in questo caso.

C'è di più sui pattern e sul matching che vedremo nel [Capitolo 18][ch18-00-patterns]<!-- ignore -->. Per ora, passeremo alla sintassi `if let`, che può essere utile in situazioni in cui l'espressione `match` è un po' prolissa.

[tuples]: ch03-02-data-types.html#the-tuple-type
[ch18-00-patterns]: ch18-00-patterns.html

