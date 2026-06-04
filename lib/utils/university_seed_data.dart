// import 'package:stiky/data/university/localized_string.dart';
// import 'package:stiky/data/university/university_model.dart';

// /// Учебные заведения Алматы для заливки в Firestore.
// ///
// /// Залить один раз:
// /// ```dart
// /// await context.read<UniversityRepository>().seedAll(kSeedUniversities);
// /// ```
// const List<University> kSeedUniversities = [
//   University(
//     id: 'kimep',
//     name: LocalizedString(
//       ru: 'KIMEP University',
//       en: 'KIMEP University',
//       kk: 'KIMEP Университеті',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'KIMEP University — один из ведущих частных университетов Казахстана с обучением на английском языке. Специализируется на бизнесе, праве и социальных науках. Аккредитован AACSB.',
//       en: 'KIMEP University is one of Kazakhstan\'s leading private universities with English-medium instruction. Specializes in business, law and social sciences. AACSB accredited.',
//       kk: 'KIMEP University — Қазақстанның жетекші жеке университеттерінің бірі, ағылшын тілінде оқытады. Бизнес, құқық және әлеуметтік ғылымдарға маманданған. AACSB аккредитациясы бар.',
//     ),
//     type: 'Частный',
//     level: 'Бакалавриат, Магистратура',
//     directions: ['Бизнес', 'Право', 'Социальные науки', 'Медиа'],
//     costRange: '2 800 000 – 3 800 000 ₸/год',
//     duration: '4 года',
//     languages: ['Английский'],
//     format: 'Очная',
//     website: 'https://www.kimep.kz',
//     instagram: 'https://instagram.com/kimepuniversity',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@kimep.kz',
//     phone: '+7 727 270 42 13',
//     tags: ['business', 'law', 'bachelor', 'master'],
//     minEnt: 80,
//     minIelts: 6.0,
//   ),
//   University(
//     id: 'kbtu',
//     name: LocalizedString(
//       ru: 'Казахстанско-Британский технический университет',
//       en: 'Kazakhstan-British Technical University',
//       kk: 'Қазақстан-Британ техникалық университеті',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'КБТУ — ведущий технический университет с совместными программами британских вузов. Сильные направления: нефтегазовая инженерия, IT, бизнес.',
//       en: 'KBTU is a leading technical university with joint programs from British universities. Strong areas: oil and gas engineering, IT, business.',
//       kk: 'ҚБТУ — британдық университеттермен бірлескен бағдарламалары бар жетекші техникалық университет. Мұнай-газ инженериясы, IT, бизнес — күшті бағыттар.',
//     ),
//     type: 'Частный',
//     level: 'Бакалавриат, Магистратура',
//     directions: ['IT', 'Инженерия', 'Нефтегазовая отрасль', 'Бизнес'],
//     costRange: '2 200 000 – 3 500 000 ₸/год',
//     duration: '4 года',
//     languages: ['Английский', 'Русский'],
//     format: 'Очная',
//     website: 'https://kbtu.kz',
//     instagram: 'https://instagram.com/kbtu_official',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@kbtu.kz',
//     phone: '+7 (727) 272-42-93',
//     tags: ['it', 'engineering', 'business', 'bachelor', 'master'],
//     minEnt: 70,
//     minIelts: 5.5,
//   ),
//   University(
//     id: 'kaznu',
//     name: LocalizedString(
//       ru: 'Казахский национальный университет им. аль-Фараби',
//       en: 'Al-Farabi Kazakh National University',
//       kk: 'Әл-Фараби атындағы Қазақ ұлттық университеті',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'КазНУ — крупнейший и старейший университет Казахстана. Более 100 специальностей. Есть бюджетные места по государственному гранту.',
//       en: 'KazNU is the largest and oldest university in Kazakhstan. Over 100 majors. State grant places available.',
//       kk: 'ҚазҰУ — Қазақстанның ең ірі және көне университеті. 100-ден астам мамандық. Мемлекеттік гранттар бар.',
//     ),
//     type: 'Государственный',
//     level: 'Бакалавриат, Магистратура, Докторантура',
//     directions: ['IT', 'Медицина', 'Право', 'Бизнес', 'Инженерия', 'Гуманитарные науки', 'Естественные науки'],
//     costRange: 'Грант / до 1 800 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский', 'Английский'],
//     format: 'Очная, Дистанционная',
//     website: 'https://kaznu.kz',
//     instagram: 'https://instagram.com/kaznu_official',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'priem@kaznu.kz',
//     phone: '+7 (727) 377-33-33',
//     tags: ['it', 'medicine', 'law', 'business', 'engineering', 'grants', 'bachelor', 'master'],
//     minEnt: 65,
//   ),
//   University(
//     id: 'iitu',
//     name: LocalizedString(
//       ru: 'Международный университет информационных технологий',
//       en: 'International University of Information Technology',
//       kk: 'Халықаралық ақпараттық технологиялар университеті',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'МУИТ — ведущий IT-университет Казахстана. Готовит специалистов в области программной инженерии, кибербезопасности и ИИ. Есть государственные гранты.',
//       en: 'IITU is Kazakhstan\'s leading IT university. Trains specialists in software engineering, cybersecurity and AI. State grants available.',
//       kk: 'ХАТУ — Қазақстанның жетекші IT-университеті. Бағдарламалық инженерия, киберқауіпсіздік және ЖИ мамандарын дайындайды. Мемлекеттік гранттар бар.',
//     ),
//     type: 'Государственный',
//     level: 'Бакалавриат, Магистратура',
//     directions: ['IT'],
//     costRange: 'Грант / до 1 600 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский', 'Английский'],
//     format: 'Очная',
//     website: 'https://iitu.edu.kz',
//     instagram: 'https://instagram.com/iitu_official',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@iitu.edu.kz',
//     phone: '+7 (727) 355-34-00',
//     tags: ['it', 'engineering', 'grants', 'bachelor', 'master'],
//     minEnt: 60,
//   ),
//   University(
//     id: 'narxoz',
//     name: LocalizedString(
//       ru: 'Университет Нархоз',
//       en: 'Narxoz University',
//       kk: 'Нархоз Университеті',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'Нархоз — ведущий частный университет в области экономики и бизнеса. Международные аккредитации, партнёрство с European Business School.',
//       en: 'Narxoz is a leading private university in economics and business. International accreditations, partnership with European Business School.',
//       kk: 'Нархоз — экономика және бизнес саласындағы жетекші жеке университет. Халықаралық аккредитациялар, European Business School серіктестігі.',
//     ),
//     type: 'Частный',
//     level: 'Бакалавриат, Магистратура',
//     directions: ['Бизнес', 'Право', 'Экономика', 'IT', 'Финансы'],
//     costRange: '1 500 000 – 2 800 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский', 'Английский'],
//     format: 'Очная, Дистанционная',
//     website: 'https://narxoz.kz',
//     instagram: 'https://instagram.com/narxoz_university',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'admissions@narxoz.kz',
//     phone: '+7 (727) 377-11-11',
//     tags: ['business', 'law', 'it', 'bachelor', 'master'],
//     minEnt: 60,
//   ),
//   University(
//     id: 'kaznpu',
//     name: LocalizedString(
//       ru: 'КазНПУ им. Абая',
//       en: 'Abai Kazakh National Pedagogical University',
//       kk: 'Абай атындағы ҚазҰПУ',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'Казахский национальный педагогический университет им. Абая — главный педагогический вуз Казахстана. Есть государственные гранты.',
//       en: 'Abai KazNPU is Kazakhstan\'s main pedagogical university. State grants available.',
//       kk: 'Абай атындағы ҚазҰПУ — Қазақстанның басты педагогикалық жоғары оқу орны. Мемлекеттік гранттар бар.',
//     ),
//     type: 'Государственный',
//     level: 'Бакалавриат, Магистратура, Докторантура',
//     directions: ['Педагогика', 'Психология', 'Гуманитарные науки', 'Естественные науки', 'IT'],
//     costRange: 'Грант / до 1 200 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский'],
//     format: 'Очная, Дистанционная',
//     website: 'https://kaznpu.kz',
//     instagram: 'https://instagram.com/kaznpu_official',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@kaznpu.kz',
//     phone: '+7 (727) 291-91-91',
//     tags: ['pedagogy', 'grants', 'bachelor', 'master'],
//     minEnt: 55,
//   ),
//   University(
//     id: 'kazmed',
//     name: LocalizedString(
//       ru: 'КазНМУ им. С. Д. Асфендиярова',
//       en: 'S.D. Asfendiyarov Kazakh National Medical University',
//       kk: 'С.Ж. Асфендияров атындағы ҚазҰМУ',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'КазНМУ — ведущий медицинский вуз Казахстана. Готовит врачей, фармацевтов и специалистов общественного здравоохранения. Есть государственные гранты.',
//       en: 'KazNMU is Kazakhstan\'s leading medical university. Trains doctors, pharmacists and public health specialists. State grants available.',
//       kk: 'ҚазҰМУ — Қазақстанның жетекші медицина университеті. Дәрігерлер, фармацевттер және денсаулық сақтау мамандарын дайындайды. Мемлекеттік гранттар бар.',
//     ),
//     type: 'Государственный',
//     level: 'Бакалавриат, Магистратура, Резидентура',
//     directions: ['Медицина', 'Фармацевтика', 'Стоматология', 'Общественное здравоохранение'],
//     costRange: 'Грант / до 2 000 000 ₸/год',
//     duration: '5–6 лет',
//     languages: ['Казахский', 'Русский', 'Английский'],
//     format: 'Очная',
//     website: 'https://kaznmu.kz',
//     instagram: 'https://instagram.com/kaznmu_official',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@kaznmu.kz',
//     phone: '+7 (727) 292-06-30',
//     tags: ['medicine', 'grants', 'bachelor', 'master'],
//     minEnt: 70,
//   ),
//   University(
//     id: 'alma_u',
//     name: LocalizedString(
//       ru: 'Alma University',
//       en: 'Alma University',
//       kk: 'Alma University',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'Alma University — современный частный университет с фокусом на бизнес, право и цифровые технологии.',
//       en: 'Alma University is a modern private university focused on business, law and digital technologies.',
//       kk: 'Alma University — бизнес, құқық және цифрлық технологияларға бағытталған заманауи жеке университет.',
//     ),
//     type: 'Частный',
//     level: 'Бакалавриат, Магистратура',
//     directions: ['Бизнес', 'Право', 'IT', 'Дизайн'],
//     costRange: '1 300 000 – 2 200 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский', 'Английский'],
//     format: 'Очная, Гибридная',
//     website: 'https://alma.edu.kz',
//     instagram: 'https://instagram.com/alma_university',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@alma.edu.kz',
//     phone: '+7 (727) 311-11-40',
//     tags: ['business', 'law', 'it', 'design', 'bachelor', 'master'],
//     minEnt: 60,
//   ),
//   University(
//     id: 'turan',
//     name: LocalizedString(
//       ru: 'Университет Туран',
//       en: 'Turan University',
//       kk: 'Тұран Университеті',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'Университет Туран — один из старейших частных университетов Казахстана. Широкий спектр направлений: экономика, IT, право, туризм и журналистика.',
//       en: 'Turan University is one of the oldest private universities in Kazakhstan with a wide range of programs.',
//       kk: 'Тұран университеті — Қазақстандағы ең көне жеке университеттердің бірі, бағдарламалардың кең спектрімен.',
//     ),
//     type: 'Частный',
//     level: 'Бакалавриат, Магистратура, Докторантура',
//     directions: ['Бизнес', 'IT', 'Право', 'Туризм', 'Журналистика'],
//     costRange: '1 000 000 – 1 800 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский', 'Английский'],
//     format: 'Очная, Дистанционная',
//     website: 'https://turan-edu.kz',
//     instagram: 'https://instagram.com/turan_university',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@turan-edu.kz',
//     phone: '+7 (727) 250-24-44',
//     tags: ['business', 'it', 'law', 'bachelor', 'master'],
//     minEnt: 50,
//   ),
//   University(
//     id: 'kazguu',
//     name: LocalizedString(
//       ru: 'Казахский гуманитарно-юридический университет',
//       en: 'Kazakh Humanitarian Law University',
//       kk: 'Қазақ гуманитарлық-заң университеті',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'КазГЮУ — ведущий юридический университет Казахстана. Есть государственные гранты.',
//       en: 'KazGUU is Kazakhstan\'s leading law university. State grants available.',
//       kk: 'ҚазГЗУ — Қазақстанның жетекші заң университеті. Мемлекеттік гранттар бар.',
//     ),
//     type: 'Государственный',
//     level: 'Бакалавриат, Магистратура',
//     directions: ['Право', 'Государственное управление', 'Международные отношения'],
//     costRange: 'Грант / до 1 600 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский'],
//     format: 'Очная',
//     website: 'https://kazguu.kz',
//     instagram: 'https://instagram.com/kazguu_official',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@kazguu.kz',
//     phone: '+7 (727) 292-09-60',
//     tags: ['law', 'grants', 'bachelor', 'master'],
//     minEnt: 65,
//   ),
//   University(
//     id: 'kau',
//     name: LocalizedString(
//       ru: 'Казахская академия транспорта и коммуникаций им. М. Тынышпаева',
//       en: 'M. Tynyshpayev Kazakhstan Academy of Transport and Communications',
//       kk: 'М. Тынышпаев атындағы Қазақ көлік және коммуникациялар академиясы',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'КазАТК — ведущий транспортный университет Казахстана. Готовит инженеров для железнодорожной, авиационной и логистической отраслей. Есть государственные гранты.',
//       en: 'KazATK is Kazakhstan\'s leading transport university. Trains engineers for rail, aviation and logistics industries. State grants available.',
//       kk: 'ҚазАТК — Қазақстанның жетекші көлік университеті. Теміржол, авиация және логистика салаларына инженерлер дайындайды. Мемлекеттік гранттар бар.',
//     ),
//     type: 'Государственный',
//     level: 'Бакалавриат, Магистратура',
//     directions: ['Инженерия', 'Транспорт', 'Логистика', 'IT'],
//     costRange: 'Грант / до 1 500 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский'],
//     format: 'Очная',
//     website: 'https://kazatk.kz',
//     instagram: 'https://instagram.com/kazatk_official',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@kazatk.kz',
//     phone: '+7 (727) 292-27-92',
//     tags: ['engineering', 'it', 'grants', 'bachelor', 'master'],
//     minEnt: 55,
//   ),
//   University(
//     id: 'kafu',
//     name: LocalizedString(
//       ru: 'Казахстанско-Американский свободный университет',
//       en: 'Kazakhstan-American Free University',
//       kk: 'Қазақстан-Американ еркін университеті',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'КАФУ — частный университет с американской моделью образования. Обучение на английском и русском языках.',
//       en: 'KAFU is a private university with the American model of education. Instruction in English and Russian.',
//       kk: 'ҚАФУ — американдық білім моделі бар жеке университет. Ағылшын және орыс тілдерінде оқыту.',
//     ),
//     type: 'Частный',
//     level: 'Бакалавриат, Магистратура',
//     directions: ['Бизнес', 'IT', 'Право', 'Психология'],
//     costRange: '1 100 000 – 2 000 000 ₸/год',
//     duration: '4 года',
//     languages: ['Английский', 'Русский'],
//     format: 'Очная, Гибридная',
//     website: 'https://kafu.kz',
//     instagram: 'https://instagram.com/kafu_almaty',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@kafu.kz',
//     phone: '+7 (727) 270-02-70',
//     tags: ['business', 'it', 'law', 'bachelor', 'master'],
//     minEnt: 55,
//     minIelts: 5.0,
//   ),
//   University(
//     id: 'kazart',
//     name: LocalizedString(
//       ru: 'Казахская национальная академия искусств им. Т. Жургенова',
//       en: 'T. Zhurgenov Kazakh National Academy of Arts',
//       kk: 'Т. Жүргенов атындағы Қазақ ұлттық өнер академиясы',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'КазНАИ — главный творческий вуз Казахстана. Готовит специалистов в области театра, кино, дизайна, живописи и музыки. Есть государственные гранты.',
//       en: 'KazNAI is Kazakhstan\'s main creative university. Trains specialists in theatre, cinema, design, painting and music. State grants available.',
//       kk: 'ҚазҰӨА — Қазақстанның басты шығармашылық жоғары оқу орны. Театр, кино, дизайн, кескіндеме және музыка мамандарын дайындайды. Мемлекеттік гранттар бар.',
//     ),
//     type: 'Государственный',
//     level: 'Бакалавриат, Магистратура',
//     directions: ['Дизайн', 'Кино и театр', 'Живопись', 'Музыка'],
//     costRange: 'Грант / до 1 500 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский'],
//     format: 'Очная',
//     website: 'https://kazart.kz',
//     instagram: 'https://instagram.com/zhurgenov_academy',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@kazart.kz',
//     phone: '+7 (727) 267-08-08',
//     tags: ['design', 'grants', 'bachelor', 'master'],
//     minEnt: 55,
//   ),
//   University(
//     id: 'almau',
//     name: LocalizedString(
//       ru: 'Алматы Менеджмент Университет (AlmaU)',
//       en: 'Almaty Management University (AlmaU)',
//       kk: 'Алматы менеджмент университеті (AlmaU)',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'AlmaU — ведущая бизнес-школа Казахстана, аккредитована AMBA. Специализируется на менеджменте, маркетинге, финансах и предпринимательстве.',
//       en: 'AlmaU is Kazakhstan\'s leading business school, AMBA accredited. Specializes in management, marketing, finance and entrepreneurship.',
//       kk: 'AlmaU — AMBA аккредитациясы бар Қазақстанның жетекші бизнес-мектебі. Менеджмент, маркетинг, қаржы және кәсіпкерлікке маманданған.',
//     ),
//     type: 'Частный',
//     level: 'Бакалавриат, Магистратура, MBA',
//     directions: ['Бизнес', 'Финансы', 'Маркетинг', 'Предпринимательство'],
//     costRange: '1 800 000 – 3 200 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский', 'Английский'],
//     format: 'Очная, Гибридная',
//     website: 'https://almau.edu.kz',
//     instagram: 'https://instagram.com/almau_official',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@almau.edu.kz',
//     phone: '+7 (727) 399-03-33',
//     tags: ['business', 'bachelor', 'master'],
//     minEnt: 60,
//   ),
//   University(
//     id: 'kazeconomics',
//     name: LocalizedString(
//       ru: 'Казахский экономический университет им. Т. Рыскулова',
//       en: 'T. Ryskulov Kazakh University of Economics',
//       kk: 'Т. Рысқұлов атындағы Қазақ экономика университеті',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'КазЭУ — ведущий экономический университет Казахстана. Есть государственные гранты.',
//       en: 'KazEU is Kazakhstan\'s leading economics university. State grants available.',
//       kk: 'ҚазЭУ — Қазақстанның жетекші экономика университеті. Мемлекеттік гранттар бар.',
//     ),
//     type: 'Государственный',
//     level: 'Бакалавриат, Магистратура, Докторантура',
//     directions: ['Бизнес', 'Экономика', 'Финансы', 'Статистика', 'IT'],
//     costRange: 'Грант / до 1 600 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский'],
//     format: 'Очная, Дистанционная',
//     website: 'https://kazeu.kz',
//     instagram: 'https://instagram.com/kazeu_official',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@kazeu.kz',
//     phone: '+7 (727) 309-55-55',
//     tags: ['business', 'it', 'grants', 'bachelor', 'master'],
//     minEnt: 60,
//   ),
//   University(
//     id: 'satpaev',
//     name: LocalizedString(
//       ru: 'Satbayev University',
//       en: 'Satbayev University',
//       kk: 'Сәтбаев Университеті',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'Казахский национальный исследовательский технический университет им. К. И. Сатпаева — ведущий технический вуз Казахстана. Есть государственные гранты.',
//       en: 'Satbayev University is Kazakhstan\'s leading technical university. State grants available.',
//       kk: 'Сәтбаев Университеті — Қазақстанның жетекші техникалық жоғары оқу орны. Мемлекеттік гранттар бар.',
//     ),
//     type: 'Государственный',
//     level: 'Бакалавриат, Магистратура, Докторантура',
//     directions: ['Инженерия', 'Горное дело', 'Нефтегазовая отрасль', 'IT', 'Архитектура'],
//     costRange: 'Грант / до 1 800 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский', 'Английский'],
//     format: 'Очная',
//     website: 'https://satbayev.university',
//     instagram: 'https://instagram.com/satbayev_university',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@satbayev.university',
//     phone: '+7 (727) 320-55-55',
//     tags: ['engineering', 'it', 'grants', 'bachelor', 'master'],
//     minEnt: 65,
//   ),
//   University(
//     id: 'kazakh_american',
//     name: LocalizedString(
//       ru: 'Казахстанско-Американский университет',
//       en: 'Kazakhstan-American University',
//       kk: 'Қазақстан-Американ университеті',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'КАУ — частный университет с американской моделью либерального образования. Сильные программы по IT, дизайну и бизнесу на английском языке.',
//       en: 'KAU is a private university with the American liberal education model. Strong IT, design and business programs in English.',
//       kk: 'ҚАУ — американдық либералды білім моделі бар жеке университет. IT, дизайн және бизнес бойынша күшті ағылшын тіліндегі бағдарламалар.',
//     ),
//     type: 'Частный',
//     level: 'Бакалавриат, Магистратура',
//     directions: ['IT', 'Дизайн', 'Бизнес', 'Гуманитарные науки'],
//     costRange: '1 200 000 – 2 100 000 ₸/год',
//     duration: '4 года',
//     languages: ['Английский', 'Русский'],
//     format: 'Очная',
//     website: 'https://kau.edu.kz',
//     instagram: 'https://instagram.com/kau_almaty',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@kau.edu.kz',
//     phone: '+7 (727) 233-88-88',
//     tags: ['it', 'design', 'business', 'bachelor', 'master'],
//     minEnt: 55,
//     minIelts: 5.0,
//   ),
//   University(
//     id: 'kazinfra',
//     name: LocalizedString(
//       ru: 'Казахская головная архитектурно-строительная академия',
//       en: 'Kazakh Leading Architecture and Civil Engineering Academy',
//       kk: 'Қазақ бас сәулет-құрылыс академиясы',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'КазГАСА — единственный в Казахстане профильный архитектурно-строительный вуз. Есть государственные гранты.',
//       en: 'KazGASA is Kazakhstan\'s only specialized architecture and construction university. State grants available.',
//       kk: 'ҚазБСА — Қазақстандағы жалғыз мамандандырылған сәулет-құрылыс жоғары оқу орны. Мемлекеттік гранттар бар.',
//     ),
//     type: 'Государственный',
//     level: 'Бакалавриат, Магистратура',
//     directions: ['Архитектура', 'Строительство', 'Дизайн', 'Инженерия'],
//     costRange: 'Грант / до 1 500 000 ₸/год',
//     duration: '4–5 лет',
//     languages: ['Казахский', 'Русский'],
//     format: 'Очная',
//     website: 'https://kazgasa.kz',
//     instagram: 'https://instagram.com/kazgasa_official',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@kazgasa.kz',
//     phone: '+7 (727) 309-67-89',
//     tags: ['design', 'engineering', 'grants', 'bachelor', 'master'],
//     minEnt: 60,
//   ),
//   University(
//     id: 'kazmira',
//     name: LocalizedString(
//       ru: 'Университет «Мирас»',
//       en: 'Miras University',
//       kk: '«Мирас» Университеті',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'Университет «Мирас» — многопрофильный частный вуз с широким спектром специальностей. Доступная стоимость обучения.',
//       en: 'Miras University is a multidisciplinary private university with a wide range of majors. Affordable tuition.',
//       kk: '«Мирас» университеті — мамандықтардың кең спектрі бар көпсалалы жеке жоғары оқу орны. Қолжетімді оқу бағасы.',
//     ),
//     type: 'Частный',
//     level: 'Бакалавриат, Магистратура',
//     directions: ['Бизнес', 'Право', 'Педагогика', 'Инженерия', 'IT'],
//     costRange: '900 000 – 1 500 000 ₸/год',
//     duration: '4 года',
//     languages: ['Казахский', 'Русский'],
//     format: 'Очная, Дистанционная',
//     website: 'https://miras.edu.kz',
//     instagram: 'https://instagram.com/miras_university',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@miras.edu.kz',
//     phone: '+7 (727) 394-80-80',
//     tags: ['business', 'law', 'pedagogy', 'engineering', 'it', 'bachelor', 'master'],
//     minEnt: 50,
//   ),
//   University(
//     id: 'kazpharm',
//     name: LocalizedString(
//       ru: 'Казахстанский медицинский университет «Высшая школа общественного здравоохранения»',
//       en: 'Kazakhstan Medical University "School of Public Health"',
//       kk: 'Қазақстан медицина университеті «Қоғамдық денсаулық сақтау жоғары мектебі»',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'ВШОЗ — специализированный медицинский университет для подготовки управленцев в сфере здравоохранения. Программы на английском языке.',
//       en: 'KSPH is a specialized medical university for training healthcare managers. English-language programs.',
//       kk: 'ҚДСЖМ — денсаулық сақтау менеджерлерін даярлауға арналған мамандандырылған медицина университеті. Ағылшын тіліндегі бағдарламалар.',
//     ),
//     type: 'Частный',
//     level: 'Магистратура, Докторантура',
//     directions: ['Медицина', 'Общественное здравоохранение', 'Менеджмент в медицине'],
//     costRange: '2 500 000 – 4 000 000 ₸/год',
//     duration: '2 года',
//     languages: ['Английский', 'Русский'],
//     format: 'Очная',
//     website: 'https://ksph.kz',
//     instagram: 'https://instagram.com/ksph_kz',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'info@ksph.kz',
//     phone: '+7 (727) 279-06-49',
//     tags: ['medicine', 'master'],
//     minIelts: 6.0,
//   ),
// ];

// /// Колледжи и программы магистратуры.
// const List<University> kSeedExtra = [
//   University(
//     id: 'col_kazgorizont',
//     name: LocalizedString(
//       ru: 'Казахский гуманитарно-технический колледж «Горизонт»',
//       en: 'Kazakh Humanitarian and Technical College "Gorizont"',
//       kk: '«Горизонт» қазақ гуманитарлық-техникалық колледжі',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'Колледж «Горизонт» — один из крупнейших частных колледжей Алматы. Подготовка специалистов по IT, бизнесу, дизайну и педагогике.',
//       en: 'Gorizont College is one of the largest private colleges in Almaty. Trains specialists in IT, business, design and pedagogy.',
//       kk: '«Горизонт» колледжі — Алматының ірі жеке колледждерінің бірі. IT, бизнес, дизайн және педагогика мамандарын дайындайды.',
//     ),
//     type: 'Частный',
//     level: 'Колледж',
//     directions: ['IT', 'Бизнес', 'Дизайн', 'Педагогика'],
//     costRange: '350 000 – 650 000 ₸/год',
//     duration: '3 года',
//     languages: ['Казахский', 'Русский'],
//     format: 'Очная',
//     website: '',
//     instagram: '',
//     imageUrl: '',
//     logoUrl: '',
//     email: '',
//     phone: '+7 (727) 394-55-55',
//     tags: ['it', 'business', 'design', 'pedagogy', 'college'],
//   ),
//   University(
//     id: 'col_binom',
//     name: LocalizedString(
//       ru: 'Колледж информационных технологий «Бином»',
//       en: 'Information Technology College "Binom"',
//       kk: '«Бином» ақпараттық технологиялар колледжі',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'Колледж «Бином» специализируется на подготовке IT-специалистов: программистов, системных администраторов и специалистов по кибербезопасности.',
//       en: 'Binom College specializes in IT specialists: programmers, system administrators and cybersecurity professionals.',
//       kk: '«Бином» колледжі IT мамандарын дайындауға маманданған: бағдарламашылар, жүйелік әкімшілер және киберқауіпсіздік мамандары.',
//     ),
//     type: 'Частный',
//     level: 'Колледж',
//     directions: ['IT'],
//     costRange: '400 000 – 700 000 ₸/год',
//     duration: '3 года',
//     languages: ['Русский', 'Казахский'],
//     format: 'Очная',
//     website: '',
//     instagram: '',
//     imageUrl: '',
//     logoUrl: '',
//     email: '',
//     phone: '+7 (727) 312-44-44',
//     tags: ['it', 'engineering', 'college'],
//   ),
//   University(
//     id: 'mba_almau',
//     name: LocalizedString(
//       ru: 'AlmaU MBA',
//       en: 'AlmaU MBA',
//       kk: 'AlmaU MBA',
//     ),
//     city: LocalizedString(ru: 'Алматы', en: 'Almaty', kk: 'Алматы'),
//     description: LocalizedString(
//       ru: 'Программа MBA Алматы Менеджмент Университета — аккредитована AMBA. Специализации: General Management, Marketing, Finance.',
//       en: 'AlmaU MBA program — AMBA accredited. Specializations: General Management, Marketing, Finance.',
//       kk: 'AlmaU MBA бағдарламасы — AMBA аккредитациясы бар. Мамандануы: General Management, Marketing, Finance.',
//     ),
//     type: 'Частный',
//     level: 'Магистратура (MBA)',
//     directions: ['Бизнес', 'Финансы', 'Маркетинг'],
//     costRange: '3 500 000 – 5 000 000 ₸/год',
//     duration: '2 года',
//     languages: ['Русский', 'Английский'],
//     format: 'Гибридная',
//     website: 'https://almau.edu.kz/mba',
//     instagram: 'https://instagram.com/almau_official',
//     imageUrl: '',
//     logoUrl: '',
//     email: 'mba@almau.edu.kz',
//     phone: '+7 (727) 399-03-33',
//     tags: ['business', 'master'],
//     minIelts: 5.5,
//   ),
// ];

// import 'package:stiky/data/news/university_news_model.dart';
// import 'package:stiky/data/programs/university_program_model.dart';

// /// Seed-данные программ и новостей для каждого вуза.
// /// 
// /// ОБНОВЛЕНО: по 10 специальностей и 5 новостей для каждого ВУЗа
// /// 
// /// Ключ Map — id документа университета в Firestore.
// ///
// /// Использование:
// /// ```dart
// /// for (final entry in kSeedPrograms.entries) {
// ///   await context.read<UniversityProgramRepository>()
// ///       .seedPrograms(entry.key, entry.value);
// /// }
// /// for (final entry in kSeedNews.entries) {
// ///   await context.read<UniversityNewsRepository>()
// ///       .seedNews(entry.key, entry.value);
// /// }
// /// ```

// // ─── ПРОГРАММЫ (10 шт на ВУЗ) ─────────────────────────────────────────────────

// final Map<String, List<UniversityProgram>> kSeedPrograms = {
//   'kimep': [
//     const UniversityProgram(
//       id: 'kimep_bba',
//       name: 'Bachelor of Business Administration',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 800 000 – 3 200 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Программа BBA охватывает менеджмент, маркетинг, финансы и предпринимательство.',
//       jobs: ['Менеджер', 'Маркетолог', 'Финансовый аналитик', 'Предприниматель'],
//     ),
//     const UniversityProgram(
//       id: 'kimep_law',
//       name: 'Юриспруденция (LLB)',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 800 000 – 3 200 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Программа по международному и казахстанскому праву.',
//       jobs: ['Юрист', 'Адвокат', 'Корпоративный советник', 'Нотариус'],
//     ),
//     const UniversityProgram(
//       id: 'kimep_mba',
//       name: 'MBA',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: '3 500 000 – 4 200 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Флагманская программа MBA с аккредитацией AACSB.',
//       jobs: ['Директор', 'Топ-менеджер', 'Консультант', 'Инвестиционный банкир'],
//     ),
//     const UniversityProgram(
//       id: 'kimep_media',
//       name: 'Журналистика и медиа',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 800 000 – 3 200 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Подготовка журналистов и медиа-профессионалов.',
//       jobs: ['Журналист', 'Редактор', 'Продюсер', 'Медиа-менеджер'],
//     ),
//     const UniversityProgram(
//       id: 'kimep_econ',
//       name: 'Экономика',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 800 000 – 3 200 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Программа экономики с углублением в макроэкономику и финансы.',
//       jobs: ['Экономист', 'Аналитик', 'Финансист', 'Консультант'],
//     ),
//     const UniversityProgram(
//       id: 'kimep_ir',
//       name: 'Международные отношения',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 800 000 – 3 200 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Подготовка специалистов в области дипломатии.',
//       jobs: ['Дипломат', 'Консультант', 'Политолог', 'Аналитик'],
//     ),
//     const UniversityProgram(
//       id: 'kimep_accounting',
//       name: 'Бухгалтерский учет и аудит',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 800 000 – 3 200 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Подготовка бухгалтеров и аудиторов.',
//       jobs: ['Бухгалтер', 'Аудитор', 'Финансовый контролер', 'CFO'],
//     ),
//     const UniversityProgram(
//       id: 'kimep_digital',
//       name: 'Цифровой маркетинг',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 800 000 – 3 200 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Программа подготовки специалистов цифрового маркетинга.',
//       jobs: ['Digital-маркетолог', 'SEO-специалист', 'Content Manager'],
//     ),
//     const UniversityProgram(
//       id: 'kimep_hr',
//       name: 'Управление человеческими ресурсами',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 800 000 – 3 200 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Подготовка HR-специалистов для международных компаний.',
//       jobs: ['HR-менеджер', 'Рекрутер', 'HR-бизнес-партнер'],
//     ),
//     const UniversityProgram(
//       id: 'kimep_finance_master',
//       name: 'Финансы (Магистратура)',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: '3 500 000 – 4 000 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Магистерская программа в области корпоративных финансов.',
//       jobs: ['Финансовый менеджер', 'Инвестиционный аналитик'],
//     ),
//   ],
//   'kaznu': [
//     const UniversityProgram(
//       id: 'kaznu_cs',
//       name: 'Информатика',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа охватывает алгоритмы, структуры данных и ИИ.',
//       jobs: ['Разработчик', 'Data Scientist', 'Системный аналитик', 'DevOps'],
//     ),
//     const UniversityProgram(
//       id: 'kaznu_law',
//       name: 'Юриспруденция',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Одна из старейших юридических программ Казахстана.',
//       jobs: ['Юрист', 'Прокурор', 'Судья', 'Нотариус'],
//     ),
//     const UniversityProgram(
//       id: 'kaznu_med',
//       name: 'Общая медицина',
//       degree: 'Бакалавриат',
//       duration: '5 лет',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Подготовка врачей общей практики.',
//       jobs: ['Врач', 'Терапевт', 'Педиатр', 'Хирург'],
//     ),
//     const UniversityProgram(
//       id: 'kaznu_econ',
//       name: 'Экономика',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Фундаментальная экономическая подготовка.',
//       jobs: ['Экономист', 'Аналитик', 'Финансист', 'Государственный служащий'],
//     ),
//     const UniversityProgram(
//       id: 'kaznu_history',
//       name: 'История',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа по казахской и мировой истории.',
//       jobs: ['Историк', 'Архивист', 'Журналист', 'Преподаватель'],
//     ),
//     const UniversityProgram(
//       id: 'kaznu_biology',
//       name: 'Биология',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа молекулярной биологии и генетики.',
//       jobs: ['Биолог', 'Генетик', 'Лаборант', 'Исследователь'],
//     ),
//     const UniversityProgram(
//       id: 'kaznu_physics',
//       name: 'Физика',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Фундаментальная физика с экспериментальной практикой.',
//       jobs: ['Физик', 'Инженер', 'Научный сотрудник', 'Преподаватель'],
//     ),
//     const UniversityProgram(
//       id: 'kaznu_chemistry',
//       name: 'Химия',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа органической и неорганической химии.',
//       jobs: ['Химик', 'Технолог', 'Лаборант', 'Исследователь'],
//     ),
//     const UniversityProgram(
//       id: 'kaznu_psychology',
//       name: 'Психология',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа клинической и социальной психологии.',
//       jobs: ['Психолог', 'Консультант', 'Клинический психолог', 'HR'],
//     ),
//     const UniversityProgram(
//       id: 'kaznu_languages',
//       name: 'Иностранные языки',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка переводчиков и учителей.',
//       jobs: ['Переводчик', 'Учитель', 'Международный специалист', 'Турист-гид'],
//     ),
//   ],
//   'kbtu': [
//     const UniversityProgram(
//       id: 'kbtu_se',
//       name: 'Программная инженерия',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 200 000 – 3 000 000 ₸/год',
//       languages: ['Английский', 'Русский'],
//       description: 'Программа совместно с британскими университетами.',
//       jobs: ['Backend-разработчик', 'Архитектор ПО', 'Tech Lead', 'CTO'],
//     ),
//     const UniversityProgram(
//       id: 'kbtu_oil',
//       name: 'Нефтегазовая инженерия',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 500 000 – 3 500 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Совместная программа с University of London.',
//       jobs: ['Нефтяной инженер', 'Геолог', 'Буровой инженер', 'Менеджер проекта'],
//     ),
//     const UniversityProgram(
//       id: 'kbtu_biz',
//       name: 'Бизнес и менеджмент',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 200 000 – 2 800 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Программа с британской аккредитацией.',
//       jobs: ['Менеджер', 'Консультант', 'Бизнес-аналитик', 'Предприниматель'],
//     ),
//     const UniversityProgram(
//       id: 'kbtu_civil',
//       name: 'Гражданское строительство',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 200 000 – 3 000 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Подготовка инженеров в области проектирования.',
//       jobs: ['Инженер-строитель', 'Прораб', 'Проектировщик', 'Архитектор'],
//     ),
//     const UniversityProgram(
//       id: 'kbtu_mechanical',
//       name: 'Механическая инженерия',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 200 000 – 3 000 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Программа проектирования механических систем.',
//       jobs: ['Механический инженер', 'Конструктор', 'Техник', 'Инженер-проектировщик'],
//     ),
//     const UniversityProgram(
//       id: 'kbtu_electrical',
//       name: 'Электрическая инженерия',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 200 000 – 3 000 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Подготовка инженеров в области электроэнергетики.',
//       jobs: ['Электротехник', 'Инженер ЭС', 'Электромонтер', 'Проектировщик'],
//     ),
//     const UniversityProgram(
//       id: 'kbtu_environmental',
//       name: 'Экологическая инженерия',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 200 000 – 2 800 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Программа в области экологии и устойчивого развития.',
//       jobs: ['Эколог', 'Инженер', 'Консультант', 'Аналитик'],
//     ),
//     const UniversityProgram(
//       id: 'kbtu_mining',
//       name: 'Горная инженерия',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 500 000 – 3 500 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Подготовка инженеров для горнодобывающей промышленности.',
//       jobs: ['Горный инженер', 'Маркшейдер', 'Технолог', 'Руководитель проекта'],
//     ),
//     const UniversityProgram(
//       id: 'kbtu_finance',
//       name: 'Финансы и инвестиции',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: '2 500 000 – 3 200 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Магистерская программа корпоративных финансов.',
//       jobs: ['Финансовый аналитик', 'Инвестиционный менеджер', 'Банкир'],
//     ),
//     const UniversityProgram(
//       id: 'kbtu_mba',
//       name: 'MBA',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: '3 000 000 – 4 000 000 ₸/год',
//       languages: ['Английский'],
//       description: 'Программа MBA с фокусом на инженерный менеджмент.',
//       jobs: ['Генеральный директор', 'Топ-менеджер', 'Консультант', 'Инвестор'],
//     ),
//   ],
//   'iitu': [
//     const UniversityProgram(
//       id: 'iitu_cs',
//       name: 'Вычислительная техника и программирование',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 600 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Флагманская программа МУИТ. Охватывает разработку ПО.',
//       jobs: ['Программист', 'Разработчик', 'Аналитик', 'Тестировщик'],
//     ),
//     const UniversityProgram(
//       id: 'iitu_cyber',
//       name: 'Кибербезопасность',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 600 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа подготовки специалистов по защите информации.',
//       jobs: ['Специалист по ИБ', 'Пентестер', 'SOC-аналитик', 'CISO'],
//     ),
//     const UniversityProgram(
//       id: 'iitu_ai',
//       name: 'Искусственный интеллект',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 600 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Специализированная программа по машинному обучению.',
//       jobs: ['ML-инженер', 'Data Scientist', 'AI-специалист', 'Исследователь'],
//     ),
//     const UniversityProgram(
//       id: 'iitu_networks',
//       name: 'Компьютерные сети и телекоммуникации',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 600 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа сетевых технологий и телекоммуникационных систем.',
//       jobs: ['Сетевой инженер', 'Системный администратор', 'Телеком-специалист'],
//     ),
//     const UniversityProgram(
//       id: 'iitu_mobile',
//       name: 'Мобильные приложения',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 600 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Разработка мобильных приложений для iOS и Android.',
//       jobs: ['Мобильный разработчик', 'iOS-разработчик', 'Android-разработчик'],
//     ),
//     const UniversityProgram(
//       id: 'iitu_webdev',
//       name: 'Веб-разработка',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 600 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Полнофункциональная веб-разработка: frontend и backend.',
//       jobs: ['Веб-разработчик', 'Frontend-разработчик', 'Backend-разработчик'],
//     ),
//     const UniversityProgram(
//       id: 'iitu_databases',
//       name: 'Управление базами данных',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 600 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Проектирование и администрирование баз данных.',
//       jobs: ['DBA', 'Инженер БД', 'Data Engineer', 'Системный аналитик'],
//     ),
//     const UniversityProgram(
//       id: 'iitu_devops',
//       name: 'DevOps и облачные технологии',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Программа облачных сервисов (AWS, Azure, GCP).',
//       jobs: ['DevOps-инженер', 'SRE', 'Cloud-архитектор', 'Platform Engineer'],
//     ),
//     const UniversityProgram(
//       id: 'iitu_blockchain',
//       name: 'Блокчейн и криптография',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Специализированная программа по блокчейну и криптографии.',
//       jobs: ['Blockchain-разработчик', 'Криптограф', 'Security-специалист'],
//     ),
//     const UniversityProgram(
//       id: 'iitu_iot',
//       name: 'Интернет вещей (IoT)',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 600 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа встроенных систем и IoT-устройств.',
//       jobs: ['IoT-разработчик', 'Embedded-разработчик', 'Инженер системы'],
//     ),
//   ],
//   'narxoz': [
//     const UniversityProgram(
//       id: 'narxoz_fin',
//       name: 'Финансы',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '1 500 000 – 2 200 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Программа с международной аккредитацией.',
//       jobs: ['Финансовый аналитик', 'Банкир', 'Инвестиционный менеджер', 'CFO'],
//     ),
//     const UniversityProgram(
//       id: 'narxoz_digit',
//       name: 'Цифровой бизнес',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '1 500 000 – 2 200 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Инновационная программа на стыке IT и бизнеса.',
//       jobs: ['Product Manager', 'Digital-маркетолог', 'Growth-менеджер', 'Стартапер'],
//     ),
//     const UniversityProgram(
//       id: 'narxoz_accounting',
//       name: 'Бухгалтерский учет',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '1 500 000 – 2 000 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка бухгалтеров с международной сертификацией.',
//       jobs: ['Бухгалтер', 'Аудитор', 'Финансовый контролер'],
//     ),
//     const UniversityProgram(
//       id: 'narxoz_marketing',
//       name: 'Маркетинг и реклама',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '1 500 000 – 2 200 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Программа маркетинга с практикой в реальных кампаниях.',
//       jobs: ['Маркетолог', 'Бренд-менеджер', 'PR-специалист', 'Рекламист'],
//     ),
//     const UniversityProgram(
//       id: 'narxoz_economics',
//       name: 'Экономика',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '1 500 000 – 2 000 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Фундаментальная экономическая подготовка.',
//       jobs: ['Экономист', 'Аналитик', 'Государственный служащий'],
//     ),
//     const UniversityProgram(
//       id: 'narxoz_management',
//       name: 'Менеджмент',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '1 500 000 – 2 200 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Управление проектами и организациями.',
//       jobs: ['Менеджер', 'Project Manager', 'Руководитель отдела'],
//     ),
//     const UniversityProgram(
//       id: 'narxoz_hr',
//       name: 'Управление человеческими ресурсами',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '1 500 000 – 2 000 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка HR-специалистов и рекрутеров.',
//       jobs: ['HR-менеджер', 'Рекрутер', 'HR-бизнес-партнер'],
//     ),
//     const UniversityProgram(
//       id: 'narxoz_logistics',
//       name: 'Логистика и управление цепями поставок',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '1 500 000 – 2 200 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Специализированная программа логистики и SCM.',
//       jobs: ['Логист', 'SCM-специалист', 'Менеджер складов'],
//     ),
//     const UniversityProgram(
//       id: 'narxoz_mba',
//       name: 'MBA',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: '2 500 000 – 3 500 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Программа MBA с международной аккредитацией EPAS.',
//       jobs: ['Генеральный директор', 'Топ-менеджер', 'Консультант'],
//     ),
//     const UniversityProgram(
//       id: 'narxoz_finance_master',
//       name: 'Финансы (Магистратура)',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: '2 000 000 – 2 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Магистерская программа корпоративных финансов.',
//       jobs: ['Финансовый менеджер', 'Инвестиционный аналитик'],
//     ),
//   ],
//   'kaznpu': [
//     const UniversityProgram(
//       id: 'kaznpu_ped_primary',
//       name: 'Педагогика начального образования',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 200 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка учителей начальных классов.',
//       jobs: ['Учитель начальных классов', 'Методист', 'Завуч'],
//     ),
//     const UniversityProgram(
//       id: 'kaznpu_ped_secondary',
//       name: 'Педагогика и методика преподавания (Средняя школа)',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 200 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка учителей различных предметов.',
//       jobs: ['Учитель', 'Методист', 'Завуч'],
//     ),
//     const UniversityProgram(
//       id: 'kaznpu_psychology',
//       name: 'Психология',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 200 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа детской и образовательной психологии.',
//       jobs: ['Школьный психолог', 'Консультант', 'Психолог'],
//     ),
//     const UniversityProgram(
//       id: 'kaznpu_special',
//       name: 'Специальная педагогика (Коррекционная)',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 200 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка педагогов для работы с детьми с ОВЗ.',
//       jobs: ['Коррекционный педагог', 'Дефектолог', 'Специалист по реабилитации'],
//     ),
//     const UniversityProgram(
//       id: 'kaznpu_languages',
//       name: 'Методика преподавания иностранных языков',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 200 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка учителей английского и других языков.',
//       jobs: ['Учитель иностранных языков', 'Переводчик', 'Методист'],
//     ),
//     const UniversityProgram(
//       id: 'kaznpu_physical',
//       name: 'Физическое воспитание и спорт',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 200 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка учителей физкультуры и тренеров.',
//       jobs: ['Учитель ФК', 'Тренер', 'Спортивный менеджер'],
//     ),
//     const UniversityProgram(
//       id: 'kaznpu_music',
//       name: 'Музыкальное образование',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 200 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка музыкальных педагогов и дирижеров.',
//       jobs: ['Учитель музыки', 'Дирижер', 'Композитор'],
//     ),
//     const UniversityProgram(
//       id: 'kaznpu_art',
//       name: 'Художественное образование',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 200 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка учителей изобразительного искусства.',
//       jobs: ['Учитель ИЗО', 'Художник', 'Дизайнер'],
//     ),
//     const UniversityProgram(
//       id: 'kaznpu_edtech',
//       name: 'Образовательные технологии',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: 'Грант / до 1 400 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа цифровой педагогики и e-learning.',
//       jobs: ['Методист', 'Разработчик курсов', 'EdTech-специалист'],
//     ),
//     const UniversityProgram(
//       id: 'kaznpu_management',
//       name: 'Образовательный менеджмент',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: 'Грант / до 1 400 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Управление образовательными учреждениями.',
//       jobs: ['Директор школы', 'Завуч', 'Методист'],
//     ),
//   ],
//   'kazmed': [
//     const UniversityProgram(
//       id: 'kazmed_medicine',
//       name: 'Общая медицина',
//       degree: 'Специалитет',
//       duration: '6 лет',
//       costRange: 'Грант / до 2 000 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Флагманская программа КазНМУ. Подготовка врачей.',
//       jobs: ['Врач', 'Хирург', 'Терапевт', 'Педиатр', 'Гинеколог'],
//     ),
//     const UniversityProgram(
//       id: 'kazmed_pharm',
//       name: 'Фармация',
//       degree: 'Бакалавриат',
//       duration: '5 лет',
//       costRange: 'Грант / до 2 000 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка фармацевтов для аптек и компаний.',
//       jobs: ['Фармацевт', 'Провизор', 'Медицинский представитель', 'Технолог'],
//     ),
//     const UniversityProgram(
//       id: 'kazmed_dentistry',
//       name: 'Стоматология',
//       degree: 'Специалитет',
//       duration: '5 лет',
//       costRange: 'Грант / до 2 000 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка стоматологов и ортодонтов.',
//       jobs: ['Стоматолог', 'Ортодонт', 'Гигиенист'],
//     ),
//     const UniversityProgram(
//       id: 'kazmed_public_health',
//       name: 'Общественное здравоохранение',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа эпидемиологии и санитарии.',
//       jobs: ['Эпидемиолог', 'Санитарный врач', 'Инспектор здравоохранения'],
//     ),
//     const UniversityProgram(
//       id: 'kazmed_nursing',
//       name: 'Сестринское дело',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 600 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка медицинских сестер и акушерок.',
//       jobs: ['Медицинская сестра', 'Акушерка', 'Palliative Care Nurse'],
//     ),
//     const UniversityProgram(
//       id: 'kazmed_laboratory',
//       name: 'Клиническая лабораторная диагностика',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 600 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка лабораторных диагностов.',
//       jobs: ['Лаборант', 'Технолог лаборатории', 'Микробиолог'],
//     ),
//     const UniversityProgram(
//       id: 'kazmed_radiology',
//       name: 'Медицинская радиология',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка рентгенологов и радиотерапевтов.',
//       jobs: ['Рентгенолог', 'Радиолог', 'Радиотерапевт'],
//     ),
//     const UniversityProgram(
//       id: 'kazmed_surgery',
//       name: 'Хирургия (Магистратура)',
//       degree: 'Магистратура',
//       duration: '2-3 года',
//       costRange: 'Грант / до 2 200 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Специальная подготовка хирургов.',
//       jobs: ['Хирург', 'Кардиохирург', 'Нейрохирург'],
//     ),
//     const UniversityProgram(
//       id: 'kazmed_pediatrics',
//       name: 'Педиатрия (Магистратура)',
//       degree: 'Магистратура',
//       duration: '2-3 года',
//       costRange: 'Грант / до 2 000 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Специальная подготовка педиатров.',
//       jobs: ['Педиатр', 'Неонатолог', 'Детский кардиолог'],
//     ),
//     const UniversityProgram(
//       id: 'kazmed_therapy',
//       name: 'Внутренние болезни (Магистратура)',
//       degree: 'Магистратура',
//       duration: '2-3 года',
//       costRange: 'Грант / до 2 000 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Специальная подготовка терапевтов.',
//       jobs: ['Терапевт', 'Кардиолог', 'Гастроэнтеролог'],
//     ),
//   ],
//   'satpaev': [
//     const UniversityProgram(
//       id: 'satpaev_mining',
//       name: 'Горное дело',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа подготовки горных инженеров.',
//       jobs: ['Горный инженер', 'Геолог', 'Маркшейдер', 'Технолог'],
//     ),
//     const UniversityProgram(
//       id: 'satpaev_metallurgy',
//       name: 'Металлургия',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Подготовка металлургов и техпроцессников.',
//       jobs: ['Металлург', 'Технолог', 'Инженер'],
//     ),
//     const UniversityProgram(
//       id: 'satpaev_geology',
//       name: 'Геология и разведка месторождений',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа геологии и поиска полезных ископаемых.',
//       jobs: ['Геолог', 'Геофизик', 'Инженер', 'Исследователь'],
//     ),
//     const UniversityProgram(
//       id: 'satpaev_construction',
//       name: 'Строительство',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Инженерное строительство и архитектура.',
//       jobs: ['Инженер-строитель', 'Прораб', 'Архитектор'],
//     ),
//     const UniversityProgram(
//       id: 'satpaev_mechanical',
//       name: 'Механическая инженерия',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Проектирование механических систем.',
//       jobs: ['Инженер-механик', 'Конструктор', 'Техник'],
//     ),
//     const UniversityProgram(
//       id: 'satpaev_electrical',
//       name: 'Электроэнергетика',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 800 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Энергетика и электроэнергетические системы.',
//       jobs: ['Электроэнергетик', 'Инженер ЭС', 'Энергетик'],
//     ),
//     const UniversityProgram(
//       id: 'satpaev_safety',
//       name: 'Безопасность жизнедеятельности',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 600 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Охрана труда и промышленная безопасность.',
//       jobs: ['Специалист по БЖД', 'Инженер по ОТ', 'Инспектор'],
//     ),
//     const UniversityProgram(
//       id: 'satpaev_environmental',
//       name: 'Экологическая инженерия',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: 'Грант / до 1 600 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Охрана окружающей среды.',
//       jobs: ['Эколог', 'Инженер-эколог', 'Аналитик'],
//     ),
//     const UniversityProgram(
//       id: 'satpaev_technology',
//       name: 'Технология горного производства',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: 'Грант / до 2 000 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Инновационные технологии в горной промышленности.',
//       jobs: ['Инженер-технолог', 'Руководитель проекта', 'Технолог'],
//     ),
//     const UniversityProgram(
//       id: 'satpaev_management',
//       name: 'Управление в горнодобывающей промышленности',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: 'Грант / до 2 000 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Менеджмент в добывающей отрасли.',
//       jobs: ['Начальник смены', 'Менеджер проекта', 'Директор'],
//     ),
//   ],
//   'almau': [
//     const UniversityProgram(
//       id: 'almau_mba',
//       name: 'MBA',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: '3 000 000 – 4 500 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Программа бизнес-школы AlmaU.',
//       jobs: ['Генеральный директор', 'Топ-менеджер', 'Консультант'],
//     ),
//     const UniversityProgram(
//       id: 'almau_pm',
//       name: 'Управление проектами',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 000 000 – 3 000 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Подготовка project managers с сертификацией PMP.',
//       jobs: ['Project Manager', 'Руководитель проекта', 'PMO Manager'],
//     ),
//     const UniversityProgram(
//       id: 'almau_finance',
//       name: 'Финансовый менеджмент',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 000 000 – 2 500 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа корпоративных финансов и инвестиций.',
//       jobs: ['Финансовый менеджер', 'CFO', 'Инвестиционный аналитик'],
//     ),
//     const UniversityProgram(
//       id: 'almau_marketing',
//       name: 'Стратегический маркетинг',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 000 000 – 2 500 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Программа маркетинговых стратегий и брендинга.',
//       jobs: ['Маркетолог', 'Бренд-менеджер', 'Chief Marketing Officer'],
//     ),
//     const UniversityProgram(
//       id: 'almau_entrepreneurship',
//       name: 'Предпринимательство и стартапы',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 000 000 – 2 500 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Программа инновационного предпринимательства.',
//       jobs: ['Предприниматель', 'Стартапер', 'Инвестор'],
//     ),
//     const UniversityProgram(
//       id: 'almau_hm',
//       name: 'Управление человеческими ресурсами',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 000 000 – 2 500 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Управление персоналом и организационное развитие.',
//       jobs: ['HR-менеджер', 'Директор по персоналу', 'Организационный консультант'],
//     ),
//     const UniversityProgram(
//       id: 'almau_business',
//       name: 'Бизнес-администрирование',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 000 000 – 2 500 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Бизнес-администрирование и управление операциями.',
//       jobs: ['Бизнес-администратор', 'Операционный менеджер'],
//     ),
//     const UniversityProgram(
//       id: 'almau_supply_chain',
//       name: 'Логистика и цепи поставок',
//       degree: 'Бакалавриат',
//       duration: '4 года',
//       costRange: '2 000 000 – 2 500 000 ₸/год',
//       languages: ['Казахский', 'Русский'],
//       description: 'Управление цепями поставок и логистика.',
//       jobs: ['Логист', 'SCM-менеджер', 'Менеджер закупок'],
//     ),
//     const UniversityProgram(
//       id: 'almau_finance_master',
//       name: 'MBA в области финансов',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: '3 500 000 – 4 500 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Специализированная MBA по финансам.',
//       jobs: ['CFO', 'Финансовый директор', 'Инвестиционный банкир'],
//     ),
//     const UniversityProgram(
//       id: 'almau_exec_mba',
//       name: 'Executive MBA',
//       degree: 'Магистратура',
//       duration: '2 года',
//       costRange: '4 000 000 – 5 000 000 ₸/год',
//       languages: ['Казахский', 'Русский', 'Английский'],
//       description: 'Программа для руководителей с опытом.',
//       jobs: ['Генеральный директор', 'Вице-президент', 'Председатель правления'],
//     ),
//   ],
// };

// // ─── НОВОСТИ (5 шт на ВУЗ) ────────────────────────────────────────────────────

// final Map<String, List<UniversityNews>> kSeedNews = {
//   'kimep': [
//     UniversityNews(
//       id: 'kimep_news_1',
//       title: 'KIMEP вошёл в топ-500 университетов QS Asia 2025',
//       body: 'KIMEP улучшил позиции в рейтинге QS Asia Rankings 2025, войдя в топ-500 лучших университетов Азии.',
//       publishedAt: DateTime(2025, 3, 15),
//     ),
//     UniversityNews(
//       id: 'kimep_news_2',
//       title: 'День открытых дверей — 15 апреля 2025',
//       body: 'KIMEP приглашает абитуриентов на День открытых дверей.',
//       publishedAt: DateTime(2025, 4, 1),
//     ),
//     UniversityNews(
//       id: 'kimep_news_3',
//       title: 'Студенты KIMEP победили на международном кейс-чемпионате',
//       body: 'Команда студентов бизнес-школы KIMEP заняла первое место на кейс-чемпионате в Сингапуре.',
//       publishedAt: DateTime(2025, 2, 20),
//     ),
//     UniversityNews(
//       id: 'kimep_news_4',
//       title: 'KIMEP запускает программу стажировок в Goldman Sachs',
//       body: 'Студенты KIMEP получат возможность пройти стажировку в Goldman Sachs.',
//       publishedAt: DateTime(2025, 1, 30),
//     ),
//     UniversityNews(
//       id: 'kimep_news_5',
//       title: 'Нобелевский лауреат прочитал лекцию в KIMEP',
//       body: 'Нобелевский лауреат по экономике посетил KIMEP и провел открытую лекцию.',
//       publishedAt: DateTime(2025, 2, 5),
//     ),
//   ],
//   'kaznu': [
//     UniversityNews(
//       id: 'kaznu_news_1',
//       title: 'КазНУ запускает новую лабораторию искусственного интеллекта',
//       body: 'КазНУ открыл современную лабораторию ИИ при поддержке Samsung.',
//       publishedAt: DateTime(2025, 4, 10),
//     ),
//     UniversityNews(
//       id: 'kaznu_news_2',
//       title: 'Приём документов для абитуриентов 2025 года',
//       body: 'КазНУ объявляет о начале приёма документов для поступающих на 2025–2026 год.',
//       publishedAt: DateTime(2025, 5, 1),
//     ),
//     UniversityNews(
//       id: 'kaznu_news_3',
//       title: 'Научная конференция «Аль-Фараби и современность»',
//       body: 'Ежегодная международная научная конференция состоится 20–22 мая.',
//       publishedAt: DateTime(2025, 5, 5),
//     ),
//     UniversityNews(
//       id: 'kaznu_news_4',
//       title: 'КазНУ получил грант на развитие научных исследований',
//       body: 'КазНУ получил грант размером 2 млрд тенге на развитие научных исследований.',
//       publishedAt: DateTime(2025, 3, 20),
//     ),
//     UniversityNews(
//       id: 'kaznu_news_5',
//       title: 'Выпускники КазНУ получили стипендии на магистратуру за рубежом',
//       body: 'Пять выпускников КазНУ получили стипендии на обучение в престижных университетах.',
//       publishedAt: DateTime(2025, 4, 15),
//     ),
//   ],
//   'kbtu': [
//     UniversityNews(
//       id: 'kbtu_news_1',
//       title: 'КБТУ подписал соглашение с Chevron о стажировках',
//       body: 'КБТУ подписал соглашение о партнёрстве с компанией Chevron.',
//       publishedAt: DateTime(2025, 3, 5),
//     ),
//     UniversityNews(
//       id: 'kbtu_news_2',
//       title: 'Хакатон KBTU Tech Challenge 2025 — регистрация открыта',
//       body: 'КБТУ проводит ежегодный хакатон. Призовой фонд — 5 000 000 тенге.',
//       publishedAt: DateTime(2025, 4, 5),
//     ),
//     UniversityNews(
//       id: 'kbtu_news_3',
//       title: 'КБТУ построил новый инженерный корпус',
//       body: 'На территории КБТУ завершено строительство нового инженерного корпуса.',
//       publishedAt: DateTime(2025, 2, 28),
//     ),
//     UniversityNews(
//       id: 'kbtu_news_4',
//       title: 'Студенты КБТУ выиграли конкурс инженерного проектирования',
//       body: 'Команда студентов КБТУ победила в международном конкурсе.',
//       publishedAt: DateTime(2025, 3, 12),
//     ),
//     UniversityNews(
//       id: 'kbtu_news_5',
//       title: 'КБТУ стал центром подготовки кадров для EXPO 2025',
//       body: 'КБТУ официально объявлен центром подготовки для EXPO 2025.',
//       publishedAt: DateTime(2025, 1, 20),
//     ),
//   ],
//   'iitu': [
//     UniversityNews(
//       id: 'iitu_news_1',
//       title: 'МУИТ запускает программу двойного диплома с университетом Иннополис',
//       body: 'МУИТ подписал соглашение о программе двойного диплома по кибербезопасности.',
//       publishedAt: DateTime(2025, 3, 20),
//     ),
//     UniversityNews(
//       id: 'iitu_news_2',
//       title: 'Студенты МУИТ заняли 2-е место на ICPC 2025',
//       body: 'Команда МУИТ вошла в тройку лидеров Международной олимпиады по программированию.',
//       publishedAt: DateTime(2025, 2, 10),
//     ),
//     UniversityNews(
//       id: 'iitu_news_3',
//       title: 'МУИТ получил аккредитацию ABET для IT-программ',
//       body: 'МУИТ получил международную аккредитацию ABET для всех IT-специальностей.',
//       publishedAt: DateTime(2025, 4, 8),
//     ),
//     UniversityNews(
//       id: 'iitu_news_4',
//       title: 'Открыт инновационный центр блокчейна в МУИТ',
//       body: 'В МУИТ открыт инновационный центр исследования блокчейна.',
//       publishedAt: DateTime(2025, 2, 18),
//     ),
//     UniversityNews(
//       id: 'iitu_news_5',
//       title: 'МУИТ включён в топ-100 IT-университетов мира',
//       body: 'МУИТ вошёл в список топ-100 лучших IT-университетов мира.',
//       publishedAt: DateTime(2025, 1, 15),
//     ),
//   ],
//   'narxoz': [
//     UniversityNews(
//       id: 'narxoz_news_1',
//       title: 'Нархоз получил международную аккредитацию EPAS',
//       body: 'Университет Нархоз успешно прошёл аккредитацию EPAS.',
//       publishedAt: DateTime(2025, 1, 15),
//     ),
//     UniversityNews(
//       id: 'narxoz_news_2',
//       title: 'Карьерная ярмарка Narxoz Career Fair 2025',
//       body: 'Университет Нархоз приглашает на ежегодную карьерную ярмарку.',
//       publishedAt: DateTime(2025, 4, 20),
//     ),
//     UniversityNews(
//       id: 'narxoz_news_3',
//       title: 'Нархоз запускает программу корпоративного лидерства',
//       body: 'Нархоз объявляет о новой программе развития лидерских компетенций.',
//       publishedAt: DateTime(2025, 3, 25),
//     ),
//     UniversityNews(
//       id: 'narxoz_news_4',
//       title: 'Выпускники Нархоза получили работу в ведущих компаниях',
//       body: 'Выпускники получили предложения работы от JPMorgan, Kaspi.kz, KPMG.',
//       publishedAt: DateTime(2025, 2, 5),
//     ),
//     UniversityNews(
//       id: 'narxoz_news_5',
//       title: 'Нархоз вошёл в топ-50 бизнес-школ Азии',
//       body: 'Университет признан одной из лучших бизнес-школ Азии.',
//       publishedAt: DateTime(2025, 3, 1),
//     ),
//   ],
//   'kaznpu': [
//     UniversityNews(
//       id: 'kaznpu_news_1',
//       title: 'КазНПУ запускает новую магистерскую программу по EdTech',
//       body: 'КазНПУ запускает магистерскую программу «Образовательные технологии».',
//       publishedAt: DateTime(2025, 4, 8),
//     ),
//     UniversityNews(
//       id: 'kaznpu_news_2',
//       title: 'Педагогическая олимпиада среди студентов — итоги',
//       body: 'Студенты КазНПУ заняли первое место в номинациях олимпиады.',
//       publishedAt: DateTime(2025, 3, 12),
//     ),
//     UniversityNews(
//       id: 'kaznpu_news_3',
//       title: 'КазНПУ получил грант на развитие цифровых учебных ресурсов',
//       body: 'КазНПУ получил грант в размере 500 млн тенге.',
//       publishedAt: DateTime(2025, 2, 20),
//     ),
//     UniversityNews(
//       id: 'kaznpu_news_4',
//       title: 'Открыта лаборатория инновационных педагогических технологий',
//       body: 'В КазНПУ открыта современная лаборатория для разработки подходов в образовании.',
//       publishedAt: DateTime(2025, 3, 5),
//     ),
//     UniversityNews(
//       id: 'kaznpu_news_5',
//       title: 'КазНПУ организует международную конференцию педагогов',
//       body: 'КазНПУ проводит Международную конференцию педагогов.',
//       publishedAt: DateTime(2025, 4, 25),
//     ),
//   ],
//   'kazmed': [
//     UniversityNews(
//       id: 'kazmed_news_1',
//       title: 'КазНМУ открыл клинику симуляционного обучения',
//       body: 'КазНМУ открыл симуляционный центр стоимостью 2 млрд тенге.',
//       publishedAt: DateTime(2025, 2, 15),
//     ),
//     UniversityNews(
//       id: 'kazmed_news_2',
//       title: 'Грантовый приём 2025: увеличено число мест',
//       body: 'Министерство здравоохранения увеличило квоту грантов для КазНМУ на 150 мест.',
//       publishedAt: DateTime(2025, 5, 1),
//     ),
//     UniversityNews(
//       id: 'kazmed_news_3',
//       title: 'КазНМУ получил признание как центр кардиохирургии в ЦА',
//       body: 'КазНМУ официально признан лучшим центром кардиохирургии в Центральной Азии.',
//       publishedAt: DateTime(2025, 3, 10),
//     ),
//     UniversityNews(
//       id: 'kazmed_news_4',
//       title: 'Студенты КазНМУ выигрывают медицинский чемпионат',
//       body: 'Команда студентов КазНМУ победила в молодёжном чемпионате.',
//       publishedAt: DateTime(2025, 2, 28),
//     ),
//     UniversityNews(
//       id: 'kazmed_news_5',
//       title: 'КазНМУ подписал соглашение с Johns Hopkins',
//       body: 'КазНМУ подписал соглашение о совместных исследованиях с Johns Hopkins.',
//       publishedAt: DateTime(2025, 1, 25),
//     ),
//   ],
//   'satpaev': [
//     UniversityNews(
//       id: 'satpaev_news_1',
//       title: 'Satbayev открыл центр горнодобывающих технологий',
//       body: 'Университет Сатбаева открыл уникальный центр горнодобывающих технологий.',
//       publishedAt: DateTime(2025, 3, 1),
//     ),
//     UniversityNews(
//       id: 'satpaev_news_2',
//       title: 'Грантовый конкурс для абитуриентов 2025',
//       body: 'Satbayev объявляет конкурс на получение корпоративных грантов.',
//       publishedAt: DateTime(2025, 4, 15),
//     ),
//     UniversityNews(
//       id: 'satpaev_news_3',
//       title: 'Satbayev подписал соглашение с ArcelorMittal',
//       body: 'Университет Сатбаева подписал долгосрочное соглашение с ArcelorMittal.',
//       publishedAt: DateTime(2025, 2, 10),
//     ),
//     UniversityNews(
//       id: 'satpaev_news_4',
//       title: 'Выпускники Satbayev работают в ведущих компаниях',
//       body: 'Выпускники университета успешно работают в ведущих горнодобывающих компаниях.',
//       publishedAt: DateTime(2025, 3, 20),
//     ),
//     UniversityNews(
//       id: 'satpaev_news_5',
//       title: 'Satbayev принял участие в International Mining Forum',
//       body: 'Университет Сатбаева участвовал в Международном горном форуме.',
//       publishedAt: DateTime(2025, 4, 10),
//     ),
//   ],
//   'almau': [
//     UniversityNews(
//       id: 'almau_news_1',
//       title: 'AlmaU вошёл в топ-5 бизнес-школ СНГ',
//       body: 'Алматы Менеджмент Университет занял 4-е место в рейтинге бизнес-школ СНГ.',
//       publishedAt: DateTime(2025, 2, 28),
//     ),
//     UniversityNews(
//       id: 'almau_news_2',
//       title: 'Мастер-класс от CEO Kaspi.kz для студентов AlmaU',
//       body: 'CEO Kaspi.kz провёл открытый мастер-класс для студентов.',
//       publishedAt: DateTime(2025, 3, 25),
//     ),
//     UniversityNews(
//       id: 'almau_news_3',
//       title: 'AlmaU запускает программу Executive MBA',
//       body: 'AlmaU объявляет о запуске новой программы Executive MBA.',
//       publishedAt: DateTime(2025, 4, 1),
//     ),
//     UniversityNews(
//       id: 'almau_news_4',
//       title: 'Выпускники AlmaU получили должности в Goldman Sachs',
//       body: 'Несколько выпускников AlmaU получили должности в Goldman Sachs.',
//       publishedAt: DateTime(2025, 3, 15),
//     ),
//     UniversityNews(
//       id: 'almau_news_5',
//       title: 'AlmaU получил грант на развитие исследований',
//       body: 'AlmaU получил грант в размере 800 млн тенге.',
//       publishedAt: DateTime(2025, 2, 1),
//     ),
//   ],
// };

import 'package:stiky/data/news/university_news_model.dart';
import 'package:stiky/data/programs/university_program_model.dart';

/// Полные seed-данные программ и новостей для всех 20 вузов.
///
/// Использование (например в SettingsScreen в debug-режиме):
/// ```dart
/// for (final e in kSeedPrograms.entries) {
///   await programRepo.seedPrograms(e.key, e.value);
/// }
/// for (final e in kSeedNews.entries) {
///   await newsRepo.seedNews(e.key, e.value);
/// }
/// ```

// ─── ПРОГРАММЫ ────────────────────────────────────────────────────────────────

final Map<String, List<UniversityProgram>> kSeedPrograms = {

  // ── Назарбаев Университет ─────────────────────────────────────────────────
  'nu': [
    const UniversityProgram(
      id: 'nu_cs',
      name: 'Computer Science',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '1 800 000 – 2 200 000 ₸/год',
      languages: ['Английский'],
      description:
          'Одна из сильнейших CS-программ в Казахстане. Алгоритмы, машинное обучение, '
          'системное программирование. Преподаватели с PhD из топ-университетов мира.',
      jobs: ['Software Engineer', 'Data Scientist', 'ML Engineer', 'Research Scientist'],
    ),
    const UniversityProgram(
      id: 'nu_medicine',
      name: 'Медицина',
      degree: 'Бакалавриат',
      duration: '6 лет',
      costRange: '1 500 000 – 2 000 000 ₸/год',
      languages: ['Английский'],
      description:
          'Программа по стандартам американских медицинских школ. Клиническая практика '
          'с 3-го курса в университетской больнице.',
      jobs: ['Врач', 'Хирург', 'Терапевт', 'Педиатр', 'Исследователь'],
    ),
    const UniversityProgram(
      id: 'nu_business',
      name: 'Business Administration',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '1 800 000 – 2 200 000 ₸/год',
      languages: ['Английский'],
      description:
          'Программа с аккредитацией AACSB. Финансы, менеджмент, предпринимательство. '
          'Обязательный семестр обмена в зарубежном университете.',
      jobs: ['Менеджер', 'Финансовый аналитик', 'Консультант', 'Предприниматель'],
    ),
    const UniversityProgram(
      id: 'nu_engineering',
      name: 'Chemical and Materials Engineering',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '1 800 000 – 2 200 000 ₸/год',
      languages: ['Английский'],
      description:
          'Инженерная программа мирового уровня. Лаборатории с новейшим оборудованием. '
          'Партнёрство с Shell, Chevron, KazMunayGas.',
      jobs: ['Инженер-технолог', 'Нефтехимик', 'Материаловед', 'Исследователь'],
    ),
    const UniversityProgram(
      id: 'nu_law',
      name: 'Law',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '1 800 000 – 2 200 000 ₸/год',
      languages: ['Английский'],
      description:
          'Программа по международному и казахстанскому праву. Moot Court competitions, '
          'стажировки в ведущих юридических фирмах.',
      jobs: ['Юрист', 'Адвокат', 'Корпоративный советник', 'Судья'],
    ),
  ],

  // ── КИМЭП ─────────────────────────────────────────────────────────────────
  'kimep': [
    const UniversityProgram(
      id: 'kimep_bba',
      name: 'Bachelor of Business Administration',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '2 800 000 – 3 200 000 ₸/год',
      languages: ['Английский'],
      description:
          'Флагманская программа KIMEP с аккредитацией AACSB. Менеджмент, маркетинг, '
          'финансы, предпринимательство. Высокий уровень трудоустройства.',
      jobs: ['Менеджер', 'Маркетолог', 'Финансовый аналитик', 'Предприниматель'],
    ),
    const UniversityProgram(
      id: 'kimep_law',
      name: 'Юриспруденция (LLB)',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '2 800 000 – 3 200 000 ₸/год',
      languages: ['Английский'],
      description:
          'Программа по международному и казахстанскому праву. '
          'Студенты участвуют в международных Moot Court соревнованиях.',
      jobs: ['Юрист', 'Адвокат', 'Корпоративный советник', 'Нотариус'],
    ),
    const UniversityProgram(
      id: 'kimep_mba',
      name: 'MBA',
      degree: 'Магистратура',
      duration: '2 года',
      costRange: '3 500 000 – 4 200 000 ₸/год',
      languages: ['Английский'],
      description:
          'Флагманская программа MBA с аккредитацией AACSB. '
          'Специализации: General Management, Finance, Marketing.',
      jobs: ['CEO', 'Директор', 'Топ-менеджер', 'Консультант'],
    ),
    const UniversityProgram(
      id: 'kimep_media',
      name: 'Медиа и коммуникации',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '2 500 000 – 3 000 000 ₸/год',
      languages: ['Английский'],
      description:
          'Журналистика, PR, digital-маркетинг, телевидение и радио. '
          'Практика в ведущих медиакомпаниях Казахстана.',
      jobs: ['Журналист', 'PR-менеджер', 'SMM-специалист', 'Редактор'],
    ),
  ],

  // ── SDU ──────────────────────────────────────────────────────────────────
  'sdu': [
    const UniversityProgram(
      id: 'sdu_cs',
      name: 'Информационные технологии',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '700 000 – 1 200 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Разработка ПО, базы данных, сети, кибербезопасность. '
          'Современные лаборатории, партнёрство с IT-компаниями.',
      jobs: ['Программист', 'Системный администратор', 'Аналитик', 'DevOps'],
    ),
    const UniversityProgram(
      id: 'sdu_business',
      name: 'Менеджмент',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '700 000 – 1 200 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Управление бизнесом, финансы, маркетинг. Практические кейсы '
          'от реальных компаний-партнёров.',
      jobs: ['Менеджер', 'Маркетолог', 'HR-специалист', 'Предприниматель'],
    ),
    const UniversityProgram(
      id: 'sdu_engineering',
      name: 'Инженерия',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '700 000 – 1 500 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Программы по механической, электрической и строительной инженерии. '
          'Оснащённые лаборатории и производственная практика.',
      jobs: ['Инженер', 'Конструктор', 'Технолог', 'Проектировщик'],
    ),
    const UniversityProgram(
      id: 'sdu_pedagogy',
      name: 'Педагогика',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '700 000 – 1 000 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Подготовка учителей начальных и средних классов. '
          'Педагогическая практика со 2-го курса в лучших школах.',
      jobs: ['Учитель', 'Педагог', 'Воспитатель', 'Методист'],
    ),
  ],

  // ── КБТУ ─────────────────────────────────────────────────────────────────
  'kbtu': [
    const UniversityProgram(
      id: 'kbtu_se',
      name: 'Программная инженерия',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '2 200 000 – 3 000 000 ₸/год',
      languages: ['Английский', 'Русский'],
      description:
          'Совместная программа с британскими университетами. '
          'Разработка ПО, архитектура систем, agile-методологии.',
      jobs: ['Backend-разработчик', 'Архитектор ПО', 'Tech Lead', 'CTO'],
    ),
    const UniversityProgram(
      id: 'kbtu_oil',
      name: 'Нефтегазовая инженерия',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '2 500 000 – 3 500 000 ₸/год',
      languages: ['Английский'],
      description:
          'Совместная программа с University of London. '
          'Подготовка инженеров для нефтегазовой отрасли.',
      jobs: ['Нефтяной инженер', 'Геолог', 'Буровой инженер', 'Менеджер проекта'],
    ),
    const UniversityProgram(
      id: 'kbtu_biz',
      name: 'Бизнес и менеджмент',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '2 200 000 – 2 800 000 ₸/год',
      languages: ['Английский'],
      description:
          'Британская аккредитация. Подготовка менеджеров '
          'для международных компаний.',
      jobs: ['Менеджер', 'Консультант', 'Бизнес-аналитик', 'Предприниматель'],
    ),
    const UniversityProgram(
      id: 'kbtu_data',
      name: 'Data Science',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '2 200 000 – 3 000 000 ₸/год',
      languages: ['Английский'],
      description:
          'Машинное обучение, анализ больших данных, статистика. '
          'Проекты с реальными данными от компаний-партнёров.',
      jobs: ['Data Scientist', 'ML Engineer', 'Data Analyst', 'AI Researcher'],
    ),
  ],

  // ── МУИТ ─────────────────────────────────────────────────────────────────
  'iitu': [
    const UniversityProgram(
      id: 'iitu_cs',
      name: 'Вычислительная техника и программирование',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 1 600 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Флагманская программа МУИТ. Охватывает разработку ПО, '
          'базы данных, сети и ИИ.',
      jobs: ['Программист', 'Разработчик', 'Аналитик', 'Тестировщик'],
    ),
    const UniversityProgram(
      id: 'iitu_cyber',
      name: 'Кибербезопасность',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 1 600 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Защита информации, этический хакинг, криптография. '
          'Востребована государственными структурами и банками.',
      jobs: ['Специалист по ИБ', 'Пентестер', 'SOC-аналитик', 'CISO'],
    ),
    const UniversityProgram(
      id: 'iitu_ai',
      name: 'Искусственный интеллект',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 1 600 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Нейронные сети, компьютерное зрение, NLP, робототехника. '
          'Лаборатория ИИ с GPU-кластером.',
      jobs: ['AI Engineer', 'ML Engineer', 'Computer Vision Engineer', 'NLP Engineer'],
    ),
    const UniversityProgram(
      id: 'iitu_design',
      name: 'Дизайн и мультимедиа',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 1 400 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'UI/UX дизайн, графический дизайн, 3D-моделирование, '
          'анимация и игровой дизайн.',
      jobs: ['UI/UX Designer', 'Graphic Designer', '3D Artist', 'Game Designer'],
    ),
  ],

  // ── AITU ─────────────────────────────────────────────────────────────────
  'aitu': [
    const UniversityProgram(
      id: 'aitu_se',
      name: 'Software Engineering',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '800 000 – 1 800 000 ₸/год',
      languages: ['Английский', 'Казахский'],
      description:
          'Разработка ПО нового поколения. Agile, DevOps, '
          'облачные технологии, микросервисная архитектура.',
      jobs: ['Software Engineer', 'Backend Developer', 'DevOps', 'Cloud Architect'],
    ),
    const UniversityProgram(
      id: 'aitu_ds',
      name: 'Data Science and AI',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '800 000 – 1 800 000 ₸/год',
      languages: ['Английский', 'Казахский'],
      description:
          'Большие данные, машинное обучение, ИИ-приложения. '
          'Практика в технологических компаниях Астаны.',
      jobs: ['Data Scientist', 'AI Engineer', 'Big Data Engineer', 'Data Analyst'],
    ),
    const UniversityProgram(
      id: 'aitu_cyber',
      name: 'Кибербезопасность',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '800 000 – 1 800 000 ₸/год',
      languages: ['Английский', 'Казахский'],
      description:
          'Защита критической инфраструктуры, форензика, '
          'этический хакинг. Сотрудничество с госструктурами.',
      jobs: ['Cybersecurity Analyst', 'Penetration Tester', 'Forensic Expert', 'CISO'],
    ),
  ],

  // ── КазНТУ (Сатбаев) ──────────────────────────────────────────────────────
  'kazntu': [
    const UniversityProgram(
      id: 'kazntu_mining',
      name: 'Горное дело',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 900 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Открытая и подземная добыча полезных ископаемых. '
          'Практика на крупнейших горнодобывающих предприятиях Казахстана.',
      jobs: ['Горный инженер', 'Маркшейдер', 'Геолог', 'Технолог'],
    ),
    const UniversityProgram(
      id: 'kazntu_it',
      name: 'Информационные системы',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 900 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'IT-программа с уклоном в промышленную автоматизацию '
          'и цифровую трансформацию производства.',
      jobs: ['IT-инженер', 'Разработчик', 'Системный аналитик', 'SCADA-инженер'],
    ),
    const UniversityProgram(
      id: 'kazntu_oil',
      name: 'Нефтегазовое дело',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 900 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Разведка и добыча нефти и газа. Партнёрство '
          'с KazMunayGas, Tengizchevroil, NCOC.',
      jobs: ['Нефтяник', 'Газовик', 'Буровик', 'Геофизик'],
    ),
    const UniversityProgram(
      id: 'kazntu_arch',
      name: 'Архитектура',
      degree: 'Бакалавриат',
      duration: '5 лет',
      costRange: 'Грант / до 900 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Проектирование зданий и городской среды. '
          'Студия проектирования, практика в ведущих архитектурных бюро.',
      jobs: ['Архитектор', 'Урбанист', 'BIM-специалист', 'Дизайнер интерьера'],
    ),
  ],

  // ── КазНУ ─────────────────────────────────────────────────────────────────
  'kaznu': [
    const UniversityProgram(
      id: 'kaznu_cs',
      name: 'Информатика',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 800 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Алгоритмы, структуры данных, ИИ, разработка ПО. '
          'Сильный математический фундамент.',
      jobs: ['Разработчик', 'Data Scientist', 'Системный аналитик', 'DevOps'],
    ),
    const UniversityProgram(
      id: 'kaznu_law',
      name: 'Юриспруденция',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 800 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Одна из старейших юридических программ Казахстана. '
          'Гражданское, уголовное, международное право.',
      jobs: ['Юрист', 'Прокурор', 'Судья', 'Нотариус'],
    ),
    const UniversityProgram(
      id: 'kaznu_med',
      name: 'Общая медицина',
      degree: 'Бакалавриат',
      duration: '5 лет',
      costRange: 'Грант / до 800 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Подготовка врачей общей практики. Клиническая практика '
          'на базе ведущих больниц Алматы.',
      jobs: ['Врач', 'Терапевт', 'Педиатр', 'Хирург'],
    ),
    const UniversityProgram(
      id: 'kaznu_econ',
      name: 'Экономика',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 800 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Макроэкономика, эконометрика, международные финансы. '
          'Подготовка аналитиков и государственных служащих.',
      jobs: ['Экономист', 'Аналитик', 'Финансист', 'Госслужащий'],
    ),
    const UniversityProgram(
      id: 'kaznu_biology',
      name: 'Биология',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 800 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Молекулярная биология, генетика, экология. '
          'Исследовательские лаборатории, гранты на научные проекты.',
      jobs: ['Биолог', 'Генетик', 'Эколог', 'Биотехнолог'],
    ),
  ],

  // ── ЕНУ ───────────────────────────────────────────────────────────────────
  'eurasian': [
    const UniversityProgram(
      id: 'enu_law',
      name: 'Юриспруденция',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 850 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Подготовка юристов широкого профиля. Практика '
          'в государственных органах и частных юридических фирмах.',
      jobs: ['Юрист', 'Прокурор', 'Адвокат', 'Нотариус'],
    ),
    const UniversityProgram(
      id: 'enu_econ',
      name: 'Экономика и менеджмент',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 850 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Управление предприятием, финансы, бухгалтерский учёт. '
          'Стажировки в госкорпорациях и частных компаниях.',
      jobs: ['Экономист', 'Менеджер', 'Бухгалтер', 'Финансовый аналитик'],
    ),
    const UniversityProgram(
      id: 'enu_it',
      name: 'Информационные технологии',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 850 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Разработка ПО, системное администрирование, '
          'кибербезопасность и цифровые государственные сервисы.',
      jobs: ['Программист', 'Системный администратор', 'IT-аналитик', 'DevOps'],
    ),
  ],

  // ── AlmaU ─────────────────────────────────────────────────────────────────
  'almau': [
    const UniversityProgram(
      id: 'almau_mba',
      name: 'MBA (General Management)',
      degree: 'Магистратура (MBA)',
      duration: '2 года',
      costRange: '3 500 000 – 5 000 000 ₸/год',
      languages: ['Русский', 'Английский'],
      description:
          'Флагманская программа MBA AlmaU с аккредитацией AMBA. '
          'Вечерний и weekend-формат для работающих специалистов.',
      jobs: ['CEO', 'Директор', 'Топ-менеджер', 'Консультант'],
    ),
    const UniversityProgram(
      id: 'almau_marketing',
      name: 'Маркетинг',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '1 800 000 – 2 800 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Digital-маркетинг, брендинг, маркетинговая аналитика. '
          'Партнёрство с ведущими рекламными агентствами.',
      jobs: ['Маркетолог', 'Бренд-менеджер', 'SMM-специалист', 'Директор по маркетингу'],
    ),
    const UniversityProgram(
      id: 'almau_finance',
      name: 'Финансы',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '1 800 000 – 2 800 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Корпоративные финансы, инвестиции, банковское дело. '
          'Подготовка для работы в банках и инвестфондах.',
      jobs: ['Финансовый аналитик', 'Инвестиционный менеджер', 'Банкир', 'CFO'],
    ),
  ],

  // ── Нархоз ────────────────────────────────────────────────────────────────
  'narxoz': [
    const UniversityProgram(
      id: 'narxoz_fin',
      name: 'Финансы',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '1 500 000 – 2 200 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Международная аккредитация. Подготовка финансистов '
          'для банков, инвестфондов и корпораций.',
      jobs: ['Финансовый аналитик', 'Банкир', 'Инвестиционный менеджер', 'CFO'],
    ),
    const UniversityProgram(
      id: 'narxoz_digit',
      name: 'Цифровой бизнес',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '1 500 000 – 2 200 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'IT и бизнес: digital-маркетинг, e-commerce, '
          'продуктовый менеджмент, стартапы.',
      jobs: ['Product Manager', 'Digital-маркетолог', 'Growth-менеджер', 'Стартапер'],
    ),
    const UniversityProgram(
      id: 'narxoz_law',
      name: 'Юриспруденция',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '1 500 000 – 2 000 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Корпоративное право, налоговое право, международное частное право. '
          'Партнёрство с юридическими фирмами Big4.',
      jobs: ['Юрист', 'Корпоративный советник', 'Налоговый консультант', 'Адвокат'],
    ),
  ],

  // ── КазНМУ ────────────────────────────────────────────────────────────────
  'meduniver': [
    const UniversityProgram(
      id: 'kazmed_general',
      name: 'Общая медицина',
      degree: 'Бакалавриат',
      duration: '6 лет',
      costRange: 'Грант / до 1 200 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Флагманская программа КазНМУ. Подготовка врачей широкого профиля. '
          'Клиническая практика в больницах Алматы с 3-го курса.',
      jobs: ['Врач', 'Хирург', 'Терапевт', 'Педиатр', 'Гинеколог'],
    ),
    const UniversityProgram(
      id: 'kazmed_pharm',
      name: 'Фармация',
      degree: 'Бакалавриат',
      duration: '5 лет',
      costRange: 'Грант / до 1 200 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Подготовка фармацевтов для аптек, фармкомпаний '
          'и научно-исследовательских лабораторий.',
      jobs: ['Фармацевт', 'Провизор', 'Медицинский представитель', 'Технолог'],
    ),
    const UniversityProgram(
      id: 'kazmed_stom',
      name: 'Стоматология',
      degree: 'Бакалавриат',
      duration: '5 лет',
      costRange: 'Грант / до 1 200 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Терапевтическая, хирургическая и ортопедическая стоматология. '
          'Клиническая база с современным оборудованием.',
      jobs: ['Стоматолог', 'Хирург-стоматолог', 'Ортодонт', 'Имплантолог'],
    ),
  ],

  // ── АГА ───────────────────────────────────────────────────────────────────
  'caa': [
    const UniversityProgram(
      id: 'caa_aviation',
      name: 'Лётная эксплуатация воздушных судов',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '900 000 – 1 500 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Подготовка пилотов гражданской авиации. Практические полёты '
          'на тренажёрах и реальных воздушных судах.',
      jobs: ['Пилот', 'Командир воздушного судна', 'Авиационный диспетчер'],
    ),
    const UniversityProgram(
      id: 'caa_engineering',
      name: 'Техническое обслуживание воздушных судов',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '900 000 – 1 500 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Инженерное обслуживание самолётов и вертолётов. '
          'Практика в Air Astana, SCAT и других авиакомпаниях.',
      jobs: ['Авиационный инженер', 'Техник по обслуживанию ВС', 'Инспектор'],
    ),
    const UniversityProgram(
      id: 'caa_logistics',
      name: 'Организация перевозок и управление на транспорте',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '700 000 – 1 200 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Логистика авиационных перевозок, управление аэропортами. '
          'Широкий спектр трудоустройства в транспортной отрасли.',
      jobs: ['Логист', 'Менеджер аэропорта', 'Специалист по перевозкам'],
    ),
  ],

  // ── КазУМОиМЯ ─────────────────────────────────────────────────────────────
  'ablaikhan': [
    const UniversityProgram(
      id: 'ablai_linguistics',
      name: 'Лингвистика',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 800 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Теория языка, переводоведение, межкультурная коммуникация. '
          'Изучение 2-3 иностранных языков.',
      jobs: ['Лингвист', 'Переводчик', 'Преподаватель иностранного языка', 'Редактор'],
    ),
    const UniversityProgram(
      id: 'ablai_translation',
      name: 'Перевод и переводоведение',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 800 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Письменный и устный перевод (английский, немецкий, французский, '
          'китайский, арабский). Практика в международных организациях.',
      jobs: ['Переводчик', 'Синхронный переводчик', 'Локализатор', 'Редактор'],
    ),
    const UniversityProgram(
      id: 'ablai_ir',
      name: 'Международные отношения',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 800 000 ₸/год',
      languages: ['Казахский', 'Русский', 'Английский'],
      description:
          'Дипломатия, международное право, геополитика. '
          'Стажировки в МИД Казахстана и международных организациях.',
      jobs: ['Дипломат', 'Международный аналитик', 'Атташе', 'Советник'],
    ),
  ],

  // ── КАЗГЮУ ────────────────────────────────────────────────────────────────
  'kazguu': [
    const UniversityProgram(
      id: 'kazguu_law',
      name: 'Юриспруденция',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '600 000 – 1 300 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Уголовное, гражданское, корпоративное право. '
          'Юридическая клиника, практика в судах и прокуратуре.',
      jobs: ['Юрист', 'Адвокат', 'Прокурор', 'Следователь'],
    ),
    const UniversityProgram(
      id: 'kazguu_biz',
      name: 'Бизнес и менеджмент',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '600 000 – 1 300 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Управление бизнесом, маркетинг, HR. '
          'Кейс-чемпионаты и практические проекты.',
      jobs: ['Менеджер', 'HR-специалист', 'Маркетолог', 'Предприниматель'],
    ),
    const UniversityProgram(
      id: 'kazguu_it',
      name: 'Информационные технологии',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '600 000 – 1 300 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Разработка ПО, веб-разработка, мобильные приложения. '
          'Лаборатория инноваций и стартап-инкубатор.',
      jobs: ['Программист', 'Веб-разработчик', 'Мобильный разработчик', 'IT-аналитик'],
    ),
    const UniversityProgram(
      id: 'kazguu_psych',
      name: 'Психология',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '600 000 – 1 300 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Клиническая и организационная психология. '
          'Психологическая служба, практика в школах и клиниках.',
      jobs: ['Психолог', 'Клинический психолог', 'HR-специалист', 'Коуч'],
    ),
  ],

  // ── Мирас ─────────────────────────────────────────────────────────────────
  'miras': [
    const UniversityProgram(
      id: 'miras_med',
      name: 'Общая медицина',
      degree: 'Бакалавриат',
      duration: '6 лет',
      costRange: '350 000 – 750 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Подготовка врачей общей практики для южного Казахстана. '
          'Клиническая практика в больницах Шымкента.',
      jobs: ['Врач', 'Терапевт', 'Педиатр', 'Хирург'],
    ),
    const UniversityProgram(
      id: 'miras_it',
      name: 'Информационные технологии',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '350 000 – 750 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Разработка программного обеспечения, системное администрирование. '
          'Доступное образование для жителей южного региона.',
      jobs: ['Программист', 'Системный администратор', 'Веб-разработчик'],
    ),
    const UniversityProgram(
      id: 'miras_pedagogy',
      name: 'Педагогика',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: '300 000 – 650 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Подготовка учителей для школ южного Казахстана. '
          'Специализации: начальные классы, казахский язык, математика.',
      jobs: ['Учитель', 'Воспитатель', 'Методист', 'Педагог-психолог'],
    ),
  ],

  // ── ВКТУ ──────────────────────────────────────────────────────────────────
  'ektu': [
    const UniversityProgram(
      id: 'ektu_engineering',
      name: 'Машиностроение',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 700 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Конструирование и производство машин и механизмов. '
          'Практика на машиностроительных заводах Усть-Каменогорска.',
      jobs: ['Инженер-конструктор', 'Технолог', 'Механик', 'Производственник'],
    ),
    const UniversityProgram(
      id: 'ektu_metallurgy',
      name: 'Металлургия',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 700 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Производство и обработка металлов. Партнёрство с '
          'Казцинком, Ульбинским металлургическим заводом.',
      jobs: ['Металлург', 'Технолог', 'Инженер-материаловед', 'Контролёр качества'],
    ),
    const UniversityProgram(
      id: 'ektu_it',
      name: 'Информатика',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 700 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Разработка ПО, администрирование, кибербезопасность. '
          'IT-центр с современным оборудованием.',
      jobs: ['Программист', 'Системный администратор', 'IT-аналитик'],
    ),
  ],

  // ── ЖГУ ───────────────────────────────────────────────────────────────────
  'zhgu': [
    const UniversityProgram(
      id: 'zhgu_pedagogy',
      name: 'Педагогика и психология',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 600 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Подготовка педагогов и психологов для учебных заведений '
          'Жетысуского региона.',
      jobs: ['Учитель', 'Школьный психолог', 'Воспитатель', 'Методист'],
    ),
    const UniversityProgram(
      id: 'zhgu_law',
      name: 'Юриспруденция',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 600 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Подготовка юристов для государственных органов '
          'и частных компаний региона.',
      jobs: ['Юрист', 'Нотариус', 'Судья', 'Следователь'],
    ),
    const UniversityProgram(
      id: 'zhgu_econ',
      name: 'Экономика',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 600 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Региональная экономика, финансы, менеджмент. '
          'Стажировки в компаниях Талдыкоргана.',
      jobs: ['Экономист', 'Бухгалтер', 'Финансист', 'Менеджер'],
    ),
  ],

  // ── КарТУ ─────────────────────────────────────────────────────────────────
  'kstu': [
    const UniversityProgram(
      id: 'kstu_mining',
      name: 'Горное дело',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 750 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Открытая и подземная добыча угля и металлических руд. '
          'Практика на шахтах и карьерах Карагандинского бассейна.',
      jobs: ['Горный инженер', 'Маркшейдер', 'Геолог', 'Взрывник'],
    ),
    const UniversityProgram(
      id: 'kstu_engineering',
      name: 'Машиностроение и автоматизация',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 750 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Проектирование автоматизированных производственных систем. '
          'CAD/CAM технологии, робототехника.',
      jobs: ['Инженер-конструктор', 'Автоматчик', 'Технолог', 'Мехатроник'],
    ),
    const UniversityProgram(
      id: 'kstu_it',
      name: 'Информационные технологии',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 750 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Разработка ПО, базы данных, web-технологии. '
          'Партнёрство с IT-компаниями Карагандинского региона.',
      jobs: ['Программист', 'Web-разработчик', 'Системный администратор'],
    ),
  ],

  // ── АГУ ───────────────────────────────────────────────────────────────────
  'agu': [
    const UniversityProgram(
      id: 'agu_pedagogy',
      name: 'Педагогика',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 600 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Подготовка учителей для школ западного Казахстана. '
          'Специализации: начальные классы, история, биология.',
      jobs: ['Учитель', 'Воспитатель', 'Методист', 'Завуч'],
    ),
    const UniversityProgram(
      id: 'agu_med',
      name: 'Сестринское дело',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 600 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Подготовка медицинских сестёр и специалистов '
          'сестринского дела. Практика в областных больницах.',
      jobs: ['Медицинская сестра', 'Старшая медсестра', 'Фельдшер'],
    ),
    const UniversityProgram(
      id: 'agu_law',
      name: 'Юриспруденция',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 600 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Правовая подготовка для государственных органов '
          'и частного сектора Актюбинской области.',
      jobs: ['Юрист', 'Нотариус', 'Следователь', 'Адвокат'],
    ),
    const UniversityProgram(
      id: 'agu_econ',
      name: 'Экономика',
      degree: 'Бакалавриат',
      duration: '4 года',
      costRange: 'Грант / до 600 000 ₸/год',
      languages: ['Казахский', 'Русский'],
      description:
          'Региональная экономика, нефтехимическая промышленность, '
          'финансы.',
      jobs: ['Экономист', 'Финансист', 'Бухгалтер', 'Аудитор'],
    ),
  ],
};

// ─── НОВОСТИ ──────────────────────────────────────────────────────────────────

final Map<String, List<UniversityNews>> kSeedNews = {

  // ── НУ ────────────────────────────────────────────────────────────────────
  'nu': [
    UniversityNews(
      id: 'nu_news_1',
      title: 'Назарбаев Университет вошёл в топ-200 QS World Rankings 2025',
      body: 'НУ впервые занял место в топ-200 университетов мира по версии QS. '
          'Это стало результатом роста исследовательских публикаций, '
          'международных партнёрств и уровня трудоустройства выпускников.',
      publishedAt: DateTime(2025, 4, 10),
      imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800',
    ),
    UniversityNews(
      id: 'nu_news_2',
      title: 'Открытие нового центра робототехники и ИИ',
      body: 'При поддержке Microsoft и Samsung НУ открыл центр '
          'исследований в области робототехники и искусственного интеллекта. '
          'Центр оснащён 50 роботизированными платформами и GPU-кластером.',
      publishedAt: DateTime(2025, 3, 20),
      imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800',
    ),
    UniversityNews(
      id: 'nu_news_3',
      title: 'День открытых дверей — 20 апреля 2025',
      body: 'Приглашаем абитуриентов и их родителей на День открытых дверей. '
          'Вы познакомитесь с деканами факультетов, посетите лаборатории '
          'и узнаете об условиях поступления и грантах.',
      publishedAt: DateTime(2025, 4, 1),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'nu_news_4',
      title: 'Студенты НУ победили на международном хакатоне в Сеуле',
      body: 'Команда из 4 студентов факультета Computer Science заняла первое место '
          'на международном хакатоне Samsung Innovation Campus в Сеуле, '
          'обойдя участников из 28 стран.',
      publishedAt: DateTime(2025, 2, 15),
      imageUrl: '',
    ),
  ],

  // ── КИМЭП ─────────────────────────────────────────────────────────────────
  'kimep': [
    UniversityNews(
      id: 'kimep_news_1',
      title: 'KIMEP вошёл в топ-500 QS Asia Rankings 2025',
      body: 'KIMEP University улучшил позиции в рейтинге QS Asia Rankings 2025, '
          'войдя в топ-500 лучших университетов Азии.',
      publishedAt: DateTime(2025, 3, 15),
      imageUrl: 'https://images.unsplash.com/photo-1498243691581-b145c3f54a5a?w=800',
    ),
    UniversityNews(
      id: 'kimep_news_2',
      title: 'День открытых дверей — 15 апреля 2025',
      body: 'KIMEP University приглашает абитуриентов на День открытых дверей. '
          'Познакомьтесь с программами, пообщайтесь с преподавателями '
          'и узнайте об условиях поступления.',
      publishedAt: DateTime(2025, 4, 1),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'kimep_news_3',
      title: 'Студенты KIMEP победили на международном кейс-чемпионате',
      body: 'Команда бизнес-школы KIMEP заняла первое место '
          'на международном кейс-чемпионате в Сингапуре, '
          'обойдя команды из 30 стран.',
      publishedAt: DateTime(2025, 2, 20),
      imageUrl: '',
    ),
  ],

  // ── SDU ───────────────────────────────────────────────────────────────────
  'sdu': [
    UniversityNews(
      id: 'sdu_news_1',
      title: 'SDU University открыл новый кампус в Каскелене',
      body: 'Открытие расширенного кампуса SDU University с современными '
          'учебными корпусами, лабораториями и спортивным комплексом. '
          'Вместимость увеличена до 10 000 студентов.',
      publishedAt: DateTime(2025, 3, 5),
      imageUrl: 'https://images.unsplash.com/photo-1607237138185-eedd9c632b0b?w=800',
    ),
    UniversityNews(
      id: 'sdu_news_2',
      title: 'Стипендиальная программа для отличников 2025',
      body: 'SDU University объявляет о запуске стипендиальной программы '
          'для абитуриентов с высокими баллами ЕНТ. '
          'Победители получат скидку 50% на обучение.',
      publishedAt: DateTime(2025, 4, 5),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'sdu_news_3',
      title: 'Партнёрство с турецкими университетами',
      body: 'SDU University подписал соглашения об академическом обмене '
          'с 5 ведущими турецкими университетами. '
          'Студенты смогут провести один семестр в Турции.',
      publishedAt: DateTime(2025, 2, 10),
      imageUrl: '',
    ),
  ],

  // ── КБТУ ──────────────────────────────────────────────────────────────────
  'kbtu': [
    UniversityNews(
      id: 'kbtu_news_1',
      title: 'КБТУ подписал соглашение с Chevron о стажировках',
      body: 'Казахстанско-Британский технический университет подписал '
          'соглашение о партнёрстве с компанией Chevron. '
          'Студенты инженерных специальностей получат доступ к оплачиваемым стажировкам.',
      publishedAt: DateTime(2025, 3, 5),
      imageUrl: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800',
    ),
    UniversityNews(
      id: 'kbtu_news_2',
      title: 'Хакатон KBTU Tech Challenge 2025',
      body: 'КБТУ проводит ежегодный хакатон для студентов IT-специальностей. '
          'Призовой фонд — 5 000 000 тенге. '
          'Заявки принимаются до 30 апреля.',
      publishedAt: DateTime(2025, 4, 5),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'kbtu_news_3',
      title: 'Запуск программы Data Science совместно с UCL',
      body: 'КБТУ запускает новую программу бакалавриата Data Science '
          'совместно с University College London. '
          'Студенты получат двойной диплом.',
      publishedAt: DateTime(2025, 1, 25),
      imageUrl: '',
    ),
  ],

  // ── МУИТ ──────────────────────────────────────────────────────────────────
  'iitu': [
    UniversityNews(
      id: 'iitu_news_1',
      title: 'МУИТ запускает программу двойного диплома с Иннополисом',
      body: 'Международный университет информационных технологий подписал '
          'соглашение с Иннополисом о программе двойного диплома '
          'по специальности «Кибербезопасность».',
      publishedAt: DateTime(2025, 3, 20),
      imageUrl: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800',
    ),
    UniversityNews(
      id: 'iitu_news_2',
      title: 'Студенты МУИТ заняли 2-е место на ICPC 2025',
      body: 'Команда МУИТ вошла в тройку лидеров Международной олимпиады '
          'по программированию ICPC в региональном этапе.',
      publishedAt: DateTime(2025, 2, 10),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'iitu_news_3',
      title: 'Открытие лаборатории AR/VR технологий',
      body: 'При поддержке компании Meta МУИТ открыл лабораторию '
          'дополненной и виртуальной реальности. '
          'Доступно для студентов всех специальностей.',
      publishedAt: DateTime(2025, 4, 12),
      imageUrl: '',
    ),
  ],

  // ── AITU ──────────────────────────────────────────────────────────────────
  'aitu': [
    UniversityNews(
      id: 'aitu_news_1',
      title: 'AITU запускает акселератор стартапов',
      body: 'Astana IT University открывает акселератор для студенческих стартапов. '
          'Первый поток получит финансирование до 10 млн тенге '
          'и менторскую поддержку от топ-предпринимателей.',
      publishedAt: DateTime(2025, 4, 8),
      imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800',
    ),
    UniversityNews(
      id: 'aitu_news_2',
      title: 'Приём документов открыт — дедлайн 30 июня',
      body: 'AITU объявляет о начале приёма документов для поступающих '
          'на 2025–2026 учебный год. '
          'Доступно онлайн-заявление на сайте университета.',
      publishedAt: DateTime(2025, 5, 1),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'aitu_news_3',
      title: 'Партнёрство с Google для обучения облачным технологиям',
      body: 'AITU стал официальным учебным партнёром Google Cloud. '
          'Студенты получат бесплатный доступ к курсам и сертификациям Google.',
      publishedAt: DateTime(2025, 3, 15),
      imageUrl: '',
    ),
  ],

  // ── КазНТУ ────────────────────────────────────────────────────────────────
  'kazntu': [
    UniversityNews(
      id: 'kazntu_news_1',
      title: 'Satbayev University открыл центр горнодобывающих технологий',
      body: 'При поддержке ERG университет открыл уникальный центр '
          'горнодобывающих технологий с современным симуляционным оборудованием.',
      publishedAt: DateTime(2025, 3, 1),
      imageUrl: 'https://images.unsplash.com/photo-1581093804475-577d72e13eda?w=800',
    ),
    UniversityNews(
      id: 'kazntu_news_2',
      title: '50 корпоративных грантов от ERG для абитуриентов 2025',
      body: 'Казахстанско-Британский технический университет объявляет '
          'о конкурсе на получение корпоративных грантов от ERG '
          'для будущих инженеров и геологов.',
      publishedAt: DateTime(2025, 4, 15),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'kazntu_news_3',
      title: 'Конференция «Горная промышленность Казахстана 2025»',
      body: 'На базе Satbayev University пройдёт ежегодная конференция '
          'горнодобывающей промышленности с участием KAZ Minerals, '
          'ERG и международных экспертов.',
      publishedAt: DateTime(2025, 5, 10),
      imageUrl: '',
    ),
  ],

  // ── КазНУ ─────────────────────────────────────────────────────────────────
  'kaznu': [
    UniversityNews(
      id: 'kaznu_news_1',
      title: 'КазНУ запускает лабораторию ИИ при поддержке Samsung',
      body: 'Казахский национальный университет им. аль-Фараби открыл '
          'современную лабораторию ИИ. '
          'Оборудована GPU-кластером для обучения нейронных сетей.',
      publishedAt: DateTime(2025, 4, 10),
      imageUrl: 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=800',
    ),
    UniversityNews(
      id: 'kaznu_news_2',
      title: 'Приём документов для абитуриентов 2025',
      body: 'КазНУ им. аль-Фараби объявляет о начале приёма документов '
          'для поступающих на 2025–2026 учебный год. '
          'Документы принимаются с 1 июня по 31 июля.',
      publishedAt: DateTime(2025, 5, 1),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'kaznu_news_3',
      title: 'Конференция «Аль-Фараби и современность»',
      body: 'Ежегодная международная научная конференция 20–22 мая. '
          'Участники обсудят вопросы философии, математики и '
          'естественных наук в контексте наследия великого учёного.',
      publishedAt: DateTime(2025, 5, 5),
      imageUrl: '',
    ),
  ],

  // ── ЕНУ ───────────────────────────────────────────────────────────────────
  'eurasian': [
    UniversityNews(
      id: 'eurasian_news_1',
      title: 'ЕНУ вошёл в топ-300 университетов Азии',
      body: 'Евразийский национальный университет им. Гумилёва '
          'занял место в топ-300 лучших университетов Азии '
          'по версии QS Asia Rankings 2025.',
      publishedAt: DateTime(2025, 3, 18),
      imageUrl: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=800',
    ),
    UniversityNews(
      id: 'eurasian_news_2',
      title: 'Открытие нового научного корпуса',
      body: 'ЕНУ открыл современный научный корпус стоимостью 3 млрд тенге '
          'с лабораториями по химии, физике и биологии.',
      publishedAt: DateTime(2025, 4, 20),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'eurasian_news_3',
      title: 'Студенческие гранты на 2025 год',
      body: 'ЕНУ объявляет о 200 государственных грантах для абитуриентов. '
          'Приём заявок — с 15 июня по 15 июля 2025 года.',
      publishedAt: DateTime(2025, 5, 15),
      imageUrl: '',
    ),
  ],

  // ── AlmaU ─────────────────────────────────────────────────────────────────
  'almau': [
    UniversityNews(
      id: 'almau_news_1',
      title: 'AlmaU вошёл в топ-5 бизнес-школ СНГ по Eduniversal',
      body: 'Алматы Менеджмент Университет занял 4-е место в рейтинге '
          'лучших бизнес-школ СНГ по версии Eduniversal.',
      publishedAt: DateTime(2025, 2, 28),
      imageUrl: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=800',
    ),
    UniversityNews(
      id: 'almau_news_2',
      title: 'Мастер-класс от CEO Kaspi.kz для студентов AlmaU',
      body: 'В рамках серии «Leaders Talk» CEO Kaspi.kz Михаил Ломтадзе '
          'провёл открытый мастер-класс для студентов MBA и бакалавриата.',
      publishedAt: DateTime(2025, 3, 25),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'almau_news_3',
      title: 'Новая MBA-специализация: Digital Transformation',
      body: 'AlmaU запускает новую специализацию MBA — '
          '«Цифровая трансформация бизнеса». '
          'Набор на первый поток открыт.',
      publishedAt: DateTime(2025, 4, 18),
      imageUrl: '',
    ),
  ],

  // ── Нархоз ────────────────────────────────────────────────────────────────
  'narxoz': [
    UniversityNews(
      id: 'narxoz_news_1',
      title: 'Нархоз получил международную аккредитацию EPAS',
      body: 'Университет Нархоз успешно прошёл аккредитацию EPAS (EFMD). '
          'Это признание качества программ на международном уровне.',
      publishedAt: DateTime(2025, 1, 15),
      imageUrl: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=800',
    ),
    UniversityNews(
      id: 'narxoz_news_2',
      title: 'Карьерная ярмарка Narxoz Career Fair 2025',
      body: 'Университет Нархоз приглашает студентов и выпускников '
          'на ежегодную карьерную ярмарку. '
          'Более 50 компаний-работодателей представят вакансии.',
      publishedAt: DateTime(2025, 4, 20),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'narxoz_news_3',
      title: 'Стипендия Narxoz Excellence Award',
      body: 'Нархоз учреждает новую стипендию для студентов с GPA выше 3.7. '
          'Ежемесячная выплата 80 000 тенге в течение всего обучения.',
      publishedAt: DateTime(2025, 3, 10),
      imageUrl: '',
    ),
  ],

  // ── КазНМУ ────────────────────────────────────────────────────────────────
  'meduniver': [
    UniversityNews(
      id: 'kazmed_news_1',
      title: 'КазНМУ открыл клинику симуляционного обучения',
      body: 'Казахский национальный медицинский университет открыл '
          'симуляционный центр стоимостью 2 млрд тенге. '
          'Студенты смогут отрабатывать навыки на роботизированных манекенах.',
      publishedAt: DateTime(2025, 2, 15),
      imageUrl: 'https://images.unsplash.com/photo-1516549655169-df83a0774514?w=800',
    ),
    UniversityNews(
      id: 'kazmed_news_2',
      title: 'Грантовый приём 2025: увеличено число мест',
      body: 'Министерство здравоохранения увеличило квоту государственных грантов '
          'для КазНМУ на 150 мест. Приём документов с 15 июня.',
      publishedAt: DateTime(2025, 5, 1),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'kazmed_news_3',
      title: 'Международная медицинская конференция в КазНМУ',
      body: 'На базе КазНМУ пройдёт международная конференция '
          '«Современная медицина Центральной Азии» с участием '
          'специалистов из 15 стран.',
      publishedAt: DateTime(2025, 4, 25),
      imageUrl: '',
    ),
  ],

  // ── АГА ───────────────────────────────────────────────────────────────────
  'caa': [
    UniversityNews(
      id: 'caa_news_1',
      title: 'Академия гражданской авиации получила сертификат ИКАО',
      body: 'АГА успешно прошла сертификацию ИКАО (Международная организация '
          'гражданской авиации), подтвердив соответствие международным '
          'стандартам авиационного образования.',
      publishedAt: DateTime(2025, 3, 8),
      imageUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800',
    ),
    UniversityNews(
      id: 'caa_news_2',
      title: 'Новый тренажёр Boeing 737 MAX для студентов',
      body: 'АГА получила современный симулятор полётов Boeing 737 MAX. '
          'Теперь студенты могут практиковаться на актуальном оборудовании '
          'без выезда за рубеж.',
      publishedAt: DateTime(2025, 4, 3),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'caa_news_3',
      title: 'Трудоустройство выпускников — 98%',
      body: 'По итогам 2024 года 98% выпускников АГА трудоустроились '
          'по специальности в Air Astana, SCAT, Qazaq Air '
          'и международных авиакомпаниях.',
      publishedAt: DateTime(2025, 2, 20),
      imageUrl: '',
    ),
  ],

  // ── КазУМОиМЯ ─────────────────────────────────────────────────────────────
  'ablaikhan': [
    UniversityNews(
      id: 'ablai_news_1',
      title: 'Студенты КазУМОиМЯ победили на Олимпиаде по переводу',
      body: 'Команда студентов университета заняла первое место '
          'на республиканской олимпиаде по переводу среди языковых вузов.',
      publishedAt: DateTime(2025, 3, 12),
      imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800',
    ),
    UniversityNews(
      id: 'ablai_news_2',
      title: 'Новые программы по китайскому и арабскому языкам',
      body: 'КазУМОиМЯ расширяет набор на специальности '
          '«Китайский язык и литература» и «Арабский язык и исламоведение». '
          'Доступны государственные гранты.',
      publishedAt: DateTime(2025, 4, 8),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'ablai_news_3',
      title: 'Международный день языков в КазУМОиМЯ',
      body: 'Ежегодный праздник языков объединит студентов, говорящих '
          'на 20 языках мира. Культурные программы, конкурсы '
          'и выставка национальных кухонь.',
      publishedAt: DateTime(2025, 5, 5),
      imageUrl: '',
    ),
  ],

  // ── КАЗГЮУ ────────────────────────────────────────────────────────────────
  'kazguu': [
    UniversityNews(
      id: 'kazguu_news_1',
      title: 'КАЗГЮУ открыл новую юридическую клинику',
      body: 'Университет КАЗГЮУ открыл расширенную юридическую клинику, '
          'где студенты оказывают бесплатную правовую помощь гражданам '
          'под руководством опытных преподавателей.',
      publishedAt: DateTime(2025, 3, 25),
      imageUrl: 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=800',
    ),
    UniversityNews(
      id: 'kazguu_news_2',
      title: 'Стипендия от крупных юридических фирм Казахстана',
      body: 'КАЗГЮУ совместно с юридическими фирмами GRATA International '
          'и Dentons учреждает стипендии для лучших студентов-юристов '
          'с последующим трудоустройством.',
      publishedAt: DateTime(2025, 4, 15),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'kazguu_news_3',
      title: 'Студенческий Moot Court — победа в региональном этапе',
      body: 'Команда КАЗГЮУ победила в региональном этапе международного '
          'конкурса по международному коммерческому арбитражу '
          'и вышла в финал в Гааге.',
      publishedAt: DateTime(2025, 2, 28),
      imageUrl: '',
    ),
  ],

  // ── Мирас ─────────────────────────────────────────────────────────────────
  'miras': [
    UniversityNews(
      id: 'miras_news_1',
      title: 'Университет «Мирас» получил государственную аккредитацию',
      body: 'Университет «Мирас» успешно прошёл государственную аккредитацию '
          'на 5 лет по всем образовательным программам. '
          'Качество обучения подтверждено Министерством образования.',
      publishedAt: DateTime(2025, 3, 5),
      imageUrl: 'https://images.unsplash.com/photo-1571260899304-425eee4c7efc?w=800',
    ),
    UniversityNews(
      id: 'miras_news_2',
      title: 'Снижение стоимости обучения для 2025 года',
      body: 'Руководство университета объявило о снижении стоимости обучения '
          'на 10% для поступающих в 2025 году. '
          'Также увеличено число мест на льготных условиях.',
      publishedAt: DateTime(2025, 4, 10),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'miras_news_3',
      title: 'Открытие медицинского симуляционного центра',
      body: 'Студенты медицинских специальностей теперь могут практиковаться '
          'в новом симуляционном центре, оснащённом манекенами '
          'и медицинским оборудованием.',
      publishedAt: DateTime(2025, 2, 18),
      imageUrl: '',
    ),
  ],

  // ── ВКТУ ──────────────────────────────────────────────────────────────────
  'ektu': [
    UniversityNews(
      id: 'ektu_news_1',
      title: 'ВКТУ подписал соглашение с Казцинком',
      body: 'Восточно-Казахстанский технический университет заключил '
          'договор о стратегическом партнёрстве с Казцинком. '
          'Студенты получат приоритетный доступ к стажировкам и трудоустройству.',
      publishedAt: DateTime(2025, 3, 10),
      imageUrl: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800',
    ),
    UniversityNews(
      id: 'ektu_news_2',
      title: '100 грантов для абитуриентов инженерных специальностей',
      body: 'ВКТУ совместно с промышленными предприятиями региона '
          'предоставляет 100 грантов на обучение по инженерным специальностям '
          'с обязательной отработкой 3 лет.',
      publishedAt: DateTime(2025, 4, 20),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'ektu_news_3',
      title: 'Открытие IT-лаборатории при поддержке Ульбинского завода',
      body: 'Ульбинский металлургический завод профинансировал создание '
          'современной IT-лаборатории в ВКТУ для подготовки '
          'специалистов по промышленной автоматизации.',
      publishedAt: DateTime(2025, 2, 25),
      imageUrl: '',
    ),
  ],

  // ── ЖГУ ───────────────────────────────────────────────────────────────────
  'zhgu': [
    UniversityNews(
      id: 'zhgu_news_1',
      title: 'ЖГУ отметил 75-летие основания',
      body: 'Жетысуский государственный университет им. Жансугурова '
          'отмечает 75-летний юбилей. За историю университета '
          'выпущено более 50 000 специалистов.',
      publishedAt: DateTime(2025, 3, 20),
      imageUrl: 'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=800',
    ),
    UniversityNews(
      id: 'zhgu_news_2',
      title: 'Набор на педагогические специальности 2025',
      body: 'ЖГУ объявляет об увеличении числа грантовых мест '
          'на педагогические специальности в 2025 году. '
          'Дополнительно открывается направление «Цифровая педагогика».',
      publishedAt: DateTime(2025, 4, 5),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'zhgu_news_3',
      title: 'Региональная олимпиада по математике',
      body: 'Студенты ЖГУ заняли призовые места на региональной олимпиаде '
          'по математике среди вузов Жетысуской области.',
      publishedAt: DateTime(2025, 2, 15),
      imageUrl: '',
    ),
  ],

  // ── КарТУ ─────────────────────────────────────────────────────────────────
  'kstu': [
    UniversityNews(
      id: 'kstu_news_1',
      title: 'КарТУ открыл центр горных технологий',
      body: 'При финансировании АрселорМиттал Темиртау '
          'Карагандинский технический университет открыл современный центр '
          'горнодобывающих технологий с VR-симулятором шахты.',
      publishedAt: DateTime(2025, 3, 15),
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
    ),
    UniversityNews(
      id: 'kstu_news_2',
      title: '200 грантов от АрселорМиттал для инженеров',
      body: 'АрселорМиттал Темиртау выделяет 200 грантов '
          'студентам инженерных специальностей КарТУ '
          'с гарантированным трудоустройством.',
      publishedAt: DateTime(2025, 4, 10),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'kstu_news_3',
      title: 'Студенты КарТУ победили на Worldskills Kazakhstan',
      body: 'Студенты Карагандинского технического университета '
          'заняли первые места на республиканском чемпионате '
          'WorldSkills Kazakhstan по специальностям «Сварочные работы» '
          'и «Электроника».',
      publishedAt: DateTime(2025, 2, 10),
      imageUrl: '',
    ),
  ],

  // ── АГУ ───────────────────────────────────────────────────────────────────
  'agu': [
    UniversityNews(
      id: 'agu_news_1',
      title: 'АГУ им. Жубанова — лучший вуз западного Казахстана',
      body: 'По результатам независимого рейтинга вузов Казахстана '
          'Актюбинский региональный университет признан лучшим '
          'в западном регионе страны по качеству педагогического образования.',
      publishedAt: DateTime(2025, 3, 22),
      imageUrl: 'https://images.unsplash.com/photo-1564981797816-1043664bf78d?w=800',
    ),
    UniversityNews(
      id: 'agu_news_2',
      title: 'Расширение медицинских программ в 2025 году',
      body: 'АГУ открывает новое направление «Сестринское дело» '
          'с 50 бюджетными местами. '
          'Программа реализуется совместно с Актюбинской областной больницей.',
      publishedAt: DateTime(2025, 4, 12),
      imageUrl: '',
    ),
    UniversityNews(
      id: 'agu_news_3',
      title: 'День открытых дверей в АГУ — 10 мая',
      body: 'Абитуриенты смогут познакомиться с факультетами, '
          'поговорить с преподавателями и узнать '
          'об условиях поступления и доступных грантах.',
      publishedAt: DateTime(2025, 5, 1),
      imageUrl: '',
    ),
  ],
};