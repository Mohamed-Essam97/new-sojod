import '../domain/entities/mood.dart';
import '../domain/entities/mood_recommendation.dart';

class MoodAdhkarData {
  static const Map<Mood, MoodRecommendation> recommendations = {
    Mood.anxious: MoodRecommendation(
      mood: Mood.anxious,
      duas: [
        DuaRecommendation(
          arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
          transliteration: 'Hasbunallahu wa ni\'mal wakeel',
          translation: 'Allah is sufficient for us, and He is the best Disposer of affairs.',
        ),
        DuaRecommendation(
          arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْجُبْنِ وَالْبُخْلِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
          transliteration: 'Allahumma inni a\'udhu bika minal-hammi wal-hazan, wal-\'ajzi wal-kasal, wal-jubni wal-bukhl, wa dhala\'id-dayni wa ghalabatir-rijal',
          translation: 'O Allah, I seek refuge in You from worry and grief, weakness and laziness, cowardice and miserliness, the burden of debt and being overpowered by men.',
        ),
        DuaRecommendation(
          arabic: 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
          transliteration: 'La ilaha illa anta subhanaka inni kuntu minaz-zalimin',
          translation: 'There is no deity except You; exalted are You. Indeed, I have been of the wrongdoers. (Dua of Yunus)',
        ),
      ],
      ayahs: [
        AyahRecommendation(
          arabic: 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
          translation: 'Verily, in the remembrance of Allah do hearts find rest.',
          reference: 'Surah Ar-Ra\'d (13:28)',
        ),
        AyahRecommendation(
          arabic: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ﴿٥﴾ إِنَّ مَعَ الْعُسْرِ يُسْرًا',
          translation: 'For indeed, with hardship comes ease. Indeed, with hardship comes ease.',
          reference: 'Surah Ash-Sharh (94:5-6)',
        ),
        AyahRecommendation(
          arabic: 'وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ',
          translation: 'And whoever relies upon Allah - then He is sufficient for him.',
          reference: 'Surah At-Talaq (65:3)',
        ),
      ],
      dhikr: [
        DhikrRecommendation(
          arabic: 'سُبْحَانَ اللهِ وَبِحَمْدِهِ',
          transliteration: 'SubhanAllahi wa bihamdihi',
          translation: 'Glory be to Allah and praise Him',
          count: 100,
        ),
        DhikrRecommendation(
          arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
          transliteration: 'La hawla wa la quwwata illa billah',
          translation: 'There is no power and no strength except with Allah',
          count: 33,
        ),
        DhikrRecommendation(
          arabic: 'اللَّهُ اللَّهُ رَبِّي لَا أُشْرِكُ بِهِ شَيْئًا',
          transliteration: 'Allahu Allahu Rabbi la ushriku bihi shay\'a',
          translation: 'Allah, Allah is my Lord, I do not associate anything with Him',
          count: 7,
        ),
      ],
    ),
    Mood.grateful: MoodRecommendation(
      mood: Mood.grateful,
      duas: [
        DuaRecommendation(
          arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          transliteration: 'Alhamdulillahi rabbil-\'alamin',
          translation: 'All praise is due to Allah, Lord of the worlds.',
        ),
        DuaRecommendation(
          arabic: 'اللَّهُمَّ لَكَ الْحَمْدُ كُلُّهُ، اللَّهُمَّ لَا قَابِضَ لِمَا بَسَطْتَ، وَلَا بَاسِطَ لِمَا قَبَضْتَ، وَلَا هَادِيَ لِمَنْ أَضْلَلْتَ، وَلَا مُضِلَّ لِمَنْ هَدَيْتَ',
          transliteration: 'Allahumma lakal-hamdu kulluhu, Allahumma la qabida lima basatt, wa la basita lima qabadt, wa la hadiya liman adlalt, wa la mudilla liman hadayt',
          translation: 'O Allah, all praise is due to You. O Allah, none can withhold what You give, and none can give what You withhold, and none can guide whom You lead astray, and none can lead astray whom You guide.',
        ),
        DuaRecommendation(
          arabic: 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
          transliteration: 'Allahumma a\'inni ala dhikrika wa shukrika wa husni \'ibadatik',
          translation: 'O Allah, help me to remember You, to thank You, and to worship You in the best manner.',
        ),
      ],
      ayahs: [
        AyahRecommendation(
          arabic: 'لَئِن شَكَرْتُمْ لَأَزِيدَنَّكُمْ',
          translation: 'If you are grateful, I will surely increase you [in favor].',
          reference: 'Surah Ibrahim (14:7)',
        ),
        AyahRecommendation(
          arabic: 'وَاشْكُرُوا لِلَّهِ إِن كُنتُمْ إِيَّاهُ تَعْبُدُونَ',
          translation: 'And be grateful to Allah, if it is [indeed] Him that you worship.',
          reference: 'Surah Al-Baqarah (2:172)',
        ),
        AyahRecommendation(
          arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
          translation: 'So remember Me; I will remember you. And be grateful to Me and do not deny Me.',
          reference: 'Surah Al-Baqarah (2:152)',
        ),
      ],
      dhikr: [
        DhikrRecommendation(
          arabic: 'الْحَمْدُ لِلَّهِ',
          transliteration: 'Alhamdulillah',
          translation: 'All praise is due to Allah',
          count: 100,
        ),
        DhikrRecommendation(
          arabic: 'اللَّهُمَّ لَكَ الْحَمْدُ حَتَّى تَرْضَى، وَلَكَ الْحَمْدُ إِذَا رَضِيتَ، وَلَكَ الْحَمْدُ بَعْدَ الرِّضَا',
          transliteration: 'Allahumma lakal-hamdu hatta tarda, wa lakal-hamdu idha radeet, wa lakal-hamdu ba\'dar-rida',
          translation: 'O Allah, all praise is due to You until You are pleased, and all praise is due to You when You are pleased, and all praise is due to You after being pleased',
          count: 3,
        ),
        DhikrRecommendation(
          arabic: 'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ',
          transliteration: 'SubhanAllah, walhamdulillah, wa la ilaha illallah, wallahu akbar',
          translation: 'Glory be to Allah, all praise is to Allah, there is no god but Allah, and Allah is the Greatest',
          count: 25,
        ),
      ],
    ),
    Mood.motivated: MoodRecommendation(
      mood: Mood.motivated,
      duas: [
        DuaRecommendation(
          arabic: 'رَبِّ اشْرَحْ لِي صَدْرِي ﴿٢٥﴾ وَيَسِّرْ لِي أَمْرِي',
          transliteration: 'Rabbish rahli sadri wa yassir li amri',
          translation: 'My Lord, expand for me my breast and ease for me my task.',
        ),
        DuaRecommendation(
          arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا',
          transliteration: 'Allahumma inni as\'aluka \'ilman nafi\'a, wa rizqan tayyiba, wa \'amalan mutaqabbala',
          translation: 'O Allah, I ask You for beneficial knowledge, goodly provision, and acceptable deeds.',
        ),
        DuaRecommendation(
          arabic: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          transliteration: 'Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan waqina \'adhaban-nar',
          translation: 'Our Lord, give us in this world good and in the Hereafter good and protect us from the punishment of the Fire.',
        ),
      ],
      ayahs: [
        AyahRecommendation(
          arabic: 'وَقُل رَّبِّ زِدْنِي عِلْمًا',
          translation: 'And say: My Lord, increase me in knowledge.',
          reference: 'Surah Ta-Ha (20:114)',
        ),
        AyahRecommendation(
          arabic: 'إِنَّ اللَّهَ لَا يُضِيعُ أَجْرَ الْمُحْسِنِينَ',
          translation: 'Indeed, Allah does not allow to be lost the reward of those who do good.',
          reference: 'Surah At-Tawbah (9:120)',
        ),
        AyahRecommendation(
          arabic: 'وَأَن لَّيْسَ لِلْإِنسَانِ إِلَّا مَا سَعَىٰ ﴿٣٩﴾ وَأَنَّ سَعْيَهُ سَوْفَ يُرَىٰ',
          translation: 'And that there is not for man except that [good] for which he strives. And that his effort is going to be seen.',
          reference: 'Surah An-Najm (53:39-40)',
        ),
      ],
      dhikr: [
        DhikrRecommendation(
          arabic: 'اللَّهُ أَكْبَرُ',
          transliteration: 'Allahu Akbar',
          translation: 'Allah is the Greatest',
          count: 100,
        ),
        DhikrRecommendation(
          arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          transliteration: 'La ilaha illallahu wahdahu la sharika lahu, lahul-mulku wa lahul-hamdu wa huwa \'ala kulli shay\'in qadeer',
          translation: 'There is no deity except Allah, alone, without partner. To Him belongs dominion and to Him belongs praise, and He is over all things competent',
          count: 10,
        ),
        DhikrRecommendation(
          arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ وَرِضَا نَفْسِهِ وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ',
          transliteration: 'SubhanAllahi wa bihamdihi \'adada khalqihi wa rida nafsihi wa zinata \'arshihi wa midada kalimatihi',
          translation: 'Glory and praise be to Allah, as much as the number of His creations, and His pleasure, and the weight of His Throne, and the ink of His words',
          count: 3,
        ),
      ],
    ),
    Mood.sad: MoodRecommendation(
      mood: Mood.sad,
      duas: [
        DuaRecommendation(
          arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ',
          transliteration: 'Allahumma inni a\'udhu bika minal-hammi wal-hazan',
          translation: 'O Allah, I seek refuge in You from worry and grief.',
        ),
        DuaRecommendation(
          arabic: 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
          transliteration: 'La ilaha illa anta subhanaka inni kuntu minaz-zalimin',
          translation: 'There is no deity except You; exalted are You. Indeed, I have been of the wrongdoers.',
        ),
        DuaRecommendation(
          arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ زَوَالِ نِعْمَتِكَ، وَتَحَوُّلِ عَافِيَتِكَ، وَفُجَاءَةِ نِقْمَتِكَ، وَجَمِيعِ سَخَطِكَ',
          transliteration: 'Allahumma inni a\'udhu bika min zawali ni\'matika, wa tahawwuli \'afiyatika, wa fuja\'ati niqmatika, wa jami\'i sakhatik',
          translation: 'O Allah, I seek refuge in You from the disappearance of Your blessing, the decline of the wellness You have given, the suddenness of Your vengeance, and all forms of Your wrath.',
        ),
      ],
      ayahs: [
        AyahRecommendation(
          arabic: 'وَلَا تَحْزَنْ عَلَيْهِمْ وَلَا تَكُن فِي ضَيْقٍ مِّمَّا يَمْكُرُونَ ﴿٧٠﴾ إِنَّ اللَّهَ مَعَ الَّذِينَ اتَّقَوا وَّالَّذِينَ هُم مُّحْسِنُونَ',
          translation: 'And do not grieve over them or be in distress from what they conspire. Indeed, Allah is with those who fear Him and those who are doers of good.',
          reference: 'Surah An-Nahl (16:127-128)',
        ),
        AyahRecommendation(
          arabic: 'قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ ۚ إِنَّ اللَّهَ يَغْفِرُ الذُّنُوبَ جَمِيعًا ۚ إِنَّهُ هُوَ الْغَفُورُ الرَّحِيمُ',
          translation: 'Say: O My servants who have transgressed against themselves, do not despair of the mercy of Allah. Indeed, Allah forgives all sins. Indeed, it is He who is the Forgiving, the Merciful.',
          reference: 'Surah Az-Zumar (39:53)',
        ),
        AyahRecommendation(
          arabic: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا ﴿٢﴾ وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ',
          translation: 'And whoever fears Allah - He will make for him a way out. And will provide for him from where he does not expect.',
          reference: 'Surah At-Talaq (65:2-3)',
        ),
      ],
      dhikr: [
        DhikrRecommendation(
          arabic: 'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ',
          transliteration: 'Ya Hayyu ya Qayyum birahmatika astagheeth',
          translation: 'O Ever-Living, O Sustainer, by Your mercy I seek relief',
          count: 3,
        ),
        DhikrRecommendation(
          arabic: 'لَا إِلَهَ إِلَّا اللَّهُ',
          transliteration: 'La ilaha illallah',
          translation: 'There is no deity except Allah',
          count: 100,
        ),
        DhikrRecommendation(
          arabic: 'أَسْتَغْفِرُ اللهَ وَأَتُوبُ إِلَيْهِ',
          transliteration: 'Astaghfirullah wa atubu ilayh',
          translation: 'I seek forgiveness from Allah and repent to Him',
          count: 100,
        ),
      ],
    ),
  };

  static MoodRecommendation getRecommendation(Mood mood) {
    return recommendations[mood]!;
  }
}
