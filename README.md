# Izzivi in ​​priložnosti pri razvoju večplatformnih mobilnih aplikacij: študija primera mobilne aplikacije za turno smučanje


### Ideja

Ideja diplomske naloge je razviti večplatformno mobilno aplikacijo, ki bo namenjena turnim smučarjem. Aplikacija bo služila kot informativno in praktično orodje pri načrtovanju in izvajanju smučarskih tur. Glavna funkcionalnost aplikacije bo bila načrtovanje ture na mobilni napravi s hkratnim obveščanjem o morebitnih nevarnostih v hribih glede na določene parametre (vremenska napoved, naklon ter pozicija izbrane poti po hribu, snežne razmere,...) ter dokumentiranje ture z aktivnim sledenjem s pomočjo GPS-a in senzorjev ki zaznavajo gibanje mobilne naprave. Uporabnik si bo ustvaril svoj profil kjer bo imel shranjene vse dokumentirane ture, ki jih bo lahko delil z drugimi uporabniki aplikacije ter hkrati videl dokumentirane ture drugih. Ideja je bila da bi imeli uporabniki ki so začetniki na področju turne smuke dokumentirane turne smuke izkušenih smučarjev ter se lahko tako odločali kam se odpraviti na turo. Te dokumentiranje ture bi imele nekakšen indikator zahtevnosti ter dodatna priporočila, da bi se lahko drugi uporabniki odločali glede na svoje sposobnosti.


### Uvod

Zadnje čase postaja turna smuka vse bolj popularna in vse več ljudi brez kakršnihkoli izkušenj na terenu izven urejenih smučišč se podaja na zahtevne in nepredvidljive terene naših gora. Tako začetniki potrebujejo nekoga, ki je že bolj izkušen in pozna teren na katerega se odpravljajo ali pa tvegajo in se na turo odpravijo sami. 

Tukaj pride do izraza naša ideja o razvoju mobilne aplikacije za turne smučarje. Ta aplikacija bi omogočala načrtovanje ture s pomočjo mobilne naprave, ki bi hkrati spremljala morebitne nevarnosti v hribih glede na parametre, kot so vremenska napoved, naklon, pozicija izbrane poti ter seveda snežne razmere. Aplikacija bi omogočala tudi dokumentiranje same ture z aktivnim sledenjem s pomočjo GPS-a in senzojev, ki zaznavajo gibanje mobilne naprave.

Vendar pa je aplikacija namenjena tudi izkušenim smučarjem, ki lahko svoje dokumentirane ture delijo z drugimi uporabniki aplikacije. Tako bi lahko začetniki in drugi smučarji videli dokumentirane turne smuke izkušenih smučarjev ter se lahko na ta način odločili, kam se odpraviti na turo. Te dokumentirane ture bi imele tudi zabeležen nivo zahtevnosti ter dodatna priporočila, da bi se lahko drugi uporabniki odločali glede na svoje sposobnosti.

Na ta način lahko aplikacija pripomore k varnejšemu in nekoliko bolj sproščenenm turnemu smučanju, hkrati pa omogoča deljenje izkušenj in znanja med uporabniki aplikacije. Tako se lahko smučarji in smučarke počutijo bolj samozavestne pri izbiri ture in se izognejo nevarnim situacijam, kar pa je ključnega pomeni pri tem športu.


### Uporabniške vloge

- Neregistriran uporabnik: Se lahko registrira ali prijavi v aplikacijo
- Registriran uporabnik: Lahko uporablja vse funkcionalnosti aplikacije


### Diagrami primerov uporabe

- TODO


### Funkcionalne zahteve

#### Registracija

Povzetek funkcionalnosti:

Nov uporabnik se lahko registrira v aplikacijo s pomočjo Google računa ali pa si ustvari račun z veljavnim e-mail naslovom ter varnim geslom.

Osnovni tok

1. Neregistriran uporabnik odpre mobilno aplikacijo
2. Prikaže se mu zaslonska maska z izbiro registracije ali prijave v svoj račun
3. Uporabnik izbere registracijo in prikaže se mu zaslonska maska za registracijo
4. Uporabnik lahko izbere način prijave z Google računom ali pa vnese veljaven e-mail naslov ter geslo
5. Podatki se shranijo v podatkovno bazo
6. Uporabnik je preusmerjen na začetno stran


#### Prijava

Povzetek funkcionalnosti:

Registriran uporabnik se lahko z uporabo obstoječega računa prijavi v aplikacijo.

Osnovni tok:

1. Registiran uporabnik odpre mobilno aplikacijo
2. Prikaže se mu zaslonska maska z izbiro registracije ali prijave v svoj račun
3. Uporabnik izbere prijavo in prikaže se mu zaslonska maska za prijavo
4. Uporabnik klikne na opcijo "Prijavi se s svojim Google računom" ali pa vnese e-mail naslov in geslo
5. Podatki se verificirajo
6. Uporabnik je preusmerjen na začetno stran


#### Načrtovanje ture 

Povzetek funkcionalnosti:

Registriran uporabnik ima možnost načrtovanja ture s pomočjo z zemljevida in orodja za izrisovanje poti.

Osnovni tok:

1. Uporabnik se izbere zaslonsko masko z zemljevidom
2. Uporabnik klikne na gumb "Načrtuj turo", nad zemljevidom se prikaže orodje za načrtovanje ture
3. Uporabnik na zemljevid začrtuje pot z dodajanjem markerjev na zemljevid, aplikacija pa med markerji izriše črto, ki predstavlja pot
4. Uporabnik zaključi načrtovanje ture s klikom na gumb "Končano"
5. Aplikacija shrani začrtano pot in uporabniku prikaže informacije o zarisani poti



#### Obveščanje o nevarnostih v gorah

Povzetek funkcionalnosti:

Aplikacija s pomočjo zaznavanja lokacije uporabnika, shranjene vremenske napovedi dneva ter snežnih razmer uporabnika obvešča o trenutnih in splošnih nevarnostih v gorah.

Osnovni tok:

1. Uporabnik se z mobilno napravo odpravi v gore
2. Aplikacija zazna hojo v hribe in začne periodično preverjati lokacijo uporabnika
3. Aplikacija s pomočjo lokacije, napovedi dneva in snežnih razmer ugotovi ali veljajo kakršnekoli trenutne nevarnosti za uporabnikovo lokacijo
4. Aplikacija v primeru da veljajo trenutne nevarnosti uporabniku pošlje obvestilo z opisom trenutne nevarnosti

Alternativni tok:

1. Uporabnik načrtuje turo in zariše določeno pot ter pritisne gumb "Končano"
2. Aplikacija za koordinate izbrane poti preveri kakšne nevarnosti bi lahko pretile na izbrani dan ture na podoben način kot pri osnovnem toku za posamezno lokacijo uporabnika
3. Aplikacija dobljene nevarnosti prikaže na zemljevidu nad začrtano potjo na koordinatah kjer veljajo


#### Dokumentiranje tur

Povzetek funkcionalnosti:

Registriran uporabnik ima možnost dokumentiranja ture, kar pomeni da aplikacija aktivno beleži in shranjuje trenutno lokacijo.

Osnovni tok:

1. Uporabnik gre na zaslonsko masko zemljevida in klikne na gumb "Sledi"
2. V primeru da je uporabnik aplikaciji že dal dovoljenje za dostop do lokacije, aplikacija začne beležiti trenutno lokacijo, drugače se uporabniku prikaže pojavno okno z zahtevo po dovoljenju za dostop do lokacije
3. Aplikacija sproti izrisuje opravljeno pot na zemljevidu
4. Uporabnik klikne na gumb "Končaj"
5. Aplikacija preneha z aktivnim beleženjem trenutne lokacije in uporabniku prikaže povzetek beležene ture
6. Uporabnik lahko nato turo shrani s klikom na gumb "Shrani" ali pa zavrže s klikom na gumb "Zavrzi"


#### Pregledovanje shranjenih tur

Povzetek funkcionalnosti: 

Registriran uporabnik lahko pregleduje svoje shranjene ture na strani "Moje ture"

Osnovni tok:

1. Uporabnik v aplikaciji izbere razdelek "Moje ture"
2. Aplikacija prikaže seznam uporabnikovih shranjenih tur
3. Uporabnik pregleduje ture


#### Ogled podrobnosti shranjenih tur

Povzetek funkcionalnosti:

Registriran uporabnik si lahko ogleda podrobnosti posameznih shranjenih tur, kot na primer analitika (dolžina ture, povprečna hitrost, opravljena višinska razlika,...), opis ture, težavnost, priporočila ter izrisana pot na zemljevidu.

Osnovni tok:

1. Uporabnik na razdelku "Moje ture" pregleduje svoje shranjene ture
2. Uporabnik klikne na eno izmed shranjenih tur na seznamu
3. Aplikacija prikaže podrobnosti izbrane ture na novi zaslonski maski (Podrobnosti ture)
   

#### Pregledovanje deljenih tur drugih uporabnikov

Povzetek funkcionalnosti:

Registriran uporabnik lahko pregleduje deljene ture drugih uporabnikov na strani "Raziskuj". (Prikaz je enak tistemu na razdelku "Moje ture")

Osnovni tok:

1. Uporabnik v aplikaciji izbere razdelek "Raziskuj"
2. Prikaže se seznam deljenih tur drugih uporabnikov
3. Uporabnik pregleduje deljene ture


