import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/date_picker_field.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';

/// CFI ilan paylaşma ekranı. Safety pilot / Time Building Post ile 1-1 yapıda.
class CfiPostScreen extends StatefulWidget {
  const CfiPostScreen({super.key});

  static const routeName = '/cfi/post';

  @override
  State<CfiPostScreen> createState() => _CfiPostScreenState();
}

class _CfiPostScreenState extends State<CfiPostScreen> {
  final _locationController = TextEditingController();
  final _aircraftController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    debugPrint('🧱 [CfiPostScreen] initState');
  }

  @override
  void dispose() {
    _locationController.dispose();
    _aircraftController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  void _onPost() {
    final fmt = DateFormat('MM/dd/yyyy');
    debugPrint('📮 [CfiPostScreen] POST tapped');
    debugPrint('   Location: ${_locationController.text}');
    debugPrint('   Aircraft: ${_aircraftController.text}');
    debugPrint('   Hourly rate: ${_hourlyRateController.text}');
    debugPrint('   Date: ${_date != null ? fmt.format(_date!) : ""}');
    // TODO: Submit post
  }

  void _dismissKeyboard() => FocusScope.of(context).unfocus();

  Widget _buildBorderedInput({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.navy900, width: 1),
      ),
      child: _CfiPostInput(
        icon: icon,
        hint: hint,
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [CfiPostScreen] build');
    SystemUIHelper.setLightStatusBar();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.cfiBackground,
      appBar: AppBar(
        backgroundColor: AppColors.cfiBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.labelBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _dismissKeyboard,
              behavior: HitTestBehavior.opaque,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 19, right: 19, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Offer instruction',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF40648D),
                        height: 32 / 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'as a CFI',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF344054),
                        height: 32 / 24,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        _buildBorderedInput(
                          icon: Icons.location_on,
                          hint: 'Location / Airport',
                          controller: _locationController,
                          onChanged: (v) =>
                              debugPrint('⌨️ [CfiPostScreen] Location: $v'),
                        ),
                        const SizedBox(height: 16),
                        DatePickerField(
                          style: DatePickerFieldStyle.borderedIcon,
                          hint: 'Date',
                          icon: Icons.calendar_today,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 365)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365 * 5)),
                          prefillFromInitialDate: false,
                          onDateChanged: (d) => setState(() => _date = d),
                        ),
                        const SizedBox(height: 16),
                        _buildBorderedInput(
                          icon: Icons.flight,
                          hint: 'Aircraft type',
                          controller: _aircraftController,
                          onChanged: (v) =>
                              debugPrint('⌨️ [CfiPostScreen] Aircraft: $v'),
                        ),
                        const SizedBox(height: 16),
                        _buildBorderedInput(
                          icon: Icons.attach_money,
                          hint: 'Hourly rate (\$)',
                          controller: _hourlyRateController,
                          keyboardType: TextInputType.number,
                          onChanged: (v) =>
                              debugPrint('⌨️ [CfiPostScreen] Rate: $v'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              0,
              24,
              18 + MediaQuery.of(context).viewPadding.bottom,
            ),
            child: PrimaryButton(
              label: 'Post',
              onPressed: _onPost,
            ),
          ),
        ],
      ),
    );
  }
}

class _CfiPostInput extends StatelessWidget {
  const _CfiPostInput({
    required this.icon,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.onChanged,
  });

  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.navy900),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 16, color: AppColors.navy900),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: AppColors.navy900,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
