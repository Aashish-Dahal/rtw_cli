class Utils {
  static String toClassName(String name) {
    return name
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
  }
}
