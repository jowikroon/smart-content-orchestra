---
title: "CCP Channable eBay DE herstelplan voor Claude (12 oktober 2026)"
type: source
scope: [CCP]
status: active
created: 2026-10-12
last_reviewed: 2026-10-14
aliases: []
tags: [channable, ebay-de, herstelplan, handoff]
sources: []
source: drive-bridge
source_kind: article
source_url: "https://docs.google.com/document/d/1Zjp45X9UANl8r_UtSVgImp8zo1Nu5gtjFECdCUVRxAo/edit"
drive_id: "1Zjp45X9UANl8r_UtSVgImp8zo1Nu5gtjFECdCUVRxAo"
ai_generator: chatgpt
ingested_from: _connector/bridge/inbox/drive/2026-10-12_ccp_channable-ebay-de-herstelplan.md
ingested_on: ""
hansos.id: src-2026-10-12-channable-ebay-de-herstelplan
record_kind: source
skill_ids: []
case_ids: []
contract_version: 0.2-draft
classification: internal
notion_id: ""
---

## Herkomst
- Bron: ChatGPT export in Google Drive, map AI-en-automatisering (of scope-map), aangemaakt 2026-10-12.
- Status: raw bronmateriaal, nog niet beoordeeld. Claims zijn indicatief tot Hans de source-pagina heeft beoordeeld (Klopt het? Werkt het? Voelt het juist?).
- Bridge-drop gemaakt door Claude-cloud op 2026-10-14 als onderdeel van de HansOS next-step (zie wiki/topics/HansOS-Next-Step-2026-10 zodra geïngest).

## Inhoud

# Channable eBay DE — herstelplan voor Claude

## CCP × A.B.S. | 12 oktober 2026 | uitvoerplan op bestaande bronnen

Doel: juiste producten, actuele verkoopbare voorraad en geldige prijzen aanbieden; iedere betaalde order met de juiste onderdelen afhandelen en tracking terugmelden. Dit document is de overdracht aan Hans en Claude. De huidige productieselectie en alle bestaande juiste listing-ID’s blijven het uitgangspunt.

# 1. Wat direct aandacht vraagt

- P0: nu controleren en herstellen als de fout nog bestaat — voorraad/limiet, kanaalbeheer, SKU-/orderkoppeling, orderimport, tracking, stock-/prijsupdates, eenheid/BOM, verrijkingsimports en foutieve fitment.
- P1: afronden vóór pilot of nieuwe bundelpublicatie — structured productvelden en klantcontent, beelden/pakket, prijsregels, gecontroleerde selectie, bundelketen en monitoring.

Afhankelijkheden met Magento/Atvise, Magmodules en de A.B.S.-koppeling staan erbij, omdat een Channable-regel een upstream fout niet altijd oplost. De eigenaren hieronder zijn werkverdeling, geen uitspraak over schuld.

# 2. Wat de beschikbare data wél vaststelt

- Volledige export 7 oktober: 4.404 listing-ID’s; 1.957 rembloklistings starten allemaal op 6 oktober. Negen listings hebben quantity ≥100. Er staan 1.057 quantity-0-records; die zijn niet automatisch koopbaar of fout.
- Aangeboden waarde uit prijs × quantity: €1.159.283,73. Rekenvoorbeeld maximaal 5 aangeboden eenheden per listing: €676.203,42, verschil €483.080,31. Geen vrijgekomen cash of gegarandeerde actuele limietruimte; de huidige Seller Hub-limiet moet worden gelezen.
- De oude weesbatch met ID-prefix 257729… heeft nul records in deze export. Ook zijn er nul prijzen ≤0. De septemberaantallen 241 wees-listings en 351 nulprijsproducten zijn daarom geen huidige herstelopdracht.
- Orderdossier 8 juli–16 september: 86 orders, 27 met importfout en 14 expliciete identifier-/titelconflicten. Een foutmelding of manual-status bewijst geen annulering of onjuiste levering.
- Herstelbestand 7 oktober en V3-productdata bevatten concrete controles: verdwenen importvelden, onzekere losse/seteenheid en gedeelde GTIN’s, foutieve diameter/modelmapping en pseudo-kits. Een voorbereid herstelbestand is geen bewijs dat het al in Channable of eBay is ingevoerd.

De bronnen zijn geen live audit van 12 oktober. Start daarom met CH-00 en noteer per punt actuele controle en eventuele reparatie. Reken historische symptomen niet opnieuw als open storing.

# 3. Uitvoervolgorde en eerste werkdag

- Begin: CH-00, daarna huidige open betaalde orders en onleverbare koopbare aanbiedingen afvangen met CH-01–CH-05. Leg eerst IDs en mappings vast; verander voorraad/pauzestatus gericht zonder listinghistorie onnodig te verliezen.
- Parallel: CH-06 upstream sync en CH-08 imports onderzoeken. CH-07 eenheid/BOM en CH-09 productcorrectheid moeten klaar zijn vóór definitieve setstock of nieuwe publicatie.
- Daarna: CH-10–CH-13 voor de kleine focusgroep afronden; CH-14 end-to-end bundlebewijs. CH-15 logging en signalering vanaf het begin inrichten.

Aan het einde van de eerste werkdag staat per taak: huidige status, exact bewijs, tijdelijke afvang, gewijzigde regel of mapping en de eerstvolgende actie. Wat bij een andere beheerpartij ligt krijgt een concrete log-/configuratievraag en eigenaar. Geen generieke melding ‘data ontbreekt’.

# 4. Hersteltaken met acceptatiecriteria

## CH-00 | P0 | Actuele nulmeting en herstelpunten vastleggen

Eigenaar: Hans + Claude. Afhankelijk: Eerste stap. Bereik: Channable-project, eBay DE-API, importbronnen, Magento-connector en Seller Hub.

Bronbevinding / huidige beperking: Bronnen lopen tot 7 oktober; de actuele configuratie op 12 oktober is nog niet live gecontroleerd. Kanaal 159122 is alleen in het septemberdossier genoemd.

- Leg huidig project-/kanaal-ID, storeview, orderkoppeling, import- en API-planning vast. Bewaar exports van regels in uitvoervolgorde, mappings, importbronnen en fouten vóór wijzigingen.
- Maak één actuele lijst: listing-ID, seller-SKU, Magento-SKU en interne product-ID, ABS-artikel, verkoopeenheid/BOM, voorraadbron/tijdstip, prijs, beheerd door welk kanaal, live status en laatste succesvolle update.
- Gebruik per taak de statussen CONTROLEREN, OPEN, IN UITVOERING, AFHANKELIJK, GEREED. Als de fout al is opgelost: bewaar actueel bewijs en sla de herstelactie over.

Gereed als: Actuele exports hebben tijdstip, scope en unieke sleutel; elke wijziging heeft een terugzetbare vorige configuratie. Geen historische aantallen als actuele foutenaantallen gepresenteerd.

Bronnen: S3, S4, S6 (links in §7).

## CH-01 | P0 | Voorraadregels en eBay-verkoopwaardelimiet herstellen

Eigenaar: Hans + Claude; Magento/ABS voor ATP. Afhankelijk: CH-00; definitieve setquantity na CH-07. Bereik: Alle beheerde aanbiedingen; eerst de negen hoge quantities.

Bronbevinding / huidige beperking: 7 okt: negen listings met quantity ≥100. Aangeboden waarde prijs×quantity €1.159.283,73. Scenario cap 5 geeft €676.203,42. September: 21919188 en gepauzeerde regels Stock/stock; huidige limiet/status onbekend.

- Controleer actuele limiet, teller en fout 21919188 in Seller Hub/Channable; maak de bestaande Stock- en stock-regels en eventuele latere overschrijvingen zichtbaar.
- Gebruik voorraad die echt aan eBay kan worden toegewezen: afgeleid van salable/ATP en gedeelde reserveringen. Eindquantity=max(0; min(kanaalplafond; verkoopbare eenheden)). Ontbrekende/verouderde voorraad nooit vervangen door een positief standaardgetal.
- Bepaal een tijdelijk kanaalplafond met Hans op basis van vraag en aanvultijd; 5 is een rekenvoorbeeld, geen eBay-norm. Begin met 17336-SET, 16880-SET, 16883-SET, 16880-SET2, 17591-SET, 17522-SET, 37422, 37848, 37647.
- Zet 0/negatieve/onbekende ATP voor bestaande listings via een aantoonbaar werkende update op 0 of in een veilige pauzestatus. Alleen een record uit de feed filteren bewijst niet dat een al bestaande eBay-aanbieding stopt.

Gereed als: Uitvoerquantity is nooit negatief of hoger dan gevalideerde ATP; null/lege bron kan geen positieve quantity opleveren. Actuele live quantity en limietteller sluiten aan op preview. Geen nieuwe 21919188 in de gecontroleerde run; daarna één volledige geplande run verifiëren.

Bronnen: S3, S4 (links in §7).

## CH-02 | P0 | Iedere live listing onder aantoonbaar voorraadbeheer brengen

Eigenaar: Hans + Claude; Channable-support als claim/adoptie nodig is. Afhankelijk: CH-00, CH-01. Bereik: eBay-live lijst versus offers van alle relevante Channable-kanalen.

Bronbevinding / huidige beperking: September: batch 257729… werd niet door API 159122 beheerd. In de volledige export van 7 okt staan nul IDs met dit prefix. De oude opdracht om 241 listings te beëindigen mag daarom niet worden herhaald.

- Vergelijk actuele eBay-ID’s met beheerde Channable-offers; zoek melding Item ignored, on eBay but not sent through this API. Prefix is alleen een historisch aanknopingspunt, geen selectiecriterium.
- Voor werkelijk onbeheerste listings: koppel/adopteer via ondersteunde Channable-route of support. Kan dat niet, voorkom verkoop op het specifieke onleverbare aanbod en leg een gerichte vervanging vast.
- Bescherm huidige IDs van 17336-SET (257750451902), 37319 (257785733291) en 37584 (257785733910). Controleer of 740541/630162 nog een huidige listing hebben; ontbreken in 7 okt is geen opdracht tot duplicaten maken.
- Controleer de 1.057 quantity-0-records in 7 okt: zijn ze bewust met out-of-stock behoud beheerd? Behoud mapping en historie; maak geen massale herplaatsing.

Gereed als: Elke werkelijk koopbare listing heeft een eigenaar/kanaal, geverifieerde productmapping en werkende voorraadupdate. Geen onbeheerde koopbare listing met onbekende ATP; oude en nieuwe IDs blijven herleidbaar.

Bronnen: S3, S4 (links in §7).

## CH-03 | P0 | SKU, EAN, Magento-ID en eBay-ID correct scheiden

Eigenaar: Claude + integratiebeheer; Hans valideert artikelen. Afhankelijk: CH-00, CH-02. Bereik: Orderimport en productregister, ook historische IDs.

Bronbevinding / huidige beperking: 14 van 86 dossierregels hebben een expliciet conflict tussen magento_sku en ABS-code in de fouttitel. Numerieke Magento-ID’s kunnen toevallig een andere bestaande ABS-code zijn. Dit bewijst een mapping-/analyseprobleem; niet automatisch dat alle 14 verkeerd zijn geleverd.

- Inspecteer de werkelijk gebruikte alternative-ID-/SKU-mapping en connectorpayload. Sla Magento entity-ID, Magento SKU, seller custom label, eBay item-ID, EAN en ABS-artikel als verschillende velden op.
- Maak de koppeling primair via betrouwbare orderregel en listing-ID → seller-SKU → gecontroleerd Magento-product → ABS-artikel/BOM. Gebruik historische listingregisters voor oude IDs.
- Controleer alle 14 conflictregels; voorbeelden: order 110528707: 16724 versus titel 37587; order 108399905: 35233 versus titel 16876; order 110556033: 16673 versus titel 37533. Titel alleen is geen autoriteit voor automatisch overschrijven.
- Ondersteun tekens zoals 36623/1 en fabrikant-SKU’s met spaties. Splits meerdere orderregels/IDs expliciet; herhaal een volledig orderbedrag niet per child.

Gereed als: Alle 14 uitzonderingen hebben een onderbouwde oplossing of expliciete blokkade. Een bekende pad-order kan niet als schijf worden gekoppeld door toevallige nummermatch. Historische en huidige IDs zijn traceerbaar zonder mutatie van primaire IDs.

Bronnen: S3, S4 (links in §7).

## CH-04 | P0 | Orderimport per foutklasse repareren en fouten zichtbaar maken

Eigenaar: Claude + Magento/Atvise; Hans beheert uitzonderingen. Afhankelijk: CH-03; voorraaddeel CH-01/CH-06. Bereik: Channable → Magento → fulfilment voor eBay DE.

Bronbevinding / huidige beperking: Dossier juli–september bevat 27 orders met importfout: voorraad 15; catalogus 5; qty-increment 3; verzendmethode 2; landconfiguratie 1; stadvalidatie 1. Foutstatus is niet hetzelfde als annulering; sommige orders zijn handmatig verwerkt.

- Controleer huidige orderwachtrij en splits deze in catalogus/mapping, voorraad, quantity-increment, verzending, land/adres en technische API-fout. Behandel echte open betaalde orders eerst.
- Controleer Magento verkoopbaarheid, juiste storeview/DE-scope, toegestane landen, betaal- en verzendmethode en bundelproduct. Leg schriftelijk de actuele eindstaat van de Duitse storeview vast.
- Stem Magento quantity increments af op de verkoopeenheid: één setorder moet naar de juiste childaantallen kunnen. Verander fabrikantverpakking/minimumaantal niet blind globaal.
- Houd een oversell/orderfout in een zichtbare uitzonderingswachtrij, met oorspronkelijke betaalstatus en orderreferentie. Zet niet globaal backorders of Enable Order for Out of Stock Items aan op basis van het oude dossier; toets eerst ondersteunde hold-route en fulfilmentgedrag.
- Herprobeer alleen na oorzaakherstel en duplicate-check. Bewaar ruwe foutcode en correlatie-ID; herstel verzending/city mapping zonder geldige klantgegevens stil te wijzigen.

Gereed als: Representatieve DE-pad-, caliper- en setorder importeren met juiste artikel en hoeveelheid. DE-adres, shipping/payment-mapping en qty-increment zijn getest. Een fout wordt zichtbaar binnen 15 minuten (voorlopig operationeel doel), niet stil verloren. Retry maakt geen extra fulfilmentorder.

Bronnen: S4 (links in §7).

## CH-05 | P0 | Tracking en verzendstatus terug naar eBay betrouwbaar maken

Eigenaar: Claude + Magento/fulfilmentintegratie. Afhankelijk: CH-03, CH-04. Bereik: Shipment → Channable → originele marketplaceorderregel.

Bronbevinding / huidige beperking: Septemberdossier verwijst naar oude trackingproblemen en een gesloten ticket; actuele trackingdekking is niet geverifieerd. Voor eBay-service en Top-Bewertung is succesvolle terugmelding relevant.

- Volg een recent werkelijk verzonden order vanaf fulfilment: shipment-ID, carrier, trackingnummer, verzendtijd, Channable order-/line-ID en eBay-status.
- Verifieer dat betaald of handmatig behandeld niet automatisch verzonden betekent. Gebruik door de connector ondersteunde carriers en statussen.
- Leg gedrag voor twee pakketten, een bundel als één marketplace-regel, gedeeltelijke/mislukte verzending en retry vast. Verzin geen Channable child-line-ID’s die niet in de order bestaan.

Gereed als: Trackingnummer en carrier zijn teruggelezen op de juiste eBay-order; duplicate statusbericht maakt geen dubbel shipment. Recente echte verzonden orders zonder terugmelding verschijnen op de uitzonderingslijst.

Bronnen: S4, S7 (links in §7).

## CH-06 | P0 | Voorraad-/prijsupdates en Magmodules-invalidatie bewijzen

Eigenaar: Claude + Magento/Atvise + Magmodules + ABS/Niek. Afhankelijk: CH-00; parallel aan CH-03/CH-04. Bereik: ABS-import → Magento → Magmodules/Channable-import → eBay.

Bronbevinding / huidige beperking: September: snelle Magmodules-laag miste events/stond stil; periodieke Channable-feed werkte wel. Hypothese legacy qty versus MSI salable is onbewezen. Geen bewijs dat dit op 12 oktober nog stuk is.

- Meet een ABS-voorraadmutatie, een verkoop/reservering, annulering en prijswijziging op gecontroleerde test-SKU’s. Leg bron- en aankomsttijd in alle lagen vast.
- Controleer Observer/Cron-instelling, wachtrij, needs_update/last_call en cron_schedule; gebruik de daadwerkelijk geconfigureerde logs, waaronder Magento var/log/channable.log en cron-/exception-/systemlog.
- Controleer of ABS-import buiten Magento-events schrijft en welke actuele salable/ATP-bron Magmodules vergelijkt. Los oorzaak op; alleen Observer↔Cron omzetten is geen bewijs van herstel.
- Leg het werkelijke import-/API-interval vast en controleer het vangnet. Voorstel: syncvertraging ≤15 minuten voor focus-SKU’s; als de connector dat niet haalt, kies een onderbouwde voorraadbuffer en haalbare SLA.

Gereed als: Vier soorten mutatie bereiken de juiste listing via de bestaande route; nul nieuwe onverklaarde queue-fouten. Eén normale ABS-import plus twee geplande cycli zijn gemeten. Oude timestamp alleen bewijst niet dat een queue kapot is wanneer geen mutatie plaatsvond.

Bronnen: S4 (links in §7).

## CH-07 | P0 | Verkoopeenheid, GTIN en vaste bundel-BOM vastleggen

Eigenaar: Hans + ABS productkennis + Claude/integratie. Afhankelijk: CH-03; nodig vóór definitieve setstock/publicatie. Bereik: Losse schijven, -SET/-SET2 en pad+disc-pseudo-kits.

Bronbevinding / huidige beperking: Nieuwste README meldt 2.271 gedeelde EAN’s en onduidelijkheid of één voorraadeenheid één schijf of doos van twee is. 16880-SET2 en twee pseudo-kits hebben tegenstrijdige/ontbrekende inhoud.

- Vraag/controleer per geselecteerd artikel: fysieke voorraadeenheid, inkoopeenheid, stuks per doos, verkoopinhoud en GTIN-betekenis. Eerst 17336, 16880, 16883; daarna andere sets.
- Leg vaste BOM vast: 17336-SET→2×17336, 16880-SET→2×16880 en 16883-SET→2×16883, uitsluitend na eenheidsbevestiging. BundleATP=min floor(childATP / BOM-aantal), gedeelde reservering met solo’s.
- 16880-SET2 aanhouden: bron noemt één schijf, onjuist per-schijfgewicht en geen K-types. Namen 36623/1 & 16883 en 36623/1 en 16883 zijn geen goedgekeurde BOM.
- Controleer juiste eBay-productidentificatie voor set/multipack. Geen kind-EAN als set-GTIN presenteren zonder geldige definitie; geen nieuwe GTIN verzinnen. MPN van component onderscheiden van eigen kit-SKU.

Gereed als: Pilot heeft één gevalideerde eenheids-/BOMtabel. Stock, inkoop, leveromvang, orderquantity en magazijnpick geven dezelfde inhoud. Test childATP 7 en BOM 2→3 sets; nul bij tekort van één child. Geen dubbel reserveren.

Bronnen: S1, S6, S7 (links in §7).

## CH-08 | P0 | Verdwenen verrijkingsimports en merge-regels herstellen

Eigenaar: Claude + Channable-beheer. Afhankelijk: CH-00, CH-03. Bereik: Imports voor ktypes, hersteller, produktart, ursprungsland, fahrzeugmodelle.

Bronbevinding / huidige beperking: README STOP2 van de 7-oktoberbron meldt verdwenen imports/0% projectvelden. Herstelbestand bestaat; werkelijk live herstel is niet bewezen.

- Controleer actieve importbronnen, download/auth/planning, join-key, dubbelen en hoofd-/aanvullende importvolgorde. Vergelijk ruwe bron → projectvelden → regels → API-build → live eBay voor focus-SKU’s.
- Herstel via stabiele SKU-key als string. Voorkom dat een lege nieuwere bron een gevalideerde verrijking wist. Voor prijs/stock geldt geen onbeperkte fallback naar verouderde positieve waarden.
- Voeg controlekolommen toe: bronversie/tijdstip, merge-match, verplichte velden, fitment_gevalideerd en publicatiegereed. Rapporteer merge-misses; niet alleen algemene vulgraad.

Gereed als: Iedere geselecteerde SKU matcht exact één juist record en houdt waarden na een volgende geplande import. Herkomst van ieder hersteld veld is traceerbaar. Geen nul-/leegte-overschrijving; live sample sluit aan op API-build.

Bronnen: S1, S6 (links in §7).

## CH-09 | P0 | Foutieve fitment en technische attributen blokkeren/herstellen

Eigenaar: ABS productkennis + Claude. Afhankelijk: CH-07, CH-08. Bereik: 16883-SET; 15042-SET; remklauwen 2050/2051/2054/2055; ambigue beide-assen-sets.

Bronbevinding / huidige beperking: 16883-SET: 230 mm product versus 254 mm kenmerk. 15042-SET: Audi 90-titel versus Alfa Romeo 90-body. V3 koppelt BMW 1-serie aan Fiat/andere merken. LOV-validatie bewijst geen juiste toepassing.

- Herstel 16883-SET diameter naar fabrikantmaat 230 mm in titel, techniek en passend eBay-attribuut. Een afgeronde inchklasse niet als exacte maat tonen.
- Blokkeer 15042-SET en conflicterende V3-modelmapping tot fabrikantfitment/OE en beperkingen zijn gecontroleerd. Zoek welke regels/modellen hetzelfde mappingpatroon gebruiken.
- Gebruik alleen toegelaten K-types en toepassingsrestricties; 16880-SET voorbereidingsbron heeft 425 na verwijderen van 13 geweigerde types, 16883-SET 639, 17336-SET 472. Bevestig werkelijk verstuurde/aanvaarde types.
- Bij twee schijven die afhankelijk van voertuig voor/achter passen: inhoud is één as, geen complete voor- én achterasset. Pad+disc-fitment gebruikt gezamenlijke juiste as/remvariant/restricties, geen union van automerken.

Gereed als: Geen hard conflict tussen merk/model/OE/as/maat en fabrikantbron; geblokkeerde records blijven niet koopbaar met verkeerde compatibiliteit. Semantische validatie staat apart van eBay-LOV- en technische acceptatie.

Bronnen: S1, S2, S6 (links in §7).

## CH-10 | P1 — vóór pilot | Merk, MPN, productkenmerken en klantcontent juist uitgeven

Eigenaar: Claude + content/ABS. Afhankelijk: CH-08, CH-09. Bereik: Vijf verkoopkandidaten en vrijgegeven technische experimenten.

Bronbevinding / huidige beperking: Kwaliteitsrapport 26 sep heeft ontbrekend gestructureerd merk, ook waar A.B.S. in titel staat. V3-remblok 35001 mist nuttige selectiecriteria. Actuele live toestand controleren.

- Map Marke/brand, Herstellernummer/MPN, as/zijde, remsysteem, exacte maten, setinhoud en geldige productidentificatie naar de echte eBay-fields. Ontbrekende beschrijving niet oplossen met onjuiste standaardtekst.
- Gebruik Content_DE als compacte conceptbasis: past dit, wat ontvangt de klant, relevante maten en restricties. Bewaar noodzakelijke fabrikant-/GPSR-/veiligheidsvelden; check werkelijke fabrikantbron en de plek waar eBay deze verwacht.
- Laat ongeverifieerde herkomst, garantie, ISO-/kwaliteitsvergelijkingen en rommelige modelnamen weg. Stel geen universele pasvorm of voordeel tegenover Bosch/Brembo als feit.
- Pas alleen gerichte geselecteerde records aan en verifieer live; oude 177-sets-leegte is geen actuele foutentelling.

Gereed als: Voor focusgroep komen titel, specificaties, compatibiliteit en body inhoudelijk overeen. Klant ziet juiste setinhoud en toepassing; geen ongeverifieerde claim. Structured brand is in native veld aanwezig, niet alleen in titel.

Bronnen: S2, S5, S6 (links in §7).

## CH-11 | P1 — vóór pilot | Afbeeldingen en bundelpakketgegevens corrigeren

Eigenaar: Claude + content + magazijn. Afhankelijk: CH-07, CH-10. Bereik: Hoofdbeeld, image URLs, pakketmaten/gewicht en verzending.

Bronbevinding / huidige beperking: September vermeldt fetch-/Cloudflare-belemmeringen; nieuwe setbron gebruikt doosmaten van één schijf. Productgewicht is geen verzendgewicht.

- Controleer exacte image URL’s op bereikbaarheid vanuit de werkelijk gebruikte fetchroute; controleer 403/429, verlopen URL, MIME en ingestresultaat. Wijzig firewall alleen voor een aangetoonde noodzakelijke route met verantwoordelijke beheerder.
- Hoofdbeeld toont daadwerkelijk geleverde componenten. Voeg alleen nuttige detail-/maatbeelden toe; stock-/merkvisual geen vervanging voor inhoud.
- Meet echte doos en brutogewicht inclusief verpakking. 17336-set productgewicht circa 10,20 kg en 16880-set 10,16 kg zijn netto productsommen; voer echte carrier-/pakketgrenzen in.

Gereed als: eBay toont de juiste beelden en accepteert de image-ingest; geen kapotte focusafbeelding. Werkelijke bundeldoos, verzendgewicht en service horen bij de juiste verkoopinhoud.

Bronnen: S1, S2, S4, S6 (links in §7).

## CH-12 | P1 — vóór pilot | Prijsimport en ordertotalen beheersen

Eigenaar: Claude + finance + ABS-koppeling. Afhankelijk: CH-03, CH-07, CH-08. Bereik: Bronprijs → regels → API-prijs; shipping/tax/discount/refund.

Bronbevinding / huidige beperking: September noemt 351 nulprijsproducten en ontbrekende prijs bij nieuwe ABS-artikelen. In actieve export 7 okt staan nul aanbiedingen met prijs ≤0. Dit historische aantal is geen huidige foutenaantal.

- Controleer huidige prijsbron, valuta, btw-scope, verkoopeenheid en regelvolgorde. Netto inkoop, ABS adviesprijs en eBay bruto verkoopprijs zijn aparte velden.
- Nieuwe records zonder geldige prijs niet creëren; bestaande records met ontbrekende prijsbron apart onderzoeken zonder oude positieve stock blind te behouden. Keer niet tweemaal van stuk naar set of van netto naar bruto om.
- Controleer bij sets/kits ordertotaal, korting, verzendbijdrage, belasting en eventuele child-/refundallocatie; som moet exact sluiten. Neem remklauwstatiegeld alleen op als werkelijk van toepassing.

Gereed als: Geen nul-/negatieve verkoopprijs of currency-/btwfout in nieuwe uitvoer. Een set gebruikt precies de bevestigde verkoopeenheid. Order- en refundtotalen sluiten op de marketplacebron; afwijking staat in uitzonderingslijst.

Bronnen: S3, S4, S6 (links in §7).

## CH-13 | P1 — vóór pilot | Catalogusgroei gecontroleerd stoppen en listinghistorie behouden

Eigenaar: Hans + Claude. Afhankelijk: CH-02, CH-08. Bereik: Nieuwe listingcreatie, focuscohort en oude/nieuwe IDs.

Bronbevinding / huidige beperking: Alle 1.957 rembloklistings in export 7 okt starten op 6 oktober. Dat verkort de huidige ID-historie; opnieuw relisten is geen standaardherstel.

- Maak één expliciete focuslijst voor 17336-SET, 37319, 37584, 740541, 630162; 16880-SET/16883-SET/210000+210001 krijgen technische teststatus.
- Stop ongecontroleerde nieuwe cataloguscreatie; maak gecontroleerde updates mogelijk voor bestaande juiste listings buiten de focusgroep. Kanaal/filterwijziging mag voorraadbeheer niet ongemerkt verbreken.
- Controleer waarom de remblokken opnieuw zijn geplaatst en voorkom dezelfde oorzaak: wijziging unieke ID, connectorwissel, importkey of kanaalverwijdering. Bescherm SKU’s met slash/spaties.
- Behoud actuele verkoopsignalen op de bestaande IDs; maak 740541 en 630162 pas opnieuw aan als een ontbrekende huidige aanbieding en juiste identiteit zijn vastgesteld.

Gereed als: Een ongewijzigde geplande run creëert geen duplicaat of nieuw listing-ID. Focusregels werken zonder bestaande voorraadupdates buiten focus te verliezen. Mapping houdt historische IDs voor orderreconciliatie.

Bronnen: S3, S6 (links in §7).

## CH-14 | P1 — vóór bundlepilot | Bundelketen testen inclusief retry, annulering en retour

Eigenaar: Claude + magazijn/finance + Hans. Afhankelijk: CH-03 t/m CH-07, CH-11, CH-12. Bereik: 17336-SET eerst; dan 16880-SET/16883-SET; armpaar pas na productvalidatie.

Bronbevinding / huidige beperking: Notitie testorder 144013527 OK is geen volledig ketenbewijs. Historisch 500 bij 16880-SET2; oorzaak staat niet vast. Bundel-API-onderzoek verwart All Brake Systems met Advanced Business Software.

- Gebruik de bestaande orderroute en echte API-schema’s. Vaste BOM vertaalt kit naar children; Claude kiest onderdelen niet vrij tijdens fulfilment. Geen platformmigratie op basis van het onderzoeksrapport.
- Test orderquantity 1 en 2, juiste childpick, parallel solo+set-reservering, dubbele notificatie/retry, price/tax-totalen en tracking op originele marketplace-line.
- Test annulering vóór pick, ontbrekend child/partiële fout en volledige/partiële retour met correcte voorraad- en refundallocatie. Traceer de historische 500 met echte exceptionlog als die reproduceert.
- Geef disc+pad-kit pas vrij na exacte gezamenlijke fitment en armpaar pas na bevestiging van positie/inhoud. Een technische proef kan in een ondersteunde testomgeving; voer geen fictieve bestelling in het klantaccount als echte verkoop op.

Gereed als: Eén bewijsdossier per vrijgegeven bundeltype bevat inputorder, BOM-versie, childaantallen, voorraadmutaties, totaal, tracking, retry, annulering en retour. Geen dubbele order/reservering of verkeerde child; alle statussen herleidbaar.

Bronnen: S1, S6, S7 (links in §7).

## CH-15 | P1 — onderdeel van herstel | Monitoring, reconciliatie en wijzigingslog installeren

Eigenaar: Claude + Hans; beheerpartijen leveren logging. Afhankelijk: Vanaf CH-00, definitieve poorten na CH-01 t/m CH-14. Bereik: Voorraad, mappings, orders, prijzen, imports en tracking.

Bronbevinding / huidige beperking: Historische incidenten waren onvoldoende zichtbaar. Het herstel moet aantoonbaar blijven na een geplande import en ABS-update.

- Controleer dagelijks of live listing-ID/SKU/quantity overeenkomen met kanaalbeheer en juiste ATP; bewaak focusgroep vaker wanneer het platform dit ondersteunt. Vergelijk na dezelfde succesvolle synccyclus.
- Maak een uitzonderingslijst voor onbeheerde koopbare listing, negatieve/null voorraad met positief aanbod, prijsfout, merge-miss/lege verplichte velden, stagnerende bronupdate, orderimportfout en ontbrekende tracking.
- Voorlopige doelen: nieuwe orderfout binnen 15 minuten zichtbaar; tracking binnen 30 minuten na beschikbaar komen bij fulfilment, tenzij platformschema anders vereist; signaal bij twee gemiste geplande runs. Leg haalbare definitieve SLA met Hans vast.
- Alertontvanger/kanaal door Hans laten aanwijzen; zonder opdracht geen e-mails/tickets/Slack-berichten versturen. Leg elke wijziging vast: regel/versie, scope, vóór/na, run-ID, resultaat en rollback.

Gereed als: Een gecontroleerde fout triggert een zichtbare uitzondering; één normale ABS-import en twee geplande Channable-runs laten geen nieuwe kritieke afwijkingen zien. Hans kan per CH-taak bewijs, resterende afhankelijkheid en actuele status bekijken.

Bronnen: S4, S6 (links in §7).

# 5. Controlepakket vóór vrijgave

- Listingcontrole: beheerd kanaal, betrouwbare SKU-/productmapping, juiste prijs en eenheid, quantity ≤ATP, geen semantische fitmentfout, juiste live beelden en fabrikant-/veiligheidsvelden.
- Ordercontrole: pad, caliper en set; DE-adres en shipping/payment; juiste quantity en BOM; geen duplicaat na retry; tekort in zichtbare hold-/uitzonderingsroute; tracking op originele marketplaceorder.
- Bundelcontrole: orderquantity 1 en 2, parallel solo+set, annulering vóór pick, ontbrekend child, verzending en volledige/partiële retour; voorraad en financiële totalen sluiten.
- Continuïteit: één normale ABS-import en twee geplande Channable-runs; geen nieuwe kritieke afwijking, duplicate listing of onverklaarde mapping-/voorraaddrift.

Status GEREED vereist een bron/runtijd en resultaat van het acceptatiecriterium. Een groene Channable-run of 100% gevulde kolom alleen is onvoldoende. Bij een aangetoonde regressie de betreffende regel/mapping terugzetten en de oorzaak vastleggen.

# 6. Kopieerbare startopdracht voor Claude

Je helpt Hans bij CCP om de bestaande eBay DE-keten via Channable, Magento, Magmodules en A.B.S. All Brake Systems betrouwbaar te maken. Gebruik dit herstelplan als concrete backlog CH-00 t/m CH-15. Voer eerst CH-00 uit: actuele inrichting, bronnen, regels/mappings in volgorde, orderroute, planning, listingregister en foutwachtrij lezen en exports vastleggen. Benoem exacte project-/kanaal-ID’s uit de actuele omgeving; kanaal 159122 uit september is geen automatisch huidige bestemming.

Maak per taak het onderscheid: bewezen in huidige omgeving, historisch incident, voorbereid herstelbestand, of onbevestigde hypothese. Geen oude aantallen of klantorderstatussen omzetten in huidige feiten. De 257729-weesbatch staat niet in de volledige export van 7 oktober; beëindig niet blind 241 oude listings. Een importfout is geen bewezen annulering; manual is geen bewezen shipment.

Begin bij huidige betaalde orderproblemen, onbeheerste koopbare listings en onbetrouwbare stock. Voer herstel alleen uit waar de live controle het probleem bevestigt. Gebruik eerst preview en beperkte focusgroep, daarna readback en een normale geplande run. Leg per stap vast: regel/mapping/versie, bron, scope, vóór/na, run-ID, resultaat, acceptatietest en terugzetbare configuratie. Bij onvoldoende toegang: noteer de exacte ontbrekende log, configuratie of API-read en welke beheerpartij deze kan leveren; vraag Hans geen data opnieuw aan te leveren die al in Drive staat.

Scheid eBay listing-ID, seller-SKU, Magento entity-ID, Magento SKU, EAN, ABS-artikel en eigen kit-SKU. Corrigeer de 14 dossierconflicten op geverifieerde orderregel/listing-ID en fabrikantbron; gebruik een fouttitel niet als automatische SKU-override. Bewaar historie van oude IDs en controleer retries op dubbele orders/reserveringen.

Laat stock volgen uit echte salable/ATP, gedeelde reserveringen, verkoopeenheid en kanaalplafond. Null, negatieve of verouderde stock mag geen positief aanbod opleveren. Cap 5 is slechts een rekenvoorbeeld voor aangeboden waarde, geen rankingtruc. Een record uit een feed filteren stopt een bestaande eBay-listing niet aantoonbaar; controleer live nul/pauzestatus. Zet niet globaal backorders aan om importfouten te maskeren.

Bevestig eerst de eenheid en GTIN-betekenis van losse schijven/setdozen. Gebruik vaste BOM’s met gevalideerde children/aantallen. Geen vrije LLM-keuze van onderdelen bij fulfilment en geen migratie naar een nieuw integratieplatform uit het onderzoek; dat rapport verwart All Brake Systems met Advanced Business Software. Test de bestaande route end-to-end.

Bescherm de huidige verkoopsignalen en IDs: 17336-SET / 257750451902, 37319 / 257785733291, 37584 / 257785733910. Zoek actuele status van 740541 en 630162 voordat je listings creëert. Technische experimenten zijn 16880-SET, 16883-SET en 210000+210001. Herplaats het catalogusassortiment niet massaal en vul het niet aan met willekeurige producten.

Herstel importjoins, lege-waarde-overschrijvingen, structured brand/MPN, echte setinhoud en semantische fitment. 16883-SET is 230 mm, niet 254 mm. Houd 15042-SET, 16880-SET2 en de twee 36623/1+16883-pseudo-kits tegen tot identiteit/BOM/fitment kloppen; controleer hetzelfde foutpatroon breder. BMW-modelmapping in V3 bij 2050/2051/2054/2055 is onbewezen en mag niet als fitment worden gepubliceerd. Content toont alleen nuttige, geverifieerde klantinformatie en noodzakelijke product-/veiligheidsgegevens.

Stuur voortgang als: CH-ID | actuele status | exact gewijzigd | bewijs van controle | resterende afhankelijkheid | eerstvolgende actie. Rond een taak pas af als het acceptatiecriterium is gehaald. Voorstel voor de herstelperiode: orderfouten binnen 15 minuten zichtbaar, tracking binnen 30 minuten nadat fulfilment het beschikbaar maakt, en alert na twee gemiste geplande runs; verifieer dat dit haalbaar is in deze connector. Gebruik de door Hans gekozen meldroute; stuur geen externe berichten/tickets en wijzig geen abonnementen zonder opdracht.

Lever uiteindelijk een actueel listing/SKU-register, mapping- en BOMtabel, regel-/importdiff, uitzonderingslijst, end-to-end testbewijs en ingevulde tracker. Sluit af met een normale ABS-import plus twee geplande Channable-runs zonder nieuwe kritieke afwijkingen.

# 7. Bronnen en overdracht

De onderstaande bestanden en bijlagen zijn in deze sessie gelezen. De primaire import-/productbronnen en mailbijlagen blijven ongewijzigd. De taaklijst staat aanvullend in het bestaande werkboek, tab Channable plan.

[S1 — Herstelde remschijfimport — snapshot 6 oktober / bestand 7 oktober](https://docs.google.com/spreadsheets/d/1EFL1FaiBf5TccRu9LKDihbrHKbPdXDsWm5gY9L5Hdcc/edit)

[S2 — Nieuwe productdata V3 — remblokken, remklauwen, fitment en GPSR](https://docs.google.com/spreadsheets/d/18oGxgeJazNqX5OAmlCFZc8l2XkR0q-b6Sx-uB3NlFbM/edit)

[S3 — Actieve eBay-export van 7 oktober — volledige CSV in mailbijlage](https://mail.google.com/mail/u/0/#all/1a1160b739f2a44e)

[S4 — Channable-orderdossier en incidentverificatie van 21 september](https://mail.google.com/mail/u/0/#all/1a0c35222dfcc7f0)

[S5 — Kwaliteitsrapport 26 september en rapportbijlagen van 6 oktober](https://mail.google.com/mail/u/0/#all/1a11033f7c7626af)

[S6 — Bestaand selectie- en groeiplan — Fixes, Bundels, Content_DE en Brondekking](https://docs.google.com/spreadsheets/d/1hNafiEnWb6dvCfpdLGbrfKlHX2CC-8aEtDstDY80Ke4/edit)

[S7 — Onderzoek custom bundel-SKU — architectuuradvies, geen implementatiebewijs](https://docs.google.com/document/d/1gaP4MZ3oS32dSCxb7CkVG7ijLoUhjeJO73ryxPOnS4w)

Lokale analysebestanden in de huidige werkomgeving, als Claude daar toegang toe heeft: /workspace/ebay-de-selection/channable_herstelplan_taken.json; evidence/recovered_mail_order_sku_conflicts.csv; evidence/recovered_mail_channable_orders_annotated.csv; evidence/content_oct7_import_update.json; evidence/content_bundle_integration_findings.json; actual_analysis.json. In een andere Claude-omgeving zijn deze paden geen beschikbare bestanden: gebruik dan de bovenstaande Drive-originelen en mailbijlagen. De bron-IDs/URL’s worden meegegeven; geen toegangstokens in het plan.
