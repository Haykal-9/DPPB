import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();

  // Theme Colors
  final Color _bgPage = const Color(0xFFF9F5F0);
  final Color _goldPrimary = const Color(0xFFD4AF37);
  final Color _textPrimary = const Color(0xFF2C2219);
  final Color _textSecondary = const Color(0xFF8D7B68);

  // Form State
  String _name = '';
  String _phone = '';
  int _people = 2;
  DateTime? _date;
  TimeOfDay? _time;
  String _notes = '';
  String _selectedZone = 'Indoor AC';

  final List<String> _zones = ['Indoor AC', 'Outdoor Terrace', 'Private Room'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      body: Stack(
        children: [
          // 1. Atmospheric Header Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/kopi/Latte.jpg', // Warm atmosphere
                  fit: BoxFit.cover,
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        _bgPage, // Fade into page color
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom AppBar
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: BackButton(color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        'Reservation',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Serif',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40), // Balance
                    ],
                  ),

                  const SizedBox(height: 30),
                  Text(
                    'Book a Table',
                    style: TextStyle(
                      fontFamily: 'Serif',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'Secure your spot for a premium coffee experience.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Floating Form Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Seating Zone'),
                          const SizedBox(height: 12),
                          _buildSeatingSelector(),
                          const SizedBox(height: 24),

                          _buildSectionTitle('Your Details'),
                          const SizedBox(height: 12),
                          _buildTextField(
                            icon: Icons.person_outline_rounded,
                            hint: 'Full Name',
                            onSaved: (v) => _name = v ?? '',
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            icon: Icons.phone_outlined,
                            hint: 'Phone Number',
                            inputType: TextInputType.phone,
                            onSaved: (v) => _phone = v ?? '',
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            icon: Icons.people_outline_rounded,
                            hint: 'Number of Guests (e.g. 2)',
                            inputType: TextInputType.number,
                            onSaved: (v) =>
                                _people = int.tryParse(v ?? '1') ?? 1,
                          ),
                          const SizedBox(height: 24),

                          _buildSectionTitle('Date & Time'),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildDatePicker()),
                              const SizedBox(width: 12),
                              Expanded(child: _buildTimePicker()),
                            ],
                          ),

                          const SizedBox(height: 24),
                          _buildSectionTitle('Special Request'),
                          const SizedBox(height: 12),
                          _buildTextField(
                            icon: Icons.note_alt_outlined,
                            hint: 'Allergies, Birthday, etc.',
                            maxLines: 2,
                            onSaved: (v) => _notes = v ?? '',
                          ),

                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _submitReservation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _goldPrimary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Confirm Reservation',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: _textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: 'Serif',
      ),
    );
  }

  Widget _buildSeatingSelector() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _zones.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final zone = _zones[index];
          final isSelected = _selectedZone == zone;
          return GestureDetector(
            onTap: () => setState(() => _selectedZone = zone),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? _textPrimary : _bgPage,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? _textPrimary : Colors.transparent,
                ),
              ),
              child: Text(
                zone,
                style: TextStyle(
                  color: isSelected ? _goldPrimary : _textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    required FormFieldSetter<String> onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _bgPage, // Creating contrast against white card
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        keyboardType: inputType,
        maxLines: maxLines,
        style: TextStyle(color: _textPrimary, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: _textSecondary.withOpacity(0.5),
            size: 20,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: _textSecondary.withOpacity(0.5),
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Required' : null,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: _goldPrimary,
                  onPrimary: Colors.white,
                  onSurface: _textPrimary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) setState(() => _date = picked);
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _bgPage,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(
              Icons.calendar_today_rounded,
              color: _textSecondary.withOpacity(0.5),
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              _date == null
                  ? 'Select Date'
                  : '${_date!.day}/${_date!.month}/${_date!.year}',
              style: TextStyle(
                color: _date == null
                    ? _textSecondary.withOpacity(0.5)
                    : _textPrimary,
                fontWeight: _date == null ? FontWeight.normal : FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: _goldPrimary,
                  onPrimary: Colors.white,
                  onSurface: _textPrimary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) setState(() => _time = picked);
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _bgPage,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(
              Icons.access_time_rounded,
              color: _textSecondary.withOpacity(0.5),
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              _time == null ? 'Select Time' : _time!.format(context),
              style: TextStyle(
                color: _time == null
                    ? _textSecondary.withOpacity(0.5)
                    : _textPrimary,
                fontWeight: _time == null ? FontWeight.normal : FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReservation() {
    if (_formKey.currentState!.validate()) {
      if (_date == null || _time == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and time')),
        );
        return;
      }
      _formKey.currentState!.save();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: _bgPage,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Icon(Icons.check_circle, color: _goldPrimary, size: 60),
              const SizedBox(height: 20),
              Text(
                'Spot Reserved!',
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '$_selectedZone confirmed for $_people guests.',
                style: TextStyle(color: _textSecondary, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Use the variables to avoid "unused" warnings
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _textSecondary.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.person, _name),
                    if (_phone.isNotEmpty) ...[
                      const Divider(height: 12),
                      _buildInfoRow(Icons.phone, _phone),
                    ],
                    if (_notes.isNotEmpty) ...[
                      const Divider(height: 12),
                      _buildInfoRow(Icons.note, _notes),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _goldPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Great!'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: _textPrimary, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
