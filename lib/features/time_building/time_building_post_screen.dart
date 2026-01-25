import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/date_picker_field.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';

class TimeBuildingPostScreen extends StatefulWidget {
  const TimeBuildingPostScreen({super.key});

  static const routeName = '/time-building/post';

  @override
  State<TimeBuildingPostScreen> createState() => _TimeBuildingPostScreenState();
}

class _TimeBuildingPostScreenState extends State<TimeBuildingPostScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _licensesController = TextEditingController();
  final _costController = TextEditingController();
  int _passengers = 1;
  DateTime? _departureDate;
  DateTime? _arrivalDate;

  @override
  void initState() {
    super.initState();
    debugPrint('🧱 [TimeBuildingPostScreen] initState');
  }

  @override
  void dispose() {
    debugPrint('🧱 [TimeBuildingPostScreen] dispose');
    _fromController.dispose();
    _toController.dispose();
    _licensesController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _swapFromTo() {
    debugPrint('🔁 [TimeBuildingPostScreen] swap FROM/TO');
    final temp = _fromController.text;
    _fromController.text = _toController.text;
    _toController.text = temp;
    setState(() {});
  }

  void _onPost() {
    final fmt = DateFormat('MM/dd/yyyy');
    debugPrint('📮 [TimeBuildingPostScreen] POST tapped');
    debugPrint('   FROM: ${_fromController.text}');
    debugPrint('   TO: ${_toController.text}');
    debugPrint('   Departure: ${_departureDate != null ? fmt.format(_departureDate!) : ""}');
    debugPrint('   Arrival: ${_arrivalDate != null ? fmt.format(_arrivalDate!) : ""}');
    debugPrint('   Licenses: ${_licensesController.text}');
    debugPrint('   Cost: ${_costController.text}');
    debugPrint('   Passengers: $_passengers');

    // TODO: Submit post
  }

  void _decreasePassengers() {
    debugPrint('➖ [TimeBuildingPostScreen] decrease passengers');
    setState(() {
      if (_passengers > 1) {
        _passengers--;
      }
    });
    debugPrint('   Passengers now: $_passengers');
  }

  void _increasePassengers() {
    debugPrint('➕ [TimeBuildingPostScreen] increase passengers');
    setState(() {
      _passengers++;
    });
    debugPrint('   Passengers now: $_passengers');
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

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
      child: _SearchInput(
        icon: icon,
        hint: hint,
        controller: controller,
        keyboardType: keyboardType,
        iconColor: AppColors.navy900,
        hintColor: AppColors.navy900,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [TimeBuildingPostScreen] build');

    // Set status bar style for light background
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
            // Başlık – "Split the payment" tek satır, "with other…" alta
            const Text(
              'Split the payment',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF40648D),
                height: 32 / 24,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'with other safety pilots',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF344054),
                height: 32 / 24,
              ),
            ),

            const SizedBox(height: 32),

                  // Form – Figma: dış border kalsın, iç border yok (app_colors)
                  Column(
                    children: [
                      // From where / Where to – tek dış border, içlerde border yok
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.navy900, width: 1),
                        ),
                        child: Column(
                          children: [
                            _SearchInput(
                              icon: Icons.location_on,
                              hint: 'From where?',
                              controller: _fromController,
                              iconColor: AppColors.navy900,
                              hintColor: AppColors.navy900,
                              onChanged: (v) => debugPrint(
                                '⌨️ [TimeBuildingPostScreen] FROM changed: $v',
                              ),
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.borderLight,
                            ),
                            _SearchInput(
                              icon: Icons.location_on,
                              hint: 'Where to?',
                              controller: _toController,
                              iconColor: AppColors.navy900,
                              hintColor: AppColors.navy900,
                              onChanged: (v) => debugPrint(
                                '⌨️ [TimeBuildingPostScreen] TO changed: $v',
                              ),
                              trailing: GestureDetector(
                                onTap: _swapFromTo,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.cardLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.swap_vert,
                                    size: 20,
                                    color: AppColors.navy900,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Date of departure – hint "Date of departure", tıklanınca takvim bugün seçili
                      DatePickerField(
                        style: DatePickerFieldStyle.borderedIcon,
                        hint: 'Date of departure',
                        icon: Icons.calendar_today,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365 * 5)),
                        prefillFromInitialDate: false,
                        onDateChanged: (d) =>
                            setState(() => _departureDate = d),
                      ),

                      const SizedBox(height: 16),

                      // Date of arrival – hint "Date of arrival", tıklanınca takvim bugün seçili
                      DatePickerField(
                        style: DatePickerFieldStyle.borderedIcon,
                        hint: 'Date of arrival',
                        icon: Icons.calendar_today,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365 * 5)),
                        prefillFromInitialDate: false,
                        onDateChanged: (d) =>
                            setState(() => _arrivalDate = d),
                      ),

                      const SizedBox(height: 16),

                      // Licenses
                      _buildBorderedInput(
                        icon: Icons.card_membership,
                        hint: 'Licenses',
                        controller: _licensesController,
                        onChanged: (v) => debugPrint(
                          '⌨️ [TimeBuildingPostScreen] Licenses changed: $v',
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Cost
                      _buildBorderedInput(
                        icon: Icons.attach_money,
                        hint: 'Cost',
                        controller: _costController,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => debugPrint(
                          '⌨️ [TimeBuildingPostScreen] Cost changed: $v',
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Passengers – dış border, app_colors
                      Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.cardLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.navy900, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.sentiment_satisfied_alt,
                              size: 24,
                              color: AppColors.navy900,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Passengers',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: AppColors.navy900,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                _CounterButton(
                                  icon: Icons.remove,
                                  onPressed: _decreasePassengers,
                                  iconColor: AppColors.white,
                                  bgColor: AppColors.navy900,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '$_passengers',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.navy900,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                _CounterButton(
                                  icon: Icons.add,
                                  onPressed: _increasePassengers,
                                  iconColor: AppColors.white,
                                  bgColor: AppColors.navy900,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 18 + MediaQuery.of(context).viewPadding.bottom),
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

class _SearchInput extends StatelessWidget {
  const _SearchInput({
    required this.icon,
    required this.hint,
    required this.controller,
    this.trailing,
    this.keyboardType,
    this.onChanged,
    this.iconColor,
    this.hintColor,
  });

  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final Color? iconColor;
  final Color? hintColor;

  @override
  Widget build(BuildContext context) {
    final ic = iconColor ?? AppColors.navy900;
    final hc = hintColor ?? AppColors.navy900;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: ic),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              onChanged: onChanged,
              style: TextStyle(fontSize: 16, color: ic),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                hintText: hint,
                hintStyle: TextStyle(fontSize: 16, color: hc),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.bgColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.navy900,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: iconColor ?? AppColors.white,
        ),
      ),
    );
  }
}
