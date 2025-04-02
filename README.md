<p align="center">
 <img width=200px height=200px src="assets/app_icons/icon-red.png"/>
</p>

<h1 align="center"> Mangayomi </h1>

<div align="center">

 [![GitHub downloads](https://img.shields.io/github/downloads/kodjodevf/mangayomi/total?label=downloads&labelColor=27303D&color=0D1117&logo=github&logoColor=FFFFFF&style=flat)](https://github.com/kodjodevf/mangayomi/releases)
![star](https://img.shields.io/github/stars/kodjodevf/mangayomi)
 [![Discord server](https://img.shields.io/discord/1157628512077893666.svg?label=&labelColor=6A7EC2&color=7389D8&logo=discord&logoColor=FFFFFF)](https://discord.com/invite/EjfBuYahsP) 


Mangayomi is an open-source Flutter app for reading manga, novels, and watching animes across multiple platforms.
</div>

## Features

<div align="left">

Features include:
* Reading manga, webtoons, comics, novels, animes, movies, and more.
* Local reading of content.
* A configurable reader with multiple viewers, reading directions and other settings.
* Tracker support for anime and manga: [MyAnimeList](https://myanimelist.net/), [AniList](https://anilist.co/) and [Kitsu](https://kitsu.io/) support.
* Categories to organize your library.
* Light and dark themes.
* Create backups locally to read offline or to your desired cloud service.

</div>

## Download
Get the app from our [releases page](https://github.com/kodjodevf/mangayomi/releases).

## iOS Sideloading Sources
<a href="https://intradeus.github.io/http-protocol-redirector?r=altstore://source?url=https://raw.githubusercontent.com/kodjodevf/mangayomi/refs/heads/main/repo/source.json"><img alt="AltStore Source" src="repo/images/buttons/altstore_button.png" width="150"></a>
&nbsp;
<a href="https://intradeus.github.io/http-protocol-redirector?r=feather://source/https://raw.githubusercontent.com/kodjodevf/mangayomi/refs/heads/main/repo/source.json"><img alt="Feather Source" src="repo/images/buttons/feather_button.png" width="150"></a>
&nbsp;
<a href="https://intradeus.github.io/http-protocol-redirector?r=sidestore://source?url=https://raw.githubusercontent.com/kodjodevf/mangayomi/refs/heads/main/repo/source.json"><img alt="Sidestore Source" src="repo/images/buttons/sidestore_button.png" width="150"></a>
&nbsp;
<a href="https://raw.githubusercontent.com/kodjodevf/mangayomi/refs/heads/main/repo/source.json"><img alt="Direct URL Source" src="repo/images/buttons/url_button.png" width="150"></a>

Note: Only future releases (> 0.5.2) will be signed (and therefore have AltStore/SideStore compatibility).

# Contributing

Contributions are welcome!

To get started with extension development, see [CONTRIBUTING-DART.md](https://github.com/kodjodevf/mangayomi-extensions/blob/main/CONTRIBUTING-DART.md) for create sources in Dart or [CONTRIBUTING-JS.md](https://github.com/kodjodevf/mangayomi-extensions/blob/main/CONTRIBUTING-JS.md) for create sources in JavaScript.

## Using flutter_rust_bridge

To run and build this app, you need to have
[Flutter SDK](https://docs.flutter.dev/get-started/install)
and [Rust toolchain](https://www.rust-lang.org/tools/install)
installed on your system.
You can check that your system is ready with the commands below.
Note that all the Flutter subcomponents should be installed.

```bash
rustc --version
flutter doctor
```

You also need to have the CLI tool for flutter_rust_bridge ready.

```bash
cargo install 'flutter_rust_bridge_codegen'
```

run the following command:

```bash
flutter_rust_bridge_codegen generate
```

Now you can run and build this app just like any other Flutter projects.

```bash
flutter run
```



## License

    Copyright 2023 Moustapha Kodjo Amadou

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    

## Disclaimer

Mangayomi is not hosting any kind of content and the developer(s) of this application does not have any affiliation with the content providers that are freely available in the internet.