// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ArtistsTable extends Artists with TableInfo<$ArtistsTable, Artist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'artists';
  @override
  String get actualTableName => 'artists';
  @override
  VerificationContext validateIntegrity(Insertable<Artist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Artist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Artist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
    );
  }

  @override
  $ArtistsTable createAlias(String alias) {
    return $ArtistsTable(attachedDatabase, alias);
  }
}

class Artist extends DataClass implements Insertable<Artist> {
  final int id;
  final String? name;
  const Artist({required this.id, this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  ArtistsCompanion toCompanion(bool nullToAbsent) {
    return ArtistsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory Artist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Artist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
    };
  }

  Artist copyWith({int? id, Value<String?> name = const Value.absent()}) =>
      Artist(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Artist(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Artist && other.id == this.id && other.name == this.name);
}

class ArtistsCompanion extends UpdateCompanion<Artist> {
  final Value<int> id;
  final Value<String?> name;
  const ArtistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ArtistsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  static Insertable<Artist> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ArtistsCompanion copyWith({Value<int>? id, Value<String?>? name}) {
    return ArtistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, Album> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'albums';
  @override
  String get actualTableName => 'albums';
  @override
  VerificationContext validateIntegrity(Insertable<Album> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Album map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Album(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
    );
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(attachedDatabase, alias);
  }
}

class Album extends DataClass implements Insertable<Album> {
  final int id;
  final String? name;
  const Album({required this.id, this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  AlbumsCompanion toCompanion(bool nullToAbsent) {
    return AlbumsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory Album.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Album(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
    };
  }

  Album copyWith({int? id, Value<String?> name = const Value.absent()}) =>
      Album(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Album(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Album && other.id == this.id && other.name == this.name);
}

class AlbumsCompanion extends UpdateCompanion<Album> {
  final Value<int> id;
  final Value<String?> name;
  const AlbumsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  AlbumsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  static Insertable<Album> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  AlbumsCompanion copyWith({Value<int>? id, Value<String?>? name}) {
    return AlbumsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $CoversTable extends Covers with TableInfo<$CoversTable, Cover> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoversTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _artMeta = const VerificationMeta('art');
  @override
  late final GeneratedColumn<Uint8List> art = GeneratedColumn<Uint8List>(
      'art', aliasedName, true,
      type: DriftSqlType.blob, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, art];
  @override
  String get aliasedName => _alias ?? 'covers';
  @override
  String get actualTableName => 'covers';
  @override
  VerificationContext validateIntegrity(Insertable<Cover> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('art')) {
      context.handle(
          _artMeta, art.isAcceptableOrUnknown(data['art']!, _artMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cover map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cover(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      art: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}art']),
    );
  }

  @override
  $CoversTable createAlias(String alias) {
    return $CoversTable(attachedDatabase, alias);
  }
}

class Cover extends DataClass implements Insertable<Cover> {
  final int id;
  final Uint8List? art;
  const Cover({required this.id, this.art});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || art != null) {
      map['art'] = Variable<Uint8List>(art);
    }
    return map;
  }

  CoversCompanion toCompanion(bool nullToAbsent) {
    return CoversCompanion(
      id: Value(id),
      art: art == null && nullToAbsent ? const Value.absent() : Value(art),
    );
  }

  factory Cover.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cover(
      id: serializer.fromJson<int>(json['id']),
      art: serializer.fromJson<Uint8List?>(json['art']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'art': serializer.toJson<Uint8List?>(art),
    };
  }

  Cover copyWith({int? id, Value<Uint8List?> art = const Value.absent()}) =>
      Cover(
        id: id ?? this.id,
        art: art.present ? art.value : this.art,
      );
  @override
  String toString() {
    return (StringBuffer('Cover(')
          ..write('id: $id, ')
          ..write('art: $art')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, $driftBlobEquality.hash(art));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cover &&
          other.id == this.id &&
          $driftBlobEquality.equals(other.art, this.art));
}

class CoversCompanion extends UpdateCompanion<Cover> {
  final Value<int> id;
  final Value<Uint8List?> art;
  const CoversCompanion({
    this.id = const Value.absent(),
    this.art = const Value.absent(),
  });
  CoversCompanion.insert({
    this.id = const Value.absent(),
    this.art = const Value.absent(),
  });
  static Insertable<Cover> custom({
    Expression<int>? id,
    Expression<Uint8List>? art,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (art != null) 'art': art,
    });
  }

  CoversCompanion copyWith({Value<int>? id, Value<Uint8List?>? art}) {
    return CoversCompanion(
      id: id ?? this.id,
      art: art ?? this.art,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (art.present) {
      map['art'] = Variable<Uint8List>(art.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoversCompanion(')
          ..write('id: $id, ')
          ..write('art: $art')
          ..write(')'))
        .toString();
  }
}

class $TunesTable extends Tunes with TableInfo<$TunesTable, Tune> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TunesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pathnameMeta =
      const VerificationMeta('pathname');
  @override
  late final GeneratedColumn<String> pathname = GeneratedColumn<String>(
      'pathname', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<int> artist = GeneratedColumn<int>(
      'artist', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES artists (id)'));
  static const VerificationMeta _albumMeta = const VerificationMeta('album');
  @override
  late final GeneratedColumn<int> album = GeneratedColumn<int>(
      'album', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES albums (id)'));
  static const VerificationMeta _artworkMeta =
      const VerificationMeta('artwork');
  @override
  late final GeneratedColumn<int> artwork = GeneratedColumn<int>(
      'artwork', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES covers (id)'));
  static const VerificationMeta _modifiedMeta =
      const VerificationMeta('modified');
  @override
  late final GeneratedColumn<DateTime> modified = GeneratedColumn<DateTime>(
      'modified', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, pathname, title, artist, album, artwork, modified];
  @override
  String get aliasedName => _alias ?? 'tunes';
  @override
  String get actualTableName => 'tunes';
  @override
  VerificationContext validateIntegrity(Insertable<Tune> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pathname')) {
      context.handle(_pathnameMeta,
          pathname.isAcceptableOrUnknown(data['pathname']!, _pathnameMeta));
    } else if (isInserting) {
      context.missing(_pathnameMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta,
          artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    }
    if (data.containsKey('album')) {
      context.handle(
          _albumMeta, album.isAcceptableOrUnknown(data['album']!, _albumMeta));
    }
    if (data.containsKey('artwork')) {
      context.handle(_artworkMeta,
          artwork.isAcceptableOrUnknown(data['artwork']!, _artworkMeta));
    }
    if (data.containsKey('modified')) {
      context.handle(_modifiedMeta,
          modified.isAcceptableOrUnknown(data['modified']!, _modifiedMeta));
    } else if (isInserting) {
      context.missing(_modifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tune map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tune(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pathname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pathname'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artist']),
      album: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}album']),
      artwork: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artwork']),
      modified: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified'])!,
    );
  }

  @override
  $TunesTable createAlias(String alias) {
    return $TunesTable(attachedDatabase, alias);
  }
}

class Tune extends DataClass implements Insertable<Tune> {
  final int id;
  final String pathname;
  final String? title;
  final int? artist;
  final int? album;
  final int? artwork;
  final DateTime modified;
  const Tune(
      {required this.id,
      required this.pathname,
      this.title,
      this.artist,
      this.album,
      this.artwork,
      required this.modified});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pathname'] = Variable<String>(pathname);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || artist != null) {
      map['artist'] = Variable<int>(artist);
    }
    if (!nullToAbsent || album != null) {
      map['album'] = Variable<int>(album);
    }
    if (!nullToAbsent || artwork != null) {
      map['artwork'] = Variable<int>(artwork);
    }
    map['modified'] = Variable<DateTime>(modified);
    return map;
  }

  TunesCompanion toCompanion(bool nullToAbsent) {
    return TunesCompanion(
      id: Value(id),
      pathname: Value(pathname),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      artist:
          artist == null && nullToAbsent ? const Value.absent() : Value(artist),
      album:
          album == null && nullToAbsent ? const Value.absent() : Value(album),
      artwork: artwork == null && nullToAbsent
          ? const Value.absent()
          : Value(artwork),
      modified: Value(modified),
    );
  }

  factory Tune.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tune(
      id: serializer.fromJson<int>(json['id']),
      pathname: serializer.fromJson<String>(json['pathname']),
      title: serializer.fromJson<String?>(json['title']),
      artist: serializer.fromJson<int?>(json['artist']),
      album: serializer.fromJson<int?>(json['album']),
      artwork: serializer.fromJson<int?>(json['artwork']),
      modified: serializer.fromJson<DateTime>(json['modified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pathname': serializer.toJson<String>(pathname),
      'title': serializer.toJson<String?>(title),
      'artist': serializer.toJson<int?>(artist),
      'album': serializer.toJson<int?>(album),
      'artwork': serializer.toJson<int?>(artwork),
      'modified': serializer.toJson<DateTime>(modified),
    };
  }

  Tune copyWith(
          {int? id,
          String? pathname,
          Value<String?> title = const Value.absent(),
          Value<int?> artist = const Value.absent(),
          Value<int?> album = const Value.absent(),
          Value<int?> artwork = const Value.absent(),
          DateTime? modified}) =>
      Tune(
        id: id ?? this.id,
        pathname: pathname ?? this.pathname,
        title: title.present ? title.value : this.title,
        artist: artist.present ? artist.value : this.artist,
        album: album.present ? album.value : this.album,
        artwork: artwork.present ? artwork.value : this.artwork,
        modified: modified ?? this.modified,
      );
  @override
  String toString() {
    return (StringBuffer('Tune(')
          ..write('id: $id, ')
          ..write('pathname: $pathname, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('album: $album, ')
          ..write('artwork: $artwork, ')
          ..write('modified: $modified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, pathname, title, artist, album, artwork, modified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tune &&
          other.id == this.id &&
          other.pathname == this.pathname &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.album == this.album &&
          other.artwork == this.artwork &&
          other.modified == this.modified);
}

class TunesCompanion extends UpdateCompanion<Tune> {
  final Value<int> id;
  final Value<String> pathname;
  final Value<String?> title;
  final Value<int?> artist;
  final Value<int?> album;
  final Value<int?> artwork;
  final Value<DateTime> modified;
  const TunesCompanion({
    this.id = const Value.absent(),
    this.pathname = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.album = const Value.absent(),
    this.artwork = const Value.absent(),
    this.modified = const Value.absent(),
  });
  TunesCompanion.insert({
    this.id = const Value.absent(),
    required String pathname,
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.album = const Value.absent(),
    this.artwork = const Value.absent(),
    required DateTime modified,
  })  : pathname = Value(pathname),
        modified = Value(modified);
  static Insertable<Tune> custom({
    Expression<int>? id,
    Expression<String>? pathname,
    Expression<String>? title,
    Expression<int>? artist,
    Expression<int>? album,
    Expression<int>? artwork,
    Expression<DateTime>? modified,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pathname != null) 'pathname': pathname,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (album != null) 'album': album,
      if (artwork != null) 'artwork': artwork,
      if (modified != null) 'modified': modified,
    });
  }

  TunesCompanion copyWith(
      {Value<int>? id,
      Value<String>? pathname,
      Value<String?>? title,
      Value<int?>? artist,
      Value<int?>? album,
      Value<int?>? artwork,
      Value<DateTime>? modified}) {
    return TunesCompanion(
      id: id ?? this.id,
      pathname: pathname ?? this.pathname,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      artwork: artwork ?? this.artwork,
      modified: modified ?? this.modified,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pathname.present) {
      map['pathname'] = Variable<String>(pathname.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<int>(artist.value);
    }
    if (album.present) {
      map['album'] = Variable<int>(album.value);
    }
    if (artwork.present) {
      map['artwork'] = Variable<int>(artwork.value);
    }
    if (modified.present) {
      map['modified'] = Variable<DateTime>(modified.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TunesCompanion(')
          ..write('id: $id, ')
          ..write('pathname: $pathname, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('album: $album, ')
          ..write('artwork: $artwork, ')
          ..write('modified: $modified')
          ..write(')'))
        .toString();
  }
}

abstract class _$TunesDb extends GeneratedDatabase {
  _$TunesDb(QueryExecutor e) : super(e);
  late final $ArtistsTable artists = $ArtistsTable(this);
  late final $AlbumsTable albums = $AlbumsTable(this);
  late final $CoversTable covers = $CoversTable(this);
  late final $TunesTable tunes = $TunesTable(this);
  late final TunesDao tunesDao = TunesDao(this as TunesDb);
  late final ArtistsDao artistsDao = ArtistsDao(this as TunesDb);
  late final AlbumsDao albumsDao = AlbumsDao(this as TunesDb);
  late final CoversDao coversDao = CoversDao(this as TunesDb);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [artists, albums, covers, tunes];
}
