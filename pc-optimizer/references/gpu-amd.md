# AMD Radeon – Adrenalin settings

The user applies these in **AMD Software: Adrenalin Edition** (right-click desktop → AMD Software). Prefer per-game profiles (Gaming → Games → pick the game) over global changes when settings differ between competitive and cinematic games.

## Global graphics (Gaming → Graphics → Custom)

| Setting | Value | Why |
|---|---|---|
| Radeon Anti-Lag | On (Anti-Lag 2 where the game supports it) | Lower input latency when GPU-bound |
| Radeon Chill | Off | Caps FPS dynamically; adds latency variance |
| Radeon Boost | Off | Drops resolution during motion; blurry |
| Radeon Image Sharpening (RIS) | On, 50–80% | Cheap sharpening, pairs well with FSR |
| Radeon Super Resolution (RSR) | Off globally | Use in-game FSR instead when available |
| Wait for Vertical Refresh | Off, unless application specifies | Use FreeSync + FPS cap instead of V-Sync |
| Texture Filtering Quality | Performance | Negligible visual loss |
| Surface Format Optimization | On | |
| Tessellation Mode | AMD optimized | |
| Shader Cache | AMD optimized | Reset it after driver updates if stutter appears |
| Enhanced Sync | Off | Can cause stutter/black screens on some titles |

## Display tab
- **AMD FreeSync**: On (also enable FreeSync/Adaptive Sync in the monitor's OSD).
- **GPU Scaling**: On, Scaling mode "Preserve aspect ratio" (or "Full panel" for stretched-resolution players).
- **10-bit pixel format**: Off for gaming.

## Performance → Tuning
- "Auto Overclock GPU" or "Auto Undervolt GPU" (RDNA) can give a few % or lower temps. Revert if games crash.
- Older Polaris cards (RX 470/480/570/580): Auto Overclock is safe; keep fan curve default unless temps > 80 °C.

## System
- **Smart Access Memory (SAM / Resizable BAR)**: RX 5000 series and newer only. Enable "Above 4G Decoding" + "Re-Size BAR" in BIOS. Not supported on Polaris (RX 400/500).
- **Driver**: install the latest Adrenalin. Polaris/Vega now receive maintenance releases — the latest available is still the right one. Use "Factory Reset" option only when switching GPU vendors or fixing corruption.
- **Startup**: AMD Noise Suppression and Adrenalin overlay can be disabled if unused.
