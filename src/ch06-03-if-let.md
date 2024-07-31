## Flusso di Controllo Conciso con `if let`

La sintassi `if let` ti permette di combinare `if` e `let` in un modo meno verboso per gestire valori che corrispondono a un pattern, ignorando il resto. Considera il programma in Listing 6-6 che fa il match su un valore `Option<u8>` nella variabile `config_max`, ma vuole eseguire il codice solo se il valore è la variante `Some`.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-06/src/main.rs:here}}
```

<span class="caption">Listing 6-6: Un `match` che si preoccupa solo di eseguire il codice quando il valore è `Some`</span>

Se il valore è `Some`, stampiamo il valore nella variante `Some` legando il valore alla variabile `max` nel pattern. Non vogliamo fare nulla con il valore `None`. Per soddisfare l'espressione `match`, dobbiamo aggiungere `_ => ()` dopo aver elaborato solo una variante, il che è un codice boilerplate fastidioso da aggiungere.

Invece, potremmo scrivere questo in un modo più breve usando `if let`. Il seguente codice si comporta allo stesso modo del `match` in Listing 6-6:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-12-if-let/src/main.rs:here}}
```

La sintassi `if let` prende un pattern e un'espressione separati da un segno uguale. Funziona allo stesso modo di un `match`, dove l'espressione è data al `match` e il pattern è il suo primo braccio. In questo caso, il pattern è `Some(max)`, e `max` viene legato al valore all'interno di `Some`. Possiamo quindi usare `max` nel corpo del blocco `if let` nello stesso modo in cui usavamo `max` nel corrispondente braccio di `match`. Il codice nel blocco `if let` non viene eseguito se il valore non corrisponde al pattern.

Usare `if let` significa meno digitazione, meno indentazione e meno codice boilerplate. Tuttavia, perdi il controllo esaustivo che `match` impone. Scegliere tra `match` e `if let` dipende da cosa stai facendo nella tua particolare situazione e se guadagnare concisione è uno scambio appropriato per perdere il controllo esaustivo.

In altre parole, puoi pensare a `if let` come zucchero sintattico per un `match` che esegue codice quando il valore corrisponde a un pattern e poi ignora tutti gli altri valori.

Possiamo includere un `else` con un `if let`. Il blocco di codice che va con l'`else` è lo stesso del blocco di codice che andrebbe con il caso `_` nell'espressione `match` equivalente a `if let` e `else`. Ricorda la definizione dell'enum `Coin` in Listing 6-4, dove la variante `Quarter` conteneva anche un valore `UsState`. Se volessimo contare tutte le monete non-quarter che vediamo mentre annunciamo anche lo stato dei quarter, potremmo farlo con un'espressione `match`, così:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-13-count-and-announce-match/src/main.rs:here}}
```

Oppure potremmo usare un'espressione `if let` e `else`, così:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-14-count-and-announce-if-let-else/src/main.rs:here}}
```

Se hai una situazione in cui la logica del tuo programma è troppo verbosa da esprimere usando un `match`, ricorda che `if let` è anche nella tua cassetta degli attrezzi di Rust.

## Sommario

Abbiamo ora coperto come usare gli enum per creare tipi personalizzati che possono essere uno di un set di valori enumerati. Abbiamo mostrato come il tipo `Option<T>` della libreria standard ti aiuta a usare il sistema dei tipi per prevenire errori. Quando i valori degli enum hanno dati al loro interno, puoi usare `match` o `if let` per estrarre e usare quei valori, a seconda di quanti casi devi gestire.

I tuoi programmi Rust ora possono esprimere concetti nel tuo dominio usando struct e enum. Creare tipi personalizzati da usare nella tua API assicura la sicurezza dei tipi: il compilatore garantirà che le tue funzioni ottengano solo valori del tipo che ogni funzione si aspetta.

Per fornire una API ben organizzata ai tuoi utenti che sia semplice da usare e che esponga esattamente ciò di cui hanno bisogno, passiamo ora ai moduli di Rust.
