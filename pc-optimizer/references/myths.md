# Tweaks to avoid

Don't recommend these. If the user asks, explain briefly why.

| Tweak | Why not |
|---|---|
| Disable Windows Defender / real-time protection | Real security risk; Dev Drive performance mode solves the dev-build case |
| Disable Windows Update | Missed security fixes and driver updates |
| Disable UAC | Security risk, no measurable gain |
| Disable anti-cheat services (Vanguard, EAC, BattlEye) | Games stop working; possible bans |
| "Debloat" scripts that remove Store/Xbox/system apps wholesale | Break Game Pass, Xbox app, updates; hard to undo |
| Disable SysMain (Superfetch) on SSD | Negligible gain; can slow app launches |
| Disable search indexing entirely | Slower search; tiny gain on NVMe |
| Disable paging file | Crashes when RAM runs out; some games require it |
| RAM "cleaners" / optimizers | Evict useful cache; make things slower |
| Nagle / TcpAckFrequency / network throttling registry hacks | No effect on modern games (they use UDP) |
| Win32PrioritySeparation, timer resolution, MMCSS hacks | Mostly placebo, sometimes worse frame pacing |
| Core-parking hacks on Intel 12th gen+ / Ryzen | Thread Director / scheduler handle it; can hurt E-core/P-core scheduling |
| "Registry cleaners" | No performance benefit, risk of breakage |
| Disabling HPET via bcdedit | Inconsistent results; skip |
| Disabling Memory Integrity / VBS | 5–10% FPS in some titles, but weaker kernel protection. Mention as a trade-off only; recommend keeping it on |
| Forcing HAGS on unsupported GPUs | HAGS needs GTX 1000+/RX 5000+/Arc; on supported cards it's optional — leave to user, test per game |
