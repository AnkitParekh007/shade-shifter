# 3D Asset Replacement Guide

`assets/models/shade_shifter_poc.glb` is a temporary proof-of-concept generated from the repository's front, left-temple, and right-temple STL previews. It is not production CAD.

A replacement GLB must be glTF 2.0, mobile-optimized, and retain three independently material-addressable mesh/node names: `front`, `left_temple`, and `right_temple`. Apply transforms, use metres consistently, remove hidden geometry, keep textures at 2048px or less, and validate with Khronos glTF Validator. Test Android/iOS material overrides, selection, rotation, zoom, memory pressure, and the automatic 2D fallback before release.
