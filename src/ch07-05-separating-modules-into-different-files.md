## Separazione dei Moduli in File Diversi

Finora, tutti gli esempi in questo capitolo hanno definito più moduli in un unico file.
Quando i moduli diventano grandi, potresti voler spostare le loro definizioni in un file separato per rendere il codice più facile da navigare.

Ad esempio, iniziamo dal codice nella Listing 7-17 che aveva più moduli del ristorante. Estrarremo i moduli in file invece di avere tutti i moduli definiti nel file radice del crate. In questo caso, il file radice del crate è *src/lib.rs*, ma questa procedura funziona anche con i binary crates il cui file radice del crate è *src/main.rs*.

Per prima cosa estrarremo il modulo `front_of_house` nel suo file. Rimuovi il codice all'interno delle parentesi graffe per il modulo `front_of_house`, lasciando solo la dichiarazione `mod front_of_house;` in modo che *src/lib.rs* contenga il codice mostrato nella Listing 7-21. Nota che questo non compilerà finché non creeremo il file *src/front_of_house.rs* nella Listing 7-22.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-21-and-22/src/lib.rs}}
```

<span class="caption">Listing 7-21: Dichiarazione del modulo `front_of_house` il
cui corpo sarà in *src/front_of_house.rs*</span>

Successivamente, posiziona il codice che era nelle parentesi graffe in un nuovo file chiamato *src/front_of_house.rs*, come mostrato nella Listing 7-22. Il compilatore sa di cercare in questo file perché ha incontrato la dichiarazione del modulo nel crate root con il nome `front_of_house`.

<span class="filename">Nome del file: src/front_of_house.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-21-and-22/src/front_of_house.rs}}
```

<span class="caption">Listing 7-22: Definizioni all'interno del modulo `front_of_house`
in *src/front_of_house.rs*</span>

Nota che hai bisogno di caricare un file usando una dichiarazione `mod` *una sola volta* nel tuo albero dei moduli. Una volta che il compilatore sa che il file fa parte del progetto (e sa dove si trova il codice nell'albero dei moduli grazie a dove hai posizionato l'istruzione `mod`), altri file nel tuo progetto dovrebbero fare riferimento al codice del file caricato usando un path dove è stato dichiarato, come trattato nella sezione [“Path per Fare Riferimento a un Elemento nell'Albero dei Moduli”][paths]<!-- ignore -->. In altre parole, `mod` *non* è un'operazione di "inclusione" che potresti aver visto in altri linguaggi di programmazione.

Successivamente, estrarremo il modulo `hosting` nel suo file. Il processo è un po' diverso perché `hosting` è un modulo figlio di `front_of_house`, non del modulo root. Posizioneremo il file per `hosting` in una nuova directory che verrà chiamata con il nome dei suoi antenati nell'albero dei moduli, in questo caso *src/front_of_house*.

Per cominciare a spostare `hosting`, cambiamo *src/front_of_house.rs* in modo che contenga solo la dichiarazione del modulo `hosting`:

<span class="filename">Nome del file: src/front_of_house.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/no-listing-02-extracting-hosting/src/front_of_house.rs}}
```

Quindi creiamo una directory *src/front_of_house* e un file *hosting.rs* per contenere le definizioni fatte nel modulo `hosting`:

<span class="filename">Nome del file: src/front_of_house/hosting.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/no-listing-02-extracting-hosting/src/front_of_house/hosting.rs}}
```

Se invece mettessimo *hosting.rs* nella directory *src*, il compilatore si aspetterebbe che il codice di *hosting.rs* sia in un modulo `hosting` dichiarato nel crate root, e non dichiarato come figlio del modulo `front_of_house`. Le regole del compilatore su quali file controllare per il codice di quali moduli fanno sì che le directory e i file corrispondano più strettamente all'albero dei moduli.

> ### Percorsi Alternativi dei File
>
> Finora abbiamo coperto i percorsi dei file più idiomatici che il compilatore Rust usa,
> ma Rust supporta anche uno stile più vecchio di percorso dei file. Per un modulo chiamato
> `front_of_house` dichiarato nel crate root, il compilatore cercherà il codice del modulo in:
>
> * *src/front_of_house.rs* (ciò che abbiamo trattato)
> * *src/front_of_house/mod.rs* (stile più vecchio, percorso ancora supportato)
>
> Per un modulo chiamato `hosting` che è un sottomodulo di `front_of_house`, il
> compilatore cercherà il codice del modulo in:
>
> * *src/front_of_house/hosting.rs* (ciò che abbiamo trattato)
> * *src/front_of_house/hosting/mod.rs* (stile più vecchio, percorso ancora supportato)
>
> Se usi entrambi gli stili per lo stesso modulo, otterrai un errore del compilatore.
> Usare un mix di entrambi gli stili per moduli diversi nello stesso progetto è
> permesso, ma potrebbe essere confuso per le persone che navigano nel tuo progetto.
>
> Il principale svantaggio dello stile che usa file chiamati *mod.rs* è che il tuo
> progetto può finire con molti file chiamati *mod.rs*, il che può diventare
> confuso quando li hai aperti nel tuo editor allo stesso tempo.

Abbiamo spostato il codice di ciascun modulo in un file separato, e l'albero dei moduli rimane lo stesso. Le chiamate di funzione in `eat_at_restaurant` funzioneranno senza alcuna modifica, anche se le definizioni risiedono in file diversi. Questa tecnica ti consente di spostare i moduli in nuovi file man mano che crescono di dimensioni.

Nota che l'istruzione `pub use crate::front_of_house::hosting` in
*src/lib.rs* non è cambiata, né `use` ha alcun impatto su quali file vengono compilati come parte del crate. La parola chiave `mod` dichiara i moduli e Rust cerca in un file con lo stesso nome del modulo il codice che va in quel modulo.

## Sommario

Rust ti permette di suddividere un package in più crates e un crate in moduli in modo da poter fare riferimento agli elementi definiti in un modulo da un altro modulo. Puoi farlo specificando percorsi assoluti o relativi. Questi percorsi possono essere portati in scope con un'istruzione `use` in modo da poter usare un percorso più breve per usi multipli dell'elemento in quel scope. Il codice del modulo è privato per impostazione predefinita, ma puoi rendere le definizioni pubbliche aggiungendo la parola chiave `pub`.

Nel prossimo capitolo, esamineremo alcune strutture di dati della collezione nella libreria standard che puoi usare nel tuo codice organizzato con ordine.

[paths]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html
