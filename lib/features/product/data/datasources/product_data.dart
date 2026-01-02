import '../models/product.dart';

/// Menu Products (Data dari Database Tapal Kuda)
final List<Product> menuProducts = [
  const Product(
    1,
    'Kopi Tubruk Arabika',
    14000.0,
    'assets/images/kopi/KOPI TUBRUK ARABIKA.jpg',
    description:
        'Nikmati kenikmatan sejati dari secangkir Kopi Tubruk Arabika, dibuat dari 100% biji arabika pilihan yang disangrai sempurna.',
    category: 'Coffee',
  ),
  const Product(
    2,
    'Cappucino',
    22000.0,
    'assets/images/kopi/CAPPUCINO.jpg',
    description:
        'Butuh pelukan hangat dalam bentuk kopi? Coba Cappuccino kami perpaduan sempurna antara espresso arabika berkualitas.',
    category: 'Coffee',
  ),
  const Product(
    3,
    'ES Kopi Susu',
    22000.0,
    'assets/images/kopi/ES KOPI SUSU.jpg',
    description:
        'Minuman favorit semua kalangan! Es Kopi Susu kami adalah kombinasi sempurna antara espresso arabika yang bold dan susu.',
    category: 'Coffee',
  ),
  const Product(
    4,
    'Espresso',
    14000.0,
    'assets/images/kopi/ESPRESSO.jpg',
    description:
        'Espresso kami dibuat dari biji arabika pilihan yang disangrai dengan sempurna untuk menghasilkan rasa kuat.',
    category: 'Coffee',
  ),
  const Product(
    5,
    'Espresso Double',
    17000.0,
    'assets/images/kopi/ESPRESSO1.jpg',
    description:
        'Siap hadapi hari yang panjang? Espresso Double kami adalah jawaban untuk kamu yang butuh ekstra tenaga.',
    category: 'Coffee',
  ),
  const Product(
    6,
    'Japanase Flavour',
    21000.0,
    'assets/images/kopi/JAPAN.jpg',
    description:
        'Rasakan kelembutan dan keunikan rasa Jepang lewat varian Japanese Flavour kami.',
    category: 'Non-Coffee',
  ),
  const Product(
    7,
    'Latte',
    25000.0,
    'assets/images/kopi/Latte.jpg',
    description:
        'Butuh momen tenang di tengah hari yang sibuk? Latte kami hadir dengan perpaduan sempurna.',
    category: 'Coffee',
  ),
  const Product(
    8,
    'Sukomon',
    21000.0,
    'assets/images/kopi/SUKOMON.jpg',
    description:
        'Sukomon adalah minuman kopi susu lemon yang menyegarkan dan unik.',
    category: 'Non-Coffee',
  ),
  const Product(
    9,
    'V60',
    19000.0,
    'assets/images/kopi/V60.jpg',
    description:
        'Nikmati kelezatan kopi dengan cara yang lebih personal dan presisi! V60 kami menggunakan metode manual.',
    category: 'Coffee',
  ),
  const Product(
    10,
    'Vietname Drip',
    19000.0,
    'assets/images/kopi/VIETNAM.jpg',
    description:
        'Rasakan kenikmatan kopi ala Vietnam dengan Vietnamese Drip kami!',
    category: 'Coffee',
  ),
];

final List<Product> mockProducts = menuProducts.take(6).toList();
