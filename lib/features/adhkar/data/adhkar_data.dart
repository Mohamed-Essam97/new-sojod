import '../domain/entities/adhkar_category_entity.dart';

List<AdhkarCategoryEntity> getAdhkarData() {
  return [
    // ── Morning ──────────────────────────────────────────────────────────────
    AdhkarCategoryEntity(
      id: 'morning',
      nameEn: 'Morning',
      nameAr: 'أذكار الصباح',
      dhikrs: [
        const DhikrEntity(
          arabic: 'أَعُوذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
          transliteration: "A'oodhu billaahi minash-shaytaanir-rajeem",
          translation: 'I seek refuge in Allah from the accursed Shaytan',
          count: 1,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
          transliteration:
              "Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namootu, wa ilaykan-nushoor",
          translation:
              'O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection.',
          count: 1,
        ),
        const DhikrEntity(
          arabic:
              'أَصْبَحْنَا عَلَى فِطْرَةِ الْإِسْلَامِ، وَعَلَى كَلِمَةِ الْإِخْلَاصِ، وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ ﷺ، وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ، حَنِيفًا مُسْلِمًا وَمَا كَانَ مِنَ الْمُشْرِكِينَ',
          transliteration:
              "Asbahna 'ala fitratil-Islam, wa 'ala kalimati-l-ikhlas, wa 'ala deeni nabiyyina Muhammad ﷺ",
          translation:
              'We rise upon the fitrah of Islam, and the word of sincere devotion, and upon the religion of our Prophet Muhammad ﷺ, and the creed of our father Ibrahim — a Muslim, and he was not of the polytheists.',
          count: 1,
        ),
        const DhikrEntity(
          arabic:
              'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ',
          transliteration:
              "Subhaanallaahi wa bihamdihi 'adada khalqihi, wa ridaa nafsihi, wa zinata 'arshihi, wa midaada kalimaatih",
          translation:
              'Glory and praise be to Allah, as many times as the number of His creation, in accordance with His Good Pleasure, equal to the weight of His Throne and equal to the ink that may be used in recording the words (for His Praise).',
          count: 3,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ',
          transliteration:
              "Allahumma inni as-alukal-'afwa wal-'afiyata fid-dunya wal-akhira",
          translation:
              'O Allah, I ask You for pardon and well-being in this life and the next.',
          count: 1,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ',
          transliteration:
              "Allahumma 'afini fi badani, Allahumma 'afini fi sam'i, Allahumma 'afini fi basari, la ilaha illa Ant",
          translation:
              'O Allah, grant me health in my body. O Allah, grant me health in my hearing. O Allah, grant me health in my sight. None has the right to be worshipped except You.',
          count: 3,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُفْرِ، وَالْفَقْرِ، وَأَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، لَا إِلَهَ إِلَّا أَنْتَ',
          transliteration:
              "Allahumma inni a'udhu bika minal-kufri wal-faqr, wa a'udhu bika min 'adhabil-qabr, la ilaha illa Ant",
          translation:
              'O Allah, I take refuge with You from disbelief and poverty, and I take refuge with You from the punishment of the grave. None has the right to be worshipped except You.',
          count: 3,
        ),
        const DhikrEntity(
          arabic:
              'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
          transliteration:
              "Hasbiyallaahu laa ilaaha illa huwa 'alayhi tawakkaltu wa huwa Rabbul-'arshil-'adheem",
          translation:
              'Allah is sufficient for me; none has the right to be worshipped except Him. Upon Him I rely, and He is the Lord of the Exalted Throne.',
          count: 7,
        ),
        const DhikrEntity(
          arabic: 'بِسْمِ اللهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
          transliteration:
              "Bismillaahil-lathee laa yadhurru ma'asmihi shay'un fil-ardhi wa laa fis-samaa'i wa huwas-Samee'ul-'Aleem",
          translation:
              'In the name of Allah with whose name nothing can cause harm on earth or in the heavens, and He is the All-Hearing, All-Knowing.',
          count: 3,
        ),
        const DhikrEntity(
          arabic: 'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ ﷺ نَبِيًّا وَرَسُولًا',
          transliteration:
              "Radhitu billaahi Rabban, wa bil-Islaami deenan, wa bi-Muhammadin ﷺ Nabiyyan wa Rasoola",
          translation:
              'I am pleased with Allah as my Lord, with Islam as my religion and with Muhammad ﷺ as my Prophet and Messenger.',
          count: 3,
        ),
        const DhikrEntity(
          arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          transliteration: 'SubhaanAllaahi wa bihamdihi',
          translation: 'Glory and praise be to Allah',
          count: 100,
        ),
      ],
    ),

    // ── Evening ───────────────────────────────────────────────────────────────
    AdhkarCategoryEntity(
      id: 'evening',
      nameEn: 'Evening',
      nameAr: 'أذكار المساء',
      dhikrs: [
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ',
          transliteration:
              "Allahumma bika amsayna, wa bika asbahna, wa bika nahya, wa bika namootu, wa ilaykal-maseer",
          translation:
              'O Allah, by You we enter the evening and by You we enter the morning, by You we live and by You we die, and to You is our return.',
          count: 1,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ إِنِّي أَمْسَيْتُ أُشْهِدُكَ وَأُشْهِدُ حَمَلَةَ عَرْشِكَ وَمَلَائِكَتَكَ وَجَمِيعَ خَلْقِكَ أَنَّكَ أَنْتَ اللَّهُ لَا إِلَهَ إِلَّا أَنْتَ وَحْدَكَ لَا شَرِيكَ لَكَ وَأَنَّ مُحَمَّدًا عَبْدُكَ وَرَسُولُكَ',
          transliteration:
              "Allahumma inni amsaytu ushhiduka wa ushhidu hamalata 'arshika wa mala'ikataka wa jamee'a khalqika...",
          translation:
              'O Allah, I have entered the evening and call on You, the bearers of Your Throne, Your angels, and all of Your creation to witness that You are Allah, none has the right to be worshipped except You, alone, without partner, and that Muhammad is Your servant and Messenger.',
          count: 4,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ مَا أَمْسَى بِي مِنْ نِعْمَةٍ، أَوْ بِأَحَدٍ مِنْ خَلْقِكَ، فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ',
          transliteration:
              "Allahumma maa amsa bee min ni'matin aw bi-ahadin min khalqika faminka wahdaka laa shareeka lak, falakal-hamdu wa lakash-shukr",
          translation:
              'O Allah, what blessing I or any of Your creation have risen upon is from You alone. You have no partner. To You belongs all praise and thanks.',
          count: 1,
        ),
        const DhikrEntity(
          arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
          transliteration:
              "A'udhu bikalimaatillaahit-taammaati min sharri maa khalaq",
          translation:
              'I seek refuge in the perfect words of Allah from the evil of what He has created.',
          count: 3,
        ),
        const DhikrEntity(
          arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ',
          transliteration:
              "Allahumma inni as-alukal-'afwa wal-'afiyah fid-dunya wal-akhirah",
          translation:
              'O Allah, I ask You for pardon and well-being in this life and the next.',
          count: 1,
        ),
        const DhikrEntity(
          arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          transliteration: 'SubhaanAllaahi wa bihamdihi',
          translation: 'Glory and praise be to Allah',
          count: 100,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
          transliteration:
              "Allahumma inni a'udhu bika minal-hammi wal-hazan, wal-'ajzi wal-kasal, wal-bukhli wal-jubn, wa dhala'id-dayni wa ghalabaatir-rijaal",
          translation:
              'O Allah, I seek refuge in You from anxiety and sorrow, weakness and laziness, miserliness and cowardice, the burden of debts and from being overpowered by men.',
          count: 1,
        ),
      ],
    ),

    // ── Wake Up ───────────────────────────────────────────────────────────────
    AdhkarCategoryEntity(
      id: 'wake_up',
      nameEn: 'Wake Up',
      nameAr: 'أذكار الاستيقاظ',
      dhikrs: [
        const DhikrEntity(
          arabic:
              'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
          transliteration:
              "Alhamdu lillahil-lathee ahyana ba'da ma amatana wa ilayhin-nushoor",
          translation:
              'Praise be to Allah who gave us life after causing us to die, and to Him we will be resurrected.',
          count: 1,
        ),
        const DhikrEntity(
          arabic:
              'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          transliteration:
              "Laa ilaaha illallaahu wahdahu laa shareeka lahu, lahul-mulku wa lahul-hamdu wa huwa 'alaa kulli shay'in qadeer",
          translation:
              'None has the right to be worshipped but Allah alone, Who has no partner. His is the dominion and His is the praise, and He is Able to do all things.',
          count: 1,
        ),
        const DhikrEntity(
          arabic: 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، لَا إِلَهَ إِلَّا أَنْتَ أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ',
          transliteration:
              "SubhaanakAllahumma wa bihamdika, laa ilaaha illaa Anta astaghfiruka wa atoobu ilayk",
          translation:
              'Glory is to You, O Allah, and praise. None has the right to be worshipped except You. I seek Your forgiveness and repent to You.',
          count: 1,
        ),
      ],
    ),

    // ── Sleep ─────────────────────────────────────────────────────────────────
    AdhkarCategoryEntity(
      id: 'sleep',
      nameEn: 'Before Sleep',
      nameAr: 'أذكار النوم',
      dhikrs: [
        const DhikrEntity(
          arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          transliteration: 'Bismika Allahumma amootu wa ahya',
          translation: 'In Your name, O Allah, I die and I live.',
          count: 1,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
          transliteration:
              "Allahumma qini 'adhabaka yawma tab'athu 'ibadak",
          translation:
              'O Allah, protect me from Your punishment on the Day You resurrect Your servants.',
          count: 3,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ بِاسْمِكَ أَحْيَا وَأَمُوتُ',
          transliteration: 'Allahumma bismika ahya wa amoot',
          translation:
              'O Allah, with Your name I live and I die.',
          count: 1,
        ),
        const DhikrEntity(
          arabic:
              'سُبْحَانَ اللَّهِ',
          transliteration: 'SubhaanAllah',
          translation: 'Glory be to Allah',
          count: 33,
        ),
        const DhikrEntity(
          arabic: 'الْحَمْدُ لِلَّهِ',
          transliteration: 'Alhamdulillah',
          translation: 'All praise is due to Allah',
          count: 33,
        ),
        const DhikrEntity(
          arabic: 'اللَّهُ أَكْبَرُ',
          transliteration: 'Allahu Akbar',
          translation: 'Allah is the Greatest',
          count: 34,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ رَبَّ السَّمَاوَاتِ السَّبْعِ وَرَبَّ الْأَرْضِ وَرَبَّ الْعَرْشِ الْعَظِيمِ، رَبَّنَا وَرَبَّ كُلِّ شَيْءٍ',
          transliteration:
              "Allahumma Rabbas-samawaatis-sab'i wa Rabbal-ardhi wa Rabbal-'arshil-'adheem, Rabbana wa Rabba kulli shay'",
          translation:
              'O Allah, Lord of the seven heavens and Lord of the earth and Lord of the Great Throne, our Lord and Lord of everything.',
          count: 1,
        ),
      ],
    ),

    // ── After Prayer ─────────────────────────────────────────────────────────
    AdhkarCategoryEntity(
      id: 'after_prayer',
      nameEn: 'After Prayer',
      nameAr: 'أذكار بعد الصلاة',
      dhikrs: [
        const DhikrEntity(
          arabic: 'أَسْتَغْفِرُ اللَّهَ',
          transliteration: 'Astaghfirullah',
          translation: 'I seek forgiveness from Allah.',
          count: 3,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
          transliteration:
              "Allahumma Antas-Salaam wa minkas-salaam, tabaarakta yaa Dhal-Jalaali wal-Ikraam",
          translation:
              'O Allah, You are As-Salaam and from You is all peace, blessed are You, O Possessor of majesty and honour.',
          count: 1,
        ),
        const DhikrEntity(
          arabic:
              'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          transliteration:
              "Laa ilaaha illallaahu wahdahu laa shareeka lahu, lahul-mulku wa lahul-hamdu wa huwa 'alaa kulli shay'in qadeer",
          translation:
              'None has the right to be worshipped but Allah alone, Who has no partner. His is the dominion and His is the praise, and He is Able to do all things.',
          count: 10,
        ),
        const DhikrEntity(
          arabic: 'سُبْحَانَ اللَّهِ',
          transliteration: 'SubhaanAllah',
          translation: 'Glory be to Allah',
          count: 33,
        ),
        const DhikrEntity(
          arabic: 'الْحَمْدُ لِلَّهِ',
          transliteration: 'Alhamdulillah',
          translation: 'All praise is due to Allah',
          count: 33,
        ),
        const DhikrEntity(
          arabic: 'اللَّهُ أَكْبَرُ',
          transliteration: 'Allahu Akbar',
          translation: 'Allah is the Greatest',
          count: 33,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ لَا مَانِعَ لِمَا أَعْطَيْتَ، وَلَا مُعْطِيَ لِمَا مَنَعْتَ، وَلَا يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدُّ',
          transliteration:
              "Allahumma laa maani'a limaa a'tayta, wa laa mu'tiya limaa mana'ta, wa laa yanfa'u dhal-jaddi minkal-jadd",
          translation:
              'O Allah, no one can withhold what You give, and no one can give what You withhold, and no amount of wealth or majesty can benefit its owner against You.',
          count: 1,
        ),
        const DhikrEntity(
          arabic: 'آيَةُ الْكُرْسِيِّ',
          transliteration: 'Ayatul-Kursi',
          translation:
              'Allah — there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth...',
          count: 1,
        ),
      ],
    ),

    // ── Going Out ─────────────────────────────────────────────────────────────
    AdhkarCategoryEntity(
      id: 'going_out',
      nameEn: 'Leaving Home',
      nameAr: 'الخروج من البيت',
      dhikrs: [
        const DhikrEntity(
          arabic:
              'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
          transliteration:
              "Bismillaah, tawakkaltu 'alAllaah, wa laa hawla wa laa quwwata illaa billaah",
          translation:
              'In the name of Allah, I place my trust in Allah, and there is no might nor power except with Allah.',
          count: 1,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أَضِلَّ أَوْ أُضَلَّ، أَوْ أَزِلَّ أَوْ أُزَلَّ، أَوْ أَظْلِمَ أَوْ أُظْلَمَ، أَوْ أَجْهَلَ أَوْ يُجْهَلَ عَلَيَّ',
          transliteration:
              "Allahumma inni a'udhu bika an adhilla aw udhall...",
          translation:
              'O Allah, I seek refuge in You lest I stray or be led astray, or I slip or be tripped, or I oppress or be oppressed, or I behave foolishly or am treated foolishly.',
          count: 1,
        ),
      ],
    ),

    // ── Entering Home ─────────────────────────────────────────────────────────
    AdhkarCategoryEntity(
      id: 'entering_home',
      nameEn: 'Entering Home',
      nameAr: 'الدخول إلى البيت',
      dhikrs: [
        const DhikrEntity(
          arabic:
              'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
          transliteration:
              "Bismillaahi walajna, wa bismillaahi kharajna, wa 'alAllaahi Rabbina tawakkalna",
          translation:
              'In the name of Allah we enter, in the name of Allah we leave, and upon our Lord we place our trust.',
          count: 1,
        ),
      ],
    ),

    // ── Forgiveness ───────────────────────────────────────────────────────────
    AdhkarCategoryEntity(
      id: 'forgiveness',
      nameEn: 'Forgiveness',
      nameAr: 'الاستغفار',
      dhikrs: [
        const DhikrEntity(
          arabic: 'أَسْتَغْفِرُ اللَّهَ',
          transliteration: 'Astaghfirullah',
          translation: 'I seek forgiveness from Allah.',
          count: 100,
        ),
        const DhikrEntity(
          arabic:
              'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
          transliteration:
              "Astaghfirullaah-al-'Adheema al-lathi laa ilaaha illaa Huwal-Hayyul-Qayyoomu wa atoobu ilayh",
          translation:
              'I seek forgiveness from Allah the Almighty, whom there is none worthy of worship except Him, the Ever-Living, the Sustainer, and I repent to Him.',
          count: 3,
        ),
        const DhikrEntity(
          arabic:
              'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
          transliteration: 'Sayyidul-Istighfar (Master Supplication for Forgiveness)',
          translation:
              'O Allah, You are my Lord, none has the right to be worshipped except You. You created me and I am Your servant, and I abide to Your covenant and promise as best I can. I seek refuge in You from the evil of what I have done. I acknowledge Your favour upon me and I confess my sin, so forgive me for truly none forgives sins except You.',
          count: 1,
        ),
      ],
    ),

    // ── Tasbih ────────────────────────────────────────────────────────────────
    AdhkarCategoryEntity(
      id: 'tasbih',
      nameEn: 'Tasbih',
      nameAr: 'التسبيح',
      dhikrs: [
        const DhikrEntity(
          arabic: 'سُبْحَانَ اللَّهِ',
          transliteration: 'SubhaanAllah',
          translation: 'Glory be to Allah',
          count: 33,
        ),
        const DhikrEntity(
          arabic: 'الْحَمْدُ لِلَّهِ',
          transliteration: 'Alhamdulillah',
          translation: 'All praise is due to Allah',
          count: 33,
        ),
        const DhikrEntity(
          arabic: 'اللَّهُ أَكْبَرُ',
          transliteration: 'Allahu Akbar',
          translation: 'Allah is the Greatest',
          count: 34,
        ),
        const DhikrEntity(
          arabic:
              'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          transliteration:
              "Laa ilaaha illallaahu wahdahu laa shareeka lahu...",
          translation:
              'None has the right to be worshipped but Allah alone, with no partner or associate. His is the dominion, to Him belongs all praise, and He is over all things competent.',
          count: 10,
        ),
        const DhikrEntity(
          arabic:
              'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
          transliteration:
              "SubhaanAllaahi wa bihamdihi, SubhaanAllaahil-'Adheem",
          translation:
              'Glory and praise be to Allah; Glory be to Allah, the Almighty.',
          count: 100,
        ),
      ],
    ),
  ];
}
