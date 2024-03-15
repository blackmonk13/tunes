library providers;

import 'dart:io';

import 'package:audiotagger/models/tag.dart';
import 'package:beamer/beamer.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tunes/database/database.dart';
import 'package:tunes/locations/locations.dart';
import 'package:tunes/locations/scan.dart';
import 'package:tunes/models/sortcriteria.dart';
import 'package:tunes/models/tunealbum.dart';
import 'package:tunes/models/tuneartist.dart';
import 'package:tunes/models/tunesong.dart';
import 'package:tunes/utils/constants.dart';
import 'package:tunes/utils/prefs.dart';

part 'albums.dart';
part 'artists.dart';
part 'common.dart';
part 'player.dart';
part 'providers.g.dart';
part 'scan.dart';
part 'songs.dart';
