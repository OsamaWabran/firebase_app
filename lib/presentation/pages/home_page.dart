import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/notification_controller.dart';

class HomePage extends GetView<NotificationController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFE8F7F4),
              Color(0xFFF4F7FB),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _HeroSection(textTheme: textTheme, colorScheme: colorScheme),
                const SizedBox(height: 20),
                Obx(
                  () => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      _StatusChip(
                        icon: Icons.notifications_active_rounded,
                        label: controller.permissionStatus.value,
                        backgroundColor: const Color(0xFFE4F8F0),
                        foregroundColor: const Color(0xFF0F766E),
                      ),
                      _StatusChip(
                        icon: Icons.wifi_tethering_rounded,
                        label: controller.messagingStatus.value,
                        backgroundColor: const Color(0xFFE8F0FE),
                        foregroundColor: const Color(0xFF1D4ED8),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text('Quick Actions', style: textTheme.titleLarge),
                const SizedBox(height: 12),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      SizedBox(
                        width: 220,
                        child: FilledButton.icon(
                          onPressed: controller.isRequestingPermission.value
                              ? null
                              : controller.requestPermission,
                          icon: controller.isRequestingPermission.value
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.shield_outlined),
                          label: Text(
                            controller.isRequestingPermission.value
                                ? 'Requesting...'
                                : 'Request Permission',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: OutlinedButton.icon(
                          onPressed: controller.isLoadingToken.value
                              ? null
                              : controller.fetchToken,
                          icon: controller.isLoadingToken.value
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.vpn_key_outlined),
                          label: Text(
                            controller.isLoadingToken.value
                                ? 'Loading...'
                                : 'Get FCM Token',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _SectionCard(
                  title: 'FCM Token',
                  subtitle:
                      'Use this token to target the current device from Firebase or your backend.',
                  trailing: Obx(
                    () => IconButton.filledTonal(
                      onPressed: controller.token.value.isEmpty
                          ? null
                          : () async {
                              await Clipboard.setData(
                                ClipboardData(text: controller.token.value),
                              );
                              Get.snackbar(
                                'Copied',
                                'The FCM token has been copied to the clipboard.',
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16),
                              );
                            },
                      icon: const Icon(Icons.copy_rounded),
                    ),
                  ),
                  child: Obx(
                    () => SelectableText(
                      controller.token.value.isEmpty
                          ? 'Press "Get FCM Token" to load the device token.'
                          : controller.token.value,
                      style: textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        color: const Color(0xFF334155),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => _SectionCard(
                    title: 'Last Notification',
                    subtitle:
                        'The latest title and body captured from foreground, background tap, or terminated launch.',
                    child: controller.lastNotification.value == null
                        ? Row(
                            children: <Widget>[
                              Icon(
                                Icons.mark_email_unread_outlined,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'No notification has been received yet.',
                                  style: textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                controller.lastNotification.value!.title,
                                style: textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.lastNotification.value!.body,
                                style: textTheme.bodyLarge?.copyWith(
                                  color: const Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Flow Coverage',
                  subtitle: 'Implemented notification scenarios in the app.',
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _CoverageItem(
                        icon: Icons.visibility_rounded,
                        text:
                            'Foreground: remote notification is mirrored with flutter_local_notifications.',
                      ),
                      SizedBox(height: 10),
                      _CoverageItem(
                        icon: Icons.layers_rounded,
                        text:
                            'Background: background handler is registered and tap events update the screen.',
                      ),
                      SizedBox(height: 10),
                      _CoverageItem(
                        icon: Icons.power_settings_new_rounded,
                        text:
                            'Terminated: initial message is captured through getInitialMessage when the app launches from a notification.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.textTheme, required this.colorScheme});

  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF0F766E),
            Color(0xFF155E75),
            Color(0xFF1D4ED8),
          ],
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1F0F172A),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Firebase Messaging Lab',
            style: textTheme.headlineMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'A Clean Architecture sample using GetX for dependency injection, navigation, and presentation state.',
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.bolt_rounded,
                  color: colorScheme.tertiaryContainer,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Foreground, Background, and Terminated states covered.',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title, style: textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                ...(trailing != null ? <Widget>[trailing!] : const <Widget>[]),
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48, maxWidth: 420),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: foregroundColor),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverageItem extends StatelessWidget {
  const _CoverageItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 18, color: const Color(0xFF0F766E)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF334155),
            ),
          ),
        ),
      ],
    );
  }
}
