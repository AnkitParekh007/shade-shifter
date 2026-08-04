# Shade Shifter — Online marketplaces and procurement links

**Project:** App-controlled color-changing eyeglass frame  
**Market:** India, with delivery to Mumbai  
**Prepared:** 4 August 2026  
**Purpose:** Online buying guide for the Experience POC, material-feasibility experiments, eyewear mechanics, PCB fabrication, prototyping and electronics workbench.

> Prices and availability change frequently. All prices below are indicative procurement ranges, not quotations. Confirm GST, delivery, customs, warranty, specifications and stock before placing an order.

## 1. Recommended buying strategy

Use different types of online sellers for different risks:

| Purchase type | Preferred channel | Why |
|---|---|---|
| Generic hand tools, tape, storage and common consumables | Amazon India | Fast delivery, broad choice and easy returns |
| Development boards, modules, LED strips and prototype wire | Robu, Robodo, Probots, FlyRobo or ElectronicsComp | Better maker inventory and technical descriptions than general marketplaces |
| MCU modules, power ICs, connectors and production-intent components | Mouser India, DigiKey India, element14 India, RS India or Evelta | Manufacturer part numbers, traceability and datasheets |
| Micro-LiPo batteries | Specialist Indian robotics store for experiments; certified battery-pack vendor for wearable alpha | Cell thickness, protection and certification matter more than price |
| Rigid/flex PCB and assembly | PCB Power/LionCircuits for India; JLCPCB/PCBWay for international comparison | Online DFM, fabrication and assembly quotations |
| Frame shells | Online 3D-printing services such as iamRapid or Makenica | Upload CAD and select SLA for appearance or PA12 SLS/MJF for function |
| Eyewear frames and small optical accessories | IndiaMART/TradeIndia for supplier discovery; Amazon only for donor samples | Mechanical specifications usually require an RFQ and samples |
| ITO-PET, conductive inks and electrochromic samples | Techinstro or research-material specialists | General “smart film” listings are commonly PDLC and do not change frame color |

## 2. Marketplace directory

### 2.1 General Indian marketplaces

| Marketplace | Link | Best Shade Shifter purchases | Avoid/verify |
|---|---|---|---|
| Amazon India | [Amazon India](https://www.amazon.in/) | Hand tools, caliper, scale, ESD supplies, safety glasses, Kapton tape, heat-shrink, cases and basic instruments | Seller identity, reviews, calibration claims and electrical safety |
| Amazon Business | [Amazon Business India](https://www.amazon.in/business) | GST invoices, repeat consumables and team purchases | Business price is not always the lowest price |
| Flipkart | [Flipkart](https://www.flipkart.com/) | Backup source for generic tools and storage | Technical components have inconsistent specifications |
| Moglix | [Moglix](https://www.moglix.com/) | Branded instruments, soldering equipment, ESD and industrial safety products | Compare model number and warranty before checkout |
| IndustryBuying | [IndustryBuying](https://www.industrybuying.com/) | Bench tools, measurement equipment, fasteners and workshop safety | Confirm seller, calibration and delivery time |
| IndiaMART | [IndiaMART](https://www.indiamart.com/) | Wholesale frames, hinges, spectacle cases, batteries, acrylic cutting and fabrication RFQs | It is a supplier-discovery platform; qualify every seller and buy samples first |
| TradeIndia | [TradeIndia](https://www.tradeindia.com/) | Alternate B2B source for eyewear components, adhesives and fabrication | MOQ, GST registration, sample policy and actual manufacturer status |

### 2.2 Indian electronics and robotics stores

| Store | Link | Best purchases | POC role |
|---|---|---|---|
| Robu | [Robu](https://robu.in/) | Espressif boards, chargers, regulators, sensors, LED products, wire, connectors, tools and test modules | Primary Indian online prototype store |
| Robodo / Bombay Electronics | [Robodo](https://robodo.in/) | ESP32 boards, [micro-LiPo batteries](https://robodo.in/collections/micro-lipo-batteries), connectors and prototyping accessories | Useful Mumbai seller and battery-size sampling source |
| Evelta | [Evelta](https://evelta.com/) | Genuine ICs/modules, connectors, Nordic/Espressif parts and engineering components | Production-direction parts with part-number discipline |
| Probots | [Probots](https://probots.co.in/) | Boards, modules, batteries, sensors and tools; example [ESP32-C3 Super Mini](https://probots.co.in/esp32-c3-supermini-development-board-risc-v-wifi-bt-type-c.html) | Board and module price comparison |
| FlyRobo | [FlyRobo](https://www.flyrobo.in/) | Development boards, modules, test accessories and robotics parts; example [ESP32-C3 Super Mini](https://www.flyrobo.in/esp32-c3-super-mini-development-board-with-4mb-flash) | Backup prototype source |
| ElectronicsComp | [ElectronicsComp](https://www.electronicscomp.com/) | Passives, modules, connectors, tools and mechanical components | Common BOM fill-in source |
| Hubtronics | [Hubtronics](https://hubtronics.in/) | Embedded boards, sensors and modules; example [ESP32-C3 Super Mini](https://hubtronics.in/esp32-c3-super-mini-unsoldered) | Backup for compact BLE board samples |
| Sharvi Electronics | [Sharvi Electronics](https://sharvielectronics.com/) | Specialized LEDs; example [WS2812B-2020 RGB LED](https://sharvielectronics.com/product/ws2812b-2020-addressable-rgb-pixel-led-2020-package/) | Micro-LED coupon and fascia experiments |
| MakerBazar | [MakerBazar](https://makerbazar.in/) | Maker modules, soldering accessories and prototype parts | Secondary comparison store |
| Zbotic | [Zbotic](https://zbotic.in/) | Electronics, tools and PCB prototyping options | Secondary source and price comparison |
| The Engineer Store | [The Engineer Store](https://www.theengineerstore.in/) | Development boards and electronics modules | Alternate board supply |

### 2.3 Authorized component distributors

Use these stores when an exact manufacturer part number, lifecycle status, datasheet, traceability or repeatable production supply matters.

| Distributor | Link | Recommended use | Procurement note |
|---|---|---|---|
| Mouser India | [Mouser India](https://www.mouser.in/) | Nordic BLE modules, Espressif modules, regulators, load switches, ESD protection, connectors and temperature sensors | Consolidate orders to reduce freight; check GST/import checkout details |
| DigiKey India | [DigiKey India](https://www.digikey.in/) | Exact ICs, antennas, connectors, development kits and hard-to-find passives | Excellent parametric search; check landed cost |
| element14 India | [element14 India](https://in.element14.com/) | Semiconductors, test tools, connectors, passives and branded development kits | India entity and broad engineering catalog |
| RS India | [RS India](https://in.rsdelivers.com/) | Test equipment, ESD, industrial connectors, tools and electronics | Strong for branded workshop equipment |
| Arrow | [Arrow Electronics India](https://www.arrow.com/en/) | Manufacturer-authorized semiconductors and design-stage sourcing | More useful after MCU/power architecture is fixed |
| Octopart | [Octopart](https://octopart.com/) | Compare stock, lifecycle and distributor pricing by exact part number | Comparison engine, not the final seller |

**Rule:** Record the manufacturer, manufacturer part number, package, datasheet URL, seller, quantity, unit price and date in the repository BOM. Do not record only “ESP32 board” or “charger module.”

## 3. Experience POC — direct online sourcing map

### 3.1 Controllers, light and power

| Required item | Target specification | Qty | Preferred online links | Indicative total |
|---|---|---:|---|---:|
| ESP32-C3 development board | USB-C, BLE 5, 3.3 V I/O, compact board | 5 | [Robu official DevKit listing](https://robu.in/product/espressif-esp32-c3/), [Robodo compact board](https://robodo.in/products/esp32-c3-super-mini-usb-c-type-development-board-compact-wifi-and-bluetooth-board), [Amazon search](https://www.amazon.in/s?k=ESP32-C3+development+board) | ₹2,500–₹6,000 |
| nRF52 production-direction boards | nRF52832 or nRF52840, onboard antenna | 2 | [Mouser search](https://www.mouser.in/c/?q=nRF52840%20development%20kit), [DigiKey search](https://www.digikey.in/en/products/filter/rf-evaluation-and-development-kits-boards/859?s=N4IgTCBcDaIMoA8CmAnAxgCxAXQL5A) | ₹3,000–₹10,000 |
| Micro RGB LEDs | WS2812B-2020 or SK6805-EC15/1515, datasheet required | 100–200 | [Sharvi WS2812B-2020](https://sharvielectronics.com/product/ws2812b-2020-addressable-rgb-pixel-led-2020-package/), [Alibaba search](https://www.alibaba.com/trade/search?SearchText=WS2812B-2020) | ₹1,000–₹4,000 plus import cost if applicable |
| Narrow addressable LED strip | 3–5 mm preferred; buy only for first light proof | 2 m | [Robu search](https://robu.in/?s=addressable+LED+strip&post_type=product), [Amazon search](https://www.amazon.in/s?k=narrow+addressable+LED+strip) | ₹1,000–₹3,000 |
| Protected micro-LiPo cells | 3.7 V, 150–250 mAh, ≤6 mm thick, protection PCB, traceable cell code | 8–10 | [Robodo micro-LiPo collection](https://robodo.in/collections/micro-lipo-batteries), [Robu LiPo search](https://robu.in/?s=lipo+battery&post_type=product) | ₹3,000–₹9,000 |
| USB-C single-cell charger | Configurable 100–200 mA, protection; load sharing preferred | 5 | [Robu charger search](https://robu.in/?s=lithium+battery+charger+USB+C&post_type=product), [Amazon search](https://www.amazon.in/s?k=USB-C+LiPo+charger+module+protection) | ₹1,000–₹3,500 |
| Regulators/protection/passives | 3.3 V regulator, load switch, ESD diode, logic shifter, resistors and capacitors | 5 sets | [Mouser](https://www.mouser.in/), [DigiKey](https://www.digikey.in/), [element14](https://in.element14.com/) | ₹1,500–₹5,000 |
| NTC temperature sensors | 10 kΩ, B=3950, small SMD or bead | 10 | [element14 search](https://in.element14.com/c/sensors-transducers/sensors/thermistors/ntc-thermistors), [Amazon search](https://www.amazon.in/s?k=10k+3950+NTC+thermistor) | ₹200–₹1,000 |
| Buttons/connectors | Side tactile switch, USB-C breakout/receptacle, JST 1.0/1.25 mm and pogo pins | 5 sets | [Robu connectors](https://robu.in/product-category/electronic-components/connectors/), [Mouser connectors](https://www.mouser.in/c/connectors/) | ₹1,500–₹5,000 |
| Flexible interconnect | 30–36 AWG silicone wire, FFC/FPC, Kapton and fine heat-shrink | 3 sets | [Robu](https://robu.in/), [Amazon search](https://www.amazon.in/s?k=30+AWG+silicone+wire+Kapton+tape+heat+shrink) | ₹1,500–₹4,000 |

### 3.2 Battery safety gate

Do **not** buy a wearable battery merely because a listing says “LiPo 200 mAh.” Before it goes near a face, obtain:

- cell manufacturer and exact cell code;
- physical dimensions and mass;
- rated/typical capacity and maximum charge current;
- integrated protection details;
- IEC 62133-2 and UN 38.3 evidence or the pack supplier’s test documentation;
- manufacturing date/lot code;
- swelling, short-circuit and incoming-inspection process.

Marketplace batteries may be used for supervised bench experiments in a LiPo-safe setup. Move to a documented custom pack before the wearable alpha.

## 4. Optical and mechanical purchases

| Required item/service | Online links | What to request | Indicative cost |
|---|---|---|---:|
| Donor eyeglass frames | [Amazon frame search](https://www.amazon.in/s?k=full+rim+wide+temple+eyeglass+frame), [IndiaMART spectacle frames](https://dir.indiamart.com/impcat/spectacle-frames.html) | Full-rim acetate/TR90/nylon, ≥6 mm temple width, standard hinge, plano/demo lens; buy 6–8 samples | ₹4,000–₹15,000 |
| Plano polycarbonate lenses | [IndiaMART optical-lens search](https://dir.indiamart.com/search.mp?ss=plano+polycarbonate+spectacle+lens) | Plano, polycarbonate, clear, edging compatibility and optional hard coat | ₹1,500–₹6,000 for 3–5 pairs |
| Hinges, screws and nose parts | [IndiaMART eyeglass-parts search](https://dir.indiamart.com/search.mp?ss=eyeglass+hinges+screws), [Amazon spectacle-repair search](https://www.amazon.in/s?k=spectacle+repair+screws+hinges) | M1–M1.4 samples, barrel/spring hinges, dimensional drawing and material | ₹1,000–₹4,000 |
| Spectacle cases | [Amazon hard-case search](https://www.amazon.in/s?k=oversized+hard+spectacle+case), [IndiaMART cases](https://dir.indiamart.com/impcat/spectacle-cases.html) | Oversized hard case with room for charging connection | ₹1,000–₹3,000 |
| SLA appearance prints | [iamRapid](https://iamrapid.com/), [Makenica](https://makenica.com/), [3Ding Mumbai](https://www.3ding.in/services/3d-printing-services-in-mumbai) | Tough/ABS-like resin, smooth finish, dimensional report; upload STEP/STL | ₹2,000–₹8,000 per iteration |
| SLS/MJF functional shells | [iamRapid](https://iamrapid.com/), [Makenica](https://makenica.com/), [Dimenl](https://dimenl.com/3d-printing) | PA12 nylon, orientation, dye/finish, dimensional tolerance and minimum wall | ₹4,000–₹15,000 per iteration |
| Frosted PMMA/light guide | [IndiaMART frosted-acrylic search](https://dir.indiamart.com/search.mp?ss=frosted+acrylic+sheet+laser+cutting), [Amazon acrylic search](https://www.amazon.in/s?k=frosted+acrylic+sheet+1mm) | 0.5–1.5 mm coupon; ask for transmission/haze where available | ₹2,000–₹8,000 including cutting trials |
| Small fasteners | [Amazon micro-screw search](https://www.amazon.in/s?k=M1+M1.2+M1.4+micro+screws), [IndiaMART micro-fastener search](https://dir.indiamart.com/search.mp?ss=micro+screws+m1) | M1/M1.2/M1.4 assorted lengths; stainless material declaration | ₹1,000–₹3,000 |

The donor frame must carry lens, bridge and hinge loads. Keep the electronic fascia removable and non-structural during the POC.

## 5. PCB and electronics fabrication

| Vendor | Link | Recommended use | Key RFQ fields |
|---|---|---|---|
| PCB Power | [PCB Power](https://www.pcbpower.com/) | India-based rigid PCB, assembly and later flex inquiry | Layer count, thickness, copper, ENIG, impedance, assembly and test |
| LionCircuits | [LionCircuits](https://www.lioncircuits.com/) | India-based online PCB fabrication and assembly | Gerber/ODB++, BOM, centroid, DFM and component sourcing |
| Circuitwala | [Circuitwala](https://www.jpcpcb.com/) | Price comparison for simple India-made prototypes | Confirm capabilities before using fine-pitch/micro-LED designs |
| JLCPCB | [JLCPCB](https://jlcpcb.com/) | Rigid/flex prototype price comparison and assembly | Flex stack-up, stiffener, ENIG, controlled bend zone, import charges |
| PCBWay | [PCBWay](https://www.pcbway.com/) | Flex PCB, assembly and mechanical-service comparison | Same released fabrication package sent to all bidders |

For the frame flex PCB, request polyimide, one or two layers, ENIG, stiffeners only at connector/solder regions, dynamic-versus-static bend declaration, panel drawing, micro-LED assembly capability, automated optical inspection and electrical test. Budget **₹8,000–₹30,000** for an early 5–10-piece experiment, depending on assembly and import cost.

## 6. Material-feasibility track

This is the highest-risk procurement area. A product called “smart film” is not automatically a color-changing film.

| Material | Preferred link | Use | Indicative cost/risk |
|---|---|---|---|
| ITO-coated PET sheet | [Techinstro ITO-PET](https://techinstro.com/shop/conductive-glass/ito-coated-on-pet-films/) | Transparent electrode coupons; specify sheet resistance, transmission, PET thickness and bend radius | ₹10,000–₹35,000 landed/small order depending on size |
| Small educational ITO-PET | [Adafruit ITO PET](https://www.adafruit.com/product/1309) | Very small flat electrode experiments | International shipping/import; not production material |
| Roll-format ITO-PET | [InfinityPV](https://www.infinitypv.com/coating-supplies/p/ito-coated-pet-film-roll) | Later roll-to-roll research, not first purchase | High MOQ/cost; listed roll prices start in the hundreds of euros |
| Flexible silver-nano film | [Nano Cintech](https://nanocintech.com/products/conductive-films/) | Alternative transparent electrode evaluation | International sample/RFQ; validate sheet resistance and encapsulation |
| Conductive silver ink/paste | [Dycotec silver conductors](https://www.dycotecmaterials.com/product-category/printed-electronics/silver-conductors/) | Printed electrode/contact experiments | Cure temperature may exceed substrate/coating limit |
| Conductive silver epoxy | [Mouser search](https://www.mouser.in/c/?q=conductive%20silver%20epoxy), [Amazon search](https://www.amazon.in/s?k=MG+Chemicals+conductive+silver+epoxy) | Low-volume electrode connection | ₹3,000–₹15,000; check shelf life and storage |
| Imported ITO-PET samples | [Alibaba ITO-PET search](https://www.alibaba.com/trade/search?SearchText=ITO+PET+conductive+film) | Supplier discovery and samples after written specifications | Quality/MOQ/customs risk; use Trade Assurance and incoming tests |
| PDLC smart film | [IndiaMART PDLC search](https://dir.indiamart.com/search.mp?ss=PDLC+smart+film) | Only lamination/electrode-handling learning | ₹5,000–₹20,000; changes transparency, **not arbitrary color** |

### Material purchase acceptance checklist

Before ordering any conductive or electrochromic film, obtain:

1. Color states and CIE L\*a\*b\* or reflectance/transmittance data.
2. Whether color persists without power and the voltage/current waveform required.
3. Flexible substrate type and total stack thickness.
4. Minimum bend radius, switching cycles and switching time.
5. Operating/storage temperature and UV data.
6. Sweat, humidity, chemical and edge-sealing requirements.
7. Electrode patterning and connection method.
8. Sample dimensions, MOQ, shelf life and export classification.

Do not purchase architectural PDLC expecting it to demonstrate multicolor frame recoloring.

## 7. Workbench tools — online purchase list

| Tool | Minimum specification | Suggested links | Budget |
|---|---|---|---:|
| Temperature-controlled soldering station | 60–90 W, grounded/ESD-safe, replaceable fine tips | [element14 soldering stations](https://in.element14.com/c/tools-production-supplies/soldering-stations-accessories/soldering-stations), [Amazon search](https://www.amazon.in/s?k=ESD+safe+temperature+controlled+soldering+station) | ₹7,000–₹15,000 |
| Hot-air rework station | Adjustable temperature/airflow, small nozzles and safe holder | [Amazon search](https://www.amazon.in/s?k=hot+air+rework+station+ESD), [Moglix search](https://www.moglix.com/search/hot%20air%20rework%20station) | ₹4,000–₹10,000 |
| Digital multimeter | Fused inputs, mV/mA ranges, capacitance and continuity | [RS multimeters](https://in.rsdelivers.com/browse/test-measurement/multimeters-accessories/digital-multimeters), [Amazon search](https://www.amazon.in/s?k=Kusam+Meco+digital+multimeter) | ₹3,000–₹12,000 |
| Bench DC supply | 0–30 V, 0–3/5 A, current limit, useful resolution below 100 mA | [element14 power supplies](https://in.element14.com/c/test-measurement/bench-power-supplies-loads/bench-power-supplies), [Amazon search](https://www.amazon.in/s?k=30V+5A+bench+DC+power+supply+current+limit) | ₹6,000–₹18,000 |
| USB-C power meter | Voltage/current/Wh display; logging preferred | [Amazon search](https://www.amazon.in/s?k=USB+C+power+meter+voltage+current+Wh) | ₹1,500–₹5,000 |
| Logic analyzer | 8-channel, 24 MHz class for first POC | [Robu search](https://robu.in/?s=logic+analyzer&post_type=product), [Amazon search](https://www.amazon.in/s?k=8+channel+24MHz+logic+analyzer) | ₹1,000–₹5,000 |
| Electronic load/battery tester | Constant-current mode at low current; logging preferred | [Amazon search](https://www.amazon.in/s?k=programmable+DC+electronic+load+battery+tester) | ₹4,000–₹15,000 |
| Lux meter | Range suitable for indoor/outdoor comparison | [Moglix search](https://www.moglix.com/search/lux%20meter), [Amazon search](https://www.amazon.in/s?k=digital+lux+meter) | ₹2,000–₹8,000 |
| Digital caliper | 0.01 mm resolution; verify against gauge/reference | [Amazon search](https://www.amazon.in/s?k=0.01mm+digital+caliper) | ₹800–₹3,000 |
| Precision scale | 0.1 g resolution, ≥500 g capacity | [Amazon search](https://www.amazon.in/s?k=0.1g+precision+scale+500g) | ₹500–₹2,000 |
| Magnification | Illuminated bench magnifier or microscope | [Amazon search](https://www.amazon.in/s?k=electronics+soldering+microscope+magnifier) | ₹1,500–₹8,000 |
| Fine hand tools | ESD tweezers, flush cutter, wire stripper, pin vise, micro files and precision drivers | [Amazon electronics-tool search](https://www.amazon.in/s?k=electronics+precision+tool+kit+ESD+tweezers+flush+cutter) | ₹3,000–₹10,000 |
| ESD protection | ESD mat, grounded lead and wrist strap | [RS ESD protection](https://in.rsdelivers.com/browse/esd-control-clean-room-pcb-prototyping/esd-control-clean-room/esd-grounding), [Amazon search](https://www.amazon.in/s?k=ESD+mat+wrist+strap+grounding) | ₹1,500–₹5,000 |
| Fume extraction | Replaceable-filter electronics fume extractor | [Amazon search](https://www.amazon.in/s?k=solder+fume+extractor+filter) | ₹2,000–₹8,000 |
| LiPo safety | LiPo-safe bags, nonflammable charging surface and suitable extinguisher nearby | [Amazon LiPo-bag search](https://www.amazon.in/s?k=LiPo+safe+battery+bag), [Amazon fire-extinguisher search](https://www.amazon.in/s?k=certified+ABC+fire+extinguisher) | ₹2,000–₹6,000 |
| Eye protection | Impact-rated safety glasses | [Moglix search](https://www.moglix.com/search/safety%20goggles), [Amazon search](https://www.amazon.in/s?k=ISI+safety+goggles) | ₹300–₹1,500 |

Rent or borrow a radiometric thermal camera and calibrated colorimeter/spectrophotometer for the POC instead of buying them. Budget approximately **₹5,000–₹20,000** for rental or lab access; obtain the instrument model, calibration state, close-focus capability and raw-data format.

## 8. Consumables and adhesives

| Item | Online links | Selection note | Budget |
|---|---|---|---:|
| Lead-free solder and flux | [element14](https://in.element14.com/c/tools-production-supplies/soldering/solder-wire), [Amazon search](https://www.amazon.in/s?k=electronics+lead+free+solder+no+clean+flux) | Buy known brand with alloy/flux declaration and SDS | ₹1,000–₹3,000 |
| Kapton/polyimide tape | [Amazon search](https://www.amazon.in/s?k=Kapton+polyimide+tape+electronics) | Verify actual polyimide and temperature rating | ₹300–₹1,500 |
| Copper foil tape | [Amazon search](https://www.amazon.in/s?k=conductive+copper+foil+tape) | State whether adhesive itself must be conductive | ₹300–₹1,500 |
| Heat-shrink and silicone wire | [Robu](https://robu.in/), [Amazon search](https://www.amazon.in/s?k=fine+heat+shrink+30AWG+silicone+wire) | Flexible, small diameter and temperature-rated | ₹800–₹3,000 |
| Neutral-cure electronics silicone | [Amazon search](https://www.amazon.in/s?k=neutral+cure+electronics+silicone) | Obtain SDS; avoid acetic-cure silicone near electronics | ₹500–₹2,000 |
| Removable thin adhesive tape | [Amazon search](https://www.amazon.in/s?k=3M+thin+double+sided+electronics+tape) | Use for removable fascia/coupon mounting | ₹500–₹2,000 |
| UV/optical resin | [Amazon search](https://www.amazon.in/s?k=UV+optical+clear+adhesive+resin) | Use only after skin-contact, yellowing and cure review | ₹1,000–₹4,000 |

Do not allow uncured resin, unknown adhesive or exposed conductor to touch the wearer’s skin. Obtain the safety data sheet and fully cure/process the material according to its supplier.

## 9. Staged online purchase orders

### Order 1 — Bench proof, week 1

| Basket | Expected spend |
|---|---:|
| 5 ESP32-C3 boards, two narrow addressable LED-strip samples, chargers, buttons, NTCs and basic connectors | ₹8,000–₹15,000 |
| Protected battery samples, LiPo bags and wiring | ₹5,000–₹12,000 |
| Soldering station, multimeter, bench supply and essential hand tools | ₹22,000–₹45,000 |
| Kapton, heat-shrink, solder, flux, tapes and safety supplies | ₹5,000–₹12,000 |
| **Order 1 total** | **₹40,000–₹84,000** |

**Gate:** Demonstrate BLE color control, current limiting, temperature monitoring, emergency off and one-hour supervised operation before ordering custom mechanics.

### Order 2 — Wearable-form exploration, weeks 2–4

| Basket | Expected spend |
|---|---:|
| 6–8 donor frames, plano lenses, hinges/screws and cases | ₹8,000–₹20,000 |
| Micro RGB LEDs and two PCB/flex coupon variants | ₹10,000–₹30,000 |
| One SLA appearance and one PA12 functional print iteration | ₹8,000–₹20,000 |
| Diffuser/light-guide and adhesive coupons | ₹3,000–₹10,000 |
| **Order 2 total** | **₹29,000–₹80,000** |

**Gate:** Achieve a removable electronic fascia, acceptable brightness, no pressure point, controlled surface temperature and target mass trajectory.

### Order 3 — Material feasibility, only after supplier RFI

| Basket | Expected spend |
|---|---:|
| ITO-PET and alternative transparent-conductor samples | ₹10,000–₹40,000 |
| Conductive ink/epoxy, electrode materials and sealing coupons | ₹5,000–₹25,000 |
| Electrochromic samples or development engagement | ₹25,000–₹1,50,000 |
| External color/UV/sweat/cycle testing allowance | ₹20,000–₹1,00,000 |
| **Order 3 total** | **₹60,000–₹3,15,000** |

Do not place Order 3 from an attractive video or listing title. Require the material acceptance data in Section 6 first.

## 10. Recommended first online cart

For the fastest credible POC, start with:

1. Five ESP32-C3 boards from Robu/Robodo, with one board from a second supplier for comparison.
2. Two narrow addressable LED strip types for the bench proof.
3. A cut tape of 100–200 WS2812B-2020 LEDs only after receiving the datasheet and reel label.
4. Eight 150–250 mAh protected micro-LiPo samples in at least two physical sizes.
5. Five USB-C charger/protection boards, NTCs, tactile switches, JST connectors and fine silicone wire.
6. A proper soldering station, fused multimeter, current-limited bench supply, ESD setup, fume extraction and LiPo-safe bags.
7. Six inexpensive wide-temple donor frames from two suppliers.
8. One SLA and one PA12 print only after the first LED-and-BLE bench demo works.

Estimated initial online procurement envelope: **₹71,000–₹1,61,000**, consistent with the Mumbai-local procurement plan. Hold back premium instruments and electrochromic development until the experience proof and demand gate pass.

## 11. Checkout and supplier-validation checklist

Before payment:

- Compare the exact manufacturer part number across at least two sellers.
- Save the product page, datasheet, quotation and lead time.
- Confirm GST invoice, freight, insurance, return policy and warranty.
- For imports, calculate product price + freight + duty/tax + courier handling + bank/FX cost.
- Ask whether stock is physically held or drop-shipped.
- Reject relabelled parts, erased markings or stock without a traceable manufacturer.
- For batteries, request certification/test evidence and manufacturing lot.
- For films/adhesives, request SDS, storage temperature, shelf life and cure process.
- For optical/mechanical parts, obtain dimensions or a drawing, not only photographs.
- For custom fabrication, send the same released CAD/PCB package to every bidder.
- Inspect incoming quantity, markings, dimensions and damage before use.
- Quarantine any swollen battery, cracked cell pouch, contaminated film or ambiguous component.
- Update the repository BOM with actual price, date, seller and received part number.

## 12. Marketplace risk ranking

| Risk level | Appropriate purchase | Channel examples |
|---|---|---|
| Low | Hand tools, storage, tapes, generic screws and donor-frame experiments | Amazon, Flipkart, IndiaMART samples |
| Medium | Dev boards, modules, LED strips, prototype connectors and test accessories | Robu, Robodo, Probots, FlyRobo, ElectronicsComp |
| High | Battery, charger/power path, ESD protection, production MCU/module and skin-adjacent adhesive | Authorized distributor or qualified specialist supplier |
| R&D-critical | Electrochromic stack, ITO-PET, conductive ink and optical encapsulation | Research-material vendor with written data and incoming validation |

## 13. Final procurement recommendation

Use Amazon as the convenience layer, not as the engineering source of truth. The preferred order of trust is:

1. Manufacturer or authorized distributor.
2. Established Indian electronics/fabrication specialist.
3. Qualified B2B supplier after sample validation.
4. General marketplace seller for noncritical items.
5. Overseas marketplace only when the item is unavailable through traceable channels and the POC can tolerate incoming inspection and import delay.

This approach keeps the first demo fast while preventing cheap or incorrectly described batteries, power components and “smart films” from distorting the POC result.

## Sources checked

- [Mouser India](https://www.mouser.in/), [DigiKey India](https://www.digikey.in/) and [element14 India](https://in.element14.com/) — authorized electronics distribution.
- [Robodo micro-LiPo catalog](https://robodo.in/collections/micro-lipo-batteries) and [Robu](https://robu.in/) — India prototype sourcing.
- [Techinstro ITO-coated PET](https://techinstro.com/shop/conductive-glass/ito-coated-on-pet-films/) — conductive flexible substrates.
- [JLCPCB](https://jlcpcb.com/), [PCB Power](https://www.pcbpower.com/) and [LionCircuits](https://www.lioncircuits.com/) — PCB fabrication/assembly.
- [iamRapid](https://iamrapid.com/), [Makenica](https://makenica.com/) and [3Ding Mumbai](https://www.3ding.in/services/3d-printing-services-in-mumbai) — online additive manufacturing.
