# NVIDIA GeForce – Control Panel / NVIDIA App

The user applies these in **NVIDIA Control Panel** → Manage 3D settings (Global or Program Settings), or the **NVIDIA App** → Graphics.

## Manage 3D settings

| Setting | Value | Why |
|---|---|---|
| Low Latency Mode | On (Ultra only if the game lacks Reflex) | Fewer queued frames |
| Power management mode | Prefer maximum performance (per-game) | Avoids clock drops; Global "Normal" saves idle power |
| Texture filtering – Quality | High performance | Negligible visual loss |
| Shader Cache Size | Driver default or 10 GB+ | Fewer stutters after updates |
| Vertical sync | Off (On only with G-SYNC + FPS cap, see below) | |
| Max Frame Rate | 3 below refresh rate when using G-SYNC (e.g. 141 at 144 Hz) | Keeps FPS inside VRR range |
| Threaded Optimization | Auto | |
| Image Scaling (NIS) | Off globally | Prefer DLSS/FSR in-game |

## In-game
- **NVIDIA Reflex**: On (On + Boost if CPU-bound). If Reflex is on, Low Latency Mode in the panel is ignored for that game.
- **DLSS**: Quality at 1440p, Balanced/Performance at 4K. Frame Generation only on RTX 40/50 and only when base FPS ≥ 60.

## Display
- **Change resolution**: pick the highest refresh rate; Output color format RGB, Full dynamic range.
- **Set up G-SYNC**: Enable for full screen and windowed mode (if the monitor is G-SYNC Compatible).

## System
- **Resizable BAR**: RTX 30 series and newer. Enable "Above 4G Decoding" + "Re-Size BAR" in BIOS.
- **Driver**: Game Ready driver via NVIDIA App. Use DDU only for real driver corruption or vendor switches.
- **Overlay/Instant Replay**: turn off if unused (NVIDIA App → Settings → Features).
