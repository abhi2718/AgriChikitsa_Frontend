import 'dart:io';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  String? path;

  if (Platform.isAndroid || Platform.isIOS) {
    // Get the Downloads directory for Android and iOS
    final Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      path = directory.path;
    } else {
      throw Exception('Unable to find storage directory.');
    }
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // For desktop platforms
    path = await PathProviderPlatform.instance.getApplicationSupportPath();
  }

  // Create the file and write bytes
  final File file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);

  // Open the file
  if (Platform.isAndroid || Platform.isIOS) {
    await open_file.OpenFile.open(file.path);
  } else if (Platform.isWindows) {
    await Process.run('start', <String>[file.path], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', <String>[file.path], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', <String>[file.path], runInShell: true);
  }
}
