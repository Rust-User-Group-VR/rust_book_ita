## Definire e istanziare le Structs

Le Structs sono simili alle tuple, discusse nella sezione [“Il tipo Tuple”][tuples]<!--
ignore -->, in quanto entrambe contengono valori correlati multipli. Come le
tuple, i pezzi di una struct possono essere di tipi diversi. A differenza delle tuple, in una struct
nominerai ciascun pezzo di dati in modo che sia chiaro cosa significano i valori. Aggiungere questi
nomi significa che le structs sono più flessibili delle tuple: non devi fare affidamento
sull'ordine dei dati per specificare o accedere ai valori di un'istanza.

Per definire una struct, inseriamo la parola chiave `struct` e nominiamo l'intera struct. Il
nome della struct dovrebbe descrivere l'importanza dei pezzi di dati raggruppati insieme. Poi, tra
parentesi graffe, definiamo i nomi e i tipi dei pezzi di dati, che chiamiamo *campi*. Ad esempio, il Listing 5-1 mostra una struct che memorizza informazioni su un account utente.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-01/src/main.rs:here}}
```

<span class="caption">Listing 5-1: Una definizione di struct `User`</span>

Per utilizzare una struct dopo averla definita, creiamo un' *istanza* di quella struct
specificando valori concreti per ciascun campo. Creiamo un'istanza indicando il nome della struct e poi aggiungiamo parentesi graffe contenenti coppie *chiave: valore*, dove le chiavi sono i nomi dei campi e i valori sono i
dati che vogliamo memorizzare in quei campi. Non dobbiamo specificare i campi nello stesso ordine in cui li abbiamo dichiarati nella struct. In altre parole, la definizione della struct è come un modello generale per il tipo, e le istanze riempiono quel modello con dati particolari per creare valori del tipo. Ad
esempio, possiamo dichiarare un particolare utente come mostrato nel Listing 5-2.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-02/src/main.rs:here}}
```

<span class="caption">Listing 5-2: Creare un'istanza della struct `User`</span>

Per ottenere un valore specifico da una struct, usiamo la notazione a punti. Ad esempio, per
accedere all'indirizzo email di questo utente, usiamo `user1.email`. Se l'istanza è
mutable, possiamo modificare un valore usando la notazione a punti e assegnando a un
campo particolare. Il Listing 5-3 mostra come modificare il valore nel campo `email`
di un'istanza `User` mutabile.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-03/src/main.rs:here}}
```

<span class="caption">Listing 5-3: Cambiare il valore nel campo `email` di un
istanza `User`</span>

Si noti che l'intera istanza deve essere mutable; Rust non ci permette di indicare
solo certi campi come mutable. Come per ogni espressione, possiamo costruire una nuova
istanza della struct come l'ultima espressione nel blocco della funzione per
restituire implicitamente quella nuova istanza.

Il Listing 5-4 mostra una funzione `build_user` che restituisce un'istanza `User` con
l'email e il nome utente forniti. Il campo `active` ottiene il valore di `true`, e
il `sign_in_count` ottiene un valore di `1`.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-04/src/main.rs:here}}
```

<span class="caption">Listing 5-4: Una funzione `build_user` che prende un'email
e un nome utente e restituisce un'istanza `User`</span>

Ha senso denominare i parametri della funzione con lo stesso nome dei campi della struct,
ma dover ripetere i nomi dei campi `email` e `username` e le
variabili è un po' tedioso. Se la struct avesse più campi, ripetere ciascun nome
sarebbe ancora più fastidioso. Fortunatamente, c'è una scorciatoia comoda!

<!-- Vecchio titolo. Non rimuovere o i link potrebbero rompersi. -->
<a id="using-the-field-init-shorthand-when-variables-and-fields-have-the-same-name"></a>

### Usare la Scorciatoia di Inizializzazione dei Campi

Poiché i nomi dei parametri e i nomi dei campi della struct sono esattamente gli stessi nel
Listing 5-4, possiamo usare la sintassi della *scorciatoia di inizializzazione dei campi* per riscrivere
`build_user` in modo che si comporti esattamente nello stesso modo ma senza la ripetizione di
`username` e `email`, come mostrato nel Listing 5-5.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-05/src/main.rs:here}}
```

<span class="caption">Listing 5-5: Una funzione `build_user` che usa la scorciatoia di inizializzazione
dei campi poiché i parametri `username` e `email` hanno lo stesso nome dei campi
della struct</span>

Qui, stiamo creando una nuova istanza della struct `User`, che ha un campo
denominato `email`. Vogliamo impostare il valore del campo `email` sul valore del
parametro `email` della funzione `build_user`. Poiché il campo `email` e
il parametro `email` hanno lo stesso nome, dobbiamo solo scrivere `email` anziché
`email: email`.

### Creare Istanza da Altre Istanze con la Sintassi di Aggiornamento delle Struct

Spesso è utile creare una nuova istanza di una struct che includa la maggior parte
dei valori da un'altra istanza, ma cambi alcuni. Puoi farlo usando
la *sintassi di aggiornamento della struct*.

Per prima cosa, nel Listing 5-6 mostriamo come creare una nuova istanza `User` in `user2`
regularmente, senza la sintassi di aggiornamento. Impostiamo un nuovo valore per `email` ma
utilizziamo gli stessi valori di `user1` che abbiamo creato nel Listing 5-2.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-06/src/main.rs:here}}
```

<span class="caption">Listing 5-6: Creare una nuova istanza `User` utilizzando tutti i valori meno uno
da `user1`</span>

Usando la sintassi di aggiornamento della struct, possiamo ottenere lo stesso effetto con meno codice, come
mostrato nel Listing 5-7. La sintassi `..` specifica che i campi rimanenti non
esplicitamente impostati dovrebbero avere lo stesso valore dei campi nell'istanza data.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-07/src/main.rs:here}}
```

<span class="caption">Listing 5-7: Usare la sintassi di aggiornamento delle struct per impostare un nuovo
valore `email` per un'istanza `User` ma usare il resto dei valori da
`user1`</span>

Il codice nel Listing 5-7 crea anche un'istanza in `user2` che ha un
valore diverso per `email` ma ha gli stessi valori per i campi `username`,
`active` e `sign_in_count` da `user1`. Il `..user1` deve venire per ultimo
per specificare che tutti i campi rimanenti devono ottenere i loro valori dai
campi corrispondenti in `user1`, ma possiamo scegliere di specificare i valori per
quanti campi vogliamo in qualsiasi ordine, indipendentemente dall'ordine dei campi nella
definizione della struct.

Si noti che la sintassi di aggiornamento delle struct utilizza `=` come un'assegnazione; questo è perché
permette di muovere i dati, proprio come abbiamo visto nella sezione [“Variabili e Dati che Interagiscono con il Move”][move]<!-- ignore -->. In questo esempio, non possiamo più usare
`user1` nella sua interezza dopo aver creato `user2` perché la `String` nel
campo `username` di `user1` è stata spostata in `user2`. Se avessimo dato a `user2` nuovi
valori `String` per entrambi `email` e `username`, e quindi usato solo i
valori `active` e `sign_in_count` da `user1`, allora `user1` sarebbe ancora
valido dopo aver creato `user2`. Sia `active` che `sign_in_count` sono tipi che
implementano il `Copy` trait, quindi il comportamento che abbiamo discusso nella sezione [“Dati Solo Stack: Copy”][copy]<!-- ignore --> si applicherebbe.

### Usare le Tuple Structs Senza Nomi di Campi per Creare Tipi Diversi

Rust supporta anche le structs che sembrano simili alle tuple, chiamate *tuple structs*.
Le Tuple structs hanno in più il significato fornito dal nome della struct ma non hanno
nomi associati ai loro campi; piuttosto, hanno solo i tipi dei campi. Le Tuple structs sono utili quando si vuole dare un nome all'intera tupla
e rendere la tupla un tipo diverso dalle altre tuple, e quando nominare ciascun
campo come in una struct regolare sarebbe ingombrante o ridondante.

Per definire una tuple struct, iniziare con la parola chiave `struct` e il nome della struct
seguiti dai tipi nella tupla. Ad esempio, qui definiamo e usiamo due
tuple structs chiamate `Color` e `Point`:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-01-tuple-structs/src/main.rs}}
```

Si noti che i valori `black` e `origin` sono di tipi diversi perché sono
istanze di tuple structs diverse. Ogni struct che definisci è il proprio tipo,
anche se i campi all'interno della struct possono avere gli stessi tipi. Ad
esempio, una funzione che accetta un parametro di tipo `Color` non può accettare
un `Point` come argomento, anche se entrambi i tipi sono costituiti da tre valori
`i32`. In caso contrario, le istanze delle tuple structs sono simili alle tuple in quanto puoi
destrutturarle nei loro singoli pezzi, e puoi usare un `.` seguito
dall'indice per accedere a un valore individuale.

### Structs Simili a Unit Senza Alcun Campo

Puoi anche definire structs che non hanno alcun campo! Queste si chiamano
*struct simili a unit* perché si comportano in modo simile a `()`, il tipo unit menzionato nella sezione [“Il tipo Tuple”][tuples]<!-- ignore -->. Le structs simili a unit possono essere utili quando hai bisogno di implementare un trait su qualche tipo ma non hai
alcun dato che vuoi memorizzare nel tipo stesso. Discuteremo i traits nel Capitolo 10. Ecco un esempio di dichiarazione e istanziazione di una struct unit chiamata `AlwaysEqual`:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-04-unit-like-structs/src/main.rs}}
```

Per definire `AlwaysEqual`, usiamo la parola chiave `struct`, il nome che vogliamo, e
poi un punto e virgola. Non c'è bisogno di parentesi graffe o parentesi! Poi possiamo ottenere un
istanza di `AlwaysEqual` nella variabile `subject` in modo simile: usando il
nome che abbiamo definito, senza alcuna parentesi graffa o parentesi. Immagina che più tardi
implementeremo un comportamento per questo tipo tale che ogni istanza di
`AlwaysEqual` sia sempre uguale a ogni istanza di qualsiasi altro tipo, forse
per avere un risultato noto a fini di test. Non avremmo bisogno di alcun dato per
implementare quel comportamento! Nel Capitolo 10 vedrai come definire i traits e
implementarli su qualsiasi tipo, incluse le structs simili a unit.

> ### Proprietà dei Dati della Struct
>
> Nella definizione della struct `User` nel Listing 5-1, abbiamo usato il tipo `String`
> posseduto piuttosto che il tipo `&str` string slice. Questa è una scelta deliberata
> perché vogliamo che ogni istanza di questa struct possieda tutti i propri dati e che
> quei dati siano validi per tutto il tempo in cui l'intera struct è valida.
>
> È anche possibile per le structs memorizzare riferimenti a dati posseduti da qualcos'altro, ma per farlo è necessario l'uso delle *lifetimes*, una caratteristica di Rust di cui parleremo nel Capitolo 10. Le Lifetimes assicurano che i dati riferiti da una struct
> siano validi per tutto il tempo in cui la struct è valida. Supponiamo che tu provi a memorizzare un riferimento
> in una struct senza specificare le lifetimes, come il seguente; questo non funzionerà:
>
> <span class="filename">Nome file: src/main.rs</span>
>
> <!-- CAN'T EXTRACT SEE https://github.com/rust-lang/mdBook/issues/1127 -->
>
> ```rust,ignore,does_not_compile
> struct User {
>     active: bool,
>     username: &str,
>     email: &str,
>     sign_in_count: u64,
> }
>
> fn main() {
>     let user1 = User {
>         active: true,
>         username: "someusername123",
>         email: "someone@example.com",
>         sign_in_count: 1,
>     };
> }
> ```
>
> Il compilatore si lamenterà che sono necessari dei specifiers di lifetime:
>
> ```console
> $ cargo run
>    Compiling structs v0.1.0 (file:///projects/structs)
> error[E0106]: missing lifetime specifier
>  --> src/main.rs:3:15
>   |
> 3 |     username: &str,
>   |               ^ expected named lifetime parameter
>   |
> help: consider introducing a named lifetime parameter
>   |
> 1 ~ struct User<'a> {
> 2 |     active: bool,
> 3 ~     username: &'a str,
>   |
>
> error[E0106]: missing lifetime specifier
>  --> src/main.rs:4:12
>   |
> 4 |     email: &str,
>   |            ^ expected named lifetime parameter
>   |
> help: consider introducing a named lifetime parameter
>   |
> 1 ~ struct User<'a> {
> 2 |     active: bool,
> 3 |     username: &str,
> 4 ~     email: &'a str,
>   |
>
> Per ulteriori informazioni su questo errore, prova `rustc --explain E0106`.
> error: impossibile compilare `structs` (bin "structs") a causa di 2 errori precedenti
> ```
>
> Nel Capitolo 10, discuteremo come risolvere questi errori in modo da poter memorizzare
> riferimenti in structs, ma per ora, correggeremo errori come questi utilizzando tipi posseduti
> come `String` anziché riferimenti come `&str`.

<!-- manual-regeneration
per l'errore sopra
dopo aver eseguito update-rustc.sh:
pbcopy < listings/ch05-using-structs-to-structure-related-data/no-listing-02-reference-in-struct/output.txt
incolla sopra
aggiungi `> ` prima di ogni riga -->

[tuples]: ch03-02-data-types.html#the-tuple-type
[move]: ch04-01-what-is-ownership.html#variables-and-data-interacting-with-move
[copy]: ch04-01-what-is-ownership.html#stack-only-data-copy
