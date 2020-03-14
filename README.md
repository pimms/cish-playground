# Cish Playground

## Getting Started

### Dependencies

Cish requires Antlr, CMake, and the Antlr runtime to configure & build properly.

``
$ brew install antlr antlr4-cpp-runtime cmake
```

`cpg.xcodeproj` assumes that the file `libantlr4-runtime.a` is placed in `/usr/local/lib` - if this is
not the case, remove the build phase that performs this check.

### Cish Submodule Initialization

Run `setup.sh` to ensure that Cish' Xcode project file is created:

```
$ ./setup.sh
```
