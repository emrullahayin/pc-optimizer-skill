# Intel Arc / Iris Xe – Intel Graphics Software

The user applies these in **Intel Graphics Software** (formerly Arc Control).

## Arc discrete GPUs (A/B series)
- **Resizable BAR is mandatory** for good performance: enable "Above 4G Decoding" + "Re-Size BAR" in BIOS. Without it Arc loses 20–40%.
- **Low Latency**: On. **Adaptive Sync**: On (with an FPS cap 3 below refresh).
- Prefer **DX12/Vulkan** in games that offer it; older DX9/DX11 titles run via translation and may be slower.
- **XeSS**: Quality at 1440p.
- Keep the driver current — Arc driver updates regularly bring large gains.

## Integrated graphics (laptops / iGPU)
- Run games on the **dGPU**: Windows Settings → System → Display → Graphics → pick the game → High performance.
- Dual-channel RAM matters a lot for iGPU performance; a single stick halves memory bandwidth.
- Plug in the charger; on battery the iGPU is power-limited.
