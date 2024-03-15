String formatDuration(Duration duration, {int padding = 2}) {
  if (duration.inMinutes < 1) {
    return '00:${duration.inSeconds.toString().padLeft(padding, '0')}';
  } else if (duration.inMinutes < 60) {
    return '${duration.inMinutes.toString().padLeft(padding, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  } else {
    return '${duration.inHours.toString().padLeft(padding, '0')}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}

String? getMonthName(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }
  List<String> months = [
    '', // Index 0 is not used
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  return months[dateTime.month];
}