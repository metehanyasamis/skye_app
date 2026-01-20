import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';

class CountryCode {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  CountryCode({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
  });
}

class CountryCodePicker extends StatefulWidget {
  const CountryCodePicker({
    super.key,
    required this.onChanged,
    this.initialCountryCode = '+1',
  });

  final Function(String dialCode) onChanged;
  final String initialCountryCode;

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  late CountryCode _selectedCountry;

  final List<CountryCode> _countries = [
    CountryCode(name: 'United States', code: 'US', dialCode: '+1', flag: '🇺🇸'),
    CountryCode(name: 'United Kingdom', code: 'GB', dialCode: '+44', flag: '🇬🇧'),
    CountryCode(name: 'Canada', code: 'CA', dialCode: '+1', flag: '🇨🇦'),
    CountryCode(name: 'Australia', code: 'AU', dialCode: '+61', flag: '🇦🇺'),
    CountryCode(name: 'Germany', code: 'DE', dialCode: '+49', flag: '🇩🇪'),
    CountryCode(name: 'France', code: 'FR', dialCode: '+33', flag: '🇫🇷'),
    CountryCode(name: 'Italy', code: 'IT', dialCode: '+39', flag: '🇮🇹'),
    CountryCode(name: 'Spain', code: 'ES', dialCode: '+34', flag: '🇪🇸'),
    CountryCode(name: 'Turkey', code: 'TR', dialCode: '+90', flag: '🇹🇷'),
    CountryCode(name: 'Russia', code: 'RU', dialCode: '+7', flag: '🇷🇺'),
    CountryCode(name: 'China', code: 'CN', dialCode: '+86', flag: '🇨🇳'),
    CountryCode(name: 'Japan', code: 'JP', dialCode: '+81', flag: '🇯🇵'),
    CountryCode(name: 'India', code: 'IN', dialCode: '+91', flag: '🇮🇳'),
    CountryCode(name: 'Brazil', code: 'BR', dialCode: '+55', flag: '🇧🇷'),
    CountryCode(name: 'Mexico', code: 'MX', dialCode: '+52', flag: '🇲🇽'),
    CountryCode(name: 'South Korea', code: 'KR', dialCode: '+82', flag: '🇰🇷'),
    CountryCode(name: 'Netherlands', code: 'NL', dialCode: '+31', flag: '🇳🇱'),
    CountryCode(name: 'Sweden', code: 'SE', dialCode: '+46', flag: '🇸🇪'),
    CountryCode(name: 'Norway', code: 'NO', dialCode: '+47', flag: '🇳🇴'),
    CountryCode(name: 'Denmark', code: 'DK', dialCode: '+45', flag: '🇩🇰'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries.firstWhere(
      (country) => country.dialCode == widget.initialCountryCode,
      orElse: () => _countries.first, // Default to US (+1)
    );
    // Call callback after build is complete to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(_selectedCountry.dialCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCountryPicker(context),
      child: Container(
        height: 56, // Match TextField height (default TextField height is ~56)
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _selectedCountry.flag,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Text(
              _selectedCountry.dialCode,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.navy800,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _countries.length,
                  itemBuilder: (context, index) {
                    final country = _countries[index];
                    final isSelected = country.dialCode == _selectedCountry.dialCode;
                    return ListTile(
                      leading: Text(
                        country.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        country.name,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      trailing: Text(
                        country.dialCode,
                        style: TextStyle(
                          color: isSelected ? AppColors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCountry = country;
                        });
                        widget.onChanged(country.dialCode);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
