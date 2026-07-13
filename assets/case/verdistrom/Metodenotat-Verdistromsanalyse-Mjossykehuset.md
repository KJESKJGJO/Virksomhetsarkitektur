# Verdistrømsanalyse — Mjøssykehuset

**Metodenotat for kobling mellom analysepakker, kapabiliteter og digitale produkter**

Versjon 0.1 — Utkast for diskusjon
Kjell Skjølås, juli 2026

---

## 1. Formål

Kapabilitetsmatrisen for Mjøssykehuset består av 16 prioriterte kapabiliteter fordelt på 3 analysepakker + tverrgående styring. Den beskriver *hva* sykehuset må mestre, men ikke *hvordan verdien skapes for pasient og virksomhet*.

Dette metodenotatet etablerer et **verdistrømsnivå mellom kapabilitet og work package** som:

- Bryter hver analysepakke ned i konkrete pasient- og driftsforløp
- Kobler value stages til de 16 kapabilitetene
- Kobler kapabiliteter til digitale produkter (SP-plattformer og SIHF-egne løsninger)
- Definerer eiere, KPI-er og informasjonsobjekter per stage
- Gir grunnlag for gevinstrealisering, prioritering og roadmap

## 2. Rammeverk

Modellen er en **hybrid mellom BIZBOK 12 og ArchiMate 3.2**, tilpasset norsk sykehuskontekst:

| Kilde | Bruk |
|---|---|
| BIZBOK Value Streams | Struktur: value stream → value stage → deltaker → value item → entrance/exit criteria |
| ArchiMate 3.2 | Notasjon: value stream, capability, business process, application component, data object |
| Porter | Skille mellom primære (pasient-orienterte) og støttende verdistrømmer |
| Lean/Value Stream Mapping | KPI-er per stage (ledetid, verditid, kvalitet, kostnad) |
| SIHF kapabilitetsmatrise | Kobling til de 16 kapabilitetene og de 3 analysepakkene |

**Kobling mellom nivåer:**

```
Analysepakke (A/B/C)
   └── Verdistrøm (7 stk)
         └── Value stage (5–7 per verdistrøm)
               ├── Kapabilitet (én eller flere av de 16)
               ├── Digitalt produkt (SP-plattform eller SIHF-løsning)
               ├── Informasjonsobjekt (FHIR/SNOMED/LOINC)
               ├── KPI (ledetid, kvalitet, gevinst)
               └── Eier (rolle/klinikk)
```

## 3. Verdistrømsportefølje

Basert på kapabilitetsmatrisen og Utviklingsplan 2022–2039 er det identifisert **7 verdistrømmer** — 4 primære (pasient-orienterte) og 3 støttende (drift/styring).

### Primære verdistrømmer

| # | Navn | Dominerende pakke | Kort beskrivelse |
|---|---|---|---|
| VS1 | Akutt inntak og innleggelse | A + B | Fra prehospital varsling til utskrivning fra akuttavdeling |
| VS2 | Elektivt kirurgisk forløp | A + B | Fra henvisning til etterkontroll for elektive inngrep |
| VS3 | Digital hjemmeoppfølging (DHO) | B + C | Fra rekruttering til langsiktig kronikeroppfølging hjemme |
| VS4 | Diagnostisk arbeidsflyt | A + C | Radiologi, patologi, klinisk-kjemisk lab — fra rekvisisjon til svarrapport |

### Støttende verdistrømmer

| # | Navn | Dominerende pakke | Kort beskrivelse |
|---|---|---|---|
| VS5 | Kapasitets- og bemanningsstyring | A + B + tverrgående | Kompetanseplanlegging, vaktplan, oppgavedeling |
| VS6 | Smart bygg og teknisk drift | C | FDVU, energi, medisinsk-teknisk utstyr, sikkerhet |
| VS7 | Datadrevet ledelse og gevinstrealisering | C + tverrgående | Virksomhetsstyring, digital tvilling, gevinstoppfølging |

## 4. Notasjon

### Value stage
Et diskret trinn i verdistrømmen med definerte inn-/utkriterier, deltakere og verdielementer.
**Skrivemåte:** `S1. Trigger`, `S2. Vurdering`, `S3. Beslutning`, …

### Kapabilitet-kobling
Value stage referer til kapabilitet via kort-ID:
- **A1** = Klinikkovergripende virksomhetsstyring
- **A2** = Pasientflyt og kapasitetsstyring
- **A3** = Akuttmedisinsk samhandling og mottaksfunksjon
- **A4** = Elektiv produksjonsstyring og planlagt aktivitet
- **A5** = Standardiserte pasientforløp og reduksjon av variasjon
- **A6** = Logistikk, transport og forsyningsstyring
- **B7** = Digital hjemmeoppfølging og digitale konsultasjoner
- **B8** = Samhandling med primærhelsetjenesten / Helsefellesskap
- **B9** = Pasient- og pårørendemedvirkning / helsekompetanse
- **B10** = Kompetanse-, bemannings- og oppgavedelingsstyring
- **C11** = Datadrevet virksomhetsstyring
- **C12** = Operativ intelligens og digital tvilling
- **C13** = Smart bygg, FDVU og teknisk driftsstyring
- **C14** = Integrasjon og digital plattformkapabilitet
- **C15** = Sikker og stabil tjenesteproduksjon
- **T16** = Gevinst-, endrings- og bærekraftsstyring (tverrgående)

### Digitale produkter (eierskap)
Hvert digitalt produkt merkes med eier:
- **[SP]** — Sykehuspartner leverer og forvalter (plattformprodukt)
- **[SIHF]** — Sykehuset Innlandet eier og forvalter selv
- **[Regional]** — HSØ RHF eller nasjonalt (NHN, Helsedir)

### Informasjonsobjekter
Refereres i FHIR R4-terminologi der det passer: `Patient`, `Encounter`, `Observation`, `Condition`, `ServiceRequest`, `DiagnosticReport`, `MedicationRequest`, `CarePlan`, `Task`, `DeviceObservation`, `Coverage`.

### KPI-typer
Fire dimensjoner per stage:
- **Ledetid** — tid fra inntreden til utreise av stage
- **Kvalitet** — utfallsmål (Clavien-Dindo, PROM, HAI, reinnleggelser)
- **Gevinst** — kostnad, kapasitetsutnyttelse, DRG, pasientvolum
- **Erfaring** — PREM, ansattbelastning, HR-indikatorer

## 5. Modenhet og gap

Verdistrømsmodellen kobles til det etablerte modenhetsrammeverket (1–5):

| Nivå | Navn | Kjennetegn på value stage-nivå |
|---|---|---|
| 1 | Initial | Ad hoc, personavhengig, ingen standardforløp |
| 2 | Reaktiv | Skriftlige rutiner finnes, men ikke digitalt støttet |
| 3 | Definert | Digitalt støttet, men fragmentert på tvers av produkter |
| 4 | Styrt | Sømløst digitalt, målt kontinuerlig, gevinst dokumentert |
| 5 | Optimaliserende | Selvjusterende (digital tvilling), prediktivt drevet |

**Mål for Mjøssykehuset 2032:** nivå 4 som hovedregel, nivå 5 på utvalgte stages (typisk innen VS3 DHO og VS7 datadrevet ledelse).

**Gap-analyse per value stage:**

```
Nå-modenhet (2026) → Mål-modenhet (2032)
        │
        ├── Rotårsak (menneske / prosess / teknologi / styring)
        │
        ├── Krav (funksjonelt + ikke-funksjonelt)
        │
        └── Work package (leveranse, avhengighet, tidspunkt)
              └── Outcome (målbar gevinst)
                    └── Eier (klinikk/stab/SP)
```

## 6. Grensesnitt mot SP

Sykehuspartner leverer plattformlaget. Hver value stage må dokumentere:

| SP-kapabilitet | Typiske produkter |
|---|---|
| Integrasjons- og plattformtjenester | HL7/FHIR-gateway, meldingsplattform, ESB |
| Sikker/stabil tjenesteproduksjon | Drift-SLA, patch-vindu, disaster recovery |
| Brukernær datadrevet tjenesteutvikling | Analytics workbench, dashboardplattform |
| Produktledelse og produktutvikling | EPJ (DIPS Arena), kurve (Metavision), PAS |
| Sikkerhets-/infrastrukturtjenester | IAM, Norsk Helsenett-tilgang, PKI |
| Skytjenester/dataplattform | HSØ Analyseplattform, Azure landing zones |

Krav til en value stage: **enhver avhengighet mot SP skal ha en tilhørende leveranseforespørsel eller SP-produkt-ID**.

## 7. Regional styringsmodell — HSØ områdestyrer

Fra april 2026 er regional digitalisering i Helse Sør-Øst styrt gjennom **8 områdestyrer** (Styresak 143-2025). Områdestyrene beslutter portefølje, prioritering og standarder på tvers av helseforetakene. Verdistrømsmodellen for Mjøssykehuset kobler områdenes portefølje til konkrete kliniske forløp — områdene beskriver *hva porteføljen skal oppnå*, verdistrømmene beskriver *hvordan forløpet skapes for pasient og drift*.

### 7.1 De 8 områdestyrene

| # | Områdestyre | Formål (kort) | Primær verdistrøm | Primære produkter |
|---|---|---|---|---|
| OS1 | Prehospital | AMK, ambulanse, akutthjelpere | VS1 | P08 |
| OS2 | Diagnostikk | Radiologi 2.0, lab, patologi, blodbank, KI-diagnostikk | VS4 | P04, P05 |
| OS3 | Pasientbehandling | EPJ, PAS, kurve, helselogistikk, legemidler | VS1, VS2 | P01, P02, P03, P07, P14 |
| OS4 | Helsesamhandling | Helsenorge, DHO, prøvesvar, PLO-meldinger | VS3 | P11, P12, P13, P15, P16 |
| OS5 | Datadrevet utvikling og forskning | Analyseplattform, FHIR, MDM, genomsenter, digital tvilling | VS7 | P17, P18, P19, P20 |
| OS6 | Byggteknologi | BIM, SD-anlegg, FDVU, IoT-sensorer, MTU, bærekraft bygg | VS6 | P21, P22, P23 |
| OS7 | Økonomi- og virksomhetsstyring | ERP, EPM, innkjøp, logistikk, kvalitet, portefølje | VS7 | P24, P25, P26 |
| OS8 | HR-tjenester | Lønn, personal, ressursstyring, kompetanse, utdanning | VS5 | P09 |

### 7.2 Mapping verdistrøm × områdestyre

| VS | OS1 | OS2 | OS3 | OS4 | OS5 | OS6 | OS7 | OS8 |
|---|---|---|---|---|---|---|---|---|
| **VS1 Akutt inntak** | **P** | S | **P** | S | | | | |
| **VS2 Elektivt kirurgisk** | | S | **P** | S | | | | |
| **VS3 DHO** | | | | **P** | | | | |
| **VS4 Diagnostikk** | | **P** | | | S | | | |
| **VS5 Kapasitet/bemanning** | | | S | | | | S | **P** |
| **VS6 Smart bygg** | | | | | | **P** | S | |
| **VS7 Datadrevet ledelse** | | | | | **P** | | **P** | S |

**P** = primært beslutningsforum for verdistrømmen · **S** = sekundær bidragsyter (samhandling, leveranser)

### 7.3 Praktiske konsekvenser for Mjøssykehuset

- **Hver value stage må identifisere ett primærområdestyre.** Beslutninger om produkter, prioritering og finansiering løftes dit — ikke til SP-linjen direkte.
- **Kryssende verdistrømmer krever koordinering mellom flere områdestyrer.** VS1 (akutt) berører OS1 (prehospital), OS3 (pasientbehandling) og OS4 (helsesamhandling) samtidig. Modellen synliggjør avhengighetene.
- **Regionale rammeavtaler og standarder** (FHIR, SNOMED CT, EPJ-mal, MTU-integrasjon PoCG) forvaltes av respektivt områdestyre og skal reflekteres som forutsetning i work package.
- **Gevinstrealisering (T16)** rapporteres både lokalt til prosjekt Mjøssykehuset OG oppover til det primære områdestyret.
- **Områdestyrene erstatter tidligere systemeiermøter og regionale styringsgrupper** — Mjøssykehuset må mappe eksisterende arbeidsforum til nytt regime.

### 7.4 Kilde

Styresak 143-2025 «Styrings- og samhandlingsmodell for digitalisering i Helse Sør-Øst». Presentasjon fra Helse Sør-Øst, april 2026.

## 8. Prosess for utfylling

Modellen er levende — skal fylles ut sammen med kliniske miljøer og produkteiere. Anbefalt prosess:

1. **Metode-forankring** (denne notatet + ledelsen)
2. **Verdistrøm-workshop per stream** (3–4 timer, 6–10 personer)
   - Fasilitator: enterprisearkitekt
   - Deltakere: klinisk leder, avdelingssykepleier, IT-ansvarlig, produktledere, pasientrepresentant
3. **Fylle ut Excel-arket per stage**: kapabiliteter → digitale produkter → informasjon → KPI → eier → gap
4. **Konsolidering**: EA verifiserer kobling mot kapabilitetsmatrisen, identifiserer overlapp/mangler
5. **PPTX-visualisering** for styringsgruppe og forankring
6. **Iterasjon**: kvartalsvis oppdatering i takt med prosjektfaser mot 2032

## 9. Leveranser i denne pakken

| Fil | Formål | Målgruppe |
|---|---|---|
| Metodenotat (dette dokument) | Rammeverk, notasjon, prosess | Arkitekter, PL, ledelse |
| Excel-modell (Verdistromsmodell_Mjossykehuset.xlsx) | Detaljert datamodell — 7 streams × 5–7 stages, 8 områdestyrer, mapping VS × OS og produkt × OS | Arkitekter, produkteiere, kliniske ledere |
| PPTX-visualisering (Verdistrommer_Mjossykehuset.pptx) | Swimlane-visualisering per stream + områdestyre-oversikt + mapping-matrise VS × OS | Styringsgruppe, workshops, forankring |

## 10. Referanser

- SIHF Kapabilitetsmatrise (juni 2026) — video-gjennomgang av 16 kapabiliteter
- Utviklingsplan 2022–2039, Sykehuset Innlandet HF
- Virksomhetsstrategi 2025–2028, Sykehuset Innlandet HF
- Konseptrapport Mjøssykehuset 2025, Helse Sør-Øst RHF
- BIZBOK Guide v12 (Business Architecture Guild)
- ArchiMate 3.2 Specification (The Open Group)
- Styresak 143-2025 «Styrings- og samhandlingsmodell for digitalisering i Helse Sør-Øst», Helse Sør-Øst RHF, april 2026
- Helse 4.0 — digitale tvillinger på prostatakreft pakkeforløp (Skjølås, 2026)

---

*Dette dokumentet er et tidlig utkast for diskusjon. Innhold, terminologi og struktur skal videreutvikles sammen med kliniske miljøer, SP og prosjektledelsen.*
