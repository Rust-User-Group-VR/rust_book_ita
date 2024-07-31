# Tipi Generici, Traits e Lifetimes

Ogni linguaggio di programmazione ha strumenti per gestire efficacemente la duplicazione
di concetti. In Rust, uno di questi strumenti è rappresentato dai *generics*: sostituti astratti per
tipi concreti o altre proprietà. Possiamo esprimere il comportamento dei generics o come essi si relazionano ad altri generics senza sapere cosa ci sarà al loro posto durante la compilazione e l'esecuzione del codice.

Le funzioni possono prendere parametri di qualche tipo generico, invece di un tipo concreto
come `i32` o `String`, nello stesso modo in cui prendono parametri con valori sconosciuti per eseguire lo stesso codice su più valori concreti. In effetti, abbiamo già usato i generics nel Capitolo 6 con `Option<T>`, nel Capitolo 8 con `Vec<T>` e `HashMap<K, V>`, e nel Capitolo 9 con `Result<T, E>`. In questo capitolo, esplorerai come definire i tuoi tipi, funzioni e metodi con i generics!

Prima esamineremo come estrarre una funzione per ridurre la duplicazione del codice. Utilizzeremo
poi la stessa tecnica per creare una funzione generica partendo da due funzioni che differiscono solo nei tipi dei loro parametri. Spiegheremo anche come usare i tipi generici nelle definizioni di struct ed enum.

Successivamente imparerai come usare i *traits* per definire il comportamento in modo generico. Puoi combinare traits con tipi generici per vincolare un tipo generico ad accettare solo quei tipi che hanno un comportamento particolare, anziché qualsiasi tipo.

Infine, discuteremo dei *lifetimes*: una varietà di generics che forniscono al compilatore informazioni su come le references si relazionano tra loro. I lifetimes ci permettono di fornire al compilatore informazioni sufficienti sui valori presi in prestito in modo che possa garantire che le references saranno valide in più situazioni rispetto a quanto potrebbe fare senza il nostro aiuto.

## Rimozione della duplicità estraendo una funzione

I generics ci permettono di sostituire tipi specifici con un segnaposto che rappresenta più tipi per rimuovere la duplicazione del codice. Prima di addentrarci nella sintassi dei generics, vediamo come rimuovere la duplicazione in modo che non implichi tipi generici estraendo una funzione che sostituisca valori specifici con un segnaposto che rappresenta più valori. Useremo quindi la stessa tecnica per estrarre una funzione generica! Vedendo come riconoscere il codice duplicato che puoi estrarre in una funzione, inizierai a riconoscere il codice duplicato che può usare i generics.

Inizieremo con il breve programma nella Listing 10-1 che trova il numero più grande in una lista.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-01/src/main.rs:here}}
```

<span class="caption">Listing 10-1: Trovare il numero più grande in una lista di
numeri</span>

Memorizziamo una lista di interi nella variabile `number_list` e mettiamo
un riferimento al primo numero della lista in una variabile chiamata `largest`. Iteriamo quindi
attraverso tutti i numeri nella lista, e se il numero corrente è maggiore del
numero memorizzato in `largest`, sostituiamo il riferimento in quella variabile.
Tuttavia, se il numero corrente è minore o uguale al numero più grande visto
finora, la variabile non cambia e il codice passa al numero successivo
nella lista. Dopo aver considerato tutti i numeri nella lista, `largest`
dovrebbe riferirsi al numero più grande, che in questo caso è 100.

Ora ci è stato chiesto di trovare il numero più grande in due diverse liste di
numeri. Per farlo, possiamo scegliere di duplicare il codice nella Listing 10-1 e usare
la stessa logica in due posti diversi nel programma, come mostrato nella Listing 10-2.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-02/src/main.rs}}
```

<span class="caption">Listing 10-2: Codice per trovare il numero più grande in
*due* liste di numeri</span>

Sebbene questo codice funzioni, duplicare il codice è tedioso e soggetto ad errori.
Dobbiamo anche ricordarci di aggiornare il codice in più punti quando vogliamo cambiarlo.

Per eliminare questa duplicazione, creeremo un'astrazione definendo una funzione
che opera su qualsiasi lista di interi passata come parametro. Questa
soluzione rende il nostro codice più chiaro e ci permette di esprimere il
concetto di trovare il numero più grande in una lista in modo astratto.

Nella Listing 10-3, estraiamo il codice che trova il numero più grande in una
funzione chiamata `largest`. Chiameremo poi la funzione per trovare il numero più
grande nelle due liste della Listing 10-2. Potremmo anche usare la funzione
su qualsiasi altra lista di valori `i32` che potremmo avere in futuro.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-03/src/main.rs:here}}
```

<span class="caption">Listing 10-3: Codice astratto per trovare il numero più
grande in due liste</span>

La funzione `largest` ha un parametro chiamato `list`, che rappresenta qualsiasi
slice concreta di valori `i32` che potremmo passare alla funzione. Di conseguenza,
quando chiamiamo la funzione, il codice viene eseguito sui valori specifici che passiamo.

In sintesi, ecco i passaggi che abbiamo seguito per cambiare il codice da Listing 10-2 a Listing 10-3:

1. Identificare il codice duplicato.
1. Estrarre il codice duplicato nel corpo della funzione e specificare gli
   input e i valori di ritorno di quel codice nella firma della funzione.
1. Aggiornare le due istanze di codice duplicato per chiamare la funzione invece.

Successivamente, useremo questi stessi passaggi con i generics per ridurre la duplicazione del codice.
Nello stesso modo in cui il corpo della funzione può operare su un `list` astratto anziché su valori specifici, i generics permettono al codice di operare su tipi astratti.

Ad esempio, supponiamo di avere due funzioni: una che trova l'elemento più grande in una slice di
valori `i32` e una che trova l'elemento più grande in una slice di valori `char`.
Come potremmo eliminare quella duplicazione? Scopriamolo!

