import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

Color? calculateFgColor(PaletteGenerator palette) {
  final bgLuminance = palette.dominantColor?.color.computeLuminance();
  Color? fgColor;
  double highestLumDiff = 0.0;

  if (bgLuminance == null) {
    return null;
  }

  for (Color color in palette.paletteColors.map((e) => e.color)) {
    double fgLuminance = color.computeLuminance();
    double lumDiff = (bgLuminance - fgLuminance).abs();
    if (lumDiff.compareTo(highestLumDiff) == 1) {
      highestLumDiff = lumDiff;
      fgColor = color;
    }
  }

  fgColor ??= bgLuminance < 0.5 ? Colors.white : Colors.black;

  return fgColor;
}

String formatDuration(Duration duration, {int padding = 2}) {
  if (duration.inMinutes < 1) {
    return '00:${duration.inSeconds.toString().padLeft(padding, '0')}';
  } else if (duration.inMinutes < 60) {
    return '${duration.inMinutes.toString().padLeft(padding, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  } else {
    return '${duration.inHours.toString().padLeft(padding, '0')}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}

String formatFileSize(String? fileSize) {
  if (fileSize == null || fileSize.isEmpty) return "Unknown size";

  double? sizeInBytes = double.tryParse(fileSize.split(' ')[0]);

  if (sizeInBytes == null) {
    return "Invalid size";
  }

  const units = ["bytes", "KB", "MB", "GB", "TB", "PB"];
  int unitIndex = 0;

  while (sizeInBytes! >= 1024 && unitIndex < units.length - 1) {
    sizeInBytes /= 1024;
    unitIndex++;
  }

  return "${sizeInBytes.toStringAsFixed(2)} ${units[unitIndex]}";
}

String camelToSentence(String text) {
  return text.replaceAllMapped(RegExp(r'^([a-z])|[A-Z]'), (Match m) {
    return m[1] == null ? " ${m[0]}" : m[1]?.toUpperCase() ?? text;
  });
}