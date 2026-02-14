import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:skye_app/shared/services/api_service.dart';
import 'package:skye_app/shared/services/auth_api_service.dart';
import 'package:skye_app/shared/services/pilot_api_service.dart';
import 'package:skye_app/shared/widgets/auth_avatar_image.dart';
import 'package:skye_app/shared/services/profile_avatar_cache.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/app_text_field.dart';
import 'package:skye_app/shared/widgets/date_picker_field.dart';
import 'package:skye_app/shared/widgets/toast_overlay.dart';

/// Edit profile - name, surname, date of birth, email, phone, password
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  static const routeName = '/profile/edit';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _avatarFile;
  String? _avatarUrl;
  final ImagePicker _imagePicker = ImagePicker();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _dateOfBirth;
  final _dateController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _phoneError;
  String? _newPasswordError;
  String? _confirmError;

  @override
  void initState() {
    super.initState();
    debugPrint('✏️ [EditProfileScreen] initState()');
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await AuthApiService.instance.getMe();
      Map<String, dynamic> u = user['user'] as Map<String, dynamic>? ?? user;
      final pilotProfile = await PilotApiService.instance.getPilotProfile();
      if (pilotProfile != null && mounted) {
        final pp = pilotProfile['data'] as Map<String, dynamic>? ?? pilotProfile;
        final photoPath = pp['profile_photo_path']?.toString();
        if (photoPath != null && photoPath.trim().isNotEmpty) {
          u = Map<String, dynamic>.from(u)..['profile_photo_path'] = photoPath;
          debugPrint('✏️ [EditProfileScreen] merged profile_photo_path from pilot profile');
        }
      }
      if (mounted) {
        final fn = (u['first_name'] ?? u['firstName'] ?? '').toString().trim();
        final ln = (u['last_name'] ?? u['lastName'] ?? '').toString().trim();
        if (fn.isNotEmpty || ln.isNotEmpty) {
          _firstNameController.text = fn;
          _lastNameController.text = ln;
        } else {
          final name = (u['name'] ?? u['full_name'] ?? '').toString().trim();
          if (name.isNotEmpty) {
            final parts = name.split(RegExp(r'\s+'));
            _firstNameController.text = parts.first;
            _lastNameController.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
          }
        }
        _emailController.text = (u['email'] ?? '').toString().trim();
        _phoneController.text = (u['phone'] ?? u['phone_number'] ?? '').toString().trim();
        final dob = u['date_of_birth'] ?? u['dateOfBirth'] ?? u['birth_date'];
        if (dob != null && dob.toString().isNotEmpty) {
          _dateOfBirth = DateTime.tryParse(dob.toString().split('T').first);
          if (_dateOfBirth != null) {
            _dateController.text = DateFormat('MM/dd/yyyy').format(_dateOfBirth!);
          }
        }
        final photoPath = u['profile_photo_path'] ?? u['avatar'] ?? u['profile_image'] ?? u['photo_url'];
        if (photoPath != null && photoPath.toString().trim().isNotEmpty) {
          final path = photoPath.toString().trim();
          _avatarUrl = path.startsWith('http') ? path : '${ApiService.baseUrl.replaceFirst('/api', '')}${path.startsWith('/') ? '' : '/'}$path';
        }
        final cached = ProfileAvatarCache.instance.file;
        if (_avatarFile == null && cached != null && cached.existsSync()) {
          _avatarFile = cached;
          debugPrint('✏️ [EditProfileScreen] restored avatar from cache');
        }
        setState(() {});
      }
    } catch (e) {
      debugPrint('❌ [EditProfileScreen] loadUser error: $e');
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  bool _validate() {
    _firstNameError = _firstNameController.text.trim().isEmpty ? 'First name required' : null;
    _lastNameError = _lastNameController.text.trim().isEmpty ? 'Last name required' : null;
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _emailError = 'Email required';
    } else if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(email)) {
      _emailError = 'Invalid email format';
    } else {
      _emailError = null;
    }
    _phoneError = _phoneController.text.trim().isEmpty ? 'Phone required' : null;

    final newPass = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;
    if (newPass.isNotEmpty || confirm.isNotEmpty) {
      _newPasswordError = newPass.length < 8 ? 'Password must be at least 8 characters' : null;
      _confirmError = newPass != confirm ? 'Passwords do not match' : null;
    } else {
      _newPasswordError = null;
      _confirmError = null;
    }
    return _firstNameError == null &&
        _lastNameError == null &&
        _emailError == null &&
        _phoneError == null &&
        _newPasswordError == null &&
        _confirmError == null;
  }

  Future<void> _save() async {
    debugPrint('💾 [EditProfileScreen] save pressed');
    if (!_validate()) {
      setState(() {});
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthApiService.instance.updateProfile({
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'name': '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        if (_dateOfBirth != null) 'date_of_birth': DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
      });

      if (_avatarFile != null && _avatarFile!.existsSync()) {
        try {
          await PilotApiService.instance.uploadProfilePhoto(_avatarFile!);
        } catch (e) {
          debugPrint('⚠️ [EditProfileScreen] avatar upload failed (may not be pilot): $e');
        }
      }

      final newPass = _newPasswordController.text;
      if (newPass.isNotEmpty && _currentPasswordController.text.isNotEmpty) {
        await AuthApiService.instance.updatePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: newPass,
          newPasswordConfirmation: _confirmPasswordController.text,
        );
      }

      if (mounted) {
        ProfileAvatarCache.instance.set(_avatarFile);
        ToastOverlay.show(context, 'Profile updated successfully', isError: false);
        Navigator.of(context).pop({'updated': true, 'avatarFile': _avatarFile});
      }
    } catch (e) {
      debugPrint('❌ [EditProfileScreen] save error: $e');
      if (mounted) {
        ToastOverlay.show(context, 'Failed to update: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('✏️ [EditProfileScreen] build()');
    SystemUIHelper.setLightStatusBar();

    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.labelBlack),
          onPressed: () {
            debugPrint('⬅️ [EditProfileScreen] Back pressed');
            ProfileAvatarCache.instance.set(_avatarFile);
            Navigator.of(context).pop({'updated': _avatarFile != null, 'avatarFile': _avatarFile});
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.labelBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAvatarSection(),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.labelBlack.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.labelBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'First Name',
                    controller: _firstNameController,
                    errorText: _firstNameError,
                    fillColor: AppColors.white,
                    enabledBorderSide: BorderSide(color: AppColors.textGray.withValues(alpha: 0.6), width: 1),
                    onChanged: (_) => setState(() => _firstNameError = null),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Last Name',
                    controller: _lastNameController,
                    errorText: _lastNameError,
                    fillColor: AppColors.white,
                    enabledBorderSide: BorderSide(color: AppColors.textGray.withValues(alpha: 0.6), width: 1),
                    onChanged: (_) => setState(() => _lastNameError = null),
                  ),
                  const SizedBox(height: 16),
                  DatePickerField(
                    label: 'Date of Birth',
                    hint: 'MM/DD/YYYY',
                    controller: _dateController,
                    fillColor: AppColors.white,
                    enabledBorderSide: BorderSide(color: AppColors.textGray.withValues(alpha: 0.6), width: 1),
                    initialDate: _dateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    prefillFromInitialDate: _dateOfBirth != null,
                    onDateChanged: (d) {
                      debugPrint('📅 [EditProfileScreen] date selected: $d');
                      setState(() => _dateOfBirth = d);
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                    fillColor: AppColors.white,
                    enabledBorderSide: BorderSide(color: AppColors.textGray.withValues(alpha: 0.6), width: 1),
                    onChanged: (_) => setState(() => _emailError = null),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Phone',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    errorText: _phoneError,
                    fillColor: AppColors.white,
                    enabledBorderSide: BorderSide(color: AppColors.textGray.withValues(alpha: 0.6), width: 1),
                    onChanged: (_) => setState(() => _phoneError = null),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.labelBlack.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.labelBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Leave blank to keep current password',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Current Password',
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrent,
                    fillColor: AppColors.white,
                    enabledBorderSide: BorderSide(color: AppColors.textGray.withValues(alpha: 0.6), width: 1),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textGray,
                      ),
                      onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'New Password',
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    errorText: _newPasswordError,
                    fillColor: AppColors.white,
                    enabledBorderSide: BorderSide(color: AppColors.textGray.withValues(alpha: 0.6), width: 1),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNew ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textGray,
                      ),
                      onPressed: () => setState(() => _obscureNew = !_obscureNew),
                    ),
                    onChanged: (_) => setState(() => _newPasswordError = null),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Confirm New Password',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    errorText: _confirmError,
                    fillColor: AppColors.white,
                    enabledBorderSide: BorderSide(color: AppColors.textGray.withValues(alpha: 0.6), width: 1),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textGray,
                      ),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    onChanged: (_) => setState(() => _confirmError = null),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy800,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ),
              const SizedBox(height: 12),
            ],
        ),
      ),
    )
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: GestureDetector(
        onTap: _showAvatarPicker,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.navy800, width: 2),
              ),
              child: _avatarFile != null
                  ? ClipOval(
                      child: Image.file(
                        _avatarFile!,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    )
                  : _avatarUrl != null && _avatarUrl!.trim().isNotEmpty
                      ? AuthAvatarImage(
                          imageUrl: _avatarUrl!,
                          size: 100,
                          placeholderIconSize: 48,
                        )
                      : CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.cardLight,
                          child: Icon(
                            Icons.person,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                        ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.navy800,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAvatarPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Change Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelBlack,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.navy800),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.labelBlack),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.navy800),
                title: const Text(
                  'Choose from Library',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.labelBlack),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final xf = await _imagePicker.pickImage(
        source: source,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 85,
      );
      if (xf != null && mounted) {
        setState(() => _avatarFile = File(xf.path));
      }
    } catch (e) {
      debugPrint('❌ [EditProfileScreen] pickImage error: $e');
      if (mounted) {
        ToastOverlay.show(context, 'Failed to pick image: $e');
      }
    }
  }
}
