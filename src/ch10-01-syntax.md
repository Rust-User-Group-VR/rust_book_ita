## Tipi di dati generici -

Utilizziamo i generici per creare definizioni per elementi come firme di funzioni o
structs, che possiamo quindi utilizzare con molti diversi tipi di dati concreti. Vediamo
prima come definire funzioni, strutture, enum e metodi utilizzando
generics. Poi discuteremo come i generici influenzano le prestazioni del codice.

### Nelle definizioni di funzione

Quando definiamo una funzione che utilizza generics, mettiamo i generici nel
firma della funzione dove di solito specifichiamo i tipi di dati dei
parametri e il valore di ritorno. Fare ciò rende il nostro codice più flessibile e fornisce
più funzionalità ai chiamanti della nostra funzione, evitando la duplicazione del codice.

Continuando con la nostra funzione `largest`, la Lista 10-4 mostra due funzioni che
trovano entrambe il valore più grande in una slice. Poi uniremo questi in un singolo
funzione che usa i generici.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-04/src/main.rs:here}}
```

<span class="caption">Lista 10-4: Due funzioni che differiscono solo nei loro
nomi e i tipi nelle loro firme</span>

La funzione `largest_i32` è quella che abbiamo estratto nella Lista 10-3 che trova
il più grande `i32` in una slice. La funzione `largest_char` trova il più grande
`char` in una slice. I corpi delle funzioni hanno lo stesso codice, quindi eliminiamo
la duplicazione introducendo un parametro di tipo generico in una singola funzione.

Per parametrizzare i tipi in una nuova funzione singola, dobbiamo dare un nome al tipo
parametro, proprio come facciamo per i parametri di valore di una funzione. Puoi utilizzare
qualsiasi identificatore come nome del parametro di tipo. Ma useremo `T` perché, per
convenzione, i nomi dei parametri di tipo in Rust sono brevi, spesso solo una lettera, e
La convenzione di denominazione dei tipi di Rust è UpperCamelCase. Breve per "tipo", `T` è il
scelta predefinita della maggior parte dei programmatori Rust.

Quando usiamo un parametro nel corpo della funzione, dobbiamo dichiarare il
nome del parametro nella firma in modo che il compilatore sappia cosa significa quel nome.
Allo stesso modo, quando usiamo un nome del parametro di tipo in una firma di funzione, noi
deve dichiarare il nome del parametro di tipo prima di usarlo. Per definire il generico
funzione `largest`, posizionare le dichiarazioni del nome del tipo tra le parentesi angolari, `<>`,
tra il nome della funzione e l'elenco dei parametri, così:

```rust,ignore
fn largest<T>(list: &[T]) -> &T {
```

Leggiamo questa definizione come: la funzione `largest` è generica su un certo tipo
`T`. Questa funzione ha un parametro chiamato `list`, che è una slice di valori
di tipo `T`. La funzione `largest` restituirà un riferimento a un valore del
stesso tipo `T`.

La Lista 10-5 mostra la combinazione di `largest` utilizzando il generico
tipo di dato nella sua firma. L'elenco mostra anche come possiamo chiamare la funzione
con una slice di valori `i32` o valori `char`. Nota che questo codice non lo farà
compilare ancora, ma lo correggeremo più avanti in questo capitolo.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-05/src/main.rs}}
```

<span class="caption">Lista 10-5: La funzione `largest` utilizza i parametri del tipo generico;
questo non compila ancora</span>

Se compiliamo questo codice ora, otterremo questo errore:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-05/output.txt}}
```

Il testo di aiuto menziona `std::cmp::PartialOrd`, che è un *trait*, e noi stiamo
per parlare dei trait nella prossima sezione. Per ora, sappi che questo errore
afferma che il corpo di `largest` non funzionerà per tutti i possibili tipi che `T`
potrebbe essere. Poiché vogliamo confrontare i valori di tipo `T` nel corpo, possiamo
usare solo tipi i cui valori possono essere ordinati. Per abilitare i confronti, la libreria standard
ha il trait `std::cmp::PartialOrd` che puoi implementare sui tipi
(vedi Appendice C per maggiori informazioni su questo trait). Seguendo il suggerimento del
testo di aiuto, limitiamo i tipi validi per `T` a solo quelli che implementano
`PartialOrd` e questo esempio compilerà, perché la libreria standard
implementa `PartialOrd` sia su `i32` che su `char`.

### Nelle definizioni di struct

Possiamo anche definire strutture per utilizzare un parametro di tipo generico in uno o più
campi utilizzando la sintassi `<>`. La Lista 10-6 definisce una struct `Point<T>` per contenere
valori delle coordinate `x` e `y` di qualsiasi tipo.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-06/src/main.rs}}
```

<span class="caption">Lista 10-6: Una struct `Point<T>` che contiene valori `x` e `y`
di tipo `T`</span>

La sintassi per utilizzare i generici nelle definizioni di strutture è simile a quella utilizzata in
definizioni di funzione. Prima, dichiariamo il nome del parametro di tipo tra parentesi angolari
subito dopo il nome della struct. Quindi usiamo il tipo generico
nella definizione della struct dove altrimenti specificheremmo tipi di dati concreti.

Da notare che poiché abbiamo utilizzato solo un tipo generico per definire `Point<T>`, questa
definizione dice che la struct `Point<T>` è generica su un certo tipo `T`, e
i campi `x` e `y` sono *entrambi* di quel stesso tipo, qualunque esso sia. Se
creiamo un'istanza di un `Point<T>` che ha valori di tipi diversi, come nella
Lista 10-7, il nostro codice non compilerà.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-07/src/main.rs}}
```

<span class="caption">Lista 10-7: I campi `x` e `y` devono essere dello stesso
tipo perché entrambi hanno lo stesso tipo di dato generico `T`.</span>

In questo esempio, quando assegniamo il valore intero 5 a `x`, facciamo sapere al compilatore
che il tipo generico `T` sarà un intero per questa istanza di
`Point<T>`. Quindi quando specificiamo 4.0 per `y`, che abbiamo definito per avere il
stesso tipo di `x`, otterremo un errore di incompatibilità di tipo così:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-07/output.txt}}
```

Per definire una struct `Point` dove `x` e `y` sono entrambi generici ma potrebbero avere
tipi diversi, possiamo utilizzare più parametri di tipo generico. Ad esempio, in
Lista 10-8, cambiamo la definizione di `Point` per essere generica su tipi `T`
e `U` dove `x` è di tipo `T` e `y` è di tipo `U`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-08/src/main.rs}}
```

<span class="caption">Lista 10-8: Una `Point<T, U>` generica su due tipi in modo tale
che `x` e `y` possano essere valori di tipi diversi</span>

Ora tutte le istanze di `Point` mostrate sono ammesse! Puoi usare quanti più tipi generici
parametri di tipo in una definizione come vuoi, ma usarne più di alcuni rende
difficile la lettura del tuo codice. Se scopri che hai bisogno di molti tipi generici in
il tuo codice, potrebbe indicare che il tuo codice ha bisogno di essere ristrutturato in pezzi più piccoli.

### Nelle definizioni Enum


Come abbiamo fatto con le strutture, possiamo definire enum per contenere tipi di dati generici nelle loro
varianti. Diamo un'occhiata all'enum `Option<T>` che la libreria standard
fornisce, che abbiamo usato nel Capitolo 6:

```rust
enum Option<T>{
    Some(T),
    None,
}
```

Questa definizione dovrebbe ora avere più senso per te. Come puoi vedere, l'enum
`Option<T>` è generica rispetto al tipo `T` ed ha due varianti: `Some`, che
contiene un valore di tipo `T`, e una variante `None` che non contiene alcun valore.
Usando l'enum `Option<T>`, possiamo esprimere il concetto astratto di un
valore opzionale, e dato che `Option<T>` è generico, possiamo usare questa astrazione 
indipendentemente dal tipo del valore opzionale. 

Gli enum possono utilizzare anche tipi generici multipli. La definizione dell'enum `Result`
che abbiamo usato nel Capitolo 9 è un esempio:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

L'enum `Result` è generico rispetto a due tipi, `T` e `E`, e ha due varianti:
`Ok`, che contiene un valore di tipo `T`, e `Err`, che contiene un valore di tipo
`E`. Questa definizione rende conveniente l'uso dell'enum `Result` dovunque abbiamo
un'operazione che potrebbe avere successo (restituire un valore di qualche tipo `T`) o fallire
(restituire un errore di qualche tipo `E`). Infatti, questo è quello che abbiamo usato per aprire un
file nell'Esempio 9-3, dove `T` è stato riempito con il tipo `std::fs::File` quando
il file è stato aperto con successo e `E` è stato riempito con il tipo
`std::io::Error` quando ci sono stati problemi nell'apertura del file. 

Quando riconosci situazioni nel tuo codice con diverse definizioni di strutture o enum
che differiscono solo nei tipi dei valori che contengono, puoi
evitare la duplicazione usando tipi generici.

### Nelle definizioni dei metodi

Possiamo implementare metodi su strutture ed enum (come abbiamo fatto nel Capitolo 5) e usare
tipi generici nelle loro definizioni, anche. L'Esempio 10-9 mostra la struttura `Point<T>`
che abbiamo definito nell'Esempio 10-6 con un metodo chiamato `x` implementatovi.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-09/src/main.rs}}
```

<span class="caption">Esempio 10-9: Implementazione di un metodo chiamato `x` sul
struttura `Point<T>` che restuirà un riferimento al campo `x` di tipo
`T`</span>

Qui, abbiamo definito un metodo chiamato `x` sul `Point<T>` che restituisce un riferimento
ai dati nel campo `x`.

Nota che dobbiamo dichiarare `T` subito dopo `impl` così possiamo usare `T` per specificare
che stiamo implementando i metodi sul tipo `Point<T>`. Dichiarando `T` come un
tipo generico dopo `impl`, Rust può identificare che il tipo tra parentesi angolari in `Point` è un tipo generico piuttosto che un tipo concreto. Avremmo potuto
scegliere un nome diverso per questo parametro generico rispetto al parametro
generico dichiarato nella definizione della struttura, ma usare lo stesso nome è
convenzionale. I metodi scritti all'interno di un `impl` che dichiara il tipo generico
saranno definiti su qualsiasi istanza del tipo, indipendentemente dal tipo concreto che
finisce per sostituire il tipo generico.

Possiamo anche specificare vincoli sui tipi generici quando definiamo metodi sul
tipo. Potremmo, ad esempio, implementare metodi solo su istanze di `Point<f32>`
piuttosto che su istanze di `Point<T>` con qualsiasi tipo generico. Nell'Esempio 10-10 usiamo il tipo concreto `f32`, il che significa che non dichiariamo nessun tipo dopo `impl`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-10/src/main.rs:here}}
```

<span class="caption">Esempio 10-10: Un blocco `impl` che si applica solo a una
struttura con un tipo concreto particolare per il parametro di tipo generico `T`</span>

Questo codice significa che il tipo `Point<f32>` avrà un metodo `distance_from_origin`;
altre istanze di `Point<T>` dove `T` non è di tipo `f32` non avranno
questo metodo definito. Il metodo misura quanto è lontano il nostro punto è dal
punto alle coordinate (0.0, 0.0) e usa operazioni matematiche che sono
disponibili solo per i tipi di floating point.

I parametri di tipo generico in una definizione di struttura non sono sempre gli stessi di quelli
che usi nelle firme dei metodi della stessa struttura. L'Esempio 10-11 usa i tipi generici
`X1` e `Y1` per la struttura `Point` e `X2` `Y2` per la firma del metodo
`mixup` per rendere l'esempio più chiaro. Il metodo crea una nuova istanza `Point`
con il valore `x` dal `Point` `self` (di tipo `X1`) e il valore `y` dal `Point` passato
(di tipo `Y2`).

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-11/src/main.rs}}
```

<span class="caption">Esempio 10-11: Un metodo che usa tipi generici diversi
dalla definizione della sua struttura</span>

In `main`, abbiamo definito un `Point` che ha un `i32` per `x` (con valore `5`)
e un `f64` per `y` (con valore `10.4`). La variabile `p2` è una struttura `Point`
che ha una slice di stringhe per `x` (con valore `"Hello"`) e un `char` per `y`
(con valore `c`). Chiamando `mixup` su `p1` con l'argomento `p2` otteniamo `p3`,
che avrà un `i32` per `x`, perché `x` proviene da `p1`. La variabile `p3`
avrà un `char` per `y`, perché `y` proviene da `p2`. La chiamata alla macro 
`println!` stamperà `p3.x = 5, p3.y = c`.

Lo scopo di questo esempio è dimostrare una situazione in cui alcuni parametri generici
sono dichiarati con `impl` e alcuni sono dichiarati con la definizione del metodo. Qui, i parametri generici `X1` e `Y1` sono dichiarati dopo `impl` perché vanno con la definizione della struttura. I parametri generici `X2` e `Y2` sono dichiarati dopo `fn mixup`, perché sono solo rilevanti per il metodo.

### Performance del codice utilizzando generici

Potresti chiederti se c'è un costo di esecuzione quando si usano parametri di tipo generico.
La buona notizia è che l'uso di tipi generici non renderà il tuo programma più lento rispetto a come sarebbe con tipi concreti.

Rust realizza questo eseguendo la monomorfizzazione del codice utilizzando 
i generici al momento della compilazione. La *monomorfizzazione* è il processo di trasformazione del
codice generico in codice specifico riempiendo i tipi concreti che vengono utilizzati quando
compilato. In questo processo, il compilatore fa l'opposto dei passaggi che abbiamo usato
per creare la funzione generica nell'Esempio 10-5: il compilatore osserva tutti i
posti in cui viene chiamato il codice generico e genera il codice per i tipi concreti
con i quali il codice generico viene chiamato.

Vediamo come funziona usando l'enum generico `Option<T>` della libreria standard:

```rust
let integer = Some(5);
let float = Some(5.0);
```
Quando Rust compila questo codice, esegue la monomorfizzazione. Durante quel
processo, il compilatore legge i valori che sono stati utilizzati nelle istanze `Option<T>`
e identifica due tipi di `Option<T>`: uno è `i32` e l'altro
è `f64`. Di conseguenza, espande la definizione generica di `Option<T>` in due
definizioni specializzate per `i32` e `f64`, sostituendo quindi la definizione generica
con quelle specifiche.

La versione monomorfizzata del codice assomiglia al seguente (il
compilatore utilizza nomi diversi da quelli che stiamo usando qui per illustrazione):

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

La generica `Option<T>` è sostituita con le definizioni specifiche create dal
compilatore. Poiché Rust compila il codice generico in codice che specifica il
tipo in ogni istanza, non paghiamo alcun costo di runtime per l'utilizzo di generics. Quando il codice
viene eseguito, si comporta come se avessimo duplicato ogni definizione a
mano. Il processo di monomorfizzazione rende i generics di Rust estremamente efficienti
a runtime.
