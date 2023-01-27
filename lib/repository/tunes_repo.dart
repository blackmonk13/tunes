import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drift/drift.dart';
import 'package:tunes/database/database.dart';
import 'package:tunes/models/tune.dart';
import 'package:tunes/utils/constants.dart';

class TunesRepository {
  final TunesDb db;

  TunesRepository({required this.db}) {
    _fscountController.add(0);
  }

  Future<List<Tune>> get tunes => db.tunesDao.allTuneEntries;
  Stream<List<Tune>> get streamedTunes => db.tunesDao.streamedTunes;

  final _fscountController = StreamController<int>();
  Stream<int> fsCount() => _fscountController.stream;

  Future<List<Map<String, dynamic>>> getFsTunes() async {
    final mediaPaths = await getMediaPaths();
    List<Map<String, dynamic>> fsItems = [];
    await for (final value in getMusic(mediaPaths)) {
      final item = await tuneMapFromFile(value as File);
      fsItems.add(item);
      _fscountController.add(fsItems.length);
    }
    return fsItems;
  }

  Future<void> addCovers(List<Uint8List> coverData) async {
    final covers = coverData
        .map(
          (e) => CoversCompanion(
            art: Value.ofNullable(e),
          ),
        )
        .toList();
    await db.coversDao.addCovers(covers);
  }

  Future<void> addArtists(List<String> artistsData) async {
    final artists = artistsData
        .map(
          (e) => ArtistsCompanion(
            name: Value.ofNullable(e),
          ),
        )
        .toList();
    await db.artistsDao.addArtists(artists);
  }

  Future<void> addAlbums(List<String> albumsData) async {
    final albums = albumsData
        .map(
          (e) => AlbumsCompanion(
            name: Value.ofNullable(e),
          ),
        )
        .toList();
    await db.albumsDao.addAlbums(albums);
  }

  Future<void> addTunes(List<Map<String, dynamic>> fstunes) async {
    final tuneComps = await Future.wait(
      fstunes.map(
        (fstune) async {
          return await tuneFromMap(fstune);
        },
      ),
    );

    await db.tunesDao.addTunes(tuneComps);
  }

  Future<Map<String, dynamic>> tuneMapFromFile(File value) async {
    final tagData = await getTags(value.path);
    final artData = await getArtwork(value.path);
    final statinfo = await value.stat();
    final modified = statinfo.modified;
    final item = {
      'pathname': value.path,
      'title': getTitle(
        filePath: value.path,
        tag: tagData,
      ),
      'artist': getArtist(tagData),
      'album': getAlbum(tagData),
      'artwork': artData,
      'modified': modified,
    };
    return item;
  }

  Future<TunesCompanion> tuneFromMap(Map<String, dynamic> tunemap) async {
    final tuneCover =
        await db.coversDao.coverByData(tunemap['artwork'] as Uint8List?);
    final coverId = tuneCover?.id;
    final artist =
        await db.artistsDao.artistByName(tunemap['artist'] as String);
    final artistId = artist?.id;
    final album = await db.albumsDao.albumByName(tunemap['album'] as String);
    final albumId = album?.id;
    final title = tunemap['title'];
    final tcom = TunesCompanion(
      pathname: Value(tunemap['pathname'] as String),
      title: title != null ? Value(title) : const Value.absent(),
      artist: artistId != null ? Value(artistId) : const Value.absent(),
      album: albumId != null ? Value(albumId) : const Value.absent(),
      modified: Value(tunemap['modified'] as DateTime),
      artwork: coverId != null ? Value(coverId) : const Value.absent(),
    );
    return tcom;
  }

  Future<int> deleteTunes(List<String> filePaths) async {
    final deleted = await db.deleteTunes(filePaths);
    final deleteFiles = filePaths.map((e) => File(e)).toList();
    for (final element in deleteFiles) {
      if (await element.exists()) {
        await element.delete();
      }
    }
    return deleted;
  }

  Future<int> renameTune(String filePath, String fileName) async {
    final afile = File(filePath);
    if (!await afile.exists()) return 0;
    final lastSeparator = filePath.lastIndexOf(Platform.pathSeparator);
    final newPath = filePath.substring(0, lastSeparator + 1) + fileName;
    final newFile = await afile.rename(newPath);
    return db.tunesDao.updateTune(
      filePath,
      TunesCompanion(
        pathname: Value(newFile.path),
      ),
    );
  }

  Future<int> updateTune(String filePath) async {
    final afile = File(filePath);
    if (!await afile.exists()) return 0;
    final tuneMap = await tuneMapFromFile(afile);
    final tune = await tuneFromMap(tuneMap);
    return db.tunesDao.updateTune(filePath, tune);
  }

  Future<Audio> audioFromTune(Tune tune) async {
    final coverId = tune.artwork;
    final cover =
        coverId == null ? null : await db.coversDao.coverById(coverId);
    final artistId = tune.artist;
    final artist =
        artistId == null ? null : await db.artistsDao.artistById(artistId);
    final albumId = tune.album;
    final album =
        albumId == null ? null : await db.albumsDao.albumById(albumId);
    final audio = Audio.file(
      tune.pathname,
      metas: Metas(
          album: album?.name,
          title: tune.title,
          artist: artist?.name,
          extra: {
            'artWork': cover?.art,
            'artist': artist,
            'album': album,
          }),
    );
    return audio;
  }

  void dispose() => _fscountController.close();
}
