<p align="center">
  <a href="" rel="noopener">
 <img width=200px height=200px src="./assets/icons/icon.png" alt="Tunes logo"></a>
</p>

<h3 align="center">Tunes</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![CI](https://github.com/blackmonk13/tunes/actions/workflows/ci.yml/badge.svg)](https://github.com/blackmonk13/tunes/actions/workflows/ci.yml)
[![GitHub Issues](https://img.shields.io/github/issues/blackmonk13/tunes.svg)](https://github.com/blackmonk13/tunes/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/blackmonk13/tunes.svg)](https://github.com/blackmonk13/tunes/pulls)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](/LICENSE)

</div>

---

<p align="center"> A local music player for Android.
    <br> 
</p>

## Table of Contents

- [About](#about)
- [Features](#features)
- [Getting Started](#getting_started)
- [Running the tests](#tests)
- [Continuous integration and releases](#releases)
- [Project layout](#layout)
- [Built Using](#built_using)
- [Contributing](#contributing)
- [Privacy](#privacy)
- [License](#license)
- [Acknowledgements](#acknowledgement)

## About <a name = "about"></a>

Tunes plays the music that is already on your phone. It has no account, no ads and needs no internet. It reads the tags and cover art in your files, keeps its own index of your library, and lets you organise it with playlists and your own tags.

## Features <a name = "features"></a>

- Browse by songs, artists, albums, genres and playlists, with sorting.
- Search by title, artist, album, genre, tag and lyrics. Words can be in any order and accents and case are ignored.
- Your own tags on songs (kept in the app, not written to the files), shown in the full player, with a page for every tag.
- Smart playlists: Recently played, Most played and Least played.
- Shuffle All, and a Now Playing sheet that shows the real queue and follows what is playing.
- Resume: the queue, the shuffle order and the position are restored when the app starts.
- Edit tags and add or remove cover art. The song page shows every cover in a carousel.
- Scan filters to choose which folders are indexed, and a watcher that keeps the library in sync.
- Light, dark and system themes.

## Getting Started <a name = "getting_started"></a>

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) 3.47 or newer (Dart 3.5.4 or newer).
- The Android SDK, and an Android device or emulator.
- Git, because Tunes gets [`mpeg_codec`](https://github.com/blackmonk13/mpeg_codec), its package for reading and writing ID3 and MP4 tags, straight from GitHub (`flutter pub get` does it, pinned to a release tag).

### Installing

```
git clone https://github.com/blackmonk13/tunes.git
cd tunes
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

`build_runner` generates the Isar, Riverpod and freezed code, so run it again after changing a collection, a `@riverpod` provider or a `@freezed` model.

To work on `mpeg_codec` together with Tunes, clone it next to this repository and add a `pubspec_overrides.yaml` (it is ignored by git):

```
dependency_overrides:
  mpeg_codec:
    path: ../mpeg_codec
```

### Building an APK

```
flutter build apk --release
```

Install a debug build over an existing install, keeping its data, with `flutter build apk --debug` and `adb install -r build/app/outputs/flutter-apk/app-debug.apk`.

## Running the tests <a name = "tests"></a>

```
flutter test
flutter analyze
```

## Continuous integration and releases <a name = "releases"></a>

Every push and pull request to `main` and `dev` runs the CI workflow. It generates the code, analyzes, runs the tests and builds the APKs, which are kept as a build artifact for 14 days. Only errors fail the analysis for now. Without the release key these APKs are signed with a debug key, so they are for trying a change out, not for publishing.

To publish a release:

1. Set the new `version:` in `pubspec.yaml` and merge it.
2. Push a tag with that version, for example `git tag v1.1.0` and `git push origin v1.1.0`.

The Release workflow checks that the tag matches `pubspec.yaml`, then builds one APK for each processor type (`arm64-v8a` is the one most phones need) and a universal APK, signed with the release key, and publishes them with a `SHA256SUMS.txt` and generated release notes. The build number is the number of the workflow run.

### Signing key

The release key is made once and kept in four repository secrets:

```
keytool -genkey -v -keystore release.keystore -alias tunes -keyalg RSA -keysize 2048 -validity 10000
base64 -w0 release.keystore
```

| Secret                      | Value                                  |
| --------------------------- | -------------------------------------- |
| `ANDROID_KEYSTORE_BASE64`   | the output of `base64` above           |
| `ANDROID_KEYSTORE_PASSWORD` | the keystore password                  |
| `ANDROID_KEY_ALIAS`         | `tunes`, the alias used above          |
| `ANDROID_KEY_PASSWORD`      | the key password                       |

Keep a copy of the keystore somewhere safe. Android only installs an update over an app signed with the same key, so a lost key means users have to uninstall before they can update. The same goes for the first release: a phone with a debug build installed has to uninstall it first.

To sign a local build with the key, put the same four values in `android/key.properties` (git ignores it), with `storeFile` relative to `android/app`:

```
storePassword=...
keyPassword=...
keyAlias=tunes
storeFile=release.keystore
```

## Project layout <a name = "layout"></a>

- `lib/utils/media_query.dart` is the library core: the Isar collections, the filesystem scanner and watcher, and the song queries.
- `lib/providers/` holds the Riverpod providers. It is a single Dart library (`providers.dart`) with part files, so imports are added only in `providers.dart`.
- `lib/providers/player.dart` and `playback_session.dart` hold playback and the saved session, on top of `just_audio` and `just_audio_background`.
- `lib/pages/`, `lib/views/` and `lib/components/` are the screens, the tabbed lists and the shared widgets.

## Built Using <a name = "built_using"></a>

- [Flutter](https://flutter.dev/) - UI framework
- [Riverpod](https://riverpod.dev/) - State management
- [Isar](https://isar.dev/) - Database
- [just_audio](https://pub.dev/packages/just_audio) and [just_audio_background](https://pub.dev/packages/just_audio_background) - Playback
- [mpeg_codec](https://github.com/blackmonk13/mpeg_codec) - ID3 and MP4 tags and cover art

## Contributing <a name = "contributing"></a>

Work is tracked in [issues](https://github.com/blackmonk13/tunes/issues). Each feature or fix gets its own branch and a pull request into `dev`, with a closing keyword such as `Closes #12` in the description. `dev` is merged into `main` for releases.

## Privacy <a name = "privacy"></a>

Everything stays on the device. Tunes keeps an index of your library, your playlists, tags, play counts and searches locally, and sends nothing anywhere. The same text is in the app under Settings, Privacy policy.

## License <a name = "license"></a>

Tunes is licensed under the [GNU General Public License v3.0](LICENSE).

## Authors <a name = "authors"></a>

- [@blackmonk13](https://github.com/blackmonk13) - Idea and initial work

See also the list of [contributors](https://github.com/blackmonk13/tunes/contributors) who participated in this project.

## Acknowledgements <a name = "acknowledgement"></a>

- [google play music icons](https://www.flaticon.com/free-icons/google-play-music)
