# Health Data Hub — Tech stack & architecture

Flutter UI for the Dots-In Medical & Fitness assignment (Part A). No backend — all data is local JSON.

## Tech stack

| Layer | Choice |
| --- | --- |
| Framework | Flutter (Dart SDK ^3.10) |
| State management | `flutter_bloc` (Cubits) + `equatable` |
| Navigation | `go_router` with Cupertino page transitions |
| Typography | `google_fonts` (Orbitron, Exo 2, Open Sans, etc.) |
| Vector assets | `flutter_svg` |
| Data | Local `assets/data/phenotype.json` via `HealthRepository` |
| Custom drawing | `CustomPainter` (health gauges, hormone chart) |

Targets iOS / Android. Design coordinates are authored against a **402px-wide** Figma frame and scaled to device width.

## Architecture

Feature-first layout under `lib/`:

```
lib/
  app/           # MaterialApp.router, DI, route table
  core/          # colors, typography, FigmaFrame scaling
  data/          # models + HealthRepository (JSON load)
  features/
    phenotype/   # hub screen + Cubit + chart/score widgets
    organ/       # organ detail + Cubit
    details/     # metric / Mentzer detail + Cubit
    blood/       # blood metrics list
    drawer/      # organ metrics bottom sheet
  shared/        # gauges, chrome, recommendation card, painters
```

### Data flow

1. `HealthRepository` loads and parses `phenotype.json` once.
2. App-wide `PhenotypeCubit` owns hub tab, drawer, and hormone focus.
3. Screen-scoped Cubits (`OrganCubit`, `MetricDetailCubit`) load by id from the same repository.
4. UI listens with `BlocBuilder` / `BlocConsumer`; navigation is declarative via `go_router`.

### UI approach

- **`FigmaFrame` + `At`**: positions widgets in design-space units so spacing stays proportional across devices.
- **Shared painters**: radial health dial and hormone line chart are drawn with `CustomPainter` and animated with `AnimationController`.
- **Reusable chrome**: header, toggles, callouts, risk tiles, recommendation / strengths–weakness card.

### Main routes

| Path | Screen |
| --- | --- |
| `/` | Phenotype hub (genotype / phenotype tabs) |
| `/organ/:id` | Organ detail (heart, lungs, …) |
| `/details/:id` | Metric detail (ranges, impacts, about) |
| `/blood` | Blood metrics list |

## Run

```bash
flutter pub get
flutter run
```
