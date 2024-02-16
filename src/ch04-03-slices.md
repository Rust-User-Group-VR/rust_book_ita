## Il tipo Slice

*Le Slice (fette)* ti permettono di fare riferimento a una sequenza contigua di elementi in una collezione, piuttosto che all'intera collezione. Una slice è un tipo di riferimento, quindi non ha ownership.

Ecco un piccolo problema di programmazione: scrivi una funzione che prende una stringa di parole separate da spazi e restituisce la prima parola che trova in quella stringa. Se la funzione non trova uno spazio nella stringa, l'intera stringa deve essere una parola, quindi dovrebbe essere restituita l'intera stringa.

Lavoriamo su come scriveremmo la firma di questa funzione senza usare le slice, per capire il problema che le slice risolveranno:

```rust,ignore
fn first_word(s: &String) -> ?
```

La funzione `first_word` ha un `&String` come parametro. Non vogliamo l'ownership, quindi va bene. Ma cosa dovremmo restituire? Non abbiamo davvero un modo per parlare di *parte* di una stringa. Tuttavia, potremmo restituire l'indice della fine della parola, indicata da uno spazio. Proviamo a farlo, come mostrato nella Lista 4-7.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:here}}
```

<span class="caption">Lista 4-7: La funzione `first_word` che restituisce un
valore dell'indice dei byte nel parametro `String`</span>

Poiché dobbiamo passare attraverso l'elemento `String` per controllare se un valore è uno spazio, convertiremo la nostra `String` in un array di byte utilizzando il metodo `as_bytes`.

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:as_bytes}}
```

Quindi, creiamo un iteratore sull'array di byte utilizzando il metodo `iter`:

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:iter}}
```

Discuteremo degli iteratori più in dettaglio nel [Chapter 13][ch13]<!-- ignore -->.
Per ora, sappi che `iter` è un metodo che restituisce ogni elemento in una collezione e che `enumerate` avvolge il risultato di `iter` e restituisce ogni elemento come parte di una tupla. Il primo elemento della tupla restituito da `enumerate` è l'indice, e il secondo elemento è un riferimento all'elemento. Questo è un po' più comodo che calcolare l'indice noi stessi.

Poiché il metodo `enumerate` restituisce una tupla, possiamo usare i pattern per destrutturare quella tupla. Discuteremo dei pattern più nel [Chapter 6][ch6]<!-- ignore -->. Nel ciclo `for`, specifichiamo un pattern che ha `i` per l'indice nella tupla e `&item` per il singolo byte nella tupla. Poiché otteniamo un riferimento all'elemento da `.iter().enumerate()`, usiamo `&` nel pattern.

Dentro il ciclo `for`, cerchiamo il byte che rappresenta lo spazio utilizzando la sintassi dei byte letterali. Se troviamo uno spazio, restituiamo la posizione. Altrimenti, restituiamo la lunghezza della stringa utilizzando `s.len()`.

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:inside_for}}
```

Adesso abbiamo un modo per scoprire l'indice della fine della prima parola nella stringa, ma c'è un problema. Stiamo restituendo un `usize` da solo, ma è solo un numero significativo nel contesto del `&String`. In altre parole, poiché è un valore separato dalla `String`, non c'è garanzia che sarà ancora valido in futuro. Considera il programma nella Lista 4-8 che utilizza la funzione `first_word` della Lista 4-7.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-08/src/main.rs:here}}
```

<span class="caption">Lista 4-8: Memorizzazione del risultato ottenuto chiamando la 
funzione `first_word` e poi modificando il contenuto di `String`</span>

Questo programma si compila senza errori e lo farebbe anche se usassimo `word` dopo aver chiamato `s.clear()`. Poiché `word` non è collegata allo stato di `s` in alcun modo, `word` contiene ancora il valore `5`. Potremmo usare quel valore `5` con la variabile `s` per cercare di estrarre la prima parola, ma questo sarebbe un bug perché il contenuto di `s` è cambiato da quando abbiamo salvato `5` in `word`.

Dover preoccuparsi dell'indice in `word` che viene fuori sincrono con i dati in `s` è noioso e incline agli errori! Gestire questi indici è ancora più fragile se scriviamo una funzione `second_word`. La sua firma dovrebbe avere quest'aspetto:

```rust,ignore
fn second_word(s: &String) -> (usize, usize) {
```

Ora stiamo monitorando un indice di inizio *e* un indice di fine, e abbiamo ancora più valori che sono stati calcolati dai dati in uno stato particolare ma non sono affatto legati a quello stato. Abbiamo tre variabili non correlate che fluttuano attorno e che devono essere mantenute in sincronia.

Fortunatamente, Rust ha una soluzione a questo problema: le slices di stringhe.

### String Slices

Una *string slice* è un riferimento a parte di una `String`, e sembra questo:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-17-slice/src/main.rs:here}}
```

Piuttosto che un riferimento all'intera `String`, `hello` è un riferimento a una porzione della `String`, specificata nell'ulteriore bit `[0..5]`. Creiamo le slice usando un intervallo tra parentesi quadre specificando `[starting_index..ending_index]`, dove `starting_index` è la prima posizione nella slice e `ending_index` è una in più rispetto all'ultima posizione nella slice. Internamente, la struttura dati della slice memorizza la posizione di inizio e la lunghezza della slice, che corrisponde a `ending_index` meno `starting_index`. Quindi, nel caso di `let world = &s[6..11];`, `world` sarebbe una slice che contiene un puntatore al byte all'indice 6 di `s` con un valore di lunghezza `5`.

La Figura 4-6 mostra questo in un diagramma.

<img alt="Trê tavoli: un tavolo che rappresenta i dati dello stack di s, che punta
al byte all'indice 0 in un tavolo dei dati della stringa &quot;hello world&quot; sul
heap. Il terzo tavolo rappresenta i dati dello stack della slice world, che
ha un valore di lunghezza di 5 e punta al byte 6 del tavolo dei dati heap."
src="img/trpl04-06.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-6: String slice che fa riferimento a parte di una
`String`</span>

Con la sintassi degli intervalli `..` di Rust, se vuoi iniziare all'indice 0, puoi eliminare il valore prima dei due punti. In altre parole, questi sono uguali:

```rust
let s = String::from("hello");

let slice = &s[0..2];
let slice = &s[..2];
```

Allo stesso modo, se la tua slice include l'ultimo byte della `String`, puoi eliminare il numero finale. Questo significa che questi sono uguali:

```rust
let s = String::from("hello");

let len = s.len();

let slice = &s[3..len];
let slice = &s[3..];
```

Puoi anche eliminare entrambi i valori per prendere una slice dell'intera stringa. Quindi questi sono uguali:

```rust
let s = String::from("hello");

let len = s.len();

let slice = &s[0..len];
let slice = &s[..];
```

> Nota: Gli indici di intervallo del taglio di stringa devono verificarsi ai limiti validi dei caratteri UTF-8.
> Se tenti di creare un taglio di stringa nel mezzo di un carattere multibyte, il tuo programma terminerà con un errore. Ai fini
> dell'introduzione dei tagli di stringa, in questa sezione assumiamo solo ASCII; una
> discussione più approfondita sulla gestione dell'UTF-8 è nella sezione [“Memorizzare testo codificato UTF-8 con le stringhe”][strings]<!-- ignore --> del Capitolo 8.

Con tutte queste informazioni in mente, riscriviamo `first_word` per restituire un
taglio. Il tipo che significa "taglio di stringa" è scritto come `&str`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-18-first-word-slice/src/main.rs:here}}
```

Otteniamo l'indice per la fine della parola nello stesso modo in cui l'abbiamo fatto nella Lista 4-7, cercando
la prima occorrenza di uno spazio. Quando troviamo uno spazio, restituiamo un
taglio di stringa utilizzando l'inizio della stringa e l'indice dello spazio come
indici di inizio e fine.

Ora quando chiamiamo `first_word`, otteniamo un valore singolo che è legato al
dati sottostanti. Il valore è composto da un riferimento al punto di partenza delell
taglio ed il numero di elementi nel taglio.

Restituire un taglio funzionerebbe anche per una funzione `second_word`:

```rust,ignore
fn second_word(s: &String) -> &str {
```

Ora abbiamo un API semplice che è molto più difficile da combinare perché il
compilatore assicurerà che i riferimenti nella `String` rimangano validi. Ricorda
l'errore nel programma nella Lista 4-8, quando abbiamo ottenuto l'indice per la fine del
prima parola ma poi abbiamo svuotato la stringa così il nostro indice era invalido? Quel codice era
logicamente incorretto ma non mostrava immediatamente errori. I problemi sarebbero
apparsi più tardi se avessimo continuato a cercare di utilizzare l'indice della prima parola con una
stringa vuota. I tagli rendono questo errore impossibile e ci fanno sapere che abbiamo un problema con
il nostro codice molto prima. Utilizzare la versione a fette di `first_word` produrrà un
errore di compilazione:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-19-slice-error/src/main.rs:here}}
```

Ecco l'errore del compilatore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-19-slice-error/output.txt}}
```

Ricordati delle regole del prestito che se abbiamo un riferimento immutabile a
qualcosa, non possiamo anche prendere un riferimento mutabile. Perché `clear` ha bisogno di
troncare la `String`, ha bisogno di ottenere un riferimento mutabile. Il `println!`
dopo la chiamata a `clear` utilizza il riferimento in `word`, quindi il riferimento
immutabile deve essere attivo in quel momento. Rust non consente il riferimento mutabile in `clear`
e il riferimento immutabile in `word` di esistere contemporaneamente, la compilazione fallisce. Non solo Rust ha
reso la nostra API più facile da usare, ha anche eliminato un'intera classe di errori a tempo di compilazione!

<!-- Old heading. Do not remove or links may break. -->
<a id="string-literals-are-slices"></a>

#### Stringhe letterali come tagli

Ricorda che abbiamo parlato delle stringhe letterali che vengono memorizzate all'interno del binario. Ora
che conosciamo i tagli, possiamo comprendere correttamente le stringhe letterali:

```rust
let s = "Ciao, mondo!";
```

Il tipo di `s` qui è `&str`: è un taglio che punta a quello specifico punto del
binario. Questo è anche il motivo per cui le stringhe letterali sono immutabili; `&str` è un
riferimento immutabile.

#### Tagli di stringa come parametri

Sapendo che puoi fare tagli di letterali e valori `String` ci porta a
un ulteriore miglioramento su `first_word`, e cioè la sua firma:

```rust,ignore
fn first_word(s: &String) -> &str {
```

Un Rustacean più esperto scriverebbe la firma mostrata nella Lista 4-9
invece perché ci consente di utilizzare la stessa funzione sia su valori `&String` che
`&str`.

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-09/src/main.rs:here}}
```

<span class="caption">Lista 4-9: Migliorare la funzione `first_word` utilizzando
un taglio di stringa per il tipo del parametro `s`</span>

Se abbiamo un taglio di stringa, possiamo passare direttamente quello. Se abbiamo una `String`, noi
possiamo passare un taglio della `String` o un riferimento alla `String`. Questa
flessibilità sfrutta le *coercizioni di deref*, una funzione che copriremo in
[“Coercizioni di Deref Impliciti con Funzioni e
Metodi”][deref-coercions]<!--ignore--> sezione del Capitolo 15.

Definire una funzione per prendere un taglio di stringa invece di un riferimento a una `String`
rende la nostra API più generale e utile senza perdere alcuna funzionalità:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-09/src/main.rs:usage}}
```

### Altri tagli

I tagli di stringa, come puoi immaginare, sono specifici per le stringhe. Ma c'è anche un
tipo di taglio più generale. Prendi in considerazione questo array:

```rust
let a = [1, 2, 3, 4, 5];
```

Proprio come potremmo voler fare riferimento a parte di una stringa, potremmo voler fare riferimento a
parte di un array. Lo faremmo così:

```rust
let a = [1, 2, 3, 4, 5];

let slice = &a[1..3];

assert_eq!(slice, &[2, 3]);
```

Questo taglio ha il tipo `&[i32]`. Funziona allo stesso modo dei tagli di stringa, memorizzando
un riferimento al primo elemento e una lunghezza. Userai questo tipo di
taglio per tutti i tipi di altre collezioni. Discuteremo queste collezioni in
dettaglio quando parleremo di vettori nel Capitolo 8.

## Riepilogo

I concetti di ownership, borrowing e tagli garantiscano la sicurezza della memoria in Rust
programmi a tempo di compilazione. Il linguaggio Rust ti dà il controllo sulla tua memoria
utilizzo nello stesso modo degli altri linguaggi di programmazione di sistema, ma il fatto di avere
il proprietario dei dati pulisce automaticamente tali dati quando il proprietario esce dallo scope
significa che non devi scrivere e correggere codice extra per ottenere questo controllo.

L'ownership (proprietà) influisce sul funzionamento di molte altre parti di Rust, quindi parleremo di
questi concetti ulteriormente nel resto del libro. Passiamo al
Capitolo 5 e diamo un'occhiata a come raggruppare parti di dati insieme in una `struct`.

[ch13]: ch13-02-iterators.html
[ch6]: ch06-02-match.html#patterns-that-bind-to-values
[strings]: ch08-02-strings.html#storing-utf-8-encoded-text-with-strings
[deref-coercions]: ch15-02-deref.html#implicit-deref-coercions-with-functions-and-methods


