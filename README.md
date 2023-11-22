<p align="center">
 <img width=200px height=200px src="assets/app_icons/icon-red.png"/>
</p>

<h1 align="center"> Mangayomi </h1>

<p align="center">

 [![latest release](https://img.shields.io/github/release/kodjodevf/mangayomi.svg?maxAge=3600&label=download)](https://github.com/kodjodevf/mangayomi/releases)
 [![Discord](https://img.shields.io/discord/1157628512077893666.svg?label=discord&labelColor=7289da&color=2c2f33&style=flat)](https://discord.com/invite/EjfBuYahsP) 

</p>

Mangayomi is free an open source manga reader and anime streaming cross-plateform app inspired by Tachiyomi made with Flutter. It allows users to read manga and watch anime from a variety of sources.

## Features

Features include:
* [Supports external sources](https://github.com/kodjodevf/mangayomi-extensions), utilizing the capabilities of the [dart_eval](https://pub.dev/packages/dart_eval) package
* Online reading from a variety of sources
* Watching anime from a variety of sources
* Local reading of downloaded content
* A configurable reader with multiple viewers, reading directions and other settings..
* Tracker support for anime and manga: [MyAnimeList](https://myanimelist.net/), [AniList](https://anilist.co/) and [Kitsu](https://kitsu.io/) support
* Categories to organize your library
* Light and dark themes
* Create backups locally to read offline or to your desired cloud service

## Screenshots :camera:

### Mobile Screenshots                                                                                                                
|          |  Reader                                               |  Player                                               |
| -------- | ----------------------------------------------------- | ----------------------------------------------------- |
| Views    |  ![mobile_reader_light](screenshots/mobile_reader.jpg)|  ![mobile_anime_player](screenshots/mobile_player.jpg)|

### Desktop Screenshots                                                                                                                
|          |  Reader                                           |  Player                                           |
| -------- | ------------------------------------------------- | ------------------------------------------------- |
| Views    |  ![desktop_reader](screenshots/desktop_reader.png)|  ![desktop_player](screenshots/desktop_player.png)|

## Download
Get the app from our [releases page](https://github.com/kodjodevf/mangayomi/releases).


## Using Rust Inside Flutter

This project use Rust for the [auto-image-cropper](https://github.com/ritiek/auto-image-cropper) crate,
utilizing the capabilities of the
[Rinf](https://pub.dev/packages/rinf) framework.

To run and build this app, you need to have
[Flutter SDK](https://docs.flutter.dev/get-started/install),
[Rust toolchain](https://www.rust-lang.org/tools/install),
and [Protobuf compiler](https://grpc.io/docs/protoc-installation)
installed on your system.
You can check that your system is ready with the commands below.
Note that all the Flutter subcomponents should be installed.

```bash
rustc --version
protoc --version
flutter doctor
```

You also need to have the CLI tool for Rinf ready.

```bash
cargo install rinf
```

Messages sent between Dart and Rust are implemented using Protobuf.
If you have newly cloned the project repository
or made changes to the `.proto` files in the `./messages` directory,
run the following command:

```bash
rinf message
```

Now you can run and build this app just like any other Flutter projects.

```bash
flutter run
```

For detailed instructions on writing Rust and Flutter together,
please refer to Rinf's [documentation](https://rinf-docs.cunarist.com).


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

The developer of this application does not have any affiliation with the content providers available.
