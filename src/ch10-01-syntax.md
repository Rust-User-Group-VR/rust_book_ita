## Tipi di dati generici

Usiamo i generici per creare definizioni per elementi come firme di funzione o
structs, che possiamo poi utilizzare con molti tipi di dati concreti differenti. Iniziamo
analizzando come definire funzioni, structs, enum e metodi usando
i generici. Poi discuteremo come i generici influenzano le prestazioni del codice.

### Nelle definizioni di funzione

Quando definiamo una funzione che utilizza i generici, posizioniamo i generici nella
firma della funzione dove di solito specificheremmo i tipi di dati dei
parametri e del valore di ritorno. Fare ciò rende il nostro codice più flessibile e fornisce
maggiore funzionalità ai chiamanti della nostra funzione evitando la duplicazione del codice.

Continuando con la nostra funzione `largest`, il Listato 10-4 mostra due funzioni che
entrambi trovano il valore più grande in una slice. Poi combineremo queste in una singola
funzione che usa i generici.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-04/src/main.rs:here}}
```

<span class="caption">Listato 10-4: Due funzioni che differiscono solo nei loro
nomi e nei tipi nelle loro firme</span>

La funzione `largest_i32` è quella che abbiamo estratto nel Listato 10-3 che trova
il più grande `i32` in una slice. La funzione `largest_char` trova il più grande
`char` in una slice. I Blocchi delle funzioni hanno lo stesso codice, quindi eliminiamo
la duplicazione introducendo un parametro di tipo generico in una singola funzione.

Per parametrizzare i tipi in una nuova funzione singola, dobbiamo assegnare un nome al tipo
di parametro, proprio come facciamo per i parametri di valore di una funzione. È possibile utilizzare
qualsiasi identificatore come nome di parametro di tipo. Ma useremo `T` perché, per
convenzione, i nomi dei parametri di tipo in Rust sono brevi, spesso di una sola lettera, e
la convenzione di denominazione dei tipi in Rust è l'utilizzo del maiuscolo a cammello.
Abbreviazione di *type* (tipo), `T` è la scelta predefinita della maggior parte dei programmatori Rust.

Quando utilizziamo un parametro nel Blocco della funzione, dobbiamo dichiarare il
nome del parametro nella firma affinché il compilatore sappia cosa significhi quel nome.
In modo simile, quando utilizziamo un nome di parametro di tipo in una firma di funzione, dobbiamo
dichiarare il nome del parametro di tipo prima di usarlo. Per definire la funzione generica
`largest`, posizioniamo le dichiarazioni di nome di tipo all'interno delle parentesi angolate,
`<>`, tra il nome della funzione e l'elenco dei parametri, in questo modo:

```rust,ignore
fn largest<T>(list: &[T]) -> &T {
```

Leggiamo questa definizione come: la funzione `largest` è generica su un certo tipo
`T`. Questa funzione ha un parametro chiamato `list`, che è una slice di valori
di tipo `T`. La funzione `largest` restituirà un riferimento a un valore dello
stesso tipo `T`.

Il Listato 10-5 mostra la definizione combinata della funzione `largest` utilizzando il tipo di
dati generico nella sua firma. Il listato mostra anche come possiamo chiamare la funzione
con una slice sia di valori `i32` che `char`. Nota che questo codice non sarà
compilato ancora, ma lo sistemeremo più avanti in questo capitolo.

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-05/src/main.rs}}
```

<span class="caption">Listato 10-5: La funzione `largest` usando parametri di tipo
generici; questo non si compila ancora</span>

Se compilassimo questo codice in questo momento, otterremmo questo errore:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-05/output.txt}}
```

Il testo di aiuto menziona `std::cmp::PartialOrd`, che è un *trait*, e ne parleremo
nella prossima sezione. Per ora, sappiate che questo errore afferma che il Blocco di `largest` 
non funzionerà per tutti i tipi possibili che `T` potrebbe essere. Siccome vogliamo comparare i
valori di tipo `T` nel Blocco, possiamo usare solo tipi i cui valori possono essere ordinati.
Per abilitare i confronti, la libreria standard ha il Trait `std::cmp::PartialOrd` che 
puoi implementare sui tipi (vedi Appendice C per ulteriori informazioni su questo trait).
Seguendo il suggerimento del testo di aiuto, restriggiamo i tipi validi per `T` solo a 
quelli che implementano `PartialOrd` e questo esempio si compilerà, perché la libreria standard
implementa `PartialOrd` sia su `i32` che `char`.

### Nelle definizioni di Struct

Possiamo anche definire structs per utilizzare un parametro di tipo generico in uno o più
campi usando la sintassi `<>`. Il Listato 10-6 definisce una struct `Point<T>` per contenere
valori di coordinate `x` e `y` di qualsiasi tipo.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-06/src/main.rs}}
```

<span class="caption">Listato 10-6: Una struct `Point<T>` che contiene valori `x` e `y`
di tipo `T`</span>

La sintassi per usare i generici nelle definizioni di struct è simile a quella usata nelle
definizioni di funzione. Prima dichiariamo il nome del parametro di tipo all'interno
delle parentesi angolate subito dopo il nome della struct. Poi usiamo il tipo generico
nella definizione della struct dove altrimenti specificheremmo i tipi di dati concreti.

Nota che poiché abbiamo utilizzato solo un tipo generico per definire `Point<T>`, questa
definizione dice che la struct `Point<T>` è generica su un certo tipo `T`, e
i campi `x` e `y` sono *entrambi* dello stesso tipo, qualunque esso possa essere. Se
creiamo un'istanza di una struct `Point<T>` che ha valori di tipi diversi, come nel
Listato 10-7, il nostro codice non sarà compilato.

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-07/src/main.rs}}
```

<span class="caption">Listato 10-7: I campi `x` e `y` devono essere dello stesso
tipo perché entrambi hanno lo stesso tipo di dato generico `T`.</span>

In questo esempio, quando assegniamo il valore intero `5` a `x`, facciamo sapere
al compilatore che il tipo generico `T` sarà un intero per questa istanza di
`Point<T>`. Poi, quando specifichiamo `4.0` per `y`, che abbiamo definito come
avere lo stesso tipo di `x`, otterremo un errore di disallineamento dei tipi, come questo:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-07/output.txt}}
```

Per definire una struct `Point` dove `x` e `y` siano entrambi generici ma possano
avere tipi diversi, possiamo utilizzare più parametri di tipo generico. Per esempio, nel
Listato 10-8, cambiamo la definizione di `Point` per essere generico su tipi `T`
e `U` dove `x` è di tipo `T` e `y` è di tipo `U`.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-08/src/main.rs}}
```

<span class="caption">Listato 10-8: Una `Point<T, U>` generica su due tipi così
che `x` e `y` possano essere valori di tipi diversi</span>

Ora tutte le istanze di `Point` mostrate sono permesse! È possibile utilizzare quanti
più parametri di tipo generico in una definizione quanto si desidera, ma utilizzandone
più di pochi rende il codice difficile da leggere. Se si scopre di aver bisogno di molti tipi
generici nel proprio codice, potrebbe indicare che il codice necessita di essere ristrutturato in parti più
piccole.

### Nelle definizioni di Enum

Come abbiamo fatto con le structs, possiamo definire enums per contenere tipi di dati
generici nelle loro varianti. Diamo un'altra occhiata all'enum `Option<T>` che la libreria standard
fornisce, che abbiamo usato nel Capitolo 6:

```rust
enum Option<T> {
    Some(T),
    None,
}
```

Questa definizione dovrebbe ora avere più senso per te. Come puoi vedere, l'enum
`Option<T>` è generico sul tipo `T` e ha due varianti: `Some`, che
contiene un valore di tipo `T`, e una variante `None` che non contiene alcun valore.
Utilizzando l'enum `Option<T>`, possiamo esprimere il concetto astratto di un valore
opzionale, e poiché `Option<T>` è generico, possiamo utilizzare questa astrazione
indipendentemente dal tipo di valore opzionale.

Gli enums possono anche usare più tipi generici. La definizione dell'enum `Result`
che abbiamo utilizzato nel Capitolo 9 è un esempio:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

L'enum `Result` è generico su due tipi, `T` e `E`, e ha due varianti:
`Ok`, che contiene un valore di tipo `T`, e `Err`, che contiene un valore di tipo
`E`. Questa definizione rende comodo utilizzare l'enum `Result` ovunque
abbiamo un'operazione che potrebbe avere successo (restituire un valore di un certo tipo `T`) o fallire
(restituire un errore di un certo tipo `E`). Infatti, questo è ciò che abbiamo usato per aprire un
file nel Listato 9-3, dove `T` è stato riempito con il tipo `std::fs::File` quando
il file è stato aperto con successo e `E` è stato riempito con il tipo
`std::io::Error` quando ci sono stati problemi nell'aprire il file.

Quando si riconoscono situazioni nel proprio codice con più definizioni di struct o enum
che differiscono solo nei tipi dei valori che contengono, si può
evitare la duplicazione utilizzando i tipi generici invece.

### Nelle definizioni di Metodo

Possiamo implementare metodi su structs e enums (come abbiamo fatto nel Capitolo 5) e usare
tipi generici nelle loro definizioni anche. Il Listato 10-9 mostra la struct `Point<T>`
che abbiamo definito nel Listato 10-6 con un metodo denominato `x` implementato su di essa.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-09/src/main.rs}}
```

<span class="caption">Listato 10-9: Implementazione di un metodo denominato `x` sulla
struct `Point<T>` che restituirà un riferimento al campo `x` di tipo
`T`</span>

Qui, abbiamo definito un metodo chiamato `x` su `Point<T>` che restituisce un riferimento
ai dati nel campo `x`.

Nota che dobbiamo dichiarare `T` subito dopo `impl` così possiamo usare `T` per specificare
che stiamo implementando metodi sul tipo `Point<T>`. Dichiarando `T` come tipo generico dopo `impl`,
Rust può identificare che il tipo nelle parentesi angolari in `Point` è un tipo generico
piuttosto che un tipo concreto. Avremmo potuto scegliere un nome diverso per questo parametro
generico rispetto al parametro generico dichiarato nella definizione della struct, ma usare
lo stesso nome è convenzionale. I metodi scritti all'interno di un `impl` che dichiara il tipo
generico saranno definiti su qualsiasi istanza del tipo, a prescindere da quale tipo concreto
finisce per sostituire il tipo generico.

Possiamo anche specificare condizioni sui tipi generici quando definiamo i metodi
sul tipo. Ad esempio, potremmo implementare metodi solo sulle istanze di `Point<f32>`
piuttosto che sulle istanze di `Point<T>` con qualsiasi tipo generico. Nel Listato 10-10
utilizziamo il tipo concreto `f32`, il che significa che non dichiariamo alcun tipo dopo `impl`.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-10/src/main.rs:here}}
```

<span class="caption">Listato 10-10: Un blocco `impl` che si applica solo a una
struct con un particolare tipo concreto per il parametro di tipo generico `T`</span>

Questo codice significa che il tipo `Point<f32>` avrà un metodo `distance_from_origin`;
altre istanze di `Point<T>` dove `T` non è di tipo `f32` non avranno questo metodo
definito. Questo metodo misura quanto il nostro punto è distante dal punto alle coordinate
(0,0) e utilizza operazioni matematiche che sono disponibili solo per tipi a
virgola mobile.

I parametri di tipo generico in una definizione di struct non sono sempre gli stessi di
quelli che si usano nelle firme dei metodi della struct stessa. Il Listato 10-11 utilizza
i tipi generici `X1` e `Y1` per la struct `Point` e `X2` `Y2` per la firma del metodo
`mixup` per chiarire l'esempio. Il metodo crea una nuova istanza di `Point`
con il valore `x` dalla `self` `Point` (di tipo `X1`) e il valore `y`
dalla `Point` passata (di tipo `Y2`).

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-11/src/main.rs}}
```

<span class="caption">Listato 10-11: Un metodo che usa tipi generici diversi
dalla definizione della sua struct</span>

In `main`, abbiamo definito una `Point` che ha un `i32` per `x` (con valore `5`)
e un `f64` per `y` (con valore `10.4`). La variabile `p2` è una struct `Point`
che ha una slice di stringa per `x` (con valore `"Hello"`) e un `char` per `y`
(con valore `c`). Chiamando `mixup` su `p1` con l'argomento `p2` otteniamo `p3`,
che avrà un `i32` per `x` perché `x` proveniva da `p1`. La variabile `p3`
avrà un `char` per `y` perché `y` proveniva da `p2`. La chiamata al macro `println!`
stamperà `p3.x = 5, p3.y = c`.

Lo scopo di questo esempio è dimostrare una situazione in cui alcuni parametri generici
sono dichiarati con `impl` e alcuni sono dichiarati con la definizione del metodo. Qui, i
parametri generici `X1` e `Y1` sono dichiarati dopo `impl` perché vanno con la
definizione della struct. I parametri generici `X2` e `Y2` sono dichiarati dopo `fn mixup`
perché sono rilevanti solo per il metodo.

### Prestazioni del codice che usa i generici

Potresti chiederti se c'è un costo di runtime quando si utilizzano parametri di tipo generico. 
La buona notizia è che usare tipi generici non renderà il tuo programma
più lento di quanto sarebbe con tipi concreti.

Rust realizza questo eseguendo la monomorfizzazione del codice utilizzando
i generici in fase di compilazione. La *monomorfizzazione* è il processo di trasformazione 
del codice generico in codice specifico riempiendo i tipi concreti che vengono usati
quando compilato. In questo processo, il compilatore fa l'opposto dei passaggi che abbiamo usato
per creare la funzione generica nel Listato 10-5: il compilatore guarda tutti i
posti in cui il codice generico viene chiamato e genera codice per i tipi concreti
con cui viene chiamato il codice generico.

Vediamo come funziona questo utilizzando l'enum generico
`Option<T>` della libreria standard:

```rust
let integer = Some(5);
let float = Some(5.0);
```

Quando Rust compila questo codice, esegue la monomorfizzazione. Durante tale
processo, il compilatore legge i valori che sono stati utilizzati nelle istanze di `Option<T>`
e identifica due tipi di `Option<T>`: uno è `i32` e l'altro
è `f64`. In questo modo, espande la definizione generica di `Option<T>` in due
definizioni specializzate per `i32` e `f64`, sostituendo così la definizione generica
con quelle specifiche.

La versione monomorfizzata del codice appare simile al seguente (il
compilatore utilizza nomi diversi da quelli che stiamo utilizzando qui a titolo di illustrazione):

<span class="filename">Nome file: src/main.rs</span>

```rust
enum Option_i32 {
    Some(i32),
    None,
}

enum Option_f64 {
    Some(f64),
    None,
}

fn main() {
    let integer = Option_i32::Some(5);
    let float = Option_f64::Some(5.0);
}
```

L'`Option<T>` generico viene sostituito con le definizioni specifiche create dal
compilatore. Poiché Rust compila il codice generico in codice che specifica il
tipo in ogni istanza, non paghiamo alcun costo di runtime per l'uso dei generici.
Quando il codice viene eseguito, si comporta come se avessimo duplicato ogni definizione
a mano. Il processo di monomorfizzazione rende i generici in Rust estremamente efficienti
a runtime.
