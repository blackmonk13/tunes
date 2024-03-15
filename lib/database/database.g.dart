// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
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
  static const VerificationMeta _pathnameMeta =
      const VerificationMeta('pathname');
  @override
  late final GeneratedColumn<String> pathname = GeneratedColumn<String>(
      'pathname', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _byteshashMeta =
      const VerificationMeta('byteshash');
  @override
  late final GeneratedColumn<String> byteshash = GeneratedColumn<String>(
      'byteshash', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [id, pathname, byteshash];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'covers';
  @override
  VerificationContext validateIntegrity(Insertable<Cover> instance,
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
    if (data.containsKey('byteshash')) {
      context.handle(_byteshashMeta,
          byteshash.isAcceptableOrUnknown(data['byteshash']!, _byteshashMeta));
    } else if (isInserting) {
      context.missing(_byteshashMeta);
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
      pathname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pathname'])!,
      byteshash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}byteshash'])!,
    );
  }

  @override
  $CoversTable createAlias(String alias) {
    return $CoversTable(attachedDatabase, alias);
  }
}

class Cover extends DataClass implements Insertable<Cover> {
  final int id;
  final String pathname;
  final String byteshash;
  const Cover(
      {required this.id, required this.pathname, required this.byteshash});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pathname'] = Variable<String>(pathname);
    map['byteshash'] = Variable<String>(byteshash);
    return map;
  }

  CoversCompanion toCompanion(bool nullToAbsent) {
    return CoversCompanion(
      id: Value(id),
      pathname: Value(pathname),
      byteshash: Value(byteshash),
    );
  }

  factory Cover.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cover(
      id: serializer.fromJson<int>(json['id']),
      pathname: serializer.fromJson<String>(json['pathname']),
      byteshash: serializer.fromJson<String>(json['byteshash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pathname': serializer.toJson<String>(pathname),
      'byteshash': serializer.toJson<String>(byteshash),
    };
  }

  Cover copyWith({int? id, String? pathname, String? byteshash}) => Cover(
        id: id ?? this.id,
        pathname: pathname ?? this.pathname,
        byteshash: byteshash ?? this.byteshash,
      );
  @override
  String toString() {
    return (StringBuffer('Cover(')
          ..write('id: $id, ')
          ..write('pathname: $pathname, ')
          ..write('byteshash: $byteshash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pathname, byteshash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cover &&
          other.id == this.id &&
          other.pathname == this.pathname &&
          other.byteshash == this.byteshash);
}

class CoversCompanion extends UpdateCompanion<Cover> {
  final Value<int> id;
  final Value<String> pathname;
  final Value<String> byteshash;
  const CoversCompanion({
    this.id = const Value.absent(),
    this.pathname = const Value.absent(),
    this.byteshash = const Value.absent(),
  });
  CoversCompanion.insert({
    this.id = const Value.absent(),
    required String pathname,
    required String byteshash,
  })  : pathname = Value(pathname),
        byteshash = Value(byteshash);
  static Insertable<Cover> custom({
    Expression<int>? id,
    Expression<String>? pathname,
    Expression<String>? byteshash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pathname != null) 'pathname': pathname,
      if (byteshash != null) 'byteshash': byteshash,
    });
  }

  CoversCompanion copyWith(
      {Value<int>? id, Value<String>? pathname, Value<String>? byteshash}) {
    return CoversCompanion(
      id: id ?? this.id,
      pathname: pathname ?? this.pathname,
      byteshash: byteshash ?? this.byteshash,
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
    if (byteshash.present) {
      map['byteshash'] = Variable<String>(byteshash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoversCompanion(')
          ..write('id: $id, ')
          ..write('pathname: $pathname, ')
          ..write('byteshash: $byteshash')
          ..write(')'))
        .toString();
  }
}

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
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      defaultValue: const Constant("Unknown"));
  static const VerificationMeta _artworkMeta =
      const VerificationMeta('artwork');
  @override
  late final GeneratedColumn<int> artwork = GeneratedColumn<int>(
      'artwork', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES covers (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, name, artwork];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artists';
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
    if (data.containsKey('artwork')) {
      context.handle(_artworkMeta,
          artwork.isAcceptableOrUnknown(data['artwork']!, _artworkMeta));
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
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      artwork: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artwork']),
    );
  }

  @override
  $ArtistsTable createAlias(String alias) {
    return $ArtistsTable(attachedDatabase, alias);
  }
}

class Artist extends DataClass implements Insertable<Artist> {
  final int id;
  final String name;
  final int? artwork;
  const Artist({required this.id, required this.name, this.artwork});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || artwork != null) {
      map['artwork'] = Variable<int>(artwork);
    }
    return map;
  }

  ArtistsCompanion toCompanion(bool nullToAbsent) {
    return ArtistsCompanion(
      id: Value(id),
      name: Value(name),
      artwork: artwork == null && nullToAbsent
          ? const Value.absent()
          : Value(artwork),
    );
  }

  factory Artist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Artist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      artwork: serializer.fromJson<int?>(json['artwork']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'artwork': serializer.toJson<int?>(artwork),
    };
  }

  Artist copyWith(
          {int? id,
          String? name,
          Value<int?> artwork = const Value.absent()}) =>
      Artist(
        id: id ?? this.id,
        name: name ?? this.name,
        artwork: artwork.present ? artwork.value : this.artwork,
      );
  @override
  String toString() {
    return (StringBuffer('Artist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('artwork: $artwork')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, artwork);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Artist &&
          other.id == this.id &&
          other.name == this.name &&
          other.artwork == this.artwork);
}

class ArtistsCompanion extends UpdateCompanion<Artist> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> artwork;
  const ArtistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.artwork = const Value.absent(),
  });
  ArtistsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.artwork = const Value.absent(),
  });
  static Insertable<Artist> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? artwork,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (artwork != null) 'artwork': artwork,
    });
  }

  ArtistsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int?>? artwork}) {
    return ArtistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      artwork: artwork ?? this.artwork,
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
    if (artwork.present) {
      map['artwork'] = Variable<int>(artwork.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('artwork: $artwork')
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
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      defaultValue: const Constant("Unknown"));
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<int> artist = GeneratedColumn<int>(
      'artist', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES artists (id)'));
  static const VerificationMeta _artworkMeta =
      const VerificationMeta('artwork');
  @override
  late final GeneratedColumn<int> artwork = GeneratedColumn<int>(
      'artwork', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES covers (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, name, artist, artwork];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'albums';
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
    if (data.containsKey('artist')) {
      context.handle(_artistMeta,
          artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    }
    if (data.containsKey('artwork')) {
      context.handle(_artworkMeta,
          artwork.isAcceptableOrUnknown(data['artwork']!, _artworkMeta));
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
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artist']),
      artwork: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artwork']),
    );
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(attachedDatabase, alias);
  }
}

class Album extends DataClass implements Insertable<Album> {
  final int id;
  final String name;
  final int? artist;
  final int? artwork;
  const Album(
      {required this.id, required this.name, this.artist, this.artwork});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || artist != null) {
      map['artist'] = Variable<int>(artist);
    }
    if (!nullToAbsent || artwork != null) {
      map['artwork'] = Variable<int>(artwork);
    }
    return map;
  }

  AlbumsCompanion toCompanion(bool nullToAbsent) {
    return AlbumsCompanion(
      id: Value(id),
      name: Value(name),
      artist:
          artist == null && nullToAbsent ? const Value.absent() : Value(artist),
      artwork: artwork == null && nullToAbsent
          ? const Value.absent()
          : Value(artwork),
    );
  }

  factory Album.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Album(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      artist: serializer.fromJson<int?>(json['artist']),
      artwork: serializer.fromJson<int?>(json['artwork']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'artist': serializer.toJson<int?>(artist),
      'artwork': serializer.toJson<int?>(artwork),
    };
  }

  Album copyWith(
          {int? id,
          String? name,
          Value<int?> artist = const Value.absent(),
          Value<int?> artwork = const Value.absent()}) =>
      Album(
        id: id ?? this.id,
        name: name ?? this.name,
        artist: artist.present ? artist.value : this.artist,
        artwork: artwork.present ? artwork.value : this.artwork,
      );
  @override
  String toString() {
    return (StringBuffer('Album(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('artist: $artist, ')
          ..write('artwork: $artwork')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, artist, artwork);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Album &&
          other.id == this.id &&
          other.name == this.name &&
          other.artist == this.artist &&
          other.artwork == this.artwork);
}

class AlbumsCompanion extends UpdateCompanion<Album> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> artist;
  final Value<int?> artwork;
  const AlbumsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.artist = const Value.absent(),
    this.artwork = const Value.absent(),
  });
  AlbumsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.artist = const Value.absent(),
    this.artwork = const Value.absent(),
  });
  static Insertable<Album> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? artist,
    Expression<int>? artwork,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (artist != null) 'artist': artist,
      if (artwork != null) 'artwork': artwork,
    });
  }

  AlbumsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int?>? artist,
      Value<int?>? artwork}) {
    return AlbumsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      artist: artist ?? this.artist,
      artwork: artwork ?? this.artwork,
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
    if (artist.present) {
      map['artist'] = Variable<int>(artist.value);
    }
    if (artwork.present) {
      map['artwork'] = Variable<int>(artwork.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('artist: $artist, ')
          ..write('artwork: $artwork')
          ..write(')'))
        .toString();
  }
}

class $SongsTable extends Songs with TableInfo<$SongsTable, Song> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _likedMeta = const VerificationMeta('liked');
  @override
  late final GeneratedColumn<bool> liked = GeneratedColumn<bool>(
      'liked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("liked" IN (0, 1))'),
      defaultValue: const Constant(false));
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
  static const VerificationMeta _lastPlayedMeta =
      const VerificationMeta('lastPlayed');
  @override
  late final GeneratedColumn<DateTime> lastPlayed = GeneratedColumn<DateTime>(
      'last_played', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _playCountMeta =
      const VerificationMeta('playCount');
  @override
  late final GeneratedColumn<int> playCount = GeneratedColumn<int>(
      'play_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pathname,
        title,
        liked,
        artist,
        album,
        artwork,
        modified,
        lastPlayed,
        playCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs';
  @override
  VerificationContext validateIntegrity(Insertable<Song> instance,
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
    if (data.containsKey('liked')) {
      context.handle(
          _likedMeta, liked.isAcceptableOrUnknown(data['liked']!, _likedMeta));
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
    if (data.containsKey('last_played')) {
      context.handle(
          _lastPlayedMeta,
          lastPlayed.isAcceptableOrUnknown(
              data['last_played']!, _lastPlayedMeta));
    }
    if (data.containsKey('play_count')) {
      context.handle(_playCountMeta,
          playCount.isAcceptableOrUnknown(data['play_count']!, _playCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Song map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Song(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pathname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pathname'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      liked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}liked'])!,
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artist']),
      album: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}album']),
      artwork: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artwork']),
      modified: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified'])!,
      lastPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_played']),
      playCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}play_count'])!,
    );
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(attachedDatabase, alias);
  }
}

class Song extends DataClass implements Insertable<Song> {
  final int id;
  final String pathname;
  final String? title;
  final bool liked;
  final int? artist;
  final int? album;
  final int? artwork;
  final DateTime modified;
  final DateTime? lastPlayed;
  final int playCount;
  const Song(
      {required this.id,
      required this.pathname,
      this.title,
      required this.liked,
      this.artist,
      this.album,
      this.artwork,
      required this.modified,
      this.lastPlayed,
      required this.playCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pathname'] = Variable<String>(pathname);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['liked'] = Variable<bool>(liked);
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
    if (!nullToAbsent || lastPlayed != null) {
      map['last_played'] = Variable<DateTime>(lastPlayed);
    }
    map['play_count'] = Variable<int>(playCount);
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      pathname: Value(pathname),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      liked: Value(liked),
      artist:
          artist == null && nullToAbsent ? const Value.absent() : Value(artist),
      album:
          album == null && nullToAbsent ? const Value.absent() : Value(album),
      artwork: artwork == null && nullToAbsent
          ? const Value.absent()
          : Value(artwork),
      modified: Value(modified),
      lastPlayed: lastPlayed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayed),
      playCount: Value(playCount),
    );
  }

  factory Song.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Song(
      id: serializer.fromJson<int>(json['id']),
      pathname: serializer.fromJson<String>(json['pathname']),
      title: serializer.fromJson<String?>(json['title']),
      liked: serializer.fromJson<bool>(json['liked']),
      artist: serializer.fromJson<int?>(json['artist']),
      album: serializer.fromJson<int?>(json['album']),
      artwork: serializer.fromJson<int?>(json['artwork']),
      modified: serializer.fromJson<DateTime>(json['modified']),
      lastPlayed: serializer.fromJson<DateTime?>(json['lastPlayed']),
      playCount: serializer.fromJson<int>(json['playCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pathname': serializer.toJson<String>(pathname),
      'title': serializer.toJson<String?>(title),
      'liked': serializer.toJson<bool>(liked),
      'artist': serializer.toJson<int?>(artist),
      'album': serializer.toJson<int?>(album),
      'artwork': serializer.toJson<int?>(artwork),
      'modified': serializer.toJson<DateTime>(modified),
      'lastPlayed': serializer.toJson<DateTime?>(lastPlayed),
      'playCount': serializer.toJson<int>(playCount),
    };
  }

  Song copyWith(
          {int? id,
          String? pathname,
          Value<String?> title = const Value.absent(),
          bool? liked,
          Value<int?> artist = const Value.absent(),
          Value<int?> album = const Value.absent(),
          Value<int?> artwork = const Value.absent(),
          DateTime? modified,
          Value<DateTime?> lastPlayed = const Value.absent(),
          int? playCount}) =>
      Song(
        id: id ?? this.id,
        pathname: pathname ?? this.pathname,
        title: title.present ? title.value : this.title,
        liked: liked ?? this.liked,
        artist: artist.present ? artist.value : this.artist,
        album: album.present ? album.value : this.album,
        artwork: artwork.present ? artwork.value : this.artwork,
        modified: modified ?? this.modified,
        lastPlayed: lastPlayed.present ? lastPlayed.value : this.lastPlayed,
        playCount: playCount ?? this.playCount,
      );
  @override
  String toString() {
    return (StringBuffer('Song(')
          ..write('id: $id, ')
          ..write('pathname: $pathname, ')
          ..write('title: $title, ')
          ..write('liked: $liked, ')
          ..write('artist: $artist, ')
          ..write('album: $album, ')
          ..write('artwork: $artwork, ')
          ..write('modified: $modified, ')
          ..write('lastPlayed: $lastPlayed, ')
          ..write('playCount: $playCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pathname, title, liked, artist, album,
      artwork, modified, lastPlayed, playCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Song &&
          other.id == this.id &&
          other.pathname == this.pathname &&
          other.title == this.title &&
          other.liked == this.liked &&
          other.artist == this.artist &&
          other.album == this.album &&
          other.artwork == this.artwork &&
          other.modified == this.modified &&
          other.lastPlayed == this.lastPlayed &&
          other.playCount == this.playCount);
}

class SongsCompanion extends UpdateCompanion<Song> {
  final Value<int> id;
  final Value<String> pathname;
  final Value<String?> title;
  final Value<bool> liked;
  final Value<int?> artist;
  final Value<int?> album;
  final Value<int?> artwork;
  final Value<DateTime> modified;
  final Value<DateTime?> lastPlayed;
  final Value<int> playCount;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.pathname = const Value.absent(),
    this.title = const Value.absent(),
    this.liked = const Value.absent(),
    this.artist = const Value.absent(),
    this.album = const Value.absent(),
    this.artwork = const Value.absent(),
    this.modified = const Value.absent(),
    this.lastPlayed = const Value.absent(),
    this.playCount = const Value.absent(),
  });
  SongsCompanion.insert({
    this.id = const Value.absent(),
    required String pathname,
    this.title = const Value.absent(),
    this.liked = const Value.absent(),
    this.artist = const Value.absent(),
    this.album = const Value.absent(),
    this.artwork = const Value.absent(),
    required DateTime modified,
    this.lastPlayed = const Value.absent(),
    this.playCount = const Value.absent(),
  })  : pathname = Value(pathname),
        modified = Value(modified);
  static Insertable<Song> custom({
    Expression<int>? id,
    Expression<String>? pathname,
    Expression<String>? title,
    Expression<bool>? liked,
    Expression<int>? artist,
    Expression<int>? album,
    Expression<int>? artwork,
    Expression<DateTime>? modified,
    Expression<DateTime>? lastPlayed,
    Expression<int>? playCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pathname != null) 'pathname': pathname,
      if (title != null) 'title': title,
      if (liked != null) 'liked': liked,
      if (artist != null) 'artist': artist,
      if (album != null) 'album': album,
      if (artwork != null) 'artwork': artwork,
      if (modified != null) 'modified': modified,
      if (lastPlayed != null) 'last_played': lastPlayed,
      if (playCount != null) 'play_count': playCount,
    });
  }

  SongsCompanion copyWith(
      {Value<int>? id,
      Value<String>? pathname,
      Value<String?>? title,
      Value<bool>? liked,
      Value<int?>? artist,
      Value<int?>? album,
      Value<int?>? artwork,
      Value<DateTime>? modified,
      Value<DateTime?>? lastPlayed,
      Value<int>? playCount}) {
    return SongsCompanion(
      id: id ?? this.id,
      pathname: pathname ?? this.pathname,
      title: title ?? this.title,
      liked: liked ?? this.liked,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      artwork: artwork ?? this.artwork,
      modified: modified ?? this.modified,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      playCount: playCount ?? this.playCount,
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
    if (liked.present) {
      map['liked'] = Variable<bool>(liked.value);
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
    if (lastPlayed.present) {
      map['last_played'] = Variable<DateTime>(lastPlayed.value);
    }
    if (playCount.present) {
      map['play_count'] = Variable<int>(playCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('pathname: $pathname, ')
          ..write('title: $title, ')
          ..write('liked: $liked, ')
          ..write('artist: $artist, ')
          ..write('album: $album, ')
          ..write('artwork: $artwork, ')
          ..write('modified: $modified, ')
          ..write('lastPlayed: $lastPlayed, ')
          ..write('playCount: $playCount')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, Playlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
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
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      defaultValue: currentDateAndTime.datetime);
  static const VerificationMeta _modifiedMeta =
      const VerificationMeta('modified');
  @override
  late final GeneratedColumn<DateTime> modified = GeneratedColumn<DateTime>(
      'modified', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, modified];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(Insertable<Playlist> instance,
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
    if (data.containsKey('modified')) {
      context.handle(_modifiedMeta,
          modified.isAcceptableOrUnknown(data['modified']!, _modifiedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Playlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Playlist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      modified: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified'])!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class Playlist extends DataClass implements Insertable<Playlist> {
  final int id;
  final String name;
  final DateTime modified;
  const Playlist(
      {required this.id, required this.name, required this.modified});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['modified'] = Variable<DateTime>(modified);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      id: Value(id),
      name: Value(name),
      modified: Value(modified),
    );
  }

  factory Playlist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Playlist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      modified: serializer.fromJson<DateTime>(json['modified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'modified': serializer.toJson<DateTime>(modified),
    };
  }

  Playlist copyWith({int? id, String? name, DateTime? modified}) => Playlist(
        id: id ?? this.id,
        name: name ?? this.name,
        modified: modified ?? this.modified,
      );
  @override
  String toString() {
    return (StringBuffer('Playlist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('modified: $modified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, modified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Playlist &&
          other.id == this.id &&
          other.name == this.name &&
          other.modified == this.modified);
}

class PlaylistsCompanion extends UpdateCompanion<Playlist> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> modified;
  const PlaylistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.modified = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.modified = const Value.absent(),
  });
  static Insertable<Playlist> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? modified,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (modified != null) 'modified': modified,
    });
  }

  PlaylistsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<DateTime>? modified}) {
    return PlaylistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      modified: modified ?? this.modified,
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
    if (modified.present) {
      map['modified'] = Variable<DateTime>(modified.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('modified: $modified')
          ..write(')'))
        .toString();
  }
}

class $PlaylistSongsTable extends PlaylistSongs
    with TableInfo<$PlaylistSongsTable, PlaylistSong> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistSongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tuneIdMeta = const VerificationMeta('tuneId');
  @override
  late final GeneratedColumn<int> tuneId = GeneratedColumn<int>(
      'tune_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES songs (id)'));
  static const VerificationMeta _playlistIdMeta =
      const VerificationMeta('playlistId');
  @override
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
      'playlist_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES playlists (id)'));
  @override
  List<GeneratedColumn> get $columns => [tuneId, playlistId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_songs';
  @override
  VerificationContext validateIntegrity(Insertable<PlaylistSong> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tune_id')) {
      context.handle(_tuneIdMeta,
          tuneId.isAcceptableOrUnknown(data['tune_id']!, _tuneIdMeta));
    } else if (isInserting) {
      context.missing(_tuneIdMeta);
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
          _playlistIdMeta,
          playlistId.isAcceptableOrUnknown(
              data['playlist_id']!, _playlistIdMeta));
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tuneId, playlistId};
  @override
  PlaylistSong map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistSong(
      tuneId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tune_id'])!,
      playlistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}playlist_id'])!,
    );
  }

  @override
  $PlaylistSongsTable createAlias(String alias) {
    return $PlaylistSongsTable(attachedDatabase, alias);
  }
}

class PlaylistSong extends DataClass implements Insertable<PlaylistSong> {
  final int tuneId;
  final int playlistId;
  const PlaylistSong({required this.tuneId, required this.playlistId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tune_id'] = Variable<int>(tuneId);
    map['playlist_id'] = Variable<int>(playlistId);
    return map;
  }

  PlaylistSongsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistSongsCompanion(
      tuneId: Value(tuneId),
      playlistId: Value(playlistId),
    );
  }

  factory PlaylistSong.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistSong(
      tuneId: serializer.fromJson<int>(json['tuneId']),
      playlistId: serializer.fromJson<int>(json['playlistId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tuneId': serializer.toJson<int>(tuneId),
      'playlistId': serializer.toJson<int>(playlistId),
    };
  }

  PlaylistSong copyWith({int? tuneId, int? playlistId}) => PlaylistSong(
        tuneId: tuneId ?? this.tuneId,
        playlistId: playlistId ?? this.playlistId,
      );
  @override
  String toString() {
    return (StringBuffer('PlaylistSong(')
          ..write('tuneId: $tuneId, ')
          ..write('playlistId: $playlistId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tuneId, playlistId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistSong &&
          other.tuneId == this.tuneId &&
          other.playlistId == this.playlistId);
}

class PlaylistSongsCompanion extends UpdateCompanion<PlaylistSong> {
  final Value<int> tuneId;
  final Value<int> playlistId;
  final Value<int> rowid;
  const PlaylistSongsCompanion({
    this.tuneId = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistSongsCompanion.insert({
    required int tuneId,
    required int playlistId,
    this.rowid = const Value.absent(),
  })  : tuneId = Value(tuneId),
        playlistId = Value(playlistId);
  static Insertable<PlaylistSong> custom({
    Expression<int>? tuneId,
    Expression<int>? playlistId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tuneId != null) 'tune_id': tuneId,
      if (playlistId != null) 'playlist_id': playlistId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistSongsCompanion copyWith(
      {Value<int>? tuneId, Value<int>? playlistId, Value<int>? rowid}) {
    return PlaylistSongsCompanion(
      tuneId: tuneId ?? this.tuneId,
      playlistId: playlistId ?? this.playlistId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tuneId.present) {
      map['tune_id'] = Variable<int>(tuneId.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistSongsCompanion(')
          ..write('tuneId: $tuneId, ')
          ..write('playlistId: $playlistId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class SongsCountData extends DataClass {
  final int? itemCount;
  const SongsCountData({this.itemCount});
  factory SongsCountData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongsCountData(
      itemCount: serializer.fromJson<int?>(json['itemCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemCount': serializer.toJson<int?>(itemCount),
    };
  }

  SongsCountData copyWith({Value<int?> itemCount = const Value.absent()}) =>
      SongsCountData(
        itemCount: itemCount.present ? itemCount.value : this.itemCount,
      );
  @override
  String toString() {
    return (StringBuffer('SongsCountData(')
          ..write('itemCount: $itemCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => itemCount.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongsCountData && other.itemCount == this.itemCount);
}

class $SongsCountView extends ViewInfo<$SongsCountView, SongsCountData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$TunesDatabase attachedDatabase;
  $SongsCountView(this.attachedDatabase, [this._alias]);
  $SongsTable get songs => attachedDatabase.songs.createAlias('t0');
  @override
  List<GeneratedColumn> get $columns => [itemCount];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'songs_count';
  @override
  Map<SqlDialect, String>? get createViewStatements => null;
  @override
  $SongsCountView get asDslTable => this;
  @override
  SongsCountData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongsCountData(
      itemCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_count']),
    );
  }

  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
      'item_count', aliasedName, true,
      generatedAs: GeneratedAs(songs.id.count(), false),
      type: DriftSqlType.int);
  @override
  $SongsCountView createAlias(String alias) {
    return $SongsCountView(attachedDatabase, alias);
  }

  @override
  Query? get query =>
      (attachedDatabase.selectOnly(songs)..addColumns($columns));
  @override
  Set<String> get readTables => const {'songs'};
}

abstract class _$TunesDatabase extends GeneratedDatabase {
  _$TunesDatabase(QueryExecutor e) : super(e);
  late final $CoversTable covers = $CoversTable(this);
  late final $ArtistsTable artists = $ArtistsTable(this);
  late final $AlbumsTable albums = $AlbumsTable(this);
  late final $SongsTable songs = $SongsTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $PlaylistSongsTable playlistSongs = $PlaylistSongsTable(this);
  late final $SongsCountView songsCount = $SongsCountView(this);
  late final SongsDao songsDao = SongsDao(this as TunesDatabase);
  late final ArtistsDao artistsDao = ArtistsDao(this as TunesDatabase);
  late final AlbumsDao albumsDao = AlbumsDao(this as TunesDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [covers, artists, albums, songs, playlists, playlistSongs, songsCount];
}
