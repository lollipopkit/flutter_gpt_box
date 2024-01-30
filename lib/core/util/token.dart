abstract final class TiktokenUtils {
  static double? getPrice(String model) {
    if (model == 'gpt-4-32k') return 0.00006;
    if (model == 'gpt-4') return 0.00003;
    if (model.startsWith('gpt-4-')) return 0.00001;
    if (model.startsWith('gpt-3.5')) return 0.000001;
    return null;
  }
}
