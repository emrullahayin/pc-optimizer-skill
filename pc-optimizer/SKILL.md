---
name: pc-optimizer
description: Diagnose and speed up a Windows 10/11 PC for gaming and software development, including GPU (AMD, NVIDIA, Intel) driver settings. Use when the user asks to make their PC faster, improve FPS, reduce input lag or stutter, tune Windows or graphics settings for a game (e.g. competitive shooters or open-world RPGs), or speed up builds, WSL, Docker, Git or IDEs. Produces a read-only diagnosis, a tailored plan, and a reversible optimization script the user runs themselves.
---

# PC Optimizer

Help the user get the most performance out of a Windows PC **safely and reversibly**. You diagnose with read-only commands, explain what will change and why, hand the user a script with a built-in backup and `-Undo`, then verify the result.

Reply in the user's language. Keep explanations short and concrete; use tables for status.

## Ground rules

- **Diagnose before recommending.** Never suggest a tweak without first checking the current value — many are already set.
- **The user applies system changes.** Do not change Windows system settings, the registry, power plans, drivers or security features yourself, even if the user grants "full permission". Prepare `scripts/optimize.ps1`, give the exact command, and let the user run it from an elevated terminal. Reading settings is fine.
- **Everything is reversible.** The script backs up registry keys, the active power plan and prior state to `Documents\PcOptimizerBackup` and creates a restore point. Always tell the user the `-Undo` command.
- **Never weaken security for FPS by default.** Do not disable Windows Defender, UAC, Windows Update, firewall, or anti-cheat services (e.g. Riot Vanguard, EAC, BattlEye). Memory Integrity / VBS may be mentioned as a 5–10% trade-off, but recommend keeping it on and let the user decide.
- **No placebo tweaks.** Skip "registry tweak packs", `TcpAckFrequency`/Nagle hacks, disabling SysMain/indexing on NVMe, "RAM cleaners", or core-parking hacks on modern CPUs. See `references/myths.md` before adding anything not listed here.
- **Be honest about bottlenecks.** If the GPU is underpowered for the monitor (e.g. a 4 GB card on 1440p/144 Hz), say so and say which settings/upgrades matter most.

## Workflow

### 1. Diagnose (read-only)
Run `scripts/diagnose.ps1` (no admin needed):

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-dir>\scripts\diagnose.ps1"
```

It reports CPU, RAM (size, speed, whether XMP/EXPO looks enabled), GPU + driver version/date, monitor resolution and refresh rate, disks, laptop vs desktop, power plan, Game Mode, Game DVR, HAGS, visual effects, Fast Startup, VBS, startup apps and free disk space.

From the output, identify:
- **Bottleneck** – GPU-bound vs CPU-bound for the user's resolution/refresh rate.
- **Quick wins** – Game DVR on, wrong refresh rate (e.g. 60 Hz on a 144 Hz monitor), XMP off (RAM at 2133/2400/4800 base speed), old GPU driver, many startup apps, low free space on C:.
- **Laptop** – if a battery exists, do not force Ultimate Performance on battery; the script handles AC only.

### 2. Ask what the PC is for
If not already clear, ask which games and which dev tools (Node, Python, .NET, Docker, WSL, Unity/Unreal...). Tailor the plan to that.

### 3. Present the plan
Show a short table: setting · current · new · why. Group into:
1. **Windows (script)** – applied by `scripts/optimize.ps1`.
2. **GPU driver panel (manual)** – from `references/gpu-amd.md`, `gpu-nvidia.md` or `gpu-intel.md` matching the detected GPU vendor.
3. **Per-game settings** – from `references/games.md`.
4. **Developer environment** – from `references/dev.md`.
5. **Manual user steps** – startup apps in Task Manager, BIOS (XMP/EXPO, Resizable BAR), monitor refresh rate.

### 4. Hand over the script
Copy `scripts/optimize.ps1` to a path the user can easily reach (e.g. their Desktop) and give the full command for an **administrator** terminal:

```powershell
powershell -ExecutionPolicy Bypass -File "C:\Users\<user>\Desktop\optimize.ps1"
```

Options the user can add: `-DryRun` (print what would change), `-SkipVisualEffects`, `-SkipHibernate`, `-SkipCleanup`, `-Undo`.

### 5. Verify
After the user runs it, run `scripts/verify.ps1` (read-only) and report a ✅/⚠️ table. Remind them to reboot if the last boot time is before the script ran. Then list remaining manual items (GPU panel, startup apps, in-game settings).

## What `optimize.ps1` changes

| Area | Change |
|---|---|
| Power | Activates Ultimate Performance (creates it if missing; falls back to High Performance), disables PCIe ASPM and USB selective suspend on AC, never sleep on AC |
| Gaming | Game Mode on, Xbox Game DVR background recording off |
| Visuals | "Best performance" visual effects, keeps font smoothing and thumbnails, no menu delay |
| Input | Mouse acceleration ("Enhance pointer precision") off |
| Boot | Fast Startup and hibernation off (desktops only by default) |
| Storage | SSD ReTrim on C:, clears user and Windows temp folders |

## References
- `references/gpu-amd.md` – AMD Adrenalin settings (Anti-Lag, FreeSync, RIS, Chill/Boost, SAM)
- `references/gpu-nvidia.md` – NVIDIA Control Panel / App settings (Low Latency, Reflex, G-SYNC, power mode)
- `references/gpu-intel.md` – Intel Arc / iGPU settings
- `references/games.md` – competitive vs cinematic game presets, frame caps, upscalers
- `references/dev.md` – Dev Drive, WSL/Docker memory, Git, IDE watchers, package caches
- `references/myths.md` – popular tweaks that don't help or cause harm
