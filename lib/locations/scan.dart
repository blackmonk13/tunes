import 'package:beamer/beamer.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:tunes/pages/scan.dart';

class ScanMusicLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/scan'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('scan'),
        title: 'Find Local Songs',
        child: ScanPage(),
      ),
    ];
  }
}

class ScanOptionsLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/scanoptions'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('scanoptions'),
        title: 'Scan Options',
        child: ScanOptions(),
      ),
    ];
  }
}

class MusicPathsLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/musicpaths'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('musicpaths'),
        title: 'Specify Folders',
        child: MediaFolders(),
      ),
    ];
  }
}

class MusicManagementLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/manageoptions'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('manageoptions'),
        title: 'Music Management Options',
        child: MusicManagement(),
      ),
    ];
  }
}