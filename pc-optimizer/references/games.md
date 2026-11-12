# Game presets

Pick the preset by game type, then adjust for the bottleneck found in the diagnosis.

## General rules
- **Display mode**: Exclusive fullscreen for competitive games; borderless is fine elsewhere if "Optimizations for windowed games" is on (Settings → System → Display → Graphics → Default graphics settings).
- **Frame cap**: with FreeSync/G-SYNC, cap at refresh − 3 (141 at 144 Hz, 162 at 165 Hz, 237 at 240 Hz) using the in-game limiter first, driver limiter second.
- **V-Sync**: off in game; let VRR + cap handle tearing.
- **Upscaler**: FSR / DLSS / XeSS "Quality" before lowering resolution. Add driver sharpening (RIS / NIS) at 50–80%.
- **Biggest FPS settings** in most engines: shadows, volumetrics/fog, ambient occlusion, reflections/ray tracing, foliage/grass density, crowd density. **Textures** cost VRAM, not FPS — keep them high if VRAM allows (4 GB → medium, 8 GB+ → high/ultra at 1440p).

## Competitive shooters (e.g. Valorant, CS2, Apex, Overwatch)
Goal: highest stable FPS ≥ refresh rate, lowest latency.
- All quality settings Low; UI quality Low.
- Off: vignette, bloom, distortion, motion blur, depth of field, film grain, chromatic aberration, "improve clarity"/extra sharpening in game.
- Anti-aliasing: MSAA none or 2x / FXAA. Anisotropic filtering 4x–8x (almost free).
- Reflex / Anti-Lag 2: On (+ Boost when CPU-bound).
- Raw input / raw input buffer: On. Windows mouse acceleration off (script handles it).
- Riot Vanguard / EAC / BattlEye must stay enabled; never suggest disabling them.

## Cinematic / open-world RPGs (e.g. The Witcher 3, Cyberpunk 2077, RDR2)
Goal: stable 60 FPS (or stable 1% lows) over peak FPS.
- Lock FPS to 60 (or VRR-friendly value) for consistency on mid/low-end GPUs.
- Upscaler Quality; textures high (VRAM permitting).
- Medium: shadows, foliage visibility, grass density, background characters/crowd, volumetrics.
- Off: hair simulation (HairWorks/TressFX), ray tracing on non-RTX/low-VRAM cards, motion blur, chromatic aberration.
- If a game offers DX11 and DX12, older GPUs (Polaris, GTX 900/1000) are often smoother in **DX11**. The Witcher 3 next-gen edition lets you pick DX11 in the launcher.

## Stutter checklist
1. Let shader compilation finish (first launch after driver update).
2. Game installed on SSD, ≥ 15% free space.
3. Close browser tabs with video, overlays (Discord, Steam, Xbox Game Bar) if not needed.
4. Check temps (GPU < 83 °C, CPU < 90 °C); clean dust filters.
5. RAM running at rated speed (XMP/EXPO enabled in BIOS).
