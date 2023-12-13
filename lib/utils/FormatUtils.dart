class FormatUtils {
  static byteCountDecimal(byteCount) {
    var bytes = byteCount;
    var unit = 'B';
    if (bytes >= 1024) {
      bytes /= 1024;
      unit = 'KB';
    }
    if (bytes >= 1024) {
      bytes /= 1024;
      unit = 'MB';
    }
    if (bytes >= 1024) {
      bytes /= 1024;
      unit = 'GB';
    }
    if (bytes >= 1024) {
      bytes /= 1024;
      unit = 'TB';
    }
    return '${bytes.toStringAsFixed(2)}$unit';
  }
}
