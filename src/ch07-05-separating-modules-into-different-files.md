## Separare i Moduli in Diversi File

Finora, tutti gli esempi in questo capitolo hanno definito più moduli in un unico file. Quando i moduli diventano grandi, potresti voler spostare le loro definizioni in un file separato per rendere più semplice la navigazione del codice.

Ad esempio, partiamo dal codice nell'Elenco 7-17 che aveva più moduli di ristorante. Estraiamo i moduli nei file invece di avere tutti i moduli definiti nel file radice del crate. In questo caso, il file radice del crate è *src/lib.rs*, ma questa procedura funziona anche con i crate binari il cui file radice del crate è *src/main.rs*.

Prima, estraiamo il modulo `front_of_house` nel suo file. Rimuovi il codice all'interno delle parentesi graffe per il modulo `front_of_house`, lasciando solo la dichiarazione `mod front_of_house;`, in modo che *src/lib.rs* contenga il codice mostrato nell'Elenco 7-21. Nota che questo non compilerà fino a quando non creeremo il file *src/front_of_house.rs* nell'Elenco 7-22.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-21-and-22/src/lib.rs}}
```

<span class="caption">Elenco 7-21: Dichiarazione del modulo `front_of_house` il cui
corpo sarà in *src/front_of_house.rs*</span>

Successivamente, posiziona il codice che era dentro le parentesi graffe in un nuovo file chiamato *src/front_of_house.rs*, come mostrato nell'Elenco 7-22. Il compilatore sa di cercare in questo file perché è incappato nella dichiarazione del modulo nel crate root con il nome `front_of_house`.

<span class="filename">Nome del file: src/front_of_house.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-21-and-22/src/front_of_house.rs}}
```

<span class="caption">Elenco 7-22: Definizioni all'interno del modulo `front_of_house`
in *src/front_of_house.rs*</span>

Nota che è necessario caricare un file utilizzando una dichiarazione `mod` *una sola volta* nella tua struttura dei moduli. Una volta che il compilatore sa che il file fa parte del progetto (e sa dove si trova il codice nel modulo perché hai inserito l'istruzione `mod`), altri file nel tuo progetto dovrebbero fare riferimento al codice del file caricato utilizzando un percorso verso dove è stato dichiarato, come spiegato nella sezione ["Percorsi per fare riferimento ad un elemento nell'albero dei moduli"][paths]<!-- ignore -->. In altre parole, `mod` *non è* un'operazione "includi" che potresti aver visto in altri linguaggi di programmazione.

Successivamente, estraiamo il modulo `hosting` nel suo file. Il processo è un po' diverso perché `hosting` è un modulo figlio di `front_of_house`, non del modulo radice. Posizioneremo il file per `hosting` in una nuova directory che sarà denominata per i suoi antenati nell'albero dei moduli, in questo caso *src/front_of_house/*.

Per iniziare a spostare `hosting`, cambiamo *src/front_of_house.rs* per contenere solo la dichiarazione del modulo `hosting`:

<span class="filename">Nome del file: src/front_of_house.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/no-listing-02-extracting-hosting/src/front_of_house.rs}}
```

Quindi creiamo una directory *src/front_of_house* e un file *hosting.rs* per contenere le definizioni fatte nel modulo `hosting`:

<span class="filename">Nome del file: src/front_of_house/hosting.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/no-listing-02-extracting-hosting/src/front_of_house/hosting.rs}}
```

Se invece mettessimo *hosting.rs* nella directory *src*, il compilatore si aspetterebbe che il codice *hosting.rs* fosse in un modulo `hosting` dichiarato nel crate root, e non dichiarato come figlio del modulo `front_of_house`. Le regole del compilatore su quali file controllare per il codice dei moduli significa che le directories e i file corrispondono più da vicino all'albero dei moduli.

> ### Percorsi alternativi di file
>
> Finora abbiamo coperto i percorsi di file più idiomatici che il compilatore di Rust usa,
> ma Rust supporta anche un vecchio stile di percorso di file. Per un modulo chiamato
> `front_of_house` dichiarato nel crate root, il compilatore cercherà il codice del modulo in:
>
> * *src/front_of_house.rs* (quello che abbiamo coperto)
> * *src/front_of_house/mod.rs* (vecchio stile, percorso ancora supportato)
>
> Per un modulo chiamato `hosting` che è un sottomodulo di `front_of_house`, il compilatore cercherà il codice del modulo in:
>
> * *src/front_of_house/hosting.rs* (quello che abbiamo coperto)
> * *src/front_of_house/hosting/mod.rs* (vecchio stile, percorso ancora supportato)
>
> Se usi entrambi gli stili per lo stesso modulo, otterrai un errore del compilatore. Utilizzare un mix di entrambi gli stili per diversi moduli nello stesso progetto è consentito, ma potrebbe confondere le persone che navigano nel tuo progetto.
>
> Il principale svantaggio dello stile che usa file chiamati *mod.rs* è che il tuo progetto può finire con molti file chiamati *mod.rs*, il che può creare confusione quando li hai aperti contemporaneamente nel tuo editor.

Abbiamo spostato il codice di ogni modulo in un file separato, e l'albero dei moduli rimane lo stesso. Le chiamate di funzione in `eat_at_restaurant` funzioneranno senza alcuna modifica, anche se le definizioni risiedono in file diversi. Questa tecnica ti permette di spostare i moduli in nuovi file man mano che aumentano di dimensioni.

Nota che l'istruzione `pub use crate::front_of_house::hosting` in
*src/lib.rs* non è cambiata, né `use` ha alcun impatto sui file che vengono compilati come parte del crate. La parola chiave `mod` dichiara i moduli, e Rust cerca in un file con lo stesso nome del modulo per il codice che va in quel modulo.

## Riepilogo

Rust ti permette di dividere un pacchetto in più crate e un crate in moduli in modo da poter fare riferimento agli elementi definiti in un modulo da un altro modulo. Puoi farlo specificando percorsi assoluti o relativi. Questi percorsi possono essere portati nello scope con un'istruzione `use` in modo da poter utilizzare un percorso più corto per usi multipli dell'elemento in quello scope. Il codice del modulo è privato di default, ma puoi rendere pubbliche le definizioni aggiungendo la parola chiave `pub`.

Nel prossimo capitolo, esamineremo alcune strutture di dati di collezione nella libreria standard che puoi utilizzare nel tuo codice ben organizzato.

[paths]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html
