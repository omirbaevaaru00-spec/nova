import 'package:stiky/data/university/localized_string.dart';

/// Перевод карточек университетов (поля name, city, description, languages)
/// на три языка. Используется для патчинга существующих документов
/// `universities/{id}`, у которых эти поля до сих пор хранятся как
/// обычные строки (старый формат).
///
/// Использование:
/// ```dart
/// for (final entry in kUniversityCardTranslations.entries) {
///   await universityRepo.patchMissingFields(entry.key, entry.value);
/// }
/// ```
final Map<String, Map<String, dynamic>> kUniversityCardTranslations = {

  'alma_u': {
    'name': const LocalizedString(
      ru: 'Alma University',
      en: 'Alma University',
      kk: 'Alma University',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Alma University — частный университет в Алматы с практико-ориентированным образованием. Сильные программы IT, бизнеса и дизайна.',
      en: 'Alma University is a private university in Almaty with practice-oriented education. Strong IT, business and design programs.',
      kk: 'Alma University — Алматыдағы практикаға бағытталған білім беретін жекеменшік университет. IT, бизнес және дизайн бағдарламалары мықты.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian', 'English'],
  },

  'kimep': {
    'name': const LocalizedString(
      ru: 'KIMEP University',
      en: 'KIMEP University',
      kk: 'KIMEP University',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'KIMEP University — один из ведущих частных университетов Казахстана с обучением на английском языке. Специализируется на бизнесе, праве и социальных науках. Аккредитован AACSB.',
      en: 'KIMEP University is one of the leading private universities in Kazakhstan with English-language instruction. Specializes in business, law and social sciences. Accredited by AACSB.',
      kk: 'KIMEP University — ағылшын тілінде оқытатын Қазақстанның жетекші жекеменшік университеттерінің бірі. Бизнес, құқық және әлеуметтік ғылымдарға маманданған. AACSB аккредитациясы бар.',
    ).toMap(),
    'languages': ['English'],
  },

  'kaznu': {
    'name': const LocalizedString(
      ru: 'КазНУ им. аль-Фараби',
      en: 'Al-Farabi Kazakh National University',
      kk: 'Әл-Фараби атындағы ҚазҰУ',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Крупнейший и старейший университет Казахстана. Входит в топ-300 мирового рейтинга QS. Широкий выбор направлений: от точных наук до медицины и гуманитарных дисциплин.',
      en: 'The largest and oldest university in Kazakhstan. Ranked in the top 300 of QS World University Rankings. Wide range of fields from exact sciences to medicine and humanities.',
      kk: 'Қазақстанның ең үлкен және ең көне университеті. QS әлемдік рейтингінің топ-300-іне кіреді. Дәл ғылымдардан медицина мен гуманитарлық пәндерге дейінгі бағыттар бар.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  'kbtu': {
    'name': const LocalizedString(
      ru: 'КБТУ',
      en: 'KBTU',
      kk: 'ҚБТУ',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Казахстанско-Британский технический университет. Совместные программы с британскими вузами по инженерии, IT и нефтегазовому делу.',
      en: 'Kazakh-British Technical University. Joint programs with British universities in engineering, IT and oil and gas.',
      kk: 'Қазақ-Британ техникалық университеті. Инженерия, IT және мұнай-газ бойынша британдық университеттермен бірлескен бағдарламалар.',
    ).toMap(),
    'languages': ['English', 'Russian'],
  },

  'iitu': {
    'name': const LocalizedString(
      ru: 'МУИТ',
      en: 'IITU',
      kk: 'ХАТУ',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Международный университет информационных технологий. Ведущий IT-вуз Казахстана с программами по программированию, кибербезопасности и ИИ.',
      en: 'International Information Technology University. Kazakhstan\'s leading IT university with programs in programming, cybersecurity and AI.',
      kk: 'Халықаралық ақпараттық технологиялар университеті. Бағдарламалау, киберқауіпсіздік және ЖИ бойынша бағдарламалары бар Қазақстанның жетекші IT университеті.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian', 'English'],
  },

  'narxoz': {
    'name': const LocalizedString(
      ru: 'Нархоз',
      en: 'Narxoz University',
      kk: 'Нархоз',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Университет Нархоз — один из старейших экономических вузов Казахстана с международной аккредитацией EPAS. Финансы, цифровой бизнес, менеджмент.',
      en: 'Narxoz University is one of the oldest economics universities in Kazakhstan with international EPAS accreditation. Finance, digital business, management.',
      kk: 'Нархоз университеті — EPAS халықаралық аккредитациясы бар Қазақстанның ең көне экономикалық университеттерінің бірі. Қаржы, цифрлық бизнес, менеджмент.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian', 'English'],
  },

  'kazmed': {
    'name': const LocalizedString(
      ru: 'КазНМУ им. Асфендиярова',
      en: 'Asfendiyarov Kazakh National Medical University',
      kk: 'Асфендияров атындағы ҚазҰМУ',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Ведущий медицинский университет Казахстана. Подготовка врачей, фармацевтов и стоматологов с клинической практикой в больницах Алматы.',
      en: 'Kazakhstan\'s leading medical university. Trains doctors, pharmacists and dentists with clinical practice at hospitals in Almaty.',
      kk: 'Қазақстанның жетекші медициналық университеті. Алматы ауруханаларында клиникалық тәжірибемен дәрігерлер, фармацевттер және стоматологтар дайындайды.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian', 'English'],
  },

  'satpaev': {
    'name': const LocalizedString(
      ru: 'Satbayev University',
      en: 'Satbayev University',
      kk: 'Satbayev University',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Ведущий технический университет Казахстана. Горное дело, нефтегазовое дело, металлургия и IT с партнёрством крупнейших компаний отрасли.',
      en: 'Kazakhstan\'s leading technical university. Mining, oil and gas, metallurgy and IT with partnerships from major industry companies.',
      kk: 'Қазақстанның жетекші техникалық университеті. Тау-кен ісі, мұнай-газ ісі, металлургия және IT саланың ірі компанияларымен серіктестікте.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  'kazguu': {
    'name': const LocalizedString(
      ru: 'КАЗГЮУ им. Нарикбаева',
      en: 'Narikbayev KAZGUU University',
      kk: 'Нарикбаев атындағы ҚАЗГЮУ',
    ).toMap(),
    'city': const LocalizedString(ru: 'Астана', en: 'Astana', kk: 'Астана').toMap(),
    'description': const LocalizedString(
      ru: 'Один из ведущих юридических и бизнес-вузов Казахстана. Программы по праву, бизнесу, IT и педагогике с упором на практику.',
      en: 'One of Kazakhstan\'s leading law and business universities. Programs in law, business, IT and pedagogy with a focus on practice.',
      kk: 'Қазақстанның жетекші заң және бизнес университеттерінің бірі. Тәжірибеге бағытталған құқық, бизнес, IT және педагогика бағдарламалары.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  'kaznpu': {
    'name': const LocalizedString(
      ru: 'КазНПУ им. Абая',
      en: 'Abai Kazakh National Pedagogical University',
      kk: 'Абай атындағы ҚазҰПУ',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Главный педагогический университет Казахстана. Подготовка учителей, психологов и специалистов по образовательным технологиям.',
      en: 'Kazakhstan\'s main pedagogical university. Trains teachers, psychologists and educational technology specialists.',
      kk: 'Қазақстанның негізгі педагогикалық университеті. Мұғалімдер, психологтар және білім беру технологиялары мамандарын дайындайды.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  'kazeconomics': {
    'name': const LocalizedString(
      ru: 'КазЭУ им. Рыскулова',
      en: 'Rysqulov University of Economics',
      kk: 'Рысқұлов атындағы ҚазЭУ',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Один из ведущих экономических университетов Казахстана. Финансы, экономика, логистика, бухучёт и менеджмент.',
      en: 'One of Kazakhstan\'s leading economics universities. Finance, economics, logistics, accounting and management.',
      kk: 'Қазақстанның жетекші экономикалық университеттерінің бірі. Қаржы, экономика, логистика, бухгалтерлік есеп және менеджмент.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  'kazinfra': {
    'name': const LocalizedString(
      ru: 'КазГАСА',
      en: 'KazGASA',
      kk: 'ҚазБСҒА',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Казахская головная архитектурно-строительная академия. Ведущий вуз страны по архитектуре, строительству и градостроительству.',
      en: 'Kazakh Leading Academy of Architecture and Civil Engineering. The country\'s leading university for architecture, construction and urban planning.',
      kk: 'Қазақ бас сәулет-құрылыс академиясы. Елдің сәулет, құрылыс және қала құрылысы саласындағы жетекші университеті.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  'kazart': {
    'name': const LocalizedString(
      ru: 'КазНАИ им. Жургенова',
      en: 'Zhurgenov Kazakh National Academy of Arts',
      kk: 'Жургенов атындағы ҚазҰӨА',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Казахская национальная академия искусств им. Жургенова. Дизайн, кино, театр, живопись, музыка и хореография.',
      en: 'Zhurgenov Kazakh National Academy of Arts. Design, film, theatre, painting, music and choreography.',
      kk: 'Жургенов атындағы Қазақ ұлттық өнер академиясы. Дизайн, кино, театр, кескіндеме, музыка және хореография.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  'kafu': {
    'name': const LocalizedString(
      ru: 'КАФУ',
      en: 'KAFU',
      kk: 'ҚАЕУ',
    ).toMap(),
    'city': const LocalizedString(ru: 'Костанай', en: 'Kostanay', kk: 'Қостанай').toMap(),
    'description': const LocalizedString(
      ru: 'Казахстанско-Американский свободный университет. Образование по американской модели с обучением на английском и русском языках.',
      en: 'Kazakh-American Free University. American-model education taught in English and Russian.',
      kk: 'Қазақ-Америка еркін университеті. Ағылшын және орыс тілдерінде американдық модель бойынша білім.',
    ).toMap(),
    'languages': ['English', 'Russian'],
  },

  'kau': {
    'name': const LocalizedString(
      ru: 'КазАТК',
      en: 'KazATC',
      kk: 'ҚазКТА',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Казахская академия транспорта и коммуникаций. Подготовка специалистов для железнодорожной, авиационной и логистической отраслей.',
      en: 'Kazakh Academy of Transport and Communications. Trains specialists for railway, aviation and logistics industries.',
      kk: 'Қазақ көлік және коммуникациялар академиясы. Теміржол, авиация және логистика салаларына мамандар дайындайды.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  'turan': {
    'name': const LocalizedString(
      ru: 'Университет Туран',
      en: 'Turan University',
      kk: 'Тұран университеті',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Один из первых частных университетов Казахстана. Бизнес, IT, право, журналистика и туризм по доступным ценам.',
      en: 'One of the first private universities in Kazakhstan. Business, IT, law, journalism and tourism at affordable prices.',
      kk: 'Қазақстанның алғашқы жекеменшік университеттерінің бірі. Қолжетімді бағамен бизнес, IT, құқық, журналистика және туризм.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian', 'English'],
  },

  'kazmira': {
    'name': const LocalizedString(
      ru: 'Университет Мирас',
      en: 'Miras University',
      kk: 'Мирас университеті',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Университет «Мирас» — доступное медицинское и инженерное образование в Алматы с собственным симуляционным центром.',
      en: 'Miras University offers affordable medical and engineering education in Almaty with its own simulation center.',
      kk: '«Мирас» университеті — Алматыда өзінің симуляциялық орталығы бар қолжетімді медициналық және инженерлік білім.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  'kazpharm': {
    'name': const LocalizedString(
      ru: 'ВШОЗ',
      en: 'KSPH',
      kk: 'ҚДСЖМ',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Казахстанская школа общественного здравоохранения. Магистратура и PhD по общественному здоровью, эпидемиологии и менеджменту здравоохранения.',
      en: 'Kazakhstan School of Public Health. Master\'s and PhD programs in public health, epidemiology and healthcare management.',
      kk: 'Қазақстан қоғамдық денсаулық сақтау мектебі. Қоғамдық денсаулық, эпидемиология және денсаулық сақтау менеджменті бойынша магистратура мен PhD.',
    ).toMap(),
    'languages': ['English', 'Russian'],
  },

  'col_binom': {
    'name': const LocalizedString(
      ru: 'Колледж «Бином»',
      en: 'Binom College',
      kk: '«Бином» колледжі',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'IT-колледж «Бином» — программирование, кибербезопасность, мобильная разработка и Data Science с гарантией стажировок в IT-компаниях.',
      en: 'Binom IT College — programming, cybersecurity, mobile development and Data Science with guaranteed internships at IT companies.',
      kk: '«Бином» IT колледжі — бағдарламалау, киберқауіпсіздік, мобильді әзірлеу және Data Science, IT компанияларында тағылымдама кепілдігімен.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  'col_kazgorizont': {
    'name': const LocalizedString(
      ru: 'Колледж «Горизонт»',
      en: 'Gorizont College',
      kk: '«Горизонт» колледжі',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Колледж «Горизонт» с международной аккредитацией ISO. IT, дизайн, бизнес, педагогика, туризм и медицинские специальности.',
      en: 'Gorizont College with ISO international accreditation. IT, design, business, pedagogy, tourism and medical specialties.',
      kk: 'ISO халықаралық аккредитациясы бар «Горизонт» колледжі. IT, дизайн, бизнес, педагогика, туризм және медициналық мамандықтар.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  // ── kazakh_american (возможно дубликат kafu) ────────────────────────────
  'kazakh_american': {
    'name': const LocalizedString(
      ru: 'КАФУ',
      en: 'KAFU',
      kk: 'ҚАЕУ',
    ).toMap(),
    'city': const LocalizedString(ru: 'Костанай', en: 'Kostanay', kk: 'Қостанай').toMap(),
    'description': const LocalizedString(
      ru: 'Казахстанско-Американский свободный университет. Образование по американской модели с обучением на английском и русском языках.',
      en: 'Kazakh-American Free University. American-model education taught in English and Russian.',
      kk: 'Қазақ-Америка еркін университеті. Ағылшын және орыс тілдерінде американдық модель бойынша білім.',
    ).toMap(),
    'languages': ['English', 'Russian'],
  },

  // ── col_design (Алматинский колледж дизайна и технологий) ────────────────
  'col_design': {
    'name': const LocalizedString(
      ru: 'Алматинский колледж дизайна и технологий',
      en: 'Almaty College of Design and Technology',
      kk: 'Алматы дизайн және технология колледжі',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Творческий колледж с углублённым изучением графического дизайна, fashion-дизайна, интерьера и мультимедиа. Современные мастерские и активное сотрудничество с дизайн-студиями.',
      en: 'A creative college with in-depth study of graphic design, fashion design, interior design and multimedia. Modern workshops and active collaboration with design studios.',
      kk: 'Графикалық дизайн, fashion-дизайн, интерьер және мультимедианы тереңдетіп оқытатын шығармашылық колледж. Заманауи шеберханалар және дизайн-студиялармен белсенді ынтымақтастық.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  // ── col_finance (Алматинский колледж экономики и статистики) ─────────────
  'col_finance': {
    'name': const LocalizedString(
      ru: 'Алматинский колледж экономики и статистики',
      en: 'Almaty College of Economics and Statistics',
      kk: 'Алматы экономика және статистика колледжі',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Колледж готовит специалистов по экономике, бухгалтерскому учёту и финансам. Практика на базе банков и финансовых компаний Алматы.',
      en: 'The college trains specialists in economics, accounting and finance. Internships at banks and financial companies in Almaty.',
      kk: 'Колледж экономика, бухгалтерлік есеп және қаржы мамандарын дайындайды. Алматы банктері мен қаржы компанияларында тәжірибе.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  // ── col_law (Алматинский колледж — Право/соцобеспечение) ──────────────────
  'col_law': {
    'name': const LocalizedString(
      ru: 'Алматинский юридический колледж',
      en: 'Almaty College of Law',
      kk: 'Алматы заң колледжі',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Колледж готовит специалистов по правоведению и социальному обеспечению. Практика в судах, нотариальных конторах и органах соцзащиты.',
      en: 'The college trains specialists in law and social security. Internships at courts, notary offices and social welfare bodies.',
      kk: 'Колледж құқықтану және әлеуметтік қамсыздандыру мамандарын дайындайды. Соттарда, нотариаттарда және әлеуметтік қорғау органдарында тәжірибе.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  // ── col_medbusiness (Алматинский медицинский колледж) ─────────────────────
  'col_medbusiness': {
    'name': const LocalizedString(
      ru: 'Алматинский медицинский колледж',
      en: 'Almaty Medical College',
      kk: 'Алматы медицина колледжі',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Подготовка медицинских сестёр, фельдшеров и фармацевтов. Практика в больницах и аптеках Алматы.',
      en: 'Training nurses, paramedics and pharmacists. Internships at hospitals and pharmacies in Almaty.',
      kk: 'Мейіргерлер, фельдшерлер және фармацевттер дайындау. Алматы аурухана мен дәріханаларында тәжірибе.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  // ── col_music (Алматинский колледж искусств им. А. Жубанова) ──────────────
  'col_music': {
    'name': const LocalizedString(
      ru: 'Алматинский колледж искусств им. А. Жубанова',
      en: 'Zhubanov Almaty College of Arts',
      kk: 'А. Жұбанов атындағы Алматы өнер колледжі',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Колледж искусств с программами по музыке, дизайну и хореографии. Подготовка музыкантов, дизайнеров и танцоров.',
      en: 'A college of arts with programs in music, design and choreography. Trains musicians, designers and dancers.',
      kk: 'Музыка, дизайн және хореография бағдарламалары бар өнер колледжі. Музыкант, дизайнер және биші дайындайды.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  // ── col_ped (Алматинский педагогический колледж) ──────────────────────────
  'col_ped': {
    'name': const LocalizedString(
      ru: 'Алматинский педагогический колледж',
      en: 'Almaty Pedagogical College',
      kk: 'Алматы педагогикалық колледжі',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Подготовка воспитателей детских садов и учителей начальных классов. Практика в школах и детских садах Алматы.',
      en: 'Training kindergarten educators and primary school teachers. Internships at schools and kindergartens in Almaty.',
      kk: 'Балабақша тәрбиешілері мен бастауыш сынып мұғалімдерін дайындау. Алматы мектептері мен балабақшаларында тәжірибе.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  // ── col_poly (Алматинский политехнический колледж) ────────────────────────
  'col_poly': {
    'name': const LocalizedString(
      ru: 'Алматинский политехнический колледж',
      en: 'Almaty Polytechnic College',
      kk: 'Алматы политехникалық колледжі',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Подготовка специалистов по инженерии и строительству. Практика на строительных и промышленных предприятиях Алматы.',
      en: 'Training specialists in engineering and construction. Internships at construction and industrial enterprises in Almaty.',
      kk: 'Инженерия және құрылыс мамандарын дайындау. Алматы құрылыс және өнеркәсіп кәсіпорындарында тәжірибе.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian'],
  },

  // ── col_tourism (Алматинский колледж туризма и сервиса) ───────────────────
  'col_tourism': {
    'name': const LocalizedString(
      ru: 'Алматинский колледж туризма и сервиса',
      en: 'Almaty College of Tourism and Service',
      kk: 'Алматы туризм және қызмет көрсету колледжі',
    ).toMap(),
    'city': const LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы').toMap(),
    'description': const LocalizedString(
      ru: 'Подготовка специалистов в туризме, гостиничном бизнесе и сервисе. Практика в отелях и туристических компаниях Алматы.',
      en: 'Training specialists in tourism, hospitality and service. Internships at hotels and travel companies in Almaty.',
      kk: 'Туризм, қонақ үй бизнесі және қызмет көрсету мамандарын дайындау. Алматы қонақ үйлері мен турфирмаларында тәжірибе.',
    ).toMap(),
    'languages': ['Kazakh', 'Russian', 'English'],
  },

};