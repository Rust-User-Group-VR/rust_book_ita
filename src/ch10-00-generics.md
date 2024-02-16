# Tipi generici, Traits e Durate

Ogni linguaggio di programmazione ha strumenti per gestire efficacemente la duplicazione
dei concetti. In Rust, uno di questi strumenti sono i *generici*: rappresentanti astratti per
tipi concreti o altre proprietà. Possiamo esprimere il comportamento dei generici o
come si relazionano ad altri generici senza sapere cosa ci sarà al loro posto
quando si compila ed esegue il codice.

Le funzioni possono accettare parametri di alcuni tipi generici, invece di un tipo concreto
come `i32` o `String`, nello stesso modo in cui una funzione prende parametri con
valori sconosciuti per eseguire lo stesso codice su molteplici valori concreti. Infatti, abbiamo
già usato i generici nel Capitolo 6 con `Option<T>`, Capitolo 8 con `Vec<T>`
e `HashMap<K, V>`, e Capitolo 9 con `Result<T, E>`. In questo capitolo, esplorerai come definire i tuoi tipi, funzioni e metodi con i generici!

Prima, rivedremo come estrarre una funzione per ridurre la duplicazione del codice. Successivamente
useremo la stessa tecnica per creare una funzione generica a partire da due funzioni che
differiscono solo per i tipi dei loro parametri. Spiegheremo anche come utilizzare
i tipi generici nelle definizioni di struct e enum.

Quindi imparerai come usare i *traits* per definire comportamenti in modo generico. Puoi
combinare i traits con i tipi generici per vincolare un tipo generico ad accettare
solo quei tipi che hanno un comportamento particolare, invece di qualsiasi tipo.

Infine, discuteremo le *durate*: una varietà di generici che forniscono al
compilatore informazioni su come le referenze si riferiscono l'una all'altra. Le durate ci permettono
di fornire al compilatore abbastanza informazioni sui valori presi in prestito in modo che possa
garantire che le referenze saranno valide in più situazioni di quelle che potrebbe senza il nostro
aiuto.

## Rimozione della duplicazione estraendo una funzione

I generici ci permettono di sostituire tipi specifici con un segnaposto che rappresenta
multipli tipi per rimuovere la duplicazione del codice. Prima di immergerci nella sintassi dei generici,
quindi, diamo prima uno sguardo a come rimuovere la duplicazione in un modo che non
implica l'uso di tipi generici estraendo una funzione che sostituisce valori specifici
con un segnaposto che rappresenta multipli valori. Poi applicheremo la stessa
tecnica per estrarre una funzione generica! Guardando come riconoscere
il codice duplicato che puoi estrarre in una funzione, inizierai a riconoscere
il codice duplicato che può utilizzare i generici.

Iniziamo con il breve programma in Lista 10-1 che trova il numero più grande
in un elenco.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-01/src/main.rs:here}}
```

<span class="caption">Lista 10-1: Trova il numero più grande in una lista di
numeri</span>

Conserviamo una lista di interi nella variabile `number_list` e mettiamo un riferimento
al primo numero nell'elenco in una variabile chiamata `largest`. Poi iteriamo
attraverso tutti i numeri della lista, e se il numero corrente è maggiore del
numero conservato in `largest`, sostituisci il riferimento in quella variabile.
Tuttavia, se il numero corrente è minore o uguale al numero più grande visto
finora, la variabile non cambia, e il codice passa al prossimo numero
della lista. Dopo aver considerato tutti i numeri della lista, `largest` dovrebbe
riferirsi al numero più grande, che in questo caso è 100.

Ora ci è stato chiesto di trovare il numero più grande in due diverse liste di
numeri. Per farlo, possiamo scegliere di duplicare il codice in Lista 10-1 e utilizzare
la stessa logica in due punti diversi del programma, come mostrato in Lista 10-2.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-02/src/main.rs}}
```

<span class="caption">Lista 10-2: Codice per trovare il numero più grande in *due*
liste di numeri</span>

Anche se questo codice funziona, duplicare il codice è noioso e può generare errori. Inoltre
dobbiamo ricordarci di aggiornare il codice in più punti quando vogliamo cambiarlo.

Per eliminare questa duplicazione, creeremo un'astrazione definendo una
funzione che opera su qualsiasi lista di interi passata in un parametro. Questa
soluzione rende il nostro codice più chiaro e ci permette di esprimere il concetto di trovare il
numero più grande in una lista in modo astratto.

In Lista 10-3, estraiamo il codice che trova il numero più grande in una
funzione chiamata `largest`. Poi chiamiamo la funzione per trovare il numero più grande
nelle due liste della Lista 10-2. Potremmo anche usare la funzione su qualsiasi altra
lista di valori `i32` che potremmo avere in futuro.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-03/src/main.rs:here}}
```

<span class="caption">Lista 10-3: Codice astratto per trovare il numero più grande
in due liste</span>

La funzione `largest` ha un parametro chiamato `list`, che rappresenta qualsiasi
fetta concreta di valori `i32` che potremmo passare nella funzione. Di conseguenza,
quando chiamiamo la funzione, il codice viene eseguito sui valori specifici che passiamo.

In sintesi, ecco i passaggi che abbiamo fatto per passare dal codice della Lista 10-2 alla
Lista 10-3:

1. Identifica il codice duplicato.
2. Estrai il codice duplicato nel corpo della funzione e specifica gli
   ingressi e i valori di ritorno di quel codice nella firma della funzione.
3. Aggiorna le due istanze di codice duplicato per chiamare la funzione invece.

Successivamente, utilizzeremo questi stessi passaggi con i generici per ridurre la duplicazione del codice. Nel
allo stesso modo che il corpo della funzione può operare su una `lista` astratta invece di valori specifici, i generici permettono al codice di operare su tipi astratti.

Ad esempio, diciamo che avevamo due funzioni: una che trova l'elemento più grande in una
fetta di valori `i32` e una che trova l'elemento più grande in una fetta di valori `char`.
Come potremmo eliminare quella duplicazione? Scopriamolo!
