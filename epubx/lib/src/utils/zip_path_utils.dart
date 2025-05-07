class ZipPathUtils {
  static String getDirectoryPath(String filePath) {
    var lastSlashIndex = filePath.lastIndexOf('/');
    if (lastSlashIndex == -1) {
      return '';
    } else {
      return filePath.substring(0, lastSlashIndex);
    }
  }

  static String? combine(String? directory, String? fileName) {
    var path;
    if (directory == null || directory == '') {
      path = fileName;
    } else {
      path = directory + '/' + fileName!;
    }
    return Uri.parse(path).normalizePath().path;
  }
}
