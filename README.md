# Health Data Hub (Flutter)

Pixel-close Flutter UI for the Dots-In **Flutter Assignment Aug 2026** — Medical & Fitness Part A.

## Design source

- Figma: https://www.figma.com/design/b6R5qEJaZ0UunV8WDjamY7/Flutter-Assignment-Aug-2026?node-id=2-5

## What’s included

- **Phenotype hub** — body overview, hormone chart, immune score ring, strengths/weaknesses, blood metrics
- **Organ Metrics drawer** — Heart, Lungs, kidneys, Brain, Bones, Stomach, Intestine + Blood/Hormone actions
- **Organ detail** — parameterized Heart/Lungs (+ other organs) with gauges, recommendations, risk list
- **Metric details** — Mentzer / LDL ranges gauge, impacted parameters, about copy
- **flutter_bloc** Cubits, **go_router**, dummy JSON, **CustomPainter** gauges/charts/pedestal
- Purposeful animations (gauge fill, chart draw-in, hero scale, drawer)

## Run

```bash
flutter pub get
flutter run
```

## Screen recording checklist

1. Scroll Phenotype hub  
2. Open Organ Metrics (avatar tap) → Heart → Lungs  
3. Open Mentzer Details from a risk tile / callout  
4. Use Blood Metrics / Hormone drawer actions  

## Notes

- No backend — data lives in `assets/data/phenotype.json`
- Visual assets under `assets/images/` (exported from Figma + usable organ PNGs)
