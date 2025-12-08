import '../models/product.dart';

/// Menu Products (Data dari Database Tapal Kuda)
final List<Product> menuProducts = [
  const Product(
    'Kopi Tubruk Arabika',
    14000.0,
    'assets/images/kopi/KOPI TUBRUK ARABIKA.jpg',
    description:
        'Nikmati kenikmatan sejati dari secangkir Kopi Tubruk Arabika, dibuat dari 100% biji arabika pilihan yang disangrai sempurna. Diseduh dengan cara tradisional khas Indonesia, kopi ini menawarkan rasa yang kaya, pekat, dan berkarakter.',
  ),
  const Product(
    'Cappucino',
    22000.0,
    'assets/images/kopi/CAPPUCINO.jpg',
    description:
        'Butuh pelukan hangat dalam bentuk kopi? Coba Cappuccino kami perpaduan sempurna antara espresso arabika berkualitas, susu steamed yang creamy, dan buih halus di atasnya.',
  ),
  const Product(
    'ES Kopi Susu',
    22000.0,
    'assets/images/kopi/ES KOPI SUSU.jpg',
    description:
        'Minuman favorit semua kalangan! Es Kopi Susu kami adalah kombinasi sempurna antara espresso arabika yang bold, susu segar yang lembut, dan sentuhan manis yang pas disajikan dingin.',
  ),
  const Product(
    'Espresso',
    14000.0,
    'assets/images/kopi/ESPRESSO.jpg',
    description:
        'Espresso kami dibuat dari biji arabika pilihan yang disangrai dengan sempurna untuk menghasilkan rasa kuat, pekat, dan aromatik. Cocok untuk kamu yang butuh dorongan energi tanpa basa-basi.',
  ),
  const Product(
    'Espresso Double',
    17000.0,
    'assets/images/kopi/ESPRESSO1.jpg',
    description:
        'Siap hadapi hari yang panjang? Espresso Double kami adalah jawaban untuk kamu yang butuh ekstra tenaga dan ekstra rasa. Dua shot espresso dari biji arabika premium, disajikan pekat dan panas.',
  ),
  const Product(
    'Japanase Flavour',
    21000.0,
    'assets/images/kopi/JAPAN.jpg',
    description:
        'Rasakan kelembutan dan keunikan rasa Jepang lewat varian Japanese Flavour kami. Mulai dari Matcha yang earthy, Hojicha yang smoky, hingga Yuzu yang segar setiap rasa dipilih dengan cermat.',
  ),
  const Product(
    'Latte',
    25000.0,
    'assets/images/kopi/Latte.jpg',
    description:
        'Butuh momen tenang di tengah hari yang sibuk? Latte kami hadir dengan perpaduan sempurna antara espresso arabika yang halus dan susu steamed yang creamy. Rasanya ringan dan aromanya menenangkan.',
  ),
  const Product(
    'Sukomon',
    21000.0,
    'assets/images/kopi/SUKOMON.jpg',
    description:
        'Sukomon adalah minuman kopi susu lemon yang menyegarkan dan unik. Menggabungkan espresso arabika yang bold, susu yang creamy, dan sentuhan asam segar dari lemon.',
  ),
  const Product(
    'V60',
    19000.0,
    'assets/images/kopi/V60.jpg',
    description:
        'Nikmati kelezatan kopi dengan cara yang lebih personal dan presisi! V60 kami menggunakan metode manual pour-over. Hasilnya? Kopi yang lebih clean, dengan rasa yang jelas dan penuh karakter.',
  ),
  const Product(
    'Vietname Drip',
    19000.0,
    'assets/images/kopi/VIETNAM.jpg',
    description:
        'Rasakan kenikmatan kopi ala Vietnam dengan Vietnamese Drip kami! Diseduh dengan metode drip tradisional, kopi ini memiliki rasa yang kental, kaya, dan sedikit manis dari campuran susu kental manis.',
  ),
];

final List<Product> mockProducts = menuProducts.take(6).toList();
