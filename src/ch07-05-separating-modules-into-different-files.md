## Separare Moduli in File Diversi

Finora, tutti gli esempi in questo capitolo hanno definito più moduli in un unico file. Quando i moduli diventano grandi, potresti voler spostare le loro definizioni in un file separato per rendere il codice più facile da navigare.

Ad esempio, iniziamo con il codice nel Listing 7-17 che aveva più moduli di ristorante. Estrarremo i moduli in file invece di avere tutti i moduli definiti nel file radice del crate. In questo caso, il file radice del crate è *src/lib.rs*, ma questa procedura funziona anche con i binary crates il cui file radice del crate è *src/main.rs*.

Per prima cosa estrarremo il modulo `front_of_house` in un proprio file. Rimuovi il codice all'interno delle parentesi graffe per il modulo `front_of_house`, lasciando solo la dichiarazione `mod front_of_house;`, in modo che *src/lib.rs* contenga il codice mostrato nel Listing 7-21. Nota che questo non verrà compilato finché non creeremo il file *src/front_of_house.rs* nel Listing 7-22.

<span class="filename">Nome file: src/lib.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-21-and-22/src/lib.rs}}
```

<span class="caption">Listing 7-21: Dichiarare il modulo `front_of_house` il cui Blocco sarà in *src/front_of_house.rs*</span>

Successivamente, posiziona il codice che era tra le parentesi graffe in un nuovo file chiamato *src/front_of_house.rs*, come mostrato nel Listing 7-22. Il compilatore sa di guardare in questo file perché ha incontrato la dichiarazione del modulo nel crate root con il nome `front_of_house`.

<span class="filename">Nome file: src/front_of_house.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-21-and-22/src/front_of_house.rs}}
```

<span class="caption">Listing 7-22: Definizioni all'interno del modulo `front_of_house` in *src/front_of_house.rs*</span>

Nota che devi caricare un file usando una dichiarazione `mod` *una sola volta* nel tuo albero del modulo. Una volta che il compilatore sa che il file fa parte del progetto (e sa dove risiede il codice nell'albero dei moduli perché hai messo la dichiarazione `mod`), gli altri file nel tuo progetto dovrebbero riferirsi al codice del file caricato usando un percorso dove è stato dichiarato, come trattato nella sezione [“Percorsi per Riferirsi a un Elemento nell'Albero del Modulo”][paths]<!-- ignore -->. In altre parole, `mod` non è un'operazione "include" che potresti aver visto in altri linguaggi di programmazione.

Successivamente, estrarremo il modulo `hosting` in un proprio file. Il processo è un po' diverso perché `hosting` è un modulo figlio di `front_of_house`, non del modulo radice. Posizioneremo il file per `hosting` in una nuova directory che verrà nominata in base ai suoi antenati nell'albero dei moduli, in questo caso *src/front_of_house*.

Per iniziare a spostare `hosting`, modifichiamo *src/front_of_house.rs* affinché contenga solo la dichiarazione del modulo `hosting`:

<span class="filename">Nome file: src/front_of_house.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/no-listing-02-extracting-hosting/src/front_of_house.rs}}
```

Quindi creiamo una directory *src/front_of_house* e un file *hosting.rs* per contenere le definizioni fatte nel modulo `hosting`:

<span class="filename">Nome file: src/front_of_house/hosting.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/no-listing-02-extracting-hosting/src/front_of_house/hosting.rs}}
```

Se invece mettessimo *hosting.rs* nella directory *src*, il compilatore si aspetterebbe che il codice di *hosting.rs* sia in un modulo `hosting` dichiarato nel crate root, e non dichiarato come figlio del modulo `front_of_house`. Le regole del compilatore per quali file verificare per il codice di quali moduli significano che le directory e i file corrispondono più strettamente all'albero del modulo.

> ### Percorsi di File Alternativi
>
> Finora abbiamo trattato i percorsi di file più idiomatici che il compilatore Rust utilizza, ma Rust supporta anche uno stile di percorso di file più vecchio. Per un modulo denominato `front_of_house` dichiarato nel crate root, il compilatore cercherà il codice del modulo in:
>
> * *src/front_of_house.rs* (quello che abbiamo trattato)
> * *src/front_of_house/mod.rs* (stile più vecchio, percorso ancora supportato)
>
> Per un modulo denominato `hosting` che è un sottomodulo di `front_of_house`, il compilatore cercherà il codice del modulo in:
>
> * *src/front_of_house/hosting.rs* (quello che abbiamo trattato)
> * *src/front_of_house/hosting/mod.rs* (stile più vecchio, percorso ancora supportato)
>
> Se utilizzi entrambi gli stili per lo stesso modulo, otterrai un errore del compilatore. L'utilizzo di un mix di entrambi gli stili per moduli diversi nello stesso progetto è consentito, ma potrebbe essere confusionario per le persone che navigano nel tuo progetto.
>
> Lo svantaggio principale dello stile che utilizza file denominati *mod.rs* è che il tuo progetto può finire con molti file denominati *mod.rs*, il che può causare confusione quando li hai aperti nel tuo editor contemporaneamente.

Abbiamo spostato il codice di ciascun modulo in un file separato e l'albero del modulo rimane lo stesso. Le chiamate di funzione in `eat_at_restaurant` funzioneranno senza alcuna modifica, anche se le definizioni risiedono in file diversi. Questa tecnica ti consente di spostare i moduli in nuovi file man mano che crescono di dimensioni.

Nota che la dichiarazione `pub use crate::front_of_house::hosting` in *src/lib.rs* non è cambiata, né `use` ha alcun impatto su quali file vengono compilati come parte del crate. La parola chiave `mod` dichiara moduli, e Rust cerca in un file con lo stesso nome del modulo il codice che entra in quel modulo.

## Sommario

Rust ti permette di dividere un package in più crates e un crate in moduli in modo che tu possa riferirti ad elementi definiti in un modulo da un altro modulo. Puoi farlo specificando percorsi assoluti o relativi. Questi percorsi possono essere portati nello Scope con una dichiarazione `use` in modo da poter utilizzare un percorso più breve per usi multipli dell'elemento in quello Scope. Il codice del modulo è privato per default, ma puoi rendere pubbliche le definizioni aggiungendo la parola chiave `pub`.

Nel prossimo capitolo, esamineremo alcune strutture di dati collettive nella libreria standard che puoi utilizzare nel tuo codice ordinatamente organizzato.

[paths]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html
