import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  int _people = 1;
  DateTime? _date;
  TimeOfDay? _time;
  String _notes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Reservation'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFe7d7c1),
                  Color(0xFFf5eee6),
                  Color(0xFFe0c3a3),
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 32,
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Card(
                    color: Colors.white.withOpacity(0.92),
                    elevation: 10,
                    shadowColor: Colors.brown.withOpacity(0.18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 36,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Banner/Header Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                'assets/images/makanan/nasiTutug.webp',
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Reservasi Meja',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Nama Lengkap',
                                prefixIcon: Icon(Icons.person_outline),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Wajib diisi'
                                  : null,
                              onSaved: (value) => _name = value ?? '',
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Nomor Telepon',
                                prefixIcon: Icon(Icons.phone),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Wajib diisi'
                                  : null,
                              onSaved: (value) => _phone = value ?? '',
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Jumlah Orang',
                                prefixIcon: Icon(Icons.people_outline),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              initialValue: _people.toString(),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Wajib diisi';
                                final n = int.tryParse(value);
                                if (n == null || n < 1)
                                  return 'Minimal 1 orang';
                                return null;
                              },
                              onSaved: (value) =>
                                  _people = int.tryParse(value ?? '1') ?? 1,
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.brown,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(
                                          const Duration(days: 365),
                                        ),
                                      );
                                      if (picked != null)
                                        setState(() => _date = picked);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.brown.withOpacity(0.04),
                                      ),
                                      child: Text(
                                        _date == null
                                            ? 'Pilih Tanggal'
                                            : '${_date!.day}/${_date!.month}/${_date!.year}',
                                        style: TextStyle(
                                          color: _date == null
                                              ? Colors.grey
                                              : Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.brown,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () async {
                                      final picked = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (picked != null)
                                        setState(() => _time = picked);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.brown.withOpacity(0.04),
                                      ),
                                      child: Text(
                                        _time == null
                                            ? 'Pilih Waktu'
                                            : _time!.format(context),
                                        style: TextStyle(
                                          color: _time == null
                                              ? Colors.grey
                                              : Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Catatan Tambahan (opsional)',
                                prefixIcon: Icon(Icons.note_alt_outlined),
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 2,
                              onSaved: (value) => _notes = value ?? '',
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  if (_date == null || _time == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Tanggal dan waktu wajib dipilih!',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  _formKey.currentState?.save();
                                  // Simulasi submit
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Reservasi berhasil dikirim!',
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 2,
                              ),
                              child: const Text('Kirim Reservasi'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
