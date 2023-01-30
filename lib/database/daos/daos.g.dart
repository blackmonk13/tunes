// GENERATED CODE - DO NOT MODIFY BY HAND

part of tunesdbdaos;

// ignore_for_file: type=lint
mixin _$AlbumsDaoMixin on DatabaseAccessor<TunesDb> {
  $AlbumsTable get albums => attachedDatabase.albums;
  $ArtistsTable get artists => attachedDatabase.artists;
  $CoversTable get covers => attachedDatabase.covers;
  $TunesTable get tunes => attachedDatabase.tunes;
}
mixin _$ArtistsDaoMixin on DatabaseAccessor<TunesDb> {
  $ArtistsTable get artists => attachedDatabase.artists;
}
mixin _$CoversDaoMixin on DatabaseAccessor<TunesDb> {
  $CoversTable get covers => attachedDatabase.covers;
}
mixin _$TunesDaoMixin on DatabaseAccessor<TunesDb> {
  $ArtistsTable get artists => attachedDatabase.artists;
  $AlbumsTable get albums => attachedDatabase.albums;
  $CoversTable get covers => attachedDatabase.covers;
  $TunesTable get tunes => attachedDatabase.tunes;
}
