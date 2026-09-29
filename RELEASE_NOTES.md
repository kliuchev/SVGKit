# SVGKit 4.0.0 — release notes draft

Draft based on `3.0.0...6002a0f`. Release validation is pending.

SVGKit 4.0.0 brings together the fixes and features added to `3.x` since 3.0.0. This is a major release because minimum platform requirements and parts of the public API have changed.

## KEY CHANGES

- Constrain the SwiftPM CocoaLumberjack dependency to `3.7.0...3.9.1`. The previous requirement allowed newer 3.x releases with higher platform and toolchain requirements, which could prevent projects using SVGKit 3.0.0 from building. ([#879](https://github.com/SVGKit/SVGKit/pull/879))
- Add support for `hsl()` and `hsla()` colors. ([#731](https://github.com/SVGKit/SVGKit/pull/731))
- Add an optional parser identifier resolver for custom SVG element identifiers and layer lookup. ([#870](https://github.com/SVGKit/SVGKit/pull/870))
- Improve text rendering: handle multiple `x`/`y` values, use a single child `tspan`'s coordinates, trim font-family whitespace, and resolve font names as well as font families. ([#816](https://github.com/SVGKit/SVGKit/pull/816), [#855](https://github.com/SVGKit/SVGKit/pull/855), [#859](https://github.com/SVGKit/SVGKit/pull/859), [#875](https://github.com/SVGKit/SVGKit/pull/875))
- Correct gradient coordinates with `gradientUnits="userSpaceOnUse"` and respect explicit image width/height when constructing the image viewBox. ([#786](https://github.com/SVGKit/SVGKit/pull/786), [#860](https://github.com/SVGKit/SVGKit/pull/860))
- Add basic aspect-fit/aspect-fill handling to `SVGKFastImageView` and initialize drawing sizes. ([#747](https://github.com/SVGKit/SVGKit/pull/747), [#864](https://github.com/SVGKit/SVGKit/pull/864))
- Fix path parsing for compact elliptical arc flags, comma-separated horizontal line arguments, and whitespace in polylines. ([#761](https://github.com/SVGKit/SVGKit/pull/761), [#786](https://github.com/SVGKit/SVGKit/pull/786), [#796](https://github.com/SVGKit/SVGKit/pull/796))
- Fix crashes involving image export on iOS 17, missing image data, missing referenced elements, nil identifiers, and missing paint colors. ([#786](https://github.com/SVGKit/SVGKit/pull/786), [#808](https://github.com/SVGKit/SVGKit/pull/808), [#840](https://github.com/SVGKit/SVGKit/pull/840), [#857](https://github.com/SVGKit/SVGKit/pull/857), [#868](https://github.com/SVGKit/SVGKit/pull/868))
- Improve Apple Silicon and macOS builds, add visionOS build fixes, and adapt the SwiftUI wrapper to compile on macOS. ([#717](https://github.com/SVGKit/SVGKit/pull/717), [#782](https://github.com/SVGKit/SVGKit/pull/782), [#863](https://github.com/SVGKit/SVGKit/pull/863), [#867](https://github.com/SVGKit/SVGKit/pull/867), [#878](https://github.com/SVGKit/SVGKit/pull/878))
- Switch default logging from TTY/ASL loggers to `DDOSLogger`. ([#807](https://github.com/SVGKit/SVGKit/pull/807))
- Update device model and pixel-density handling for newer iPhones and iPads. ([#817](https://github.com/SVGKit/SVGKit/pull/817), [#826](https://github.com/SVGKit/SVGKit/pull/826), [#828](https://github.com/SVGKit/SVGKit/pull/828), [#841](https://github.com/SVGKit/SVGKit/pull/841), [#845](https://github.com/SVGKit/SVGKit/pull/845), [#865](https://github.com/SVGKit/SVGKit/pull/865))
- Add a privacy manifest and resource packaging changes; improve module/header integration and disable assertions in SwiftPM release builds. ([#720](https://github.com/SVGKit/SVGKit/pull/720), [#743](https://github.com/SVGKit/SVGKit/pull/743), [#780](https://github.com/SVGKit/SVGKit/pull/780), [#807](https://github.com/SVGKit/SVGKit/pull/807), [#810](https://github.com/SVGKit/SVGKit/pull/810), [#819](https://github.com/SVGKit/SVGKit/pull/819), [#824](https://github.com/SVGKit/SVGKit/pull/824), [#825](https://github.com/SVGKit/SVGKit/pull/825), [#842](https://github.com/SVGKit/SVGKit/pull/842), [#866](https://github.com/SVGKit/SVGKit/pull/866))

## BREAKING CHANGES AND MIGRATION

### Platform and toolchain requirements

The manifests declare the following requirements; platform and installation-method validation remains pending:

| Installation method | iOS | tvOS | macOS | Swift tools |
| --- | --- | --- | --- | --- |
| SwiftPM | 13 (previously 9) | 13 (previously 9) | 10.10 (unchanged) | 5.3 (previously 5.1) |
| CocoaPods | 11 (previously 5) | 11 (previously 9) | 11 (previously 10.9) | — |

These are manifest declarations, not a guarantee of effective minimums: dependencies and individual APIs can impose additional requirements. The macOS SwiftUI wrapper is available from macOS 10.15. ([#726](https://github.com/SVGKit/SVGKit/pull/726), [#792](https://github.com/SVGKit/SVGKit/pull/792), [#825](https://github.com/SVGKit/SVGKit/pull/825), [#878](https://github.com/SVGKit/SVGKit/pull/878))

### SVGLength

Replace calls to `pixelsValueWithGradientDimension:` with `pixelsValueWithGradientDimension:treatAsPercentage:`. Pass `YES` to preserve the previous treatment of unitless values between 0 and 1 as fractions of the supplied dimension; pass `NO` for absolute unitless coordinates such as `userSpaceOnUse`. ([#786](https://github.com/SVGKit/SVGKit/pull/786))

```objc
// Before
[length pixelsValueWithGradientDimension:dimension];

// Preserve the previous behavior
[length pixelsValueWithGradientDimension:dimension treatAsPercentage:YES];
```

### Swift parser callers

Parser headers now declare nullability explicitly. Handle optional results from `parseSynchronously`, `parseSourceUsingDefaultSVGKParser:` and `NSDictionaryFromCSSAttributes:`, and optional properties such as `currentParseRun`, `rootOfSVGTree` and `parsedDocument`. Other declarations within the annotated headers default to nonnull. Existing Swift callers may need changes. ([#874](https://github.com/SVGKit/SVGKit/pull/874))

### Dependencies and headers

The CocoaLumberjack cap applies to SwiftPM. Projects that also require CocoaLumberjack newer than 3.9.1 must reconcile those requirements; the resolver cannot satisfy both. ([#879](https://github.com/SVGKit/SVGKit/pull/879))

`SVGKDefine_Private.h` is now private and is no longer exposed through the SwiftPM public include directory. Code importing this internal header must be updated. ([#720](https://github.com/SVGKit/SVGKit/pull/720), [#807](https://github.com/SVGKit/SVGKit/pull/807))

### Rendering

Text positioning, font selection, image sizing, gradients and content-mode handling include behavior corrections. Recheck affected SVG assets and visual snapshots when upgrading.

## CONTRIBUTORS

Thanks to the authors and co-authors of the changes since 3.0.0:

- [@0x1306a94](https://github.com/0x1306a94)
- [@agruchala](https://github.com/agruchala)
- [@albianto](https://github.com/albianto)
- [@ap-for-work](https://github.com/ap-for-work)
- [@area51bis](https://github.com/area51bis)
- [@bfolkens](https://github.com/bfolkens)
- [@Chen-Charles-Ke](https://github.com/Chen-Charles-Ke)
- [@Cokile](https://github.com/Cokile)
- [@cyrillelegrand](https://github.com/cyrillelegrand)
- [@DmitryShapovalov](https://github.com/DmitryShapovalov)
- [@Farazkarimi](https://github.com/Farazkarimi)
- [@farfromrefug](https://github.com/farfromrefug)
- [@freddiebo](https://github.com/freddiebo)
- [@GlennBrann](https://github.com/GlennBrann)
- [@Haoocen](https://github.com/Haoocen)
- [@JasonnnW3000](https://github.com/JasonnnW3000)
- [@joannaquu](https://github.com/joannaquu)
- [@kardeslik](https://github.com/kardeslik)
- [@kgn](https://github.com/kgn)
- [@kliuchev](https://github.com/kliuchev)
- [@kpacholak](https://github.com/kpacholak)
- [@louis1001](https://github.com/louis1001)
- [@lxalfonso](https://github.com/lxalfonso)
- [@mylogon341](https://github.com/mylogon341)
- [@nikos0406](https://github.com/nikos0406)
- [@PhilippeWeidmann](https://github.com/PhilippeWeidmann)
- [@pixelmatrix](https://github.com/pixelmatrix)
- [@sbeitzel](https://github.com/sbeitzel)
- [@sebj](https://github.com/sebj)
- [@Simon-Zeng](https://github.com/Simon-Zeng)
- [@stevekellyhpe](https://github.com/stevekellyhpe)
- [@SystemKeeper](https://github.com/SystemKeeper)
- [@troZee](https://github.com/troZee)
- [@ZevEisenberg](https://github.com/ZevEisenberg)
- [@ziloongyang](https://github.com/ziloongyang)
- Moisés Moreno (co-author of [#859](https://github.com/SVGKit/SVGKit/pull/859) and [#860](https://github.com/SVGKit/SVGKit/pull/860))
- [@ronickg](https://github.com/ronickg)

[Changes reviewed for this draft](https://github.com/SVGKit/SVGKit/compare/3.0.0...6002a0ff6b2d4405805395959b92b38aa24662cb)
