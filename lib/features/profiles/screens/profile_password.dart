import 'package:clarified_mobile/features/shared/widgets/page_buttom_slug.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final currentPasswordTextController = TextEditingController();
  final newPasswordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        // mainAxisSize: MainAxisSize.min,

        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: PasswordInputBox(
                    label: "Current Password",
                    textController: currentPasswordTextController,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: PasswordInputBox(
                    label: "New Password",
                    textController: newPasswordTextController,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: PasswordInputBox(
                    label: "Confirm Password",
                    textController: confirmPasswordTextController,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Password must contain:',
                  style: TextStyle(
                    color: Color(0xFF344054),
                    fontSize: 12,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Min 6 characters',
                      style: TextStyle(
                        color: Color(0xFF475467),
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'At least 1 special characters',
                      style: TextStyle(
                        color: Color(0xFF475467),
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'At least 1 number',
                      style: TextStyle(
                        color: Color(0xFF475467),
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF04686E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFF04686E),
                ),
                elevation: 3,
              ),
              onPressed: () async {
                print("MROE MORE MOIRE");
              },
              child: const Text(
                "UPDATE PASSWORD",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const PageButtomSlug(),
    );
  }
}

class PasswordInputBox extends StatefulWidget {
  const PasswordInputBox({
    super.key,
    required this.textController,
    required this.label,
  });

  final TextEditingController textController;
  final String label;

  @override
  State<PasswordInputBox> createState() => _PasswordInputBoxState();
}

class _PasswordInputBoxState extends State<PasswordInputBox> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Color(0xFF344054),
            fontSize: 14,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            // vertical: 12,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFEAECF0),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x0C101828),
                blurRadius: 2,
                offset: Offset(0, 1),
                spreadRadius: 0,
              )
            ],
          ),
          child: TextFormField(
            controller: widget.textController,
            obscureText: !showPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: IconButton(
                // padding: const EdgeInsets.all(1),
                icon: const Icon(Icons.visibility),
                selectedIcon: const Icon(Icons.visibility_off),
                isSelected: showPassword,
                onPressed: () => setState(
                  () => showPassword = !showPassword,
                ),
              ),
            ),
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF475467),
            ),
          ),
        ),
      ],
    );
  }
}
