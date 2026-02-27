import '../domain/entities/adhkar_category_entity.dart';

/// Sample Adhkar data - can be expanded or moved to JSON/assets
List<AdhkarCategoryEntity> getAdhkarData() {
  return [
    AdhkarCategoryEntity(
      id: 'morning',
      nameEn: 'Morning',
      nameAr: 'أذكار الصباح',
      dhikrs: [
        const DhikrEntity(
          arabic: 'أَعُوذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
          transliteration: 'A\'oodhu billaahi minash-shaytaanir-rajeem',
          translation: 'I seek refuge in Allah from the accursed Shaytan',
          count: 1,
        ),
        const DhikrEntity(
          arabic: 'بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ',
          transliteration: 'Bismillaahir-Rahmaanir-Raheem',
          translation: 'In the name of Allah, the Most Gracious, the Most Merciful',
          count: 1,
        ),
        const DhikrEntity(
          arabic: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
          transliteration: 'Allahumma salli wa sallim \'ala nabiyyina Muhammad',
          translation: 'O Allah, send blessings and peace upon our Prophet Muhammad',
          count: 1,
        ),
        const DhikrEntity(
          arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
          transliteration: 'La ilaha illallah wahdahu la sharika lah',
          translation: 'None has the right to be worshipped but Allah alone',
          count: 1,
        ),
        const DhikrEntity(
          arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          transliteration: 'SubhanAllahi wa bihamdihi',
          translation: 'Glory and praise be to Allah',
          count: 100,
        ),
      ],
    ),
    AdhkarCategoryEntity(
      id: 'evening',
      nameEn: 'Evening',
      nameAr: 'أذكار المساء',
      dhikrs: [
        const DhikrEntity(
          arabic: 'أَعُوذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
          transliteration: 'A\'oodhu billaahi minash-shaytaanir-rajeem',
          translation: 'I seek refuge in Allah from the accursed Shaytan',
          count: 1,
        ),
        const DhikrEntity(
          arabic: 'آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ',
          transliteration: 'Aamanar-Rasoolu bimaa unzila ilayhi min Rabbihi wal-mu\'minoon',
          translation: 'The Messenger believes in what has been revealed to him from his Lord',
          count: 1,
        ),
        const DhikrEntity(
          arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          transliteration: 'SubhanAllahi wa bihamdihi',
          translation: 'Glory and praise be to Allah',
          count: 100,
        ),
      ],
    ),
    AdhkarCategoryEntity(
      id: 'sleep',
      nameEn: 'Sleep',
      nameAr: 'أذكار النوم',
      dhikrs: [
        const DhikrEntity(
          arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          transliteration: 'Bismika Allahumma amootu wa ahya',
          translation: 'In Your name, O Allah, I die and I live',
          count: 1,
        ),
        const DhikrEntity(
          arabic: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
          transliteration: 'Allahumma qini \'adhabaka yawma tab\'athu \'ibadak',
          translation: 'O Allah, protect me from Your punishment on the day You resurrect Your servants',
          count: 1,
        ),
      ],
    ),
    AdhkarCategoryEntity(
      id: 'after_prayer',
      nameEn: 'After Prayer',
      nameAr: 'أذكار بعد الصلاة',
      dhikrs: [
        const DhikrEntity(
          arabic: 'أَسْتَغْفِرُ اللَّهَ',
          transliteration: 'Astaghfirullah',
          translation: 'I seek forgiveness from Allah',
          count: 3,
        ),
        const DhikrEntity(
          arabic: 'اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ',
          transliteration: 'Allahumma Antas-Salaam wa minkas-salaam',
          translation: 'O Allah, You are As-Salaam and from You is all peace',
          count: 1,
        ),
        const DhikrEntity(
          arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
          transliteration: 'La ilaha illallah wahdahu la sharika lah',
          translation: 'None has the right to be worshipped but Allah alone',
          count: 10,
        ),
      ],
    ),
    AdhkarCategoryEntity(
      id: 'wake_up',
      nameEn: 'Wake Up',
      nameAr: 'أذكار الاستيقاظ',
      dhikrs: [
        const DhikrEntity(
          arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا',
          transliteration: 'Alhamdu lillahil-ladhee ahyana ba\'da ma amatana',
          translation: 'Praise be to Allah who has brought us to life after causing us to die',
          count: 1,
        ),
      ],
    ),
    AdhkarCategoryEntity(
      id: 'completion',
      nameEn: 'Completion Dua',
      nameAr: 'دعاء الختم',
      dhikrs: [
        const DhikrEntity(
          arabic: 'صَدَقَ اللَّهُ الْعَظِيمُ',
          transliteration: 'Sadaqallahul-\'Azeem',
          translation: 'Allah the Most Great has spoken the truth',
          count: 1,
        ),
      ],
    ),
  ];
}
