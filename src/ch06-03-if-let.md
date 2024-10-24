## Flusso di controllo conciso con `if let`

La sintassi `if let` ti consente di combinare `if` e `let` in un modo meno verbose per gestire valori che corrispondono a un modello mentre ignora il resto. Considera il programma nel Listing 6-6 che corrisponde su un valore `Option<u8>` nella variabile `config_max` ma vuole eseguire codice solo se il valore è la variante `Some`.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-06/src/main.rs:here}}
```

<span class="caption">Listing 6-6: Un `match` che si preoccupa solo di eseguire codice quando il valore è `Some`</span>

Se il valore è `Some`, stampiamo il valore nella variante `Some` legando il valore alla variabile `max` nel modello. Non vogliamo fare nulla con il valore `None`. Per soddisfare l'espressione `match`, dobbiamo aggiungere `_ => ()` dopo aver processato solo una variante, il che è fastidioso boilerplate code da aggiungere.

Invece, potremmo scrivere questo in un modo più breve usando `if let`. Il seguente codice si comporta allo stesso modo del `match` nel Listing 6-6:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-12-if-let/src/main.rs:here}}
```

La sintassi `if let` prende un modello e un'espressione separati da un segno uguale. Funziona allo stesso modo di un `match`, dove l'espressione viene data al `match` e il modello è il suo primo ramo. In questo caso, il modello è `Some(max)`, e `max` si lega al valore all'interno di `Some`. Possiamo quindi usare `max` nel blocco `if let` allo stesso modo in cui usavamo `max` nel corrispondente ramo del `match`. Il codice nel blocco `if let` non viene eseguito se il valore non corrisponde al modello.

Usare `if let` significa meno digitazione, meno indentazione e meno boilerplate code. Tuttavia, si perde il controllo esaustivo che `match` impone. Scegliere tra `match` e `if let` dipende da quello che stai facendo nella tua particolare situazione e se ottenere concisione è un compromesso appropriato per perdere il controllo esaustivo.

In altre parole, puoi pensare a `if let` come a zucchero sintattico per un `match` che esegue codice quando il valore corrisponde a un modello e quindi ignora tutti gli altri valori.

Possiamo includere un `else` con un `if let`. Il blocco di codice che va con il `else` è lo stesso del blocco di codice che andrebbe con il caso `_` nell'espressione `match` che è equivalente al `if let` e `else`. Ricorda la definizione dell'`Enum` `Coin` nel Listing 6-4, dove la variante `Quarter` deteneva anche un valore `UsState`. Se volessimo contare tutte le monete non-quarter che vediamo annunciando anche lo stato dei quarters, potremmo farlo con un'espressione `match`, come questa:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-13-count-and-announce-match/src/main.rs:here}}
```

Oppure potremmo usare un'espressione `if let` e `else`, come questa:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-14-count-and-announce-if-let-else/src/main.rs:here}}
```

Se hai una situazione in cui il tuo programma ha una logica che è troppo prolissa da esprimere usando un `match`, ricorda che `if let` è anche nella tua cassetta degli attrezzi di Rust.

## Sommario

Abbiamo ora coperto come utilizzare gli enum per creare tipi personalizzati che possono essere uno di un set di valori enumerati. Abbiamo mostrato come il tipo `Option<T>` della libreria standard aiuta a utilizzare il sistema di tipi per prevenire errori. Quando i valori enum contengono dati al loro interno, puoi utilizzare `match` o `if let` per estrarre e usare quei valori, a seconda di quanti casi devi gestire.

I tuoi programmi Rust possono ora esprimere concetti nel tuo dominio usando struct ed enum. Creare tipi personalizzati da usare nella tua API garantisce la sicurezza dei tipi: il compilatore si assicurerà che le tue funzioni ricevano solo valori del tipo che ciascuna funzione si aspetta.

Per fornire un'API ben organizzata ai tuoi utenti che sia semplice da usare e esponga solo ciò di cui gli utenti hanno bisogno, rivolgiamoci ora ai moduli di Rust.

