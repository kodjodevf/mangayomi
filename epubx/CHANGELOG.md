## 4.0.0

- Merge all pull requests

## 3.0.0
### Changed
- `metadata` file now saves as `mimetype` [pull#1](https://github.com/rbcprolabs/epubx.dart/pull/1) 
### Added
- Epub v3 support [dart-epub | pull#76](https://github.com/orthros/dart-epub/pull/76) 
- Doc comment [dart-epub | pull#80](https://github.com/orthros/dart-epub/pull/80) 

## 3.0.0-dev.3
### Changed
- At `EpubReader.{openBook, readBook}` first argument can be future (not before) 

## 3.0.0-dev.2
### Fixed
- Fixed null-safety bug

## 3.0.0-dev.1
### Added
- Null-safety migration
### Changed
- Upgrade all dependencies

## 2.1.0
### Fixed
- Version 3 EPUB's can have a null Table of Contents
- Updated `pedantic` analysis options

## 2.0.7
### Added
- Added example of using `epub` in a web page: `examples/web_ex`
### Fixed
- Fixed errors from pedantic analysis
### Changed
- Added pedantic analysis options

## 2.0.6
### Fixed
- Fixed Issue #35: File cannot be opened if its path is url-encoded in the manifest
- Updated `examples/dart_ex` to have a README as well as use a locally stored file.

## 2.0.5
### Changed
- Exposed `EpubChapterRef` to consumers.

## 2.0.4
### Fixed
- Merged pull request #45
    - Fixes pana hits to make code more readable

## 2.0.3
### Changed
- Raised `sdk` version constraint to 2.0.0
- Raised constraint on `async` to 3.0.0
### Fixed
- Merged pull request #40 by vblago. 
    - Fixes Undefined class 'XmlBuilder'

## 2.0.2
### Changed
- Lowered sdk version constraint to 2.0.0-dev.61.0

## 2.0.1
### Changed
- Formatted documents

## 2.0.0
### Added
- Added support for writing Epubs back to Byte Arrays
- Tests for writing Epubs

### Changed
- Epub Readers and Writers now have their == operator and hashCode get-er overridden

### Fixed
- Fixed an issue when reading EpubContentFileRef

## 1.3.2
### Changed
- Updates to Travis configuration and publishing

## 1.3.1
### Changed
- Updates to Travis configuration and publishing
### Removed
- Removed unused variable `FilePath` from `EpubBook` and `EpubBookRef`

## 1.3.0
### Added
- Package now supports Dart 2!
### Removed
- Removed support for Dart 1.2.21

## 1.2.10
### Fixed
- Merged pull request #15 from ShadowJonathan/dev. 
    - Fixes issue with parsing schema by removing `opf:` namespace

## 1.2.9
### Changed
- Ran code through `dartfmt` as per analysis by `pana`

## 1.2.8
### Added
- Added unit tests for Images
### Changed
- Updated dependencies

## 1.2.7
### Added
- Added upper limit of Dart version to 2.0.1

## 1.2.6
### Added
- Added Support for Dart 2.0

## 1.2.5
### Added
- A publish step in the travis deploy

## 1.2.4
### Changed
- EnumFromString no longer uses the `mirrors` package to make this Flutter compatible by @MostafaAyesh 

## 1.2.3
### Added
- This Changelog!

### Changed
- Author email

## 1.2.2
### Changed
- Dependencies were updated to more permissive versions by @jarontai

### Added
- Example by @jarontai
- More Entities and types are exported by @jarontai

### Fixed
- Issue with case sensitivity in switch statements from @jarontai
- Issue with Async Loops from @jarontai

## 1.2.1
### Fixed
- Made code in line with Dart styleguide
