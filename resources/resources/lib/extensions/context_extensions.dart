import 'package:flash/flash.dart';
import 'package:flutter/widgets.dart';
import 'package:resources/localization/app_localizations.dart';
import 'package:resources/widgets/custom_flash_widget.dart';

extension ContextExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  void showCustomFlashMessage({
    String? title,
    String? message,
    bool positionBottom = false,
    bool darkTheme = false,
    required String status,
  }) {
    final l10n = AppLocalizations.of(this);
    final resolvedTitle = title ?? l10n.unexpectedError;
    final resolvedMessage = message ?? l10n.unexpectedError;
    showFlash(
      context: this,
      duration: const Duration(seconds: 2),
      builder: (_, controller) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: CustomFlashWidget(
            status: status,
            controller: controller,
            title: resolvedTitle,
            message: resolvedMessage,
            darkTheme: darkTheme,
            positionBottom: positionBottom,
          ),
        );
      },
    );
  }
}
