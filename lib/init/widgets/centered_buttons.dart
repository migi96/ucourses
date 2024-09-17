import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/constants_exports.dart';

class CenteredButtons extends StatefulWidget {
  final VoidCallback onAdminPressed;
  final VoidCallback onStudentPressed;

  const CenteredButtons({
    super.key,
    required this.onAdminPressed,
    required this.onStudentPressed,
  });

  @override
  _CenteredButtonsState createState() => _CenteredButtonsState();
}

class _CenteredButtonsState extends State<CenteredButtons> {
  bool _isHoveredAdmin = false;
  bool _isHoveredStudent = false;
  bool _isAdminSelected = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHoveredAdmin = true),
          onExit: (_) => setState(() => _isHoveredAdmin = false),
          child: _buildTextButtonWithIcon(
            onPressed: () {
              widget.onAdminPressed();
              setState(() {
                _isAdminSelected = true;
              });
            },
            icon: FontAwesomeIcons.userTie,
            label: AppTexts.admin,
            isHovered: _isHoveredAdmin || _isAdminSelected,
          ),
        ),
        const SizedBox(width: 40), // Space between buttons
        MouseRegion(
          onEnter: (_) => setState(() => _isHoveredStudent = true),
          onExit: (_) => setState(() => _isHoveredStudent = false),
          child: _buildTextButtonWithIcon(
            onPressed: () {
              widget.onStudentPressed();
              setState(() {
                _isAdminSelected = false;
              });
            },
            icon: FontAwesomeIcons.userGraduate,
            label: AppTexts.student,
            isHovered: _isHoveredStudent || !_isAdminSelected,
          ),
        ),
      ],
    );
  }

  Widget _buildTextButtonWithIcon({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isHovered,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHovered ? Colors.white : Colors.white.withOpacity(0.3),
        ),
        color: isHovered ? Colors.white : Colors.transparent,
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isHovered ? AppColors.primaryColor : Colors.white,
        ),
        label: Text(
          label,
          style: Styles.style18.copyWith(
            color: isHovered ? AppColors.primaryColor : Colors.white,
          ),
        ),
      ),
    );
  }
}
