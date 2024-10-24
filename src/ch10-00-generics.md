# Tipi generici, Traits e Lifetimes

Ogni linguaggio di programmazione ha strumenti per gestire efficacemente la duplicazione
dei concetti. In Rust, uno di questi strumenti è *i generici*: sostituti astratti per
tipi concreti o altre proprietà. Possiamo esprimere il comportamento dei generici o
come si relazionano ad altri generici senza sapere cosa sarà al loro posto
quando si compila ed esegue il codice.

Le funzioni possono prendere parametri di un tipo generico, invece di un tipo concreto
come `i32` o `String`, nello stesso modo in cui prendono parametri con valori sconosciuti
per eseguire lo stesso codice su più valori concreti. In effetti, abbiamo già
usato generici nel Capitolo 6 con `Option<T>`, nel Capitolo 8 con `Vec<T>` e
`HashMap<K, V>`, e nel Capitolo 9 con `Result<T, E>`. In questo capitolo, esplorerai
come definire i tuoi tipi, funzioni e metodi con i generici!

Per prima cosa, rivedremo come estrarre una funzione per ridurre la duplicazione del codice. Poi
useremo la stessa tecnica per creare una funzione generica da due funzioni che
differiscono solo nei tipi dei loro parametri. Spiegheremo anche come usare i
tipi generici nelle definizioni di struct ed enum.

Poi imparerai come usare i *trait* per definire il comportamento in modo generico. Puoi
combinare i trait con i tipi generici per limitare un tipo generico ad accettare
solo quei tipi che hanno un particolare comportamento, anziché qualsiasi tipo.

Infine, discuteremo di *lifetimes*: una varietà di generici che forniscono al
compilatore informazioni su come le references si relazionano tra loro. Le lifetimes ci permettono
di fornire al compilatore abbastanza informazioni sui valori presi in prestito affinché possa
garantire che le references saranno valide in più situazioni di quanto potrebbe senza il nostro aiuto.

## Rimozione della duplicazione estraendo una funzione

I generici ci permettono di sostituire tipi specifici con un segnaposto che rappresenta
più tipi per rimuovere la duplicazione del codice. Prima di immergerci nella sintassi dei generici,
vediamo prima come rimuovere la duplicazione in un modo che non coinvolga i tipi generici estraendo
una funzione che sostituisce i valori specifici con un segnaposto che rappresenta più valori. Poi
applicheremo la stessa tecnica per estrarre una funzione generica! Riconoscendo
il codice duplicato che puoi estrarre in una funzione, inizierai a riconoscere
il codice duplicato che può usare i generici.

Inizieremo con il breve programma nel Listing 10-1 che trova il numero più grande
in una lista.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-01/src/main.rs:here}}
```

<span class="caption">Listing 10-1: Trovare il numero più grande in una lista di
numeri</span>

Memorizziamo una lista di interi nella variabile `number_list` e posizioniamo un riferimento
al primo numero della lista in una variabile chiamata `largest`. Poi iteriamo
attraverso tutti i numeri nella lista, e se il numero corrente è maggiore del
numero memorizzato in `largest`, sostituiamo il riferimento in quella variabile.
Tuttavia, se il numero corrente è minore o uguale al numero più grande visto
finora, la variabile non cambia, e il codice passa al numero successivo
nella lista. Dopo aver considerato tutti i numeri nella lista, `largest` dovrebbe
riferirsi al numero più grande, che in questo caso è 100.

Ci è stato ora assegnato il compito di trovare il numero più grande in due liste
differenti di numeri. Per farlo, possiamo scegliere di duplicare il codice nel Listing 10-1 e usare
la stessa logica in due posti diversi nel programma, come mostrato nel Listing 10-2.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-02/src/main.rs}}
```

<span class="caption">Listing 10-2: Codice per trovare il numero più grande in *due*
liste di numeri</span>

Anche se questo codice funziona, duplicare il codice è tedioso e incline agli errori. Dobbiamo anche
ricordarci di aggiornare il codice in più posti quando vogliamo cambiarlo.

Per eliminare questa duplicazione, creeremo un'astrazione definendo una
funzione che opera su qualsiasi lista di interi passata come parametro. Questa
soluzione rende il nostro codice più chiaro e ci permette di esprimere il concetto
di trovare il numero più grande in una lista in modo astratto.

Nel Listing 10-3, estraiamo il codice che trova il numero più grande in una
funzione chiamata `largest`. Poi chiamiamo la funzione per trovare il numero più grande
nelle due liste del Listing 10-2. Potremmo anche usare la funzione su qualsiasi altra
lista di valori `i32` che potremmo avere in futuro.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-03/src/main.rs:here}}
```

<span class="caption">Listing 10-3: Codice astratto per trovare il numero più grande
in due liste</span>

La funzione `largest` ha un parametro chiamato `list`, che rappresenta qualsiasi
slice concreta di valori `i32` che potremmo passare alla funzione. Di conseguenza,
quando chiamiamo la funzione, il codice viene eseguito sui valori specifici che passiamo.

In sintesi, ecco i passi che abbiamo seguito per cambiare il codice dal Listing 10-2 al
Listing 10-3:

1. Identificare il codice duplicato.
2. Estrarre il codice duplicato nel blocco della funzione, e specificare gli
   input e i valori di ritorno di quel codice nella firma della funzione.
3. Aggiornare le due istanze di codice duplicato per chiamare la funzione invece.

Successivamente, useremo questi stessi passi con i generici per ridurre la duplicazione del codice. Nello
stesso modo in cui il blocco della funzione può operare su un `list` astratto anziché
su valori specifici, i generici permettono al codice di operare su tipi astratti.

Ad esempio, supponiamo di avere due funzioni: una che trova l'elemento più grande in una
slice di valori `i32` e una che trova l'elemento più grande in una slice di valori `char`.
Come elimineremmo quella duplicazione? Scopriamolo!
