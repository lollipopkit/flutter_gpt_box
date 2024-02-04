enum ModelType {
  text,
  tts,
  image,
  ;

  static ModelType? fromString(String? value) {
    if (value == null) return null;
    if (value.startsWith('gpt-')) return text;
    if (value.startsWith('tts-')) return tts;
    if (value.startsWith('dall-e')) return image;
    return null;
  }
}
