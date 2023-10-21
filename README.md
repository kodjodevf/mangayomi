<p align="center">
 <img width=200px height=200px src="assets/app_icons/icon-red.png"/>
</p>

<h1 align="center"> Mangayomi </h1>

Mangayomi is free an open source manga reader and anime streaming cross-plateform app inspired by Tachiyomi made with Flutter. It allows users to read manga and watch anime from a variety of sources.

## Features

Features include:
* [Supports external sources](https://github.com/kodjodevf/mangayomi-extensions)
* Online reading from a variety of sources
* Watch anime from a variety of sources
* Local reading of downloaded content
* Read and manage local archives (.cbz, .zip)
* Watch and manage local Anime
* A configurable reader with multiple viewers, reading directions.
* Tracker support for anime and manga: [MyAnimeList](https://myanimelist.net/) and [AniList](https://anilist.co/) support
* Categories to organize your library
* Light and dark themes

## Screenshots :camera:

### Mobile Screenshots                                                                                                                
| Views    |  Light                                                     |  Dark                                                        |
| -------- | ---------------------------------------------------------- | ------------------------------------------------------------ |
| Manga    |  ![mobile_manga_light](screenshots/mobile_manga_light.png)     |![mobile_manga_dark](screenshots/mobile_manga_dark.png)      |
| Anime    |  ![mobile_anime_light](screenshots/mobile_anime_light.png)     |![mobile_anime_dark](screenshots/mobile_anime_dark.png)      |
| Reader   |  ![mobile_reader_light](screenshots/mobile_reader_light.png)   |![mobile_reader_dark](screenshots/mobile_reader_dark.png) |
| Player   |  ![mobile_anime_player](screenshots/mobile_anime_player.png)|![mobile_anime_player](screenshots/mobile_anime_player.png)|

### Desktop Screenshots                                                                                                                
| Views    |  Light                                                     |  Dark                                                        |
| -------- | ---------------------------------------------------------- | ------------------------------------------------------------ |
| Manga    |  ![desktop_manga_light](screenshots/desktop_manga_light.png)     |![desktop_manga_dark](screenshots/desktop_manga_dark.png)      |
| Anime    |  ![desktop_anime_light](screenshots/desktop_anime_light.png)     |![desktop_anime_dark](screenshots/desktop_anime_dark.png)      |
| Reader   |  ![desktop_reader_light](screenshots/desktop_reader_light.png)   |![desktop_reader_dark](screenshots/desktop_reader_dark.png) |
| Player   |  ![desktop_anime_player](screenshots/desktop_anime_player.png)|![desktop_anime_player](screenshots/desktop_anime_player.png)|

## Download
Get the app from our [releases page](https://github.com/kodjodevf/mangayomi/releases).

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

## Using Rust Inside Flutter

This project leverages Flutter for GUI and Rust for the backend logic,
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


