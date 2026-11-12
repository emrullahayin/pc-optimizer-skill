# PC Optimizer — Claude Skill

A [Claude Agent Skill](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview) that safely and reversibly speeds up Windows 10/11 PCs for **gaming** and **software development**, including AMD / NVIDIA / Intel GPU settings.

Claude replies in the user's language, so the skill works for users worldwide.

## What it does

1. **Diagnosis (read-only):** Checks CPU, RAM (is XMP/EXPO enabled?), GPU and driver version, monitor refresh rate, disks, power plan, Game Mode, Game DVR, startup apps and developer tools.
2. **Tailored plan:** Finds the real bottleneck and recommends only settings that actually help. No placebo "registry tweaks".
3. **Reversible script:** `optimize.ps1` backs up current settings and creates a system restore point before changing anything. `-Undo` reverts everything in one command; `-DryRun` shows what would change first.
4. **GPU guides:** Recommended settings for AMD Adrenalin, NVIDIA Control Panel / NVIDIA App and Intel Arc.
5. **Game presets:** For competitive shooters (Valorant, CS2…) and cinematic RPGs (The Witcher 3, Cyberpunk 2077…).
6. **Developer environment:** Dev Drive, WSL/Docker memory limits, Git, VS Code and package caches.
7. **Verification:** `verify.ps1` checks that everything was applied.

## Safety principles

- The **user** applies system changes, not Claude. Claude prepares the script, gives the command and checks the result.
- Defender, UAC, Windows Update, the firewall and anti-cheat (Vanguard, EAC, BattlEye…) are **never** disabled.
- Every change is backed up and reversible.

## Installation

### Claude Code (global, available in every project)
```bash
git clone https://github.com/emrullahayin/pc-optimizer-skill.git
```
Copy the `pc-optimizer` folder into your personal skills folder:
- Windows: `%USERPROFILE%\.claude\skills\pc-optimizer`
- macOS/Linux: `~/.claude/skills/pc-optimizer`

### Claude.ai / Claude Desktop
Zip the `pc-optimizer` folder and upload it via **Settings → Capabilities → Skills → Upload skill**.

## Usage

Just ask Claude, for example:
- "Speed up my PC for gaming"
- "My FPS in Valorant is low, what can I do?"
- "WSL and npm install are really slow"

You can also run the scripts manually:
```powershell
# Diagnose (no admin needed)
powershell -ExecutionPolicy Bypass -File .\pc-optimizer\scripts\diagnose.ps1

# Preview
powershell -ExecutionPolicy Bypass -File .\pc-optimizer\scripts\optimize.ps1 -DryRun

# Apply (ADMINISTRATOR terminal)
powershell -ExecutionPolicy Bypass -File .\pc-optimizer\scripts\optimize.ps1

# Undo
powershell -ExecutionPolicy Bypass -File .\pc-optimizer\scripts\optimize.ps1 -Undo

# Verify
powershell -ExecutionPolicy Bypass -File .\pc-optimizer\scripts\verify.ps1
```

Extra options: `-SkipVisualEffects`, `-SkipHibernate`, `-SkipCleanup`.

Backups are saved to `Documents\PcOptimizerBackup`. Note: the PCIe/USB power sub-settings are not reset by `-Undo`, but the previous power plan is re-activated.

## Structure

```
pc-optimizer/
├── SKILL.md              # instructions for Claude
├── scripts/
│   ├── diagnose.ps1      # read-only diagnosis
│   ├── optimize.ps1      # backed-up, reversible settings
│   └── verify.ps1        # read-only verification
└── references/
    ├── gpu-amd.md
    ├── gpu-nvidia.md
    ├── gpu-intel.md
    ├── games.md
    ├── dev.md
    └── myths.md          # tweaks that don't help or cause harm
```

## License

MIT — see [LICENSE](LICENSE). Use at your own risk.
