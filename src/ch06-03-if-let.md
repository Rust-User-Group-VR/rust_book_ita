## Controllo di flusso conciso con `if let`

La sintassi `if let` ti permette di combinare `if` e `let` in un modo meno verboso per
gestire i valori che corrispondono a un determinato modello ignorando il resto. Prendi in considerazione il
programma nella Lista 6-6 che corrisponde a un valore `Option<u8>` nel
variabile `config_max`, ma vuole eseguire il codice solo se il valore è la variante `Some`.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-06/src/main.rs:here}}
```

<span class="caption">Lista 6-6: Un `match` che si preoccupa solo di eseguire
codice quando il valore è `Some`</span>

Se il valore è `Some`, stampiamo il valore nella variante `Some` assegnando
il valore alla variabile `max` nel modello. Non vogliamo fare nulla
con il valore `None`. Per soddisfare l'espressione `match`, dobbiamo aggiungere `_ =>
()` dopo aver elaborato solo una variante, il che è un codice superfluo fastidioso da
aggiungere.

Invece, potremmo scrivere questo in modo più breve usando `if let`. Il codice seguente si comporta allo stesso modo del `match` nella Lista 6-6:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-12-if-let/src/main.rs:here}}
```

La sintassi `if let` accetta un pattern e un'espressione separati da un uguale
segno. Funziona allo stesso modo di un `match`, dove l'espressione viene data al
`match` e il modello è il suo primo ramo. In questo caso, il modello è
`Some(max)`, e `max` si lega al valore dentro `Some`. Quindi possiamo
usare `max` nel corpo del blocco `if let` allo stesso modo in cui abbiamo usato `max` in
il corrispondente ramo `match`. Il codice nel blocco `if let` non viene eseguito se il
valore non corrisponde al modello.

Usando `if let` significa meno digitazione, meno indentazione e meno codice ridondante.
Tuttavia, perdi il controllo esaustivo che `match` impone. Scegliere
tra `match` e `if let` dipende da ciò che stai facendo nella tua particolare
situazione e se guadagnare sinteticità è un compromesso appropriato per
perdere controllo esaustivo.

In altre parole, puoi pensare a `if let` come zucchero sintattico per un `match` che
esegue codice quando il valore corrisponde a un pattern e poi ignora tutti gli altri valori.

Possiamo includere un `else` con un `if let`. Il blocco di codice che va con il
`else` è lo stesso del blocco di codice che andrebbe con il caso `_` nel
espressione `match` che equivale all'`if let` e `else`. Ricorda il
definizione dell'enum `Coin` nella Lista 6-4, dove la variante `Quarter` teneva anche un
valore `UsState`. Se volessimo contare tutte le monete non da un quarto che vediamo mentre anche
annunciamo lo stato dei quarti, potremmo farlo con un' espressione `match`
così:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-13-count-and-announce-match/src/main.rs:here}}
```

Oppure potremmo usare un'espressione `if let` e `else`, così:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-14-count-and-announce-if-let-else/src/main.rs:here}}
```

Se hai una situazione in cui il tuo programma ha una logica che è troppo verbosa per
esprimere usando un `match`, ricorda che `if let` è nella tua cassetta degli attrezzi di Rust.

## Sommario

Abbiamo ora trattato come utilizzare gli enum per creare tipi personalizzati che possono essere uno di un
insieme di valori enumerati. Abbiamo mostrato come il tipo `Option<T>` della libreria standard
ti aiuta a usare il sistema di tipi per prevenire errori. Quando i valori enum hanno
dati dentro di loro, puoi utilizzare `match` o `if let` per estrarre e utilizzare quei
valori, a seconda di quanti casi devi gestire.

Ora i tuoi programmi Rust possono esprimere concetti nel tuo dominio usando strutture e
enum. La creazione di tipi personalizzati da utilizzare nella tua API assicura la sicurezza dei tipi: il
compilatore avrà la certezza che le tue funzioni ricevano solo valori del tipo che ogni
funzione si aspetta.

Per fornire un'API ben organizzata ai tuoi utenti che è facile da
usare ed espone solo esattamente ciò di cui i tuoi utenti avranno bisogno, passiamo ora ai
moduli di Rust.

