## Percorsi per Fare Riferimento a un Elemento nell'Albero dei Moduli

Per mostrare a Rust dove trovare un elemento in un albero dei moduli, usiamo un percorso nello stesso modo in cui utilizziamo un percorso quando navighiamo in un filesystem. Per chiamare una funzione, dobbiamo conoscere il suo percorso.

Un percorso può assumere due forme:

* Un *percorso assoluto* è il percorso completo che inizia dalla radice di un crate; per il codice
  da un crate esterno, il percorso assoluto inizia con il nome del crate, e per
  il codice dal crate corrente, inizia con la parola letterale `crate`.
* Un *percorso relativo* inizia dal modulo corrente e utilizza `self`, `super` o
  un identificatore nel modulo corrente.

Sia i percorsi assoluti che quelli relativi sono seguiti da uno o più identificatori
separati da doppio due punti (`::`).

Tornando a Listing 7-1, supponiamo di voler chiamare la funzione `add_to_waitlist`.
Questo è lo stesso che chiedersi: qual è il percorso della funzione `add_to_waitlist`?
La lista 7-3 contiene la lista 7-1 con alcuni dei moduli e delle funzioni
rimossi.

Mostreremo due modi per chiamare la funzione `add_to_waitlist` da una nuova funzione,
`eat_at_restaurant`, definita nella radice del crate. Questi percorsi sono corretti, ma
c'è un altro problema rimanente che impedirà a questo esempio di compilarsi
così com'è. Spiegheremo perché tra un po'.

La funzione `eat_at_restaurant` fa parte dell'API pubblica del nostro crate di libreria, quindi
la contrassegniamo con la parola chiave `pub`. Nella sezione [“Esposizione dei Percorsi con la parola chiave `pub`”][pub]<!-- ignore -->, entreremo più nel dettaglio su `pub`.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-03/src/lib.rs}}
```

<span class="caption">Listing 7-3: Chiamare la funzione `add_to_waitlist` utilizzando
percorsi assoluti e relativi</span>

La prima volta che chiamiamo la funzione `add_to_waitlist` in `eat_at_restaurant`,
usiamo un percorso assoluto. La funzione `add_to_waitlist` è definita nello stesso
crate di `eat_at_restaurant`, il che significa che possiamo usare la parola chiave `crate` per
iniziare un percorso assoluto. Includiamo quindi ciascuno dei moduli successivi fino a
raggiungere `add_to_waitlist`. Puoi immaginare un filesystem con la stessa
struttura: specificheremo il percorso `/front_of_house/hosting/add_to_waitlist` per
eseguire il programma `add_to_waitlist`; usare il nome del `crate` per iniziare dalla
radice del crate è come usare `/` per iniziare dalla radice del filesystem nella tua shell.

La seconda volta che chiamiamo `add_to_waitlist` in `eat_at_restaurant`, usiamo un
percorso relativo. Il percorso inizia con `front_of_house`, il nome del modulo
definito allo stesso livello dell'albero dei moduli di `eat_at_restaurant`. Qui l'equivalente nel filesystem sarebbe usare il percorso
`front_of_house/hosting/add_to_waitlist`. Iniziare con un nome di modulo significa
che il percorso è relativo.

Scegliere se utilizzare un percorso relativo o assoluto è una decisione che prenderai
in base al tuo progetto, e dipende dal fatto che è più probabile che tu sposti il
codice di definizione dell'elemento separatamente o insieme al codice che utilizza
l'elemento. Ad esempio, se spostassimo il modulo `front_of_house` e la
funzione `eat_at_restaurant` in un modulo chiamato `customer_experience`, dovremmo
aggiornare il percorso assoluto a `add_to_waitlist`, ma il percorso relativo
sarebbe ancora valido. Tuttavia, se spostassimo la funzione `eat_at_restaurant`
separatamente in un modulo chiamato `dining`, il percorso assoluto alla chiamata
di `add_to_waitlist` rimarrebbe lo stesso, ma il percorso relativo dovrebbe essere
aggiornato. La nostra preferenza in generale è di specificare percorsi assoluti perché è
più probabile che vogliamo spostare le definizioni di codice e le chiamate degli elementi
indipendentemente l'una dall'altra.

Proviamo a compilare Listing 7-3 e scopriamo perché non si compilerà ancora! Gli
errori che otteniamo sono mostrati in Listing 7-4.

```console
{{#include ../listings/ch07-managing-growing-projects/listing-07-03/output.txt}}
```

<span class="caption">Listing 7-4: Errori del compilatore dalla costruzione del codice in
Listing 7-3</span>

I messaggi di errore dicono che il modulo `hosting` è privato. In altre parole, abbiamo
i percorsi corretti per il modulo `hosting` e la funzione `add_to_waitlist`,
ma Rust non ci permetterà di usarli poiché non ha accesso alle sezioni
private. In Rust, tutti gli elementi (funzioni, metodi, struct, enum,
moduli e costanti) sono privati per impostazione predefinita nei moduli parent. Se vuoi
rendere un elemento come una funzione o una struct privato, lo metti in un modulo.

Gli elementi in un modulo parent non possono utilizzare gli elementi privati all'interno dei
moduli child, ma gli elementi nei moduli child possono utilizzare gli elementi nei loro moduli ancestor. Questo è
perché i moduli child avvolgono e nascondono i loro dettagli di implementazione, ma i moduli child
possono vedere il contesto in cui sono definiti. Per continuare con il nostro
metafora, pensa alle regole di privacy come all'ufficio amministrativo di un
ristorante: quello che succede lì è privato per i clienti del ristorante, ma
i manager dell'ufficio possono vedere e fare tutto nel ristorante che gestiscono.

Rust ha scelto di far funzionare il sistema di moduli in questo modo in modo che nascondere i dettagli interni
dell'implementazione sia l'impostazione predefinita. In questo modo, sai quali parti del
codice interno puoi cambiare senza rompere il codice esterno. Tuttavia, Rust ti dà la possibilità
di esporre le parti interne del codice dei moduli child ai moduli ancestor esterni
usando la parola chiave `pub` per rendere un elemento pubblico.

### Esposizione dei Percorsi con la parola chiave `pub`

Torniamo all'errore nella lista 7-4 che ci diceva che il modulo `hosting` è
privato. Vogliamo che la funzione `eat_at_restaurant` nel modulo parent abbia
accesso alla funzione `add_to_waitlist` nel modulo child, quindi contrassegniamo il
modulo `hosting` con la parola chiave `pub`, come mostrato in Listing 7-5.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-05/src/lib.rs}}
```

<span class="caption">Listing 7-5: Dichiarare il modulo `hosting` come `pub` per
usarlo da `eat_at_restaurant`</span>

Sfortunatamente, il codice nella lista 7-5 genera ancora errori del compilatore, come
mostrato nella lista 7-6.

```console
{{#include ../listings/ch07-managing-growing-projects/listing-07-05/output.txt}}
```

<span class="caption">Listing 7-6: Errori del compilatore dalla costruzione del codice in
Listing 7-5</span>

Cosa è successo? Aggiungere la parola chiave `pub` davanti a `mod hosting` rende il
modulo pubblico. Con questa modifica, se possiamo accedere a `front_of_house`, possiamo
accedere a `hosting`. Ma i *contenuti* di `hosting` sono ancora privati; rendere il
modulo pubblico non rende i suoi contenuti pubblici. La parola chiave `pub` su un modulo
permette solo al codice nei suoi moduli ancestor di riferirsi ad esso, non di accedere
al suo codice interno. Poiché i moduli sono contenitori, non c'è molto che possiamo fare
rendendo solo il modulo pubblico; dobbiamo andare oltre e scegliere di rendere uno o più
degli elementi all'interno del modulo pubblici.

Gli errori nella lista 7-6 dicono che la funzione `add_to_waitlist` è privata.
Le regole di privacy si applicano a struct, enum, funzioni e metodi così come
ai moduli.

Facciamo anche la funzione `add_to_waitlist` pubblica aggiungendo la parola
chiave `pub` prima della sua definizione, come nella lista 7-7.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-07/src/lib.rs}}
```

<span class="caption">Listing 7-7: Aggiungere la parola chiave `pub` a `mod hosting`
e `fn add_to_waitlist` ci permette di chiamare la funzione da
`eat_at_restaurant`</span>

Ora il codice si compilerà! Per capire perché l'aggiunta della parola chiave `pub` ci permette di
usare questi percorsi in `eat_at_restaurant` rispetto alle regole di privacy, diamo un'occhiata
ai percorsi assoluti e relativi.

Nel percorso assoluto, partiamo da `crate`, la radice dell'albero dei moduli del nostro crate.
Il modulo `front_of_house` è definito nella radice del crate. Anche se
`front_of_house` non è pubblico, poiché la funzione `eat_at_restaurant` è
definita nello stesso modulo di `front_of_house` (cioè, `eat_at_restaurant`
e `front_of_house` sono fratelli), possiamo fare riferimento a `front_of_house` da
`eat_at_restaurant`. Successivamente c'è il modulo `hosting` contrassegnato con `pub`. Possiamo
accedere al modulo parent di `hosting`, quindi possiamo accedere a `hosting`. Infine, la
funzione `add_to_waitlist` è contrassegnata con `pub` e possiamo accedere al suo modulo parent, quindi
questa chiamata di funzione funziona!

Nel percorso relativo, la logica è la stessa del percorso assoluto tranne per il
primo passo: piuttosto che iniziare dalla radice del crate, il percorso inizia da
`front_of_house`. Il modulo `front_of_house` è definito all'interno dello stesso modulo
di `eat_at_restaurant`, quindi il percorso relativo che inizia dal modulo in cui
`eat_at_restaurant` è definito funziona. Poi, poiché `hosting` e
`add_to_waitlist` sono contrassegnati con `pub`, il resto del percorso funziona, e
questa chiamata di funzione è valida!

Se hai intenzione di condividere il tuo crate di libreria in modo che altri progetti possano
utilizzare il tuo codice, la tua API pubblica è il tuo contratto con gli utenti del tuo crate che determina come
possono interagire con il tuo codice. Ci sono molte considerazioni sulla gestione delle
modifiche alla tua API pubblica per rendere più facile per le persone dipendere dal tuo
crate. Queste considerazioni sono fuori dal campo di applicazione di questo libro; se sei
interessato a questo argomento, consulta [Le Linee Guida API di Rust][api-guidelines].

> #### Le Migliori Pratiche per i Pacchetti con un Binario e una Libreria
>
> Abbiamo menzionato che un pacchetto può contenere sia una radice del crate binario *src/main.rs*
> sia una radice del crate di libreria *src/lib.rs*, e che entrambi i crate avranno
> il nome del pacchetto per impostazione predefinita. Tipicamente, i pacchetti con questo schema
> di contenere sia una libreria che un crate binario avranno solo il codice necessario nel
> crate binario per iniziare un eseguibile che chiama il codice all'interno del crate di libreria.
> Questo permette ad altri progetti di beneficiare della maggior parte della funzionalità che
> il pacchetto fornisce poiché il codice del crate di libreria può essere condiviso.
>
> L'albero dei moduli dovrebbe essere definito in *src/lib.rs*. Poi, qualsiasi elemento pubblico può
> essere usato nel crate binario iniziando i percorsi con il nome del pacchetto.
> Il crate binario diventa un utente del crate di libreria proprio come farebbe un crate completamente
> esterno: può solo usare l'API pubblica. Questo ti aiuta a progettare una buona API; non solo sei l'autore,
> sei anche un cliente!
>
> Nel [Capitolo 12][ch12]<!-- ignore -->, dimostreremo questa pratica organizzativa
> con un programma da linea di comando che conterrà sia un crate binario
> che un crate di libreria.

### Iniziare Percorsi Relativi con `super`

Possiamo costruire percorsi relativi che iniziano nel modulo parent, piuttosto che
nel modulo corrente o nella radice del crate, utilizzando `super` all'inizio del
percorso. Questo è come iniziare un percorso filesystem con la sintassi `..`. Usare
`super` ci permette di fare riferimento a un elemento che sappiamo essere nel modulo parent,
il che può rendere più facile la riorganizzazione dell'albero dei moduli quando il modulo è strettamente
relato al parent ma il parent potrebbe essere spostato altrove nell'albero dei moduli un giorno.

Considera il codice in Listing 7-8 che modella la situazione in cui uno chef
corregge un ordine errato e lo porta personalmente al cliente. La
funzione `fix_incorrect_order` definita nel modulo `back_of_house` chiama la
funzione `deliver_order` definita nel modulo parent specificando il percorso a
`deliver_order`, iniziando con `super`.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-08/src/lib.rs}}
```

<span class="caption">Listing 7-8: Chiamare una funzione utilizzando un percorso relativo
che inizia con `super`</span>

La funzione `fix_incorrect_order` si trova nel modulo `back_of_house`, quindi possiamo
usare `super` per andare al modulo parent di `back_of_house`, che in questo caso
è `crate`, la radice. Da lì, cerchiamo `deliver_order` e lo troviamo.
Successo! Pensiamo che il modulo `back_of_house` e la funzione `deliver_order`
siano probabilmente destinati a rimanere nella stessa relazione tra di loro e a
essere spostati insieme se un giorno decidessimo di riorganizzare l'albero dei moduli
del crate. Pertanto, abbiamo usato `super` in modo da avere meno luoghi in cui aggiornare
il codice in futuro se questo codice venisse spostato in un altro modulo.

### Rendere Pubblici Structs e Enums

Possiamo anche usare `pub` per designare structs e enums come pubblici, ma ci
sono alcuni dettagli aggiuntivi nell'uso di `pub` con structs e enums. Se usiamo `pub`
prima di una definizione struct, rendiamo la struct pubblica, ma i campi della struct
saranno ancora privati. Possiamo rendere ogni campo pubblico o meno caso per caso. Nella
lista 7-9, abbiamo definito una struct pubblica `back_of_house::Breakfast`
con un campo `toast` pubblico ma un campo `seasonal_fruit` privato. Questo modella
il caso in un ristorante in cui il cliente può scegliere il tipo di pane che
accompagna un pasto, ma il cuoco decide quale frutta accompagna il pasto in base a ciò che è
di stagione e disponibile in magazzino. La frutta disponibile cambia rapidamente, quindi
i clienti non possono scegliere la frutta o nemmeno vedere quale frutta riceveranno.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-09/src/lib.rs}}
```

<span class="caption">Listing 7-9: Una struct con alcuni campi pubblici e alcuni
campi privati</span>

Poiché il campo `toast` nella struct `back_of_house::Breakfast` è pubblico,
in `eat_at_restaurant` possiamo scrivere e leggere il campo `toast` usando la notazione col
punto. Nota che non possiamo usare il campo `seasonal_fruit` in
`eat_at_restaurant`, perché `seasonal_fruit` è privato. Prova a togliere il commento alla
linea che modifica il valore del campo `seasonal_fruit` per vedere quale errore ottieni!

Nota anche che poiché `back_of_house::Breakfast` ha un campo privato, la
struct deve fornire una funzione associata pubblica che costruisca un'istanza di `Breakfast`
(l'abbiamo chiamata `summer` qui). Se `Breakfast` non avesse una tale funzione, non
potremmo creare un'istanza di `Breakfast` in `eat_at_restaurant` perché non
potremmo impostare il valore del campo privato `seasonal_fruit` in `eat_at_restaurant`.

Al contrario, se rendiamo un enum pubblico, tutte le sue varianti diventano pubbliche. Abbiamo
bisogno solo della `pub` davanti alla parola chiave `enum`, come mostrato in Listing 7-10.

<span class="filename">Nome del file: src/lib.rs</span>

```rust```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-10/src/lib.rs}}
```

<span class="caption">Listing 7-10: Designare un enum come pubblico rende tutte le sue
varianti pubbliche</span>

Poiché abbiamo reso l'enum `Appetizer` pubblico, possiamo usare le varianti `Soup` e `Salad` in `eat_at_restaurant`.

Gli enum non sono molto utili a meno che le loro varianti non siano pubbliche; sarebbe fastidioso
dover annotare tutte le varianti enum con `pub` in ogni caso, quindi l'impostazione predefinita per le varianti enum è di essere pubblica. Le struct sono spesso utili anche senza che i loro campi siano pubblici, quindi i campi delle struct seguono la regola generale di essere privati per impostazione predefinita, a meno che non siano annotati con `pub`.

C'è un'altra situazione che coinvolge `pub` che non abbiamo coperto, ed è la nostra ultima funzione del sistema dei moduli: la parola chiave `use`. Tratteremo `use` da sola prima e poi mostreremo come combinare `pub` e `use`.

[pub]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html#exposing-paths-with-the-pub-keyword
[api-guidelines]: https://rust-lang.github.io/api-guidelines/
[ch12]: ch12-00-an-io-project.html
