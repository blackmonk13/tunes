library providers;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide MediaQuery;
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mime/mime.dart';
import 'package:mpeg_codec/mpeg_codec.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunes/models/filters/filters.dart';
import 'package:tunes/utils/constants.dart';
import 'package:tunes/utils/media_query.dart';
import 'package:tunes/utils/prefs.dart';

part 'albums.dart';
part 'artists.dart';
part 'common.dart';
part 'genres.dart';
part 'player.dart';
part 'playback_session.dart';
part 'playlists.dart';
part 'providers.g.dart';
part 'songs.dart';
