## Memorizzare chiavi con valori associati in Hash Map

L'ultima delle nostre raccolte comuni è la *hash map*. Il tipo `HashMap<K, V>`
memorizza una mappatura di chiavi di tipo `K` a valori di tipo `V` utilizzando una
*funzione di hashing*, che determina come posiziona queste chiavi e valori in
memoria. Molti linguaggi di programmazione supportano questo tipo di struttura dati, ma
spesso usano un nome diverso, come hash, map, object, hash table,
dictionary, o associative array, solo per citarne alcuni.

Le hash map sono utili quando si vuole cercare dati non utilizzando un indice, come
si può fare con i vettori, ma utilizzando una chiave che può essere di qualsiasi tipo. Ad esempio,
in un gioco, potresti tenere traccia del punteggio di ciascuna squadra in una hash map in cui
ogni chiave è il nome di una squadra e i valori sono i punteggi di ciascuna squadra. Dato un nome di squadra, puoi recuperare il suo punteggio.

Esamineremo l'API di base delle hash map in questa sezione, ma molte altre funzionalità
si trovano nelle funzioni definite su `HashMap<K, V>` dalla libreria standard.
Come sempre, consulta la documentazione della libreria standard per ulteriori informazioni.

### Creare una nuova Hash Map

Un modo per creare una hash map vuota è utilizzare `new` e aggiungere elementi con
`insert`. In elenco 8-20, stiamo tenendo traccia dei punteggi di due squadre i cui
nominativi sono *Blu* e *Giallo*. La squadra Blu inizia con 10 punti, e la squadra Gialla inizia con 50.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-20/src/main.rs:here}}
```

<span class="caption">Elenco 8-20: Creazione di una nuova hash map e inserimento di alcune
chiavi e valori</span>

Nota che dobbiamo prima `use` l'`HashMap` dalla parte delle collezioni di
la libreria standard. Delle nostre tre raccolte comuni, questa è la meno
spesso utilizzata, quindi non è inclusa nelle funzionalità portate nello scope
automaticamente nel preludio. Le hash map hanno anche meno supporto dalla
libreria standard; non c'è ad esempio un macro integrato per costruirle.

Proprio come i vettori, le hash map memorizzano i loro dati nel heap. Questa `HashMap` ha
chiavi di tipo `String` e valori di tipo `i32`. Come i vettori, le hash map sono
omogenee: tutte le chiavi devono avere lo stesso tipo tra loro, e tutti
i valori devono avere lo stesso tipo.

### Accesso ai Valori in una Hash Map

Possiamo ottenere un valore dalla hash map fornendo la sua chiave al metodo `get`,
come mostrato nell'Elenco 8-21.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-21/src/main.rs:here}}
```

<span class="caption">Elenco 8-21: Accesso al punteggio per la squadra Blu
memorizzato nella hash map</span>

Qui, `score` avrà il valore che è associato alla squadra Blu, e il
risultato sarà `10`. Il metodo `get` restituisce un `Option<&V>`; se non c'è nessun
valore per quella chiave nella hash map, `get` restituirà `None`. Questo programma
gestisce l'`Option` chiamando `copied` per ottenere un `Option<i32>` piuttosto che un
`Option<&i32>`, poi `unwrap_or` per impostare `score` a zero se `scores` non
ha un'entrata per la chiave.

Possiamo iterare su ogni coppia chiave/valore in una hash map in modo simile a come
faremmo con i vettori, utilizzando un ciclo `for`:

```rust
{{#rustdoc_include ../listings/ch08-common-collections/no-listing-03-iterate-over-hashmap/src/main.rs:here}}
```

Questo codice stamperà ogni coppia in un ordine arbitrario:

```testo
Giallo: 50
Blu: 10
```

### Hash Map e Ownership

Per i tipi che implementano il trait `Copy`, come `i32`, i valori vengono copiati
nella hash map. Per i valori di tipo `String`, i valori saranno spostati e
la hash map sarà il proprietario di quei valori, come dimostrato nell'Elenco 8-22.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-22/src/main.rs:here}}
```

<span class="caption">Elenco 8-22: Dimostrazione che le chiavi e i valori sono posseduti da
la hash map una volta che sono inseriti</span>

Non siamo in grado di utilizzare le variabili `field_name` e `field_value` dopo
che sono state spostate nella hash map con la chiamata a `insert`.

Se inseriamo riferimenti a valori nella hash map, i valori non verranno spostati
nella hash map. I valori a cui puntano i riferimenti devono essere validi per almeno
finché la hash map è valida. Parleremo di più di questi problemi nel
[“Validating References with
Lifetimes”][validating-references-with-lifetimes]<!-- ignore --> sezione nel
Capitolo 10.

### Aggiornare una Hash Map

Sebbene il numero di coppie chiave e valore sia incrementabile, ogni chiave unica può
avere solo un valore associato ad essa in un dato momento (ma non viceversa: ad esempio,
sia la squadra Blu che la squadra Gialla potrebbero avere il valore 10 memorizzato in
la hash map `scores`).

Quando si vuole cambiare i dati in una hash map, bisogna decidere come
gestire il caso in cui una chiave ha già un valore assegnato. Si potrebbe sostituire il
vecchio valore con il nuovo valore, ignorando completamente il vecchio valore. Si potrebbe
mantenere il vecchio valore e ignorare il nuovo valore, aggiungendo solo il nuovo valore se la
chiave *non* ha già un valore. Oppure si potrebbe combinare il vecchio valore e il
nuovo valore. Vediamo come fare ciascuna di queste cose!

#### Sovrascrivere un Valore

Se inseriamo una chiave e un valore in una hash map e poi inseriamo la stessa chiave
con un valore diverso, il valore associato a quella chiave verrà sostituito.
Anche se il codice nell'Elenco 8-23 chiama `insert` due volte, la hash map conterrà
solo una coppia chiave/valore perché stiamo inserendo il valore per la chiave della squadra Blu entrambe le volte.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-23/src/main.rs:here}}
```

<span class="caption">Elenco 8-23: Sostituzione di un valore memorizzato con una particolare
chiave</span>

Questo codice stamperà `{"Blu": 25}`. Il valore originale di `10` è stato
sovrascritto.

<!-- Vecchie intestazioni. Non rimuovere o i link potrebbero rompersi. -->
<a id="only-inserting-a-value-if-the-key-has-no-value"></a>

#### Aggiungere una Chiave e un Valore Solo Se una Chiave Non è Presente

È comune controllare se una particolare chiave esiste già nella hash map
con un valore e poi prendere le seguenti azioni: se la chiave esiste nella hash
map, il valore esistente dovrebbe rimanere così com'è. Se la chiave non esiste,
inserirlo e un valore per esso.

Le hash map hanno una speciale API per questo chiamata `entry` che prende la chiave che
vuoi controllare come parametro. Il valore di ritorno del metodo `entry` è un enum
chiamato `Entry` che rappresenta un valore che potrebbe esistere o meno. Diciamo
che vogliamo controllare se la chiave per la squadra Gialla ha un valore associato
ad essa. Se non lo fa, vogliamo inserire il valore 50, e lo stesso per la
squadra Blu. Utilizzando l'API `entry`, il codice somiglia all'Elenco 8-24.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-24/src/main.rs:here}}
```

<span class="caption">Elenco 8-24: Uso del metodo `entry` per inserire solo se
la chiave non ha già un valore</span>
Il metodo `or_insert` su `Entry` è definito per restituire un riferimento mutabile al
valore per la chiave `Entry` corrispondente se quella chiave esiste, e in caso contrario,
inserisce il parametro come nuovo valore per questa chiave e restituisce un riferimento mutabile
al nuovo valore. Questa tecnica è molto più pulita rispetto a scrivere la
logica da noi stessi e, in aggiunta, gioca più bene con il Borrow Checker.

Eseguendo il codice in Elenco 8-24 si stamperà `{"Yellow": 50, "Blue": 10}`. Il
prima chiamata a `entry` inserirà la chiave per la squadra Gialla con il valore
50 perché la squadra Gialla non ha già un valore. La seconda chiamata a
`entry` non cambierà la mappa hash perché la squadra Blu ha già il
valore 10.

#### Aggiornamento di un valore basato sul vecchio valore

Un altro caso d'uso comune per le mappe hash è guardare il valore di una chiave e poi
aggiornarlo in base al vecchio valore. Per esempio, l'Elenco 8-25 mostra il codice che
conta quante volte ogni parola appare in un certo testo. Utilizziamo una mappa hash con
le parole come chiavi e incrementiamo il valore per tenere traccia di quante volte abbiamo
visto quella parola. Se è la prima volta che vediamo una parola, inseriamo prima
il valore 0.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-25/src/main.rs:here}}
```

<span class="caption">Elenco 8-25: Conteggio delle occorrenze di parole utilizzando una mappa
hash che memorizza parole e conteggi</span>

Questo codice stamperà `{"world": 2, "hello": 1, "wonderful": 1}`. Potresti vedere
le stesse coppie chiave / valore stampate in un ordine diverso: ricorda dalla
sezione ["Accedere ai valori in una mappa hash"][access]<!-- ignore --> che
iterare su una mappa hash avviene in un ordine arbitrario.

Il metodo `split_whitespace` restituisce un iteratore su sottosettori, separati da
spazi bianchi, del valore in `text`. Il metodo `or_insert` restituisce un riferimento
mutabile (`&mut V`) al valore per la chiave specificata. Qui memorizziamo quello
riferimento mutabile nella variabile `count`, quindi per assegnare a quel valore,
dobbiamo prima dereferenziare `count` usando l'asterisco (`*`). Il riferimento
mutabile esce dallo scope alla fine del ciclo `for`, quindi tutte queste
modifiche sono sicure e consentite dalle regole di prestito.

### Funzioni di Hashing

Per impostazione predefinita, `HashMap` utilizza una funzione di hashing chiamata *SipHash* che può fornire
resistenza ai Denial of Service (DoS) attacchi che coinvolgono tabelle hash[^siphash]<!-- ignore -->. Questo non è l'algoritmo di hashing
più veloce disponibile, ma il compromesso per una migliore sicurezza che viene con il calo delle prestazioni ne vale la pena. Se profilate il vostro codice e scoprite che la funzione hash predefinita è troppo lenta per i vostri scopi, potete passare a un'altra funzione
specificando un hasher diverso. Un *hasher* è un tipo che implementa il
tratto `BuildHasher`. Parleremo dei tratti e di come implementarli nel Capitolo 10. Non
devi per forza implementare il tuo hasher da zero; [crates.io](https://crates.io/)<!-- ignore --> ha librerie condivise dagli
altri utenti Rust che forniscono hasher che implementano molti algoritmi di hashing
comuni.

[^siphash]: [https://en.wikipedia.org/wiki/SipHash](https://en.wikipedia.org/wiki/SipHash)

## Sommario

Vettori, stringhe e mappe hash forniranno una grande quantità di funzionalità
necessarie nei programmi quando c'è bisogno di memorizzare, accedere e modificare dati. Ecco
alcuni esercizi che ora dovresti essere pronto a risolvere:

* Dato un elenco di interi, usa un vettore e restituisci la mediana (quando ordinati,
  il valore nella posizione centrale) e la moda (il valore che si verifica più spesso;
  una mappa hash sarà utile qui) dell'elenco.
* Convertire le stringhe in pig latin. La prima consonante di ogni parola viene spostata in
  alla fine della parola e viene aggiunto “ay”, quindi “first” diventa “irst-fay.” Parole
  che iniziano con una vocale hanno “hay” aggiunto alla fine invece (“apple” diventa
  “apple-hay”). Tenete a mente i dettagli sulla codifica UTF-8!
* Usando una mappa hash e vettori, crea un'interfaccia di testo per consentire a un utente di aggiungere
  i nomi dei dipendenti a un dipartimento in un'azienda. Ad esempio, “Aggiungi Sally a
  Ingegneria” o “Aggiungi Amir alle Vendite.” Poi lascia che l'utente recuperi un elenco di tutte
  le persone in un dipartimento o tutte le persone nell'azienda per dipartimento, ordinate
  alfabeticamente.

La documentazione dell'API della libreria standard descrive i metodi che i vettori, stringhe,
e le mappe hash hanno che saranno utili per questi esercizi!

Stiamo entrando in programmi più complessi in cui le operazioni possono fallire, quindi, è
il momento perfetto per discutere la gestione degli errori. Lo faremo subito dopo!

[validating-references-with-lifetimes]:
ch10-03-lifetime-syntax.html#validating-references-with-lifetimes
[access]: #accessing-values-in-a-hash-map

