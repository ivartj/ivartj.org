title: bbcode
description: Kommandolinjeredskap som prosesserer BB-kode.

[b]bbcode[/b] er et kommandolinjeverktøy jeg skrev i programmeringspråket C for å generere HTML-innhold til denne nettsiden. Den tar inn filer skrevet i BBCode, et markeringsspråk brukt på mange nettfora, og gir tilbake HTML-kode som kan inkluderes i et HTML-dokument, som det du leser.

Det var hovedsakelig en morsom øvelse ettersom det allerede finnes lignende verktøy, men ingen for BBCode som jeg vet om.

[b]Nedlastinger[/b]
Kildekode: [url=/files/bbcode-0.02.tar.gz]bbcode-0.02.tar.gz[/url]

Den nyeste kildekoden er tilgjengelig på [url=https://github.com/ivartj/bbcode]Github[/url].

[b]Detaljer[/b]
I motsetning til mange andre implementasjoner av BBCode, bruker ikke dette verktøyet regulære uttrykk, som pleier å være begrenset i hvordan de kan tolket strukturen til en tekst. Den gir HTML som er strukturert i et skikkelig hierarki selv om BB-koden den får ikke er det.

Som et eksempel, for å få følgende:

[i]skrå skrift, [b]fet og skrå skrift[/i], fet skrift.[/b]

Så kan du skrive den følgende BB-koden:
[code]
[i]skrå skrift, [b]fet og skrå skrift[/i], fet skrift.[/b]
[/code]

og få tilbake denne HTML-en
[code]
<em>skrå skrift, <strong>fet og skrå skrift</strong></em><strong>, fet skrift.</strong>
[/code]
