class PrayerGuideResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<PrayerGuideStep>? data;

  PrayerGuideResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory PrayerGuideResponse.fromJson(Map<String, dynamic> json) {
    return PrayerGuideResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? (json['data'] as List).map((i) => PrayerGuideStep.fromJson(i)).toList() : null,
    );
  }
}

class PrayerGuideStep {
  final String? stepKey;
  final int? order;
  final String? stepName;
  final String? arabicText;
  final String? transliteration;
  final String? translation;
  final bool? isPlaceholder;
  final List<Rakat>? rakats;
  final List<Verse>? verses;

  PrayerGuideStep({
    this.stepKey,
    this.order,
    this.stepName,
    this.arabicText,
    this.transliteration,
    this.translation,
    this.isPlaceholder,
    this.rakats,
    this.verses,
  });

  factory PrayerGuideStep.fromJson(Map<String, dynamic> json) {
    return PrayerGuideStep(
      stepKey: json['stepKey'],
      order: json['order'],
      stepName: json['stepName'],
      arabicText: json['arabicText'],
      transliteration: json['transliteration'],
      translation: json['translation'],
      isPlaceholder: json['isPlaceholder'],
      rakats: json['rakats'] != null ? (json['rakats'] as List).map((i) => Rakat.fromJson(i)).toList() : null,
      verses: json['verses'] != null ? (json['verses'] as List).map((i) => Verse.fromJson(i)).toList() : null,
    );
  }
}

class Rakat {
  final int? rakat;
  final int? surahNumber;
  final String? surahName;
  final String? arabicText;
  final String? transliteration;
  final String? translation;
  final List<WordByWord>? wordByWord;
  final String? audioUrl;
  final List<Verse>? verses;

  Rakat({
    this.rakat,
    this.surahNumber,
    this.surahName,
    this.arabicText,
    this.transliteration,
    this.translation,
    this.wordByWord,
    this.audioUrl,
    this.verses,
  });

  factory Rakat.fromJson(Map<String, dynamic> json) {
    return Rakat(
      rakat: json['rakat'],
      surahNumber: json['surahNumber'],
      surahName: json['surahName'],
      arabicText: json['arabicText'],
      transliteration: json['transliteration'],
      translation: json['translation'],
      wordByWord: json['wordByWord'] != null ? (json['wordByWord'] as List).map((i) => WordByWord.fromJson(i)).toList() : null,
      audioUrl: json['audioUrl'],
      verses: json['verses'] != null ? (json['verses'] as List).map((i) => Verse.fromJson(i)).toList() : null,
    );
  }
}

class Verse {
  final int? verseNumber;
  final String? verseKey;
  final String? arabicText;
  final String? transliteration;
  final String? translation;
  final String? audioUrl;

  Verse({
    this.verseNumber,
    this.verseKey,
    this.arabicText,
    this.transliteration,
    this.translation,
    this.audioUrl,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verseNumber: json['verseNumber'],
      verseKey: json['verseKey'],
      arabicText: json['arabicText'],
      transliteration: json['transliteration'],
      translation: json['translation'],
      audioUrl: json['audioUrl'],
    );
  }
}

class WordByWord {
  final String? arabic;
  final String? transliteration;
  final String? meaning;

  WordByWord({
    this.arabic,
    this.transliteration,
    this.meaning,
  });

  factory WordByWord.fromJson(Map<String, dynamic> json) {
    return WordByWord(
      arabic: json['arabic'],
      transliteration: json['transliteration'],
      meaning: json['meaning'],
    );
  }
}
