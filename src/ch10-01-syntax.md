## Tipi di Dati Generici

Usiamo i generics per creare definizioni per elementi come firme di funzioni o
structs, che possiamo poi utilizzare con molti tipi di dati concreti diversi. Vediamo
prima come definire funzioni, structs, enums e metodi usando i generics. Poi discuteremo come i generics influenzano le prestazioni del codice.

### Nelle Definizioni di Funzioni

Quando definiamo una funzione che utilizza i generics, posizioniamo i generics nella
firma della funzione dove di solito specificheremmo i tipi di dati dei
parametri e il valore di ritorno. Così facendo, rendiamo il nostro codice più flessibile e forniamo
più funzionalità ai chiamanti della nostra funzione evitando la duplicazione del codice.

Continuando con la nostra funzione `largest`, il Listing 10-4 mostra due funzioni che
trovano entrambe il valore più grande in una slice. Poi le combineremo in un'unica
funzione che utilizza i generics.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-04/src/main.rs:here}}
```

<span class="caption">Listing 10-4: Due funzioni che differiscono solo nei loro
nomi e nei tipi nelle loro firme</span>

La funzione `largest_i32` è quella estratta nel Listing 10-3 che trova
il più grande `i32` in una slice. La funzione `largest_char` trova il più grande
`char` in una slice. I corpi delle funzioni hanno lo stesso codice, quindi eliminiamo
la duplicazione introducendo un parametro di tipo generico in un'unica funzione.

Per parametrizzare i tipi in una nuova funzione singola, dobbiamo nominare il parametro di tipo,
proprio come facciamo per i parametri di valore di una funzione. Puoi usare
qualsiasi identificatore come nome del parametro di tipo. Ma useremo `T` perché, per
convenzione, i nomi dei parametri di tipo in Rust sono brevi, spesso solo una lettera, e
la convenzione di denominazione dei tipi in Rust è UpperCamelCase. Breve per *tipo*, `T` è la
scelta predefinita della maggior parte dei programmatori Rust.

Quando usiamo un parametro nel corpo della funzione, dobbiamo dichiarare il
nome del parametro nella firma affinché il compilatore sappia cosa significa quel nome.
Allo stesso modo, quando usiamo un nome di parametro di tipo in una firma di funzione, dobbiamo dichiarare il nome del parametro di tipo prima di usarlo. Per definire la funzione generica
`largest`, posizioniamo le dichiarazioni del nome del tipo tra parentesi angolari,
`<>`, tra il nome della funzione e l'elenco dei parametri, così:

```rust,ignore
fn largest<T>(list: &[T]) -> &T {
```

Leggiamo questa definizione come: la funzione `largest` è generica su un tipo
`T`. Questa funzione ha un parametro chiamato `list`, che è una slice di valori
di tipo `T`. La funzione `largest` restituirà un riferimento a un valore dello
stesso tipo `T`.

Il Listing 10-5 mostra la definizione combinata della funzione `largest` utilizzando il tipo generico nella sua firma. Il listing mostra anche come possiamo chiamare la funzione con una slice di valori `i32` o `char`. Nota che questo codice non si compilerà ancora, ma lo correggeremo più tardi in questo capitolo.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-05/src/main.rs}}
```

<span class="caption">Listing 10-5: La funzione `largest` utilizza parametri di tipo
generici; questo non si compila ancora</span>

Se compiliamo questo codice ora, otterremo questo errore:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-05/output.txt}}
```

Il testo di aiuto menziona `std::cmp::PartialOrd`, che è un *trait*, e parleremo
dei traits nella prossima sezione. Per ora, sappi che questo errore
indica che il corpo di `largest` non funzionerà per tutti i possibili tipi che `T`
potrebbe essere. Poiché vogliamo confrontare valori di tipo `T` nel corpo, possiamo
usare solo tipi i cui valori possono essere ordinati. Per abilitare i confronti, la libreria standard ha il trait `std::cmp::PartialOrd` che puoi implementare sui tipi
(vedi l'Appendice C per ulteriori informazioni su questo trait). Seguendo il suggerimento del testo di aiuto, restringiamo i tipi validi per `T` a solo quelli che implementano `PartialOrd` e questo esempio si compila, perché la libreria standard
implementa `PartialOrd` sia su `i32` che su `char`.

### Nelle Definizioni di Struct

Possiamo anche definire struct per utilizzare un parametro di tipo generico in uno o più
campi usando la sintassi `<>`. Il Listing 10-6 definisce una struct `Point<T>` per contenere
valori di coordinate `x` e `y` di qualsiasi tipo.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-06/src/main.rs}}
```

<span class="caption">Listing 10-6: Una struct `Point<T>` che contiene valori `x` e `y`
di tipo `T`</span>

La sintassi per usare i generics nelle definizioni di struct è simile a quella utilizzata nelle
definizioni di funzioni. Prima dichiariamo il nome del parametro di tipo dentro
parentesi angolari subito dopo il nome della struct. Poi usiamo il tipo
generico nella definizione della struct dove altrimenti specificheremmo tipi di dati concreti.

Nota che poiché abbiamo utilizzato un solo tipo generico per definire `Point<T>`, questa
definizione dice che la struct `Point<T>` è generica su un tipo `T`, e
i campi `x` e `y` sono *entrambi* di quel tipo, qualunque esso sia. Se
creiamo un'istanza di un `Point<T>` che ha valori di tipi diversi, come nel
Listing 10-7, il nostro codice non si compilerà.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-07/src/main.rs}}
```

<span class="caption">Listing 10-7: I campi `x` e `y` devono essere dello stesso
tipo poiché entrambi hanno lo stesso tipo di dato generico `T`.</span>

In questo esempio, quando assegniamo il valore intero `5` a `x`, facciamo sapere al
compilatore che il tipo generico `T` sarà un intero per questa istanza di
`Point<T>`. Poi, quando specifichiamo `4.0` per `y`, che abbiamo definito per avere lo
stesso tipo di `x`, otterremo un errore di corrispondenza di tipo come questo:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-07/output.txt}}
```

Per definire una struct `Point` dove `x` e `y` sono entrambi generici ma potrebbero avere tipi diversi, possiamo usare più parametri di tipo generici. Per esempio, nel
Listing 10-8, cambiamo la definizione di `Point` per essere generica sui tipi `T`
e `U` dove `x` è di tipo `T` e `y` è di tipo `U`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-08/src/main.rs}}
```

<span class="caption">Listing 10-8: Una `Point<T, U>` generica su due tipi in modo che
`x` e `y` possano essere valori di tipi diversi</span>

Ora tutte le istanze di `Point` mostrate sono permesse! Puoi usare quanti parametri
di tipo generici vuoi in una definizione, ma usarne più di pochi rende
difficile leggere il codice. Se scopri di aver bisogno di molti tipi generici
nel tuo codice, potrebbe indicare che il tuo codice ha bisogno
di essere ristrutturato in pezzi più piccoli.

### Nelle Definizioni di Enum

Come abbiamo fatto con le structs, possiamo definire enums per contenere tipi di dati generici nelle loro varianti. Diamo un'altra occhiata alla enum `Option<T>` che la libreria standard fornisce, che abbiamo utilizzato nel Capitolo 6:

```rust
enum Option<T> {
    Some(T),
    None,
}
```

Questa definizione dovrebbe ora avere più senso per te. Come puoi vedere, l'enum
`Option<T>` è generica sul tipo `T` e ha due varianti: `Some`, che
contiene un valore di tipo `T`, e una variante `None` che non contiene alcun valore.
Usando l'enum `Option<T>`, possiamo esprimere il concetto astratto di un
valore opzionale, e poiché `Option<T>` è generica, possiamo usare questa astrazione
indipendentemente dal tipo del valore opzionale.

Gli enums possono anche usare più tipi generici. La definizione dell'enum `Result`
che abbiamo utilizzato nel Capitolo 9 ne è un esempio:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

L'enum `Result` è generica su due tipi, `T` ed `E`, e ha due varianti:
`Ok`, che contiene un valore di tipo `T`, e `Err`, che contiene un valore di tipo
`E`. Questa definizione rende conveniente usare l'enum `Result` ovunque abbiamo
un'operazione che potrebbe avere successo (restituire un valore di qualche tipo `T`) o fallire
(restituire un errore di qualche tipo `E`). In effetti, questo è ciò che abbiamo usato per aprire un 
file nel Listing 9-3, dove `T` è stato riempito con il tipo `std::fs::File` quando il file è stato aperto con successo e `E` è stato riempito con il tipo
`std::io::Error` quando ci sono stati problemi nell'aprire il file.

Quando riconosci situazioni nel tuo codice con più definizioni di struct o enum 
che differiscono solo nei tipi dei valori che contengono, puoi
evitare duplicazioni usando i tipi generici.

### Nelle Definizioni di Metodi

Possiamo implementare metodi su structs e enums (come abbiamo fatto nel Capitolo 5) e usare
tipi generici anche nelle loro definizioni. Il Listing 10-9 mostra la struct `Point<T>`
che abbiamo definito nel Listing 10-6 con un metodo chiamato `x` implementato su di essa.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-09/src/main.rs}}
```

<span class="caption">Listing 10-9: Implementazione di un metodo chiamato `x` sulla
struct `Point<T>` che restituirà un riferimento al campo `x` di tipo
`T`</span>

Qui, abbiamo definito un metodo chiamato `x` su `Point<T>` che restituisce un riferimento
al dato nel campo `x`.

Nota che dobbiamo dichiarare `T` subito dopo `impl` affinché possiamo usare `T` per specificare
che stiamo implementando metodi sul tipo `Point<T>`. Dichiarando `T` come tipo generico dopo `impl`, Rust può identificare che il tipo nelle parentesi
angolari in `Point` è un tipo generico anziché un tipo concreto. Avremmo
potuto scegliere un nome diverso per questo parametro generico rispetto a quello dichiarato nella definizione della struct, ma usare lo stesso nome è convenzionale. I metodi scritti dentro un `impl` che dichiara il tipo generico saranno definiti su qualsiasi istanza del tipo, qualunque tipo concreto finisca per sostituire il tipo generico.

Possiamo anche specificare vincoli sui tipi generici quando definiamo metodi sul
tipo. Potremmo, per esempio, implementare metodi solo su istanze di `Point<f32>`
anziché su istanze di `Point<T>` con qualsiasi tipo generico. Nel Listing 10-10 usiamo 
il tipo concreto `f32`, il che significa che non dichiariamo alcun tipo dopo `impl`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-10/src/main.rs:here}}
```

<span class="caption">Listing 10-10: Un blocco `impl` che si applica solo a una
struct con un tipo concreto particolare per il parametro di tipo generico `T`</span>

Questo codice significa che il tipo `Point<f32>` avrà un metodo `distance_from_origin`;
altre istanze di `Point<T>` dove `T` non è di tipo `f32` non avranno questo metodo
definito. Il metodo misura quanto lontano è il nostro punto dal
punto alle coordinate (0.0, 0.0) e utilizza operazioni matematiche che sono
disponibili solo per i tipi a virgola mobile.

I parametri di tipo generico in una definizione di struct non sono sempre gli stessi di quelli che usi nelle firme dei metodi di quella stessa struct. Il Listing 10-11 usa i tipi generici `X1` e `Y1` per la struct `Point` e `X2` e `Y2` per la firma del metodo `mixup` per rendere l'esempio più chiaro. Il metodo crea una nuova istanza di `Point`
con il valore `x` dalla `self` `Point` (di tipo `X1`) e il valore `y` dalla `Point` passata
(in di tipo `Y2`).

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-11/src/main.rs}}
```

<span class="caption">Listing 10-11: Un metodo che utilizza tipi generici diversi
da quelli della definizione della sua struct</span>

In `main`, abbiamo definito un `Point` che ha un `i32` per `x` (con valore `5`)
e un `f64` per `y` (con valore `10.4`). La variabile `p2` è una struct `Point`
che ha una stringa slice per `x` (con valore `"Hello"`) e un `char` per `y` (con valore `c`). Chiamare `mixup` su `p1` con l'argomento `p2` ci dà `p3`,
che avrà un `i32` per `x` perché `x` deriva da `p1`. La variabile `p3`
avrà un `char` per `y` perché `y` deriva da `p2`. La chiamata alla macro `println!` stamperà `p3.x = 5, p3.y = c`.

Lo scopo di questo esempio è dimostrare una situazione in cui alcuni
parametri generici sono dichiarati con `impl` e alcuni sono dichiarati con la definizione del metodo. Qui, i parametri generici `X1` e `Y1` sono dichiarati dopo `impl`
perché vanno con la definizione della struct. I parametri generici `X2`
e `Y2` sono dichiarati dopo `fn mixup` perché sono rilevanti solo per il
metodo.

### Prestazioni del Codice che Usa i Generics

Potresti chiederti se c'è un costo in tempo di esecuzione quando si utilizzano i parametri di tipo generici. La buona notizia è che usare tipi generici non renderà il tuo programma
più lento di quanto sarebbe con tipi concreti.

Rust realizza questo eseguendo la monomorfizzazione del codice che utilizza
generics al tempo di compilazione. *Monomorfizzazione* è il processo di trasformazione del codice generico in codice specifico riempiendo i tipi concreti che vengono utilizzati durante la compilazione. In questo processo, il compilatore esegue il contrario dei passaggi utilizzati per creare la funzione generica nel Listing 10-5: il compilatore analizza tutti i luoghi dove il codice generico viene chiamato e genera codice per i tipi concreti con cui il codice generico viene chiamato.

Vediamo come funziona utilizzando l'enum generico `Option<T>` della
libreria standard:

```rust
let integer = Some(5);
let float = Some(5.0);
```

Quando Rust compila questo codice, esegue la monomorfizzazione. Durante quel
processo, il compilatore legge i valori che sono stati utilizzati nelle istanze di `Option<T>`
e identifica due tipi di `Option<T>`: uno è `i32` e l'altro
è `f64`. Così, espande la definizione generica di `Option<T>` in due
definizioni specializzate per `i32` e `f64`, sostituendo così la definizione
generica con quelle specifiche.

La versione monomorfizzata del codice sembra simile a quanto segue (il
compilatore usa nomi diversi da quelli che stiamo usando qui per illustrazione):

<span class="filename">Nome del file: src/main.rs</span>

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

La `Option<T>` generica viene sostituita con le definizioni specifiche create
dal compilatore. Poiché Rust compila il codice generico in codice che specifica il
tipo in ciascuna istanza, non paghiamo alcun costo in tempo di esecuzione per
usare i generics. Quando il codice viene eseguito, funziona proprio come farebbe
se avessimo duplicato ciascuna definizione a mano. Il processo di monomorfizzazione
rende i generics di Rust estremamente efficienti in fase di esecuzione.
