## Memorizzazione di Testo Codificato UTF-8 con Stringhe

Abbiamo parlato di stringhe nel Capitolo 4, ma ora le analizzeremo più in profondità.
I nuovi Rustacean spesso si bloccano sulle stringhe per una combinazione di tre
motivi: la propensione di Rust a esporre possibili errori, le stringhe che sono una struttura dati più
complesso di quanto molti programmatori diano loro credito, e
UTF-8. Questi fattori si combinano in un modo che può sembrare difficile quando provenite
da altri linguaggi di programmazione.

Discutiamo le stringhe nel contesto delle collezioni perché le stringhe sono
implementate come una collezione di byte, più alcuni metodi per fornire utili
funzionalità quando quei byte sono interpretati come testo. In questa sezione, parleremo
delle operazioni su `String` che ogni tipo di collezione ha, come
creare, aggiornare, e leggere. Discuteremo anche i modi in cui `String`
è diversa dalle altre collezioni, ovvero come indicizzare in una `String` è
complicato dalle differenze tra come le persone e i computer interpretano
dati di tipo `String`.

### Cos'è una Stringa?

Prima di tutto definiremo cosa intendiamo con il termine *stringa*. Rust ha solo uno string
tipo nel linguaggio core, che è il slice di string `str` che di solito è visto
nella sua forma prestata `&str`. Nel Capitolo 4, abbiamo parlato di *slice di stringhe*,
che sono riferimenti ad alcuni dati di stringa codificati UTF-8 memorizzati altrove. Le stringhe
letterali, per esempio, sono memorizzate nel binario del programma e quindi sono
slice di stringhe.

Il tipo `String`, che è fornito dalla libreria standard di Rust piuttosto che
incluso nel linguaggio core, è un tipo di stringa codificato UTF-8, modificabile, proprietario e ingrandibile.
Quando i Rustacean si riferiscono a "stringhe" in Rust, potrebbero essere
riferimento a entrambi i tipi `String` o slice di stringhe `&str`, non solo uno
di quei tipi. Anche se questa sezione riguarda soprattutto `String`, entrambi i tipi sono
usati intensamente nella libreria standard di Rust, e sia `String` che le slice di stringhe
sono codificati in UTF-8.

### Creare una Nuova Stringa

Molte delle stesse operazioni disponibili con `Vec<T>` sono disponibili con `String`
pure, poiché `String` è effettivamente implementata come un involucro attorno a un vettore
di byte con alcune garanzie, restrizioni e capacità aggiuntive. Un esempio
di una funzione che funziona allo stesso modo con `Vec<T>` e `String` è la funzione `new`
per creare un'istanza, mostrata in Elencazione 8-11.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-11/src/main.rs:here}}
```

<span class="caption">Elencazione 8-11: Creazione di una nuova `String` vuota</span>

Questa riga crea una nuova stringa vuota chiamata `s`, nei cui possiamo quindi caricare i dati.
Spesso, avremo alcuni dati iniziali con cui vogliamo iniziare la stringa.
Per farlo, utilizziamo il metodo `to_string`, che è disponibile su qualsiasi tipo
che implementa il trait `Display`, come fanno le stringhe letterali. L'Elencazione 8-12 mostra
due esempi.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-12/src/main.rs:here}}
```

<span class="caption">Elencazione 8-12: Utilizzo del metodo `to_string` per creare un
`String` da una stringa letterale</span>

Questo codice crea una stringa contenente `initial contents`.

Possiamo anche usare la funzione `String::from` per creare una `String` da una stringa
letterale. Il codice nell'Elencazione 8-13 è equivalente al codice dall'Elencazione 8-12
che utilizza `to_string`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-13/src/main.rs:here}}
```

<span class="caption">Elencazione 8-13: Utilizzo della funzione `String::from` per creare
una `String` da una stringa letterale</span>

Poiché le stringhe sono utilizzate per così tante cose, possiamo usare molte diverse API generiche
per le stringhe, fornendoci molte opzioni. Alcuni di essi possono sembrare
ridondanti, ma tutti hanno il loro posto! In questo caso, `String::from` e
`to_string` fanno la stessa cosa, quindi la scelta dipende da stile e
leggibilità.

Ricorda che le stringhe sono codificate in UTF-8, quindi possiamo includere qualsiasi dato correttamente codificato
in esse, come mostrato nell'Elencazione 8-14.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-14/src/main.rs:here}}
```

<span class="caption">Elencazione 8-14: Memorizzazione di saluti in diverse lingue in
stringhe</span>

Tutte queste sono valide valori di `String`.

### Aggiornamento di una Stringa

Una `String` può crescere in dimensione e il suo contenuto può cambiare, proprio come il contenuto
di un `Vec<T>`, se vi si caricano più dati. Inoltre, puoi comodamente
utilizzare l'operatore `+` o la macro `format!` per concatenare i valori di `String`.

#### Aggiungere a una Stringa con `push_str` e `push`

Possiamo far crescere una `String` utilizzando il metodo `push_str` per aggiungere una slice di stringa,
come mostrato nell'Elencazione 8-15.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-15/src/main.rs:here}}
```

<span class="caption">Elencazione 8-15: Aggiunta di una slice di stringa a una `String`
utilizzando il metodo `push_str`</span>

Dopo queste due righe, `s` conterrà `foobar`. Il metodo `push_str` prende una
slice di stringa perché non vogliamo necessariamente prendere il proprietà del
parametro. Per esempio, nel codice nell'Elencazione 8-16, vogliamo essere in grado di usare
`s2` dopo aver aggiunto il suo contenuto a `s1`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-16/src/main.rs:here}}
```

<span class="caption">Elencazione 8-16: Utilizzazione di una slice di stringa dopo aver aggiunto il suo
contenuti a una `String`</span>

Se il metodo `push_str` prendesse proprietà di `s2`, non saremmo in grado di stampare
il suo valore all'ultima riga. Tuttavia, questo codice funziona come ci aspettiamo!

Il metodo `push` prende un singolo carattere come parametro e lo aggiunge al
`String`. L'Elencazione 8-17 aggiunge la lettera "l" a una `String` utilizzando il metodo `push`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-17/src/main.rs:here}}
```

<span class="caption">Elencazione 8-17: Aggiunta di un carattere a un valore `String`
utilizzando `push`</span>

Di conseguenza, `s` conterrà `lol`.

#### Concatenazione con l'Operatore `+` o la Macro `format!`

Spesso, vorrai combinare due stringhe esistenti. Un modo per farlo è usare
l'operatore `+`, come mostrato nell'Elencazione 8-18.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-18/src/main.rs:here}}
```

<span class="caption">Elencazione 8-18: Utilizzo dell'operatore `+` per combinare due
valori `String` in un nuovo valore `String`</span>

La stringa `s3` conterrà `Hello, world!`. Il motivo per cui `s1` non è più
valida dopo l'aggiunta, e il motivo per cui abbiamo usato un riferimento a `s2`, ha a che fare
con la firma del metodo che viene chiamato quando usiamo l'operatore `+`.
L'operatore `+` utilizza il metodo `add`, la cui firma sembra qualcosa di simile
a questa:

```rust,ignore
fn add(self, s: &str) -> String {
```

Nella libreria standard, vedrai `add` definito usando generici e tipi associati. Qui, abbiamo sostituito i tipi generici con tipi concreti, che è ciò che accade quando chiamiamo questo metodo con valori `String`. Discuteremo dei generici nel Capitolo 10.
Questa firma ci fornisce gli indizi di cui abbiamo bisogno per capire i punti delicati dell'operatore `+`.

Prima di tutto, `s2` ha un `&`, il che significa che stiamo aggiungendo un *riferimento* della seconda stringa alla prima stringa. Questo è dovuto al parametro `s` nella funzione `add`: possiamo solo aggiungere un `&str` a una `String`; non possiamo aggiungere due valori `String` insieme. Ma aspetta, il tipo di `&s2` è `&String`, non `&str`, come specificato nel secondo parametro di `add`. Allora perché il Listato 8-18 compila?

Il motivo per cui siamo in grado di usare `&s2` nella chiamata a `add` è che il compilatore può *coercere* l'argomento `&String` in un `&str`. Quando chiamiamo il metodo `add`, Rust usa una *coercizione deref*, che qui trasforma `&s2` in `&s2[..]`. Discuteremo della coercizione deref in modo più approfondito nel Capitolo 15. Poiché `add` non prende ownership del parametro `s`, `s2` rimarrà ancora una `String` valida dopo quest'operazione.

In secondo luogo, possiamo vedere dalla firma che `add` prende ownership di `self`, perché `self` non ha un `&`. Questo significa che `s1` nel Listato 8-18 sarà spostato nella chiamata `add` e non sarà più valido dopo di essa. Quindi, anche se `let s3 = s1 + &s2;` sembra che copierà entrambe le stringhe e ne creerà una nuova, questa istruzione prende effettivamente l'ownership di `s1`, appende una copia del contenuto di `s2`, e poi restituisce l'ownership del risultato. In altre parole, sembra che stia facendo un sacco di copie ma non lo è; l'implementazione è più efficiente della copia.

Se abbiamo bisogno di concatenare più stringhe, il comportamento dell'operatore `+` diventa sgradevole:

```rust
{{#rustdoc_include ../listings/ch08-common-collections/no-listing-01-concat-multiple-strings/src/main.rs:here}}
```

A questo punto, `s` sarà `tic-tac-toe`. Con tutti i caratteri `+` e `"`, è difficile capire cosa sta succedendo. Per combinazioni di stringhe più complesse, possiamo invece usare il macro `format!`:

```rust
{{#rustdoc_include ../listings/ch08-common-collections/no-listing-02-format/src/main.rs:here}}
```

Anche questo codice imposta `s` su `tic-tac-toe`. Il macro `format!` funziona come `println!`, ma invece di stampare l'output sullo schermo, restituisce una `String` con il contenuto. La versione del codice che usa `format!` è molto più facile da leggere, e il codice generato dal macro `format!` usa i riferimenti in modo che questa chiamata non prenda ownership di nessuno dei suoi parametri.

### Indicizzazione nelle stringhe

In molti altri linguaggi di programmazione, l'accesso ai singoli caratteri in una stringa facendo riferimento a loro tramite indice è un'operazione valida e comune. Tuttavia, se provi ad accedere alle parti di una `String` usando la sintassi di indicizzazione in Rust, otterrai un errore. Considera il codice non valido nel Listato 8-19.

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-19/src/main.rs:here}}
```

<span class="caption">Listato 8-19: Tentativo di usare la sintassi di indicizzazione con una
String</span>

Questo codice risulterà nell'errore seguente:

```console
{{#include ../listings/ch08-common-collections/listing-08-19/output.txt}}
```

L'errore e la nota raccontano la storia: le stringhe Rust non supportano l'indicizzazione. Ma perché no? Per rispondere a quella domanda, dobbiamo discutere di come Rust memorizza le stringhe in memoria.

#### Rappresentazione interna

Una `String` è un involucro su un `Vec<u8>`. Diamo un'occhiata ad alcune delle nostre stringhe correttamente codificate in UTF-8 dall'Esempio 8-14. Prima, questa:

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-14/src/main.rs:spanish}}
```

In questo caso, `len` sarà 4, il che significa che il vettore che memorizza la stringa "Hola" è lungo 4 byte. Ognuno di queste lettere richiede 1 byte quando viene codificato in UTF-8. La seguente linea, tuttavia, potrebbe sorprenderti. (Nota che questa stringa inizia con la lettera cirillica maiuscola Ze, non il numero 3.)

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-14/src/main.rs:russian}}
```

Se ti chiedessero quanto è lunga la stringa, potresti dire 12. In realtà, la risposta di Rust è 24: questo è il numero di byte che serve per codificare "Здравствуйте" in UTF-8, perché ogni valore scalare Unicode in quella stringa richiede 2 byte di storage. Pertanto, un indice nei byte della stringa non corrisponderà sempre a un valido valore scalare Unicode. Per dimostrarlo, considera questo codice Rust non valido:

```rust,ignore,does_not_compile
let hello = "Здравствуйте";
let answer = &hello[0];
```

Sai già che `answer` non sarà `З`, la prima lettera. Quando codificato in UTF-8, il primo byte di `З` è `208` e il secondo è `151`, quindi sembrerebbe che `answer` dovrebbe in effetti essere `208`, ma `208` non è un carattere valido da solo. Restituire `208` probabilmente non è quello che un utente vorrebbe se chiedesse la prima lettera di questa stringa; tuttavia, questi sono gli unici dati che Rust ha all'indice di byte 0. Gli utenti generalmente non vogliono che venga restituito il valore del byte, anche se la stringa contiene solo lettere latine: se `&"hello"[0]` fosse codice valido che restituisce il valore del byte, restituirebbe `104`, non `h`.

La risposta, quindi, è che per evitare di restituire un valore inaspettato e causare bug che potrebbero non essere scoperti immediatamente, Rust non compila questo codice per niente e previene incomprensioni all'inizio del processo di sviluppo.

#### Byte e valori scalari e cluster di grafemi! Oh mio!

Un altro punto sull'UTF-8 è che ci sono effettivamente tre modi rilevanti per guardare le stringhe dal punto di vista di Rust: come byte, valori scalari, e cluster di grafemi (la cosa più vicina a quello che chiameremmo *lettere*).

Se guardiamo la parola hindi "नमस्ते" scritta nel script Devanagari, viene memorizzata come un vettore di valori `u8` che sembra così:

```text
[224, 164, 168, 224, 164, 174, 224, 164, 184, 224, 165, 141, 224, 164, 164,
224, 165, 135]
```

Questi sono 18 byte ed è così che i computer memorizzano in ultima analisi questi dati. Se li guardiamo come valori scalari Unicode, che sono ciò che il tipo `char` di Rust è, quei byte sembrano così:

```text
['न', 'म', 'स', '्', 'त', 'े']
```

Ci sono sei valori `char` qui, ma il quarto e il sesto non sono lettere: sono diacritici che non hanno senso da soli. Infine, se li guardiamo come cluster di grafemi, otterremmo quello che una persona chiamerebbe le quattro lettere che compongono la parola Hindi:

```text
["न", "म", "स्", "ते"]
```

Rust fornisce diversi modi di interpretare i dati grezzi delle stringhe che i computer memorizzano in modo che ogni programma possa scegliere l'interpretazione di cui ha bisogno, indipendentemente dal linguaggio umano in cui sono i dati.

Un motivo finale per cui Rust non ci permette di indicizzare una `String` per ottenere un carattere è che le operazioni di indicizzazione dovrebbero sempre richiedere un tempo costante (O(1)). Ma non è possibile garantire tale performance con una `String`, perché Rust dovrebbe passare attraverso il contenuto dall'inizio all'indice per determinare quanti caratteri validi ci sono.

### Frammentare le Stringhe

L'indicizzazione in una stringa è spesso una cattiva idea perché non è chiaro quale dovrebbe essere il tipo di ritorno dell'operazione di indicizzazione della stringa: un valore byte, un carattere, un cluster di grafemi o una slice di stringa. Se hai davvero bisogno di usare gli indici per creare slice di stringa, quindi, Rust chiede di essere più specifici.

Piuttosto che indicizzare usando `[]` con un singolo numero, è possibile usare `[]` con un range per creare una slice di stringa contenente byte specifici:

```rust
let hello = "Здравствуйте";

let s = &hello[0..4];
```

Qui, `s` sarà un `&str` che contiene i primi 4 byte della stringa. Prima abbiamo menzionato che ciascuno di questi caratteri era di 2 byte, il che significa che `s` sarà `Зд`.

Se provassimo a tagliare solo una parte dei byte di un carattere con qualcosa come `&hello[0..1]`, Rust entrerebbe in panico a runtime allo stesso modo come se un indice non valido fosse accesso in un vettore:

```console
{{#include ../listings/ch08-common-collections/output-only-01-not-char-boundary/output.txt}}
```

Dovresti usare i range per creare slice di stringhe con cautela, perché fare ciò può far crashare il tuo programma.

### Metodi per Iterare Sulle Stringhe

Il modo migliore per operare su pezzi di stringhe è essere espliciti su se si desiderano caratteri o byte. Per i singoli valori scalari Unicode, usa il metodo `chars`. Chiamare `chars` su "Зд" separa e restituisce due valori di tipo `char`, e puoi iterare sul risultato per accedere a ciascun elemento:

```rust
for c in "Зд".chars() {
    println!("{c}");
}
```

Questo codice stamperà quanto segue:

```text
З
д
```

In alternativa, il metodo `bytes` restituisce ogni byte grezzo, che potrebbe essere appropriato per il tuo dominio:

```rust
for b in "Зд".bytes() {
    println!("{b}");
}
```

Questo codice stamperà i quattro byte che compongono questa stringa:

```text
208
151
208
180
```

Ma ricorda che i valori scalari Unicode validi possono essere composti da più di 1 byte.

Ottenere cluster di grafemi dalle stringhe come con lo script Devanagari è complesso, quindi questa funzionalità non è fornita dalla libreria standard. Le Crate sono disponibili su [crates.io](https://crates.io/)<!-- ignore --> se questa è la funzionalità di cui hai bisogno.

### Le Stringhe Non Sono Così Semplici

Per riassumere, le stringhe sono complicate. Linguaggi di programmazione diversi fanno scelte diverse su come presentare questa complessità al programmatore. Rust ha scelto di rendere il corretto trattamento dei dati `String` il comportamento predefinito per tutti i programmi Rust, il che significa che i programmatori devono pensare più in anticipo al trattamento dei dati UTF-8. Questo compromesso espone più della complessità delle stringhe rispetto a quanto è evidente in altri linguaggi di programmazione, ma ti impedisce di dover gestire errori che coinvolgono caratteri non ASCII più avanti nel tuo ciclo di vita dello sviluppo.

La buona notizia è che la libreria standard offre molte funzionalità basate sui tipi `String` e `&str` per gestire correttamente queste situazioni complesse. Assicurati di consultare la documentazione per metodi utili come `contains` per la ricerca in una stringa e `replace` per sostituire parti di una stringa con un'altra stringa.

Passiamo ora a qualcosa di un po' meno complesso: le hash map!

