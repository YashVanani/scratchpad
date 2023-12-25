import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnlockPopUp extends StatefulWidget {
  final String message;
  final Future Function() onConfirmed;
  const UnlockPopUp({
    super.key,
    required this.message,
    required this.onConfirmed,
  });

  @override
  State<UnlockPopUp> createState() => _UnlockPopUpState();
}

class _UnlockPopUpState extends State<UnlockPopUp> {
  bool isBusy = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 86,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.confirmation,
                      style: TextStyle(
                        color: Color(0xFF1D2939),
                        fontSize: 20,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isBusy)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: SizedBox.square(
                          dimension: 12,
                          child: CircularProgressIndicator(),
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      color: Color(0xFF475467),
                      fontSize: 14,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xFFEAECF0)),
                top: BorderSide(width: 1, color: Color(0xFFEAECF0)),
                right: BorderSide(color: Color(0xFFEAECF0)),
                bottom: BorderSide(color: Color(0xFFEAECF0)),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed:
                      isBusy ? null : () => Navigator.of(context).maybePop(),
                  child: Text(
                    AppLocalizations.of(context)!.cancel_capital,
                    style: TextStyle(
                      color: Color(0xFF344054),
                      fontSize: 14,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 96),
                TextButton(
                  onPressed: isBusy
                      ? null
                      : () async {
                          setState(() => isBusy = true);
                          try {
                            await widget.onConfirmed();
                            Navigator.of(context).maybePop();
                            return;
                          } catch (e) {
                            print(e);
                          }

                          setState(() => isBusy = false);
                        },
                  child: Text(
                    AppLocalizations.of(context)!.yes_unlock,
                    style: TextStyle(
                      color: Color(0xFF12B669),
                      fontSize: 14,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
