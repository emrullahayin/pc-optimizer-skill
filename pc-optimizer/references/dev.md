# Developer environment

Unlike Windows system settings, these are per-user app configs. You may apply them yourself after showing the user the change, unless the user prefers to do it.

## Dev Drive (Windows 11 22H2+) – biggest win
ReFS volume with Defender "performance mode" (async scanning). Builds, `npm install`, `git` operations get ~20–30% faster.
- The **user** creates it: Settings → System → Storage → Advanced storage settings → Disks & volumes → Create Dev Drive. A 100–150 GB VHDX is usually enough.
- Move repos there, e.g. `D:\src`.
- Point package caches to it (user-level env vars, set with `setx`):
  - npm: `npm config set cache D:\packages\npm-cache`
  - pnpm: `pnpm config set store-dir D:\packages\pnpm-store`
  - pip: `setx PIP_CACHE_DIR D:\packages\pip`
  - NuGet: `setx NUGET_PACKAGES D:\packages\nuget`
  - Cargo: `setx CARGO_HOME D:\packages\cargo`
  - Maven: `setx MAVEN_OPTS -Dmaven.repo.local=D:\packages\maven`
  - Gradle: `setx GRADLE_USER_HOME D:\packages\gradle`
- Do not add broad Defender exclusions yourself; Dev Drive's performance mode is the safe alternative.

## WSL 2 / Docker Desktop
Without limits WSL can take 50% of RAM and keep it. Create `%UserProfile%\.wslconfig`:

```ini
[wsl2]
memory=16GB        # ~half of physical RAM on 32 GB machines; 8GB on 16 GB machines
processors=8       # leave a few threads for Windows/games
swap=4GB

[experimental]
autoMemoryReclaim=gradual
sparseVhd=true
```

Then `wsl --shutdown`. Keep Linux projects inside the WSL filesystem (`\\wsl$\...`, `~/src`), not on `/mnt/c` — cross-filesystem I/O is 5–10x slower.
Docker Desktop: use the WSL 2 backend; prune with `docker system prune` occasionally.

## Git
```bash
git config --global core.fsmonitor true
git config --global core.untrackedcache true
git config --global feature.manyFiles true
git config --global fetch.writeCommitGraph true
```
Large repos: `git maintenance start` in the repo.

## VS Code
In user `settings.json`:
```json
"files.watcherExclude": {
  "**/node_modules/**": true, "**/dist/**": true, "**/build/**": true,
  "**/.git/objects/**": true, "**/.venv/**": true, "**/target/**": true
},
"search.exclude": { "**/node_modules": true, "**/dist": true },
"typescript.tsserver.maxTsServerMemory": 4096
```
Disable extensions you don't use per workspace.

## JetBrains / Visual Studio
- JetBrains: Help → Change Memory Settings → 4096 MB on 16 GB+ machines. Exclude `node_modules`/`build` from indexing.
- Visual Studio: keep solutions on Dev Drive; disable unused workloads' extensions.

## Gaming + dev on one machine
- Stop Docker/WSL before competitive games (`wsl --shutdown`), they reserve RAM and CPU.
- Close IDE indexers / watch tasks while gaming.
