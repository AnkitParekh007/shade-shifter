# Shade Shifter POC — Beginner Build Package (Rev A)

This package targets the selected route:

1. Build and validate a low-cost bench prototype.
2. Print a large rectangular unisex fit-check frame.
3. Transfer the proven electronics into a wearable LED-frame prototype.

The LED frame proves the app-controlled color experience. It is not the final commercial material architecture.

## Package contents

| File/folder | Purpose |
|---|---|
| `BUILD-BLUEPRINT.md` | Complete buying, wiring, assembly, testing, safety and troubleshooting guide |
| `bom.csv` | Exact staged bill of materials with quantities and buy gates |
| `cad/shade_shifter_rev_a.scad` | Editable parametric CAD for the frame front, temples, diffusers and electronics pods |
| `cad/PRINTING-RFQ.md` | Ready-to-send online 3D-printing quotation request |
| `firmware/shade_shifter_bench.ino` | ESP32 BLE + RGB LED bench firmware |
| `tools/generate_preview_stl.py` | Generates preview STL meshes without requiring OpenSCAD |
| `stl/` | Generated fit-check STL files |

## Start here

Do **not** order the wearable print first. Complete Gates 0–3 in `BUILD-BLUEPRINT.md`. The first useful purchase is only the bench kit, approximately ₹3,500–₹7,500 depending on tools already owned.

## Important limitations

- Rev A is a non-certified engineering prototype, not medical eyewear or a consumer product.
- Use plano/demo lenses only. A qualified optician must handle prescription lenses and final lens retention.
- Never charge a battery while wearing the frame.
- Do not place an exposed LiPo cell, bare wiring, or hot LED strip against skin.
- The generated STLs are fit/volume previews; use the OpenSCAD source and service-provider DFM review for the functional print.

