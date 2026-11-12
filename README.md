# PC Optimizer — Claude Skill

Windows 10/11 bilgisayarları **oyun** ve **yazılım geliştirme** için güvenli ve geri alınabilir şekilde hızlandıran bir [Claude Agent Skill](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview).

*A Claude Agent Skill that safely and reversibly speeds up Windows 10/11 PCs for gaming and software development, including AMD / NVIDIA / Intel GPU settings. English summary below.*

## Ne yapar?

1. **Teşhis (salt-okunur):** İşlemci, RAM (XMP açık mı), ekran kartı ve sürücü sürümü, monitör yenileme hızı, diskler, güç planı, Oyun Modu, Game DVR, başlangıç uygulamaları ve geliştirici araçlarını kontrol eder.
2. **Kişiye özel plan:** Darboğazı bulur, sadece gerçekten işe yarayan ayarları önerir. Placebo "registry tweak"leri önermez.
3. **Geri alınabilir betik:** `optimize.ps1` ayarları değiştirmeden önce yedek ve sistem geri yükleme noktası alır. `-Undo` ile tek komutta geri alınır, `-DryRun` ile önce ne yapacağını gösterir.
4. **Ekran kartı rehberleri:** AMD Adrenalin, NVIDIA Control Panel ve Intel Arc için önerilen ayarlar.
5. **Oyun ön ayarları:** Rekabetçi FPS oyunları (Valorant, CS2…) ve sinematik RPG'ler (Witcher 3, Cyberpunk…) için.
6. **Geliştirici ortamı:** Dev Drive, WSL/Docker bellek sınırı, Git, VS Code ve paket önbellekleri.
7. **Doğrulama:** `verify.ps1` her şeyin uygulandığını kontrol eder.

## Güvenlik ilkeleri

- Sistem ayarlarını Claude değil, **kullanıcı** uygular. Claude betiği hazırlar, komutu verir, sonucu kontrol eder.
- Defender, UAC, Windows Update, güvenlik duvarı ve anti-cheat (Vanguard, EAC…) **asla** kapatılmaz.
- Her değişiklik yedeklenir ve geri alınabilir.

## Kurulum

### Claude Code
```bash
git clone https://github.com/<kullanici-adi>/pc-optimizer-skill.git
```
`pc-optimizer` klasörünü kişisel skill klasörüne kopyalayın:
- Windows: `%USERPROFILE%\.claude\skills\pc-optimizer`
- macOS/Linux: `~/.claude/skills/pc-optimizer`

### Claude.ai / Claude Desktop
`pc-optimizer` klasörünü zip'leyip **Settings → Capabilities → Skills → Upload skill** ile yükleyin.

## Kullanım

Claude'a şöyle yazmanız yeterli:
- "Bilgisayarımı oyun için hızlandır"
- "Valorant'ta FPS'im düşük, ne yapabilirim?"
- "WSL ve npm install çok yavaş"

Betikleri elle de çalıştırabilirsiniz:
```powershell
# Teşhis (yönetici gerekmez)
powershell -ExecutionPolicy Bypass -File .\pc-optimizer\scripts\diagnose.ps1

# Önizleme
powershell -ExecutionPolicy Bypass -File .\pc-optimizer\scripts\optimize.ps1 -DryRun

# Uygula (YÖNETİCİ terminal)
powershell -ExecutionPolicy Bypass -File .\pc-optimizer\scripts\optimize.ps1

# Geri al
powershell -ExecutionPolicy Bypass -File .\pc-optimizer\scripts\optimize.ps1 -Undo

# Kontrol
powershell -ExecutionPolicy Bypass -File .\pc-optimizer\scripts\verify.ps1
```

Ek seçenekler: `-SkipVisualEffects`, `-SkipHibernate`, `-SkipCleanup`.

Yedekler `Belgeler\PcOptimizerBackup` klasörüne kaydedilir. Not: Güç planında yapılan PCIe/USB alt ayarları `-Undo` ile sıfırlanmaz, ancak önceki plan geri etkinleştirilir.

## Yapı

```
pc-optimizer/
├── SKILL.md              # Claude için talimatlar
├── scripts/
│   ├── diagnose.ps1      # salt-okunur teşhis
│   ├── optimize.ps1      # yedekli, geri alınabilir ayarlar
│   └── verify.ps1        # salt-okunur doğrulama
└── references/
    ├── gpu-amd.md
    ├── gpu-nvidia.md
    ├── gpu-intel.md
    ├── games.md
    ├── dev.md
    └── myths.md          # işe yaramayan / zararlı tweak'ler
```

## English summary

`pc-optimizer` teaches Claude to diagnose a Windows PC with read-only commands, explain a tailored plan, hand the user a reversible PowerShell script (backup, restore point, `-DryRun`, `-Undo`), give GPU-vendor-specific driver panel settings and per-game presets, tune developer environments (Dev Drive, WSL, Git, VS Code), and verify the result. It never disables security features or anti-cheat, and avoids placebo tweaks.

## Lisans

MIT — bkz. [LICENSE](LICENSE). Kullanım kendi sorumluluğunuzdadır.
