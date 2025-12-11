/// Format harga ke format Rupiah dengan separator titik
/// Example: 25000.0 -> "Rp 25.000"
String formatRupiah(num price) {
  final priceInt = price.toInt();
  final priceString = priceInt.toString();
  
  String result = '';
  int count = 0;
  
  for (int i = priceString.length - 1; i >= 0; i--) {
    if (count == 3) {
      result = '.$result';
      count = 0;
    }
    result = priceString[i] + result;
    count++;
  }
  
  return 'Rp $result';
}
