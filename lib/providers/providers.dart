library providers;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:id3_codec/id3_codec.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tunes/utils/prefs.dart';

part 'albums.dart';
part 'artists.dart';
part 'common.dart';
part 'genres.dart';
part 'playlists.dart';
part 'providers.g.dart';
part 'songs.dart';
