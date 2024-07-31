## Definizione e istanziazione di Struct

Le Struct sono simili ai tuple, discussi nella sezione [“Il Tipo Tuple”][tuples]<!--
ignore -->, in quanto entrambi contengono più valori correlati. Come nei tuple,
i componenti di una struct possono essere di tipi diversi. A differenza dei tuple,
in una struct si assegna un nome a ciascun elemento di dati, quindi è chiaro cosa
significano i valori. L'aggiunta di questi nomi rende le struct più flessibili dei 
tuple: non è necessario fare affidamento sull'ordine dei dati per specificare o 
accedere ai valori di un'istanza.

Per definire una struct, inseriamo la parola chiave `struct` e nominiamo l'intera 
struct. Il nome di una struct dovrebbe descrivere l'importanza dei dati che vengono 
raggruppati. Quindi, tra parentesi graffe, definiamo i nomi e i tipi dei dati, che 
chiamiamo *campi*. Ad esempio, Elenco 5-1 mostra una struct che memorizza informazioni 
su un account utente.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-01/src/main.rs:here}}
```

<span class="caption">Elenco 5-1: Una definizione di struct `User`</span>

Per utilizzare una struct dopo averla definita, creiamo un' *istanza* di quella struct
specificando valori concreti per ciascuno dei campi. Creiamo un'istanza dichiarando 
il nome della struct e poi aggiungendo parentesi graffe contenenti coppie *chiave: valore*,  
dove le chiavi sono i nomi dei campi e i valori sono i dati che vogliamo memorizzare in quei 
campi. Non è necessario specificare i campi nello stesso ordine in cui sono stati dichiarati 
nella struct. In altre parole, la definizione di struct è come un modello generale per il tipo, 
e le istanze compilano quel modello con dati particolari per creare valori del tipo. Ad esempio, 
possiamo dichiarare un utente specifico come mostrato nell'Elenco 5-2.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-02/src/main.rs:here}}
```

<span class="caption">Elenco 5-2: Creazione di un'istanza della struct `User`</span>

Per ottenere un valore specifico da una struct, utilizziamo la notazione a punti. Ad esempio, 
per accedere all'indirizzo email di questo utente, usiamo `user1.email`. Se l'istanza è mutable, 
possiamo cambiare un valore utilizzando la notazione a punti e assegnando a un campo particolare. 
L'Elenco 5-3 mostra come cambiare il valore nel campo `email` di un'istanza mutable di `User`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-03/src/main.rs:here}}
```

<span class="caption">Elenco 5-3: Modifica del valore nel campo `email` di un'istanza di `User`</span>

Nota che l'intera istanza deve essere mutable; Rust non permette di contrassegnare solo alcuni 
campi come mutable. Come con qualsiasi espressione, possiamo costruire una nuova istanza della 
struct come ultima espressione nel corpo della funzione per restituire implicitamente quella 
nuova istanza.

L'Elenco 5-4 mostra una funzione `build_user` che restituisce un'istanza `User` con l'email e 
il nome utente forniti. Il campo `active` ottiene il valore `true`, e il campo `sign_in_count` 
ottiene un valore di `1`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-04/src/main.rs:here}}
```

<span class="caption">Elenco 5-4: Una funzione `build_user` che prende un'email e un nome utente
e restituisce un'istanza di `User`</span>

Ha senso chiamare i parametri della funzione con lo stesso nome dei campi della struct, ma 
dover ripetere i nomi dei campi `email` e `username` e le variabili è un po' tedioso. Se 
la struct avesse più campi, ripetere ogni nome diventerebbe ancora più fastidioso. Per fortuna, 
esiste una scorciatoia comoda!

<!-- Vecchio titolo. Non rimuoverlo o i link potrebbero rompersi. -->
<a id="using-the-field-init-shorthand-when-variables-and-fields-have-the-same-name"></a>

### Utilizzo della scorciatoia per l'inizializzazione dei campi

Poiché i nomi dei parametri e i nomi dei campi della struct sono esattamente uguali in
l'Elenco 5-4, possiamo usare la sintassi *scorciatoia per l'inizializzazione dei campi* per
riscrivere `build_user` in modo che si comporti esattamente allo stesso modo ma senza la ripetizione
di `username` e `email`, come mostrato nell'Elenco 5-5.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-05/src/main.rs:here}}
```

<span class="caption">Elenco 5-5: Una funzione `build_user` che utilizza la scorciatoia
per l'inizializzazione dei campi perché i parametri `username` e `email`
hanno lo stesso nome dei campi della struct</span>

Qui, stiamo creando una nuova istanza della struct `User`, che ha un campo denominato `email`.
Vogliamo impostare il valore del campo `email` al valore del parametro `email` della funzione
`build_user`. Poiché il campo `email` e il parametro `email` hanno lo stesso nome, dobbiamo
scrivere solo `email` invece di `email: email`.

### Creazione di istanze da altre istanze con la sintassi di aggiornamento delle struct

È spesso utile creare una nuova istanza di una struct che include la maggior parte dei valori
da un'altra istanza, ma ne cambia alcuni. È possibile farlo utilizzando la *sintassi di aggiornamento
delle struct*.

Per prima cosa, nell'Elenco 5-6 mostriamo come creare una nuova istanza `User` in `user2`
regolarmente, senza la sintassi di aggiornamento. Impostiamo un nuovo valore per `email` ma
usiamo gli stessi valori di `user1` che abbiamo creato nell'Elenco 5-2.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-06/src/main.rs:here}}
```

<span class="caption">Elenco 5-6: Creazione di una nuova istanza `User` utilizzando tutti i valori
tranne uno da `user1`</span>

Utilizzando la sintassi di aggiornamento delle struct, possiamo ottenere lo stesso effetto con
meno codice, come mostrato nell'Elenco 5-7. La sintassi `..` specifica che i campi rimanenti
non impostati esplicitamente devono avere lo stesso valore dei campi nell'istanza data.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-07/src/main.rs:here}}
```

<span class="caption">Elenco 5-7: Utilizzo della sintassi di aggiornamento delle struct per impostare un nuovo
valore `email` per un'istanza `User` ma per utilizzare il resto dei valori da `user1`</span>

Il codice nell'Elenco 5-7 crea anche un'istanza in `user2` che ha un valore diverso per `email`
ma ha gli stessi valori per i campi `username`, `active` e `sign_in_count` da `user1`. Il `..user1`
deve venire per ultimo per specificare che i campi rimanenti dovrebbero ottenere i loro valori dai
campi corrispondenti in `user1`, ma possiamo scegliere di specificare valori per quanti campi
vogliamo in qualsiasi ordine, indipendentemente dall'ordine dei campi nella definizione della struct.

Nota che la sintassi di aggiornamento delle struct utilizza `=` come un'assegnazione; questo 
perché sposta i dati, proprio come abbiamo visto nella sezione [“Variabili e Dati che Interagiscono
con il Movimento”][move]<!-- ignore -->. In questo esempio, non possiamo più utilizzare `user1` come
un tutto dopo aver creato `user2` perché il `String` nel campo `username` di `user1` è stato 
spostato in `user2`. Se avessimo dato a `user2` nuovi valori `String` sia per `email` che per 
`username`, e quindi avessimo utilizzato solo i valori `active` e `sign_in_count` da `user1`, 
allora `user1` sarebbe ancora valido dopo aver creato `user2`. Sia `active` che `sign_in_count`
sono tipi che implementano il trait `Copy`, quindi il comportamento discusso nella sezione 
[“Dati Solo nel Pila: Copy”][copy]<!-- ignore --> si applicherebbe.

### Utilizzo di Struct a Tupla senza Campi Nominati per Creare Tipi Diversi

Rust supporta anche struct che sembrano simili ai tuple, chiamati *struct a tupla*.
Le struct a tupla hanno il significato aggiunto fornito dal nome della struct ma non hanno
nomi associati ai loro campi; piuttosto, hanno solo i tipi dei campi. Le struct a tupla
sono utili quando si desidera dare all'intero tuple un nome e rendere il tuple un tipo diverso
rispetto ad altri tuple, e quando assegnare un nome a ciascun campo come in una struct regolare
sarebbe verboso o ridondante.

Per definire una struct a tupla, inizia con la parola chiave `struct` e il nome della struct
seguiti dai tipi nel tuple. Ad esempio, qui definiamo e utilizziamo due struct a tupla chiamate
`Color` e `Point`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-01-tuple-structs/src/main.rs}}
```

Nota che i valori `black` e `origin` sono tipi diversi perché sono istanze di struct a tupla
diverse. Ogni struct che definisci è il proprio tipo, anche se i campi all'interno della struct
potrebbero avere gli stessi tipi. Ad esempio, una funzione che prende un parametro di tipo `Color`
non può prendere un `Point` come argomento, anche se entrambi i tipi sono costituiti da tre valori `i32`.
Altrimenti, le istanze di struct a tupla sono simili ai tuple in quanto è possibile destrutturarle
nei loro singoli componenti, e si può utilizzare un `.` seguito dall'indice per accedere a un valore
individuale.

### Struct a Unità senza Campi

È possibile definire struct che non hanno campi! Questi sono chiamati *struct a unità* perché si
comportano in modo simile a `()`, il tipo unità che abbiamo menzionato nella sezione
[“Il Tipo Tuple”][tuples]<!-- ignore -->. Le struct a unità possono essere utili quando è necessario 
implementare un trait su qualche tipo ma non si hanno dati che si desidera memorizzare nel tipo stesso.
Discuteremo dei trait nel Capitolo 10. Ecco un esempio di dichiarazione e istanziazione di una struct
a unità chiamata `AlwaysEqual`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-04-unit-like-structs/src/main.rs}}
```

Per definire `AlwaysEqual`, utilizziamo la parola chiave `struct`, il nome che desideriamo,
e poi un punto e virgola. Nessun bisogno di parentesi graffe o parentesi! Poi possiamo ottenere
un'istanza di `AlwaysEqual` nella variabile `subject` in un modo simile: utilizzando il nome
che abbiamo definito, senza alcuna parentesi graffe o parentesi. Immagina che più tardi implementeremo
un comportamento per questo tipo tale che ogni istanza di `AlwaysEqual` sia sempre uguale a ogni
istanza di qualsiasi altro tipo, magari per avere un risultato noto per scopi di test. Non avremmo 
bisogno di alcun dato per implementare quel comportamento! Vedrai nel Capitolo 10 come definire trait
e implementarli su qualsiasi tipo, incluse le struct a unità.

> ### Proprietà dei Dati nelle Struct
>
> Nella definizione di `User` nell'Elenco 5-1, abbiamo usato il tipo `String` di proprietà
> piuttosto che il tipo di slice di stringa `&str`. Questa è una scelta deliberata perché
> vogliamo che ciascuna istanza di questa struct sia proprietaria di tutti i suoi dati e che
> quei dati siano validi per tutto il tempo in cui la struct è valida.
>
> È anche possibile che le struct memorizzino riferimenti a dati posseduti da qualcos'altro,
> ma per farlo è necessario utilizzare le *lifetime*, una funzione di Rust che discuteremo
> nel Capitolo 10. Le lifetime assicurano che i dati riferiti da una struct siano validi per
> tutto il tempo in cui la struct è valida. Supponiamo che tu provi a memorizzare un riferimento
> in una struct senza specificare le lifetime, come segue; questo non funzionerà:
>
> <span class="filename">Nome del file: src/main.rs</span>
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
> Il compilatore si lamenterà perché ha bisogno di specificatori di lifetime:
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
> For more information about this error, try `rustc --explain E0106`.
> error: could not compile `structs` (bin "structs") due to 2 previous errors
> ```
>
> Nel Capitolo 10, discuteremo come risolvere questi errori in modo che tu possa memorizzare
> riferimenti nelle struct, ma per ora, risolveremo errori come questi usando tipi di proprietà
> come `String` invece di riferimenti come `&str`.

<!-- 
rigenerazione manuale
per l'errore sopra
dopo aver eseguito update-rustc.sh:
pbcopy < listings/ch05-using-structs-to-structure-related-data/no-listing-02-reference-in-struct/output.txt
copia incolla sopra
aggiungi `> ` prima di ogni linea 
-->

[tuples]: ch03-02-data-types.html#the-tuple-type
[move]: ch04-01-what-is-ownership.html#variables-and-data-interacting-with-move
[copy]: ch04-01-what-is-ownership.html#stack-only-data-copy
