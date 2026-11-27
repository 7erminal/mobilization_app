import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

/// Shows "Reference: <short id>" for a failed request, with tap-to-copy for
/// the full id. Renders nothing when [requestId] is null/empty.
///
/// Usage on error screens/dialogs:
/// ```dart
/// informationDialogWithButton(context, 'Payment Failed', message,
///     BrandColors.danger, BrandColors.black, 'Retry', () => Navigator.pop(context),
///     requestId: failure.requestId);
/// ```
///
/// The id comes from `error.request_id` in the server response, falling back
/// to the `X-Request-Id` response header, and finally to the client-generated
/// request id when the server never answered. IDs are logging labels and
/// contain no PII.
class ReferenceTag extends StatelessWidget {
  const ReferenceTag({
    super.key,
    required this.requestId,
    this.label = 'Reference',
  });

  /// The X-Request-Id of the failed call.
  final String? requestId;

  /// Prefix shown before the id.
  final String label;

  static const int _visibleChars = 8;

  @override
  Widget build(BuildContext context) {
    final String? id = requestId;
    if (id == null || id.isEmpty) return const SizedBox.shrink();

    final String shortId =
        id.length <= _visibleChars ? id : id.substring(0, _visibleChars);

    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: id));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('$label copied (${shortId}\u2026)'),
              duration: const Duration(seconds: 2),
            ),
          );
      },
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '$shortId\u2026',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: BrandColors.primaryColorDark,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.copy, size: 13, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
