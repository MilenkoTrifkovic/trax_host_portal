import 'package:file_picker/file_picker.dart';
import 'package:trax_host_portal/models/guest_dart.dart';

/// Parses a file (CSV, XLSX) and returns a list of Guest objects.
abstract class FileParser {
  List<Guest_old> parseFile(PlatformFile file);
}
