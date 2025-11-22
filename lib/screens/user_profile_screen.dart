import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../model/user_profile_data.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../services/user_profile_service.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import 'login_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileService _profileService = UserProfileService();
  late Future<UserProfileData> _profileFuture;
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<UserProfileData> _loadProfile() async {
    final authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    return _profileService.fetchProfileData(
      userId: user.uid,
      fallbackName: user.displayName ?? 'User',
      fallbackEmail: user.email ?? 'N/A',
    );
  }

  void _refreshProfile() {
    setState(() {
      _profileFuture = _loadProfile();
    });
  }

  void _showLanguageSheet() {
    if (!mounted) return;
    final localeProvider = context.read<LocaleProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final localization = AppLocalizations.of(context);
        final currentLocale = localeProvider.locale.languageCode;
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  Text(
                    localization.language,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    localization.languageDescription,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  RadioListTile<String>(
                    value: 'en',
                    groupValue: currentLocale,
                    title: Text(
                      localization.languageEnglish,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        localeProvider.setLocale(const Locale('en'));
                        Navigator.pop(context);
                      }
                    },
                  ),
                  RadioListTile<String>(
                    value: 'so',
                    groupValue: currentLocale,
                    title: Text(
                      localization.languageSomali,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        localeProvider.setLocale(const Locale('so'));
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    // Show option to pick from gallery or camera
    if (!mounted) return;
    
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );

    if (source == null || !mounted) return;

    // Request appropriate permission based on source
    final hasPermission = source == ImageSource.camera
        ? await _ensureCameraPermission()
        : await _ensureGalleryPermission();
    
    if (!hasPermission) return;

    final result = await _picker.pickImage(source: source);
    if (!mounted || result == null) return;

    setState(() {
      _profileImage = File(result.path);
    });
  }

  Future<bool> _ensureGalleryPermission() async {
    try {
      Permission permission;
      
      if (Platform.isIOS) {
        permission = Permission.photos;
      } else {
        // For Android 13+ (API 33+), Permission.photos maps to READ_MEDIA_IMAGES
        // For older versions, it should still work but may need storage permission
        // The permission_handler package handles this automatically
        permission = Permission.photos;
      }

      var status = await permission.status;
      if (status.isGranted) {
        return true;
      }

      status = await permission.request();
      if (status.isGranted) {
        return true;
      }

      // If photos permission is denied, try storage permission for older Android
      if (Platform.isAndroid && !status.isGranted) {
        final storagePermission = Permission.storage;
        final storageStatus = await storagePermission.status;
        if (storageStatus.isGranted) {
          return true;
        }
        final requestedStorageStatus = await storagePermission.request();
        if (requestedStorageStatus.isGranted) {
          return true;
        }
      }

      if (mounted) {
        final message = status.isPermanentlyDenied
            ? 'Please enable photo permissions in Settings.'
            : 'Photo permission is required to pick an image.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
          ),
        );
      }

      if (status.isPermanentlyDenied && mounted) {
        await openAppSettings();
      }

      return false;
    } catch (e) {
      // If permission handling fails, try to proceed anyway
      // image_picker might handle permissions internally
      if (mounted) {
        debugPrint('Permission error: $e');
      }
      return true; // Allow image_picker to handle permissions
    }
  }

  Future<bool> _ensureCameraPermission() async {
    final permission = Permission.camera;
    
    var status = await permission.status;
    if (status.isGranted) {
      return true;
    }

    status = await permission.request();
    if (status.isGranted) {
      return true;
    }

    if (mounted) {
      final message = status.isPermanentlyDenied
          ? 'Please enable camera permissions in Settings.'
          : 'Camera permission is required to take a photo.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    if (status.isPermanentlyDenied && mounted) {
      await openAppSettings();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final background = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        iconTheme: theme.appBarTheme.iconTheme,
        title: Text(
          localization.profile,
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProfile,
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return IconButton(
                tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode_outlined),
                onPressed: themeProvider.toggleTheme,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _showLanguageSheet,
            tooltip: localization.language,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: FutureBuilder<UserProfileData>(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return _ErrorState(
                  message: snapshot.error.toString(),
                  onRetry: _refreshProfile,
                );
              }
              final profile = snapshot.data;
              if (profile == null) {
                return _ErrorState(
                  message: 'Unable to load profile.',
                  onRetry: _refreshProfile,
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = math.min(constraints.maxWidth, 520.0);
                  return SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: _ProfileCard(
                            cardColor: cardColor,
                            data: profile,
                            profileImage: _profileImage,
                            onAvatarTap: _pickImage,
                            onLogout: _handleLogout,
                            localization: localization,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          content: const SizedBox.shrink(),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(   color:  Color(0XFF0a032c),
 width: 1.5),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
   color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0XFF0a032c),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Log out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );

    // If user cancelled, do nothing
    if (shouldLogout != true || !mounted) return;

    // Proceed with logout
    final authProvider = context.read<AuthProvider>();
    final cartProvider = context.read<CartProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      // Clear cart before signing out
      await cartProvider.clearUserCart();
      await authProvider.signOut();
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Signed out successfully.')),
      );
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Failed to sign out. Please try again.')),
      );
    }
  }
}

class _ProfileCard extends StatelessWidget {
  final Color cardColor;
  final UserProfileData data;
  final File? profileImage;
  final VoidCallback onAvatarTap;
  final Future<void> Function() onLogout;
  final AppLocalizations localization;

  const _ProfileCard({
    required this.cardColor,
    required this.data,
    required this.profileImage,
    required this.onAvatarTap,
    required this.onLogout,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final initials = _buildInitials(data.fullName);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: onAvatarTap,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 104.w,
                        height: 104.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: profileImage == null
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF4C6FFF),
                                    Color(0xFF1EB980),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: profileImage != null
                              ? Image.file(
                                  profileImage!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.transparent,
                                  alignment: Alignment.center,
                                  child: Text(
                                    initials,
                                    style: TextStyle(
                                  color: Colors.white,
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        width: 34.w,
                        height: 34.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  data.fullName,
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  data.status,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  data.email,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 28.h),
          _OptionTile(
            icon: Icons.person_outline,
            iconColor: const Color(0xFF60B158),
            label: localization.personalData,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localization.personalData)),
              );
            },
          ),
          _OptionTile(
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFFFFB648),
            label: localization.orderStatus,
            onTap: () {},
          ),
          _OptionTile(
            icon: Icons.mail_outline,
            iconColor: const Color(0xFF5A8CFF),
            label: localization.messages,
            onTap: () {},
          ),
          _OptionTile(
            icon: Icons.notifications_none,
            iconColor: const Color(0xFFFF6D7A),
            label: localization.notifications,
            onTap: () {},
          ),
          _OptionTile(
            icon: Icons.location_on_outlined,
            iconColor: const Color(0xFFB983FF),
            label: localization.trackingOrder,
            onTap: () {},
          ),
          _OptionTile(
            icon: Icons.logout,
            iconColor: const Color(0xFFE35050),
            label: localization.logout,
            onTap: () async {
              await onLogout();
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }

  String _buildInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.last.isNotEmpty ? parts.last[0] : '';
    final combined = (first + last).trim();
    return combined.isEmpty ? 'U' : combined.toUpperCase();
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  const _OptionTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 46.w,
                  height: 46.w,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            color: theme.dividerColor,
            height: 1.h,
          ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}


