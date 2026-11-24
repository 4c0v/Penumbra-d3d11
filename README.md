# Penumbra-d3d11
My little port from OpenGL to DirectX11

![Progress](https://img.shields.io/badge/progress-~80%25-809099?style=for-the-badge&labelColor=131313)
![full game build](https://img.shields.io/badge/full_game_build-in_progress-809099?style=flat-square&labelColor=131313)

![backend](https://img.shields.io/badge/backend-done-809099?style=flat-square&labelColor=131313)
![HLSL shaders](https://img.shields.io/badge/HLSL_shaders-51_ported-809099?style=flat-square&labelColor=131313)
![checks](https://img.shields.io/badge/checks-84%2F84_passing-809099?style=flat-square&labelColor=131313)
![GPU](https://img.shields.io/badge/verified_on-real_GPU_FL_11.0-809099?style=flat-square&labelColor=131313)
![first run](https://img.shields.io/badge/first_run-boots_to_level_load-809099?style=flat-square&labelColor=131313)

## Frontier
Backend: 5 classes implementing the engine's `iLowLevelGraphics`, `iTexture`, `iVertexBuffer`, `iGpuProgram` and `iOcclusionQuery` (about 5,200 lines).

## Shaders
51 HLSL files from 64 Cg originals the rest are old-GPU fallbacks and two-pass spot lights skipped.

Compiled at runtime with `D3DCompile`; the engine still asks for `X.cg` and gets `X.hlsl`.

## License

Penumbra-d3d11 is primarily distributed under the terms of the zlib license. See [LICENSE](LICENSE) and [NOTICES.md](NOTICES.md) for 3rd party software and their licenses.
