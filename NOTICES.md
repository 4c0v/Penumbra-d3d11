# Penumbra: Overture - Direct3D 11 port

## 3rd party software used

### HPL1 Engine
**License:** GPLv3 (Cg shaders: zlib, assets: CC BY-SA 3.0)
**Source:** https://github.com/FrictionalGames/HPL1Engine
**Modified:** added a Direct3D 11 graphics backend, ported the Cg shaders to HLSL thus removed the OpenGL/Cg code paths.

### Penumbra: Overture source
**License:** GPLv3
**Source:** https://github.com/FrictionalGames/PenumbraOverture
**Modified:** removed the Cg/OpenGL setup code so it runs on the D3D11 backend.

### OALWrapper
**License:** zlib
**Source:** https://github.com/FrictionalGames/OALWrapper
Used as is.

### tinyXML
**License:** zlib
**Source:** http://www.sourceforge.net/projects/tinyxml
Used as is (bundled with HPL1 Engine).

### AngelScript 2.38.0
**License:** zlib
**Source:** https://www.angelcode.com/angelscript/
Built for Windows, engine script code updated to the current API.

### Newton Game Dynamics 2.36
**License:** zlib-style
**Source:** https://github.com/scummvm/scummvm (`engines/hpl1`)
Taken from ScummVM's copy, built for Windows with shim headers.

### SDL 1.2, SDL_image 1.2.12, SDL_ttf 2.0.11
**License:** LGPL 2.1
**Source:** https://www.libsdl.org/
Used as is (`SDL.dll`, SDL_image and SDL_ttf built for Windows).

### OpenAL Soft 1.25.2
**License:** LGPL
**Source:** https://github.com/kcat/openal-soft
Used as is (`OpenAL32.dll`).

### zlib
**License:** zlib license
**Source:** https://github.com/madler/zlib
Built for Windows, unmodified.

### libpng 1.6.59
**License:** PNG Reference Library License v2
**Source:** https://github.com/pnggroup/libpng
Built for Windows, unmodified.

### libjpeg-turbo 3.2.1
**License:** IJG / BSD-3-Clause / zlib
**Source:** https://github.com/libjpeg-turbo/libjpeg-turbo
Built for Windows, unmodified.

### FreeType 2.15.0
**License:** FreeType License (FTL)
**Source:** https://freetype.org/
Built for Windows, unmodified.

### libogg 1.3.6, libvorbis 1.3.7, libtheora
**License:** BSD-3-Clause
**Source:** https://xiph.org/
Built for Windows, unmodified.
