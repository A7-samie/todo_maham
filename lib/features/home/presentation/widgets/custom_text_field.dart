import 'package:material_ui/material_ui.dart';
import 'package:todo_maham/core/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final double? width;
  final bool? isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String value)? onChanged;
  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.width,
    this.isPassword,
    this.controller,
    this.validator,
    this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColor.whiteColor,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: prefixIcon ?? Icon(Icons.search),
          hintText: hintText,
          prefixIconConstraints: BoxConstraints(maxHeight: 25, maxWidth: 20),
          border: InputBorder.none,
          hintStyle: TextStyle(),
        ),
      ),
    );
  }
}
