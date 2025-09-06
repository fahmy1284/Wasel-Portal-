import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

enum TextFieldType { text, email, password, phone, number, multiline }

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextFieldType type;
  final bool isRequired;
  final bool isReadOnly;
  final int? maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.initialValue,
    this.type = TextFieldType.text,
    this.isRequired = false,
    this.isReadOnly = false,
    this.maxLines,
    this.maxLength,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  bool _obscureText = true;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: AppTheme.labelLarge,
              ),
              if (widget.isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: AppTheme.errorRed,
                    fontSize: 16,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          obscureText: widget.type == TextFieldType.password && _obscureText,
          readOnly: widget.isReadOnly,
          maxLines: _getMaxLines(),
          maxLength: widget.maxLength,
          keyboardType: _getKeyboardType(),
          textInputAction: _getTextInputAction(),
          inputFormatters: _getInputFormatters(),
          validator: widget.validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          style: AppTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: _getPrefixIcon(),
            suffixIcon: _getSuffixIcon(),
            counterText: widget.maxLength != null ? null : '',
          ),
        ),
      ],
    );
  }

  int? _getMaxLines() {
    if (widget.maxLines != null) return widget.maxLines;
    if (widget.type == TextFieldType.multiline) return 4;
    if (widget.type == TextFieldType.password) return 1;
    return 1;
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.phone:
        return TextInputType.phone;
      case TextFieldType.number:
        return TextInputType.number;
      case TextFieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getTextInputAction() {
    if (widget.type == TextFieldType.multiline) {
      return TextInputAction.newline;
    }
    return TextInputAction.next;
  }

  List<TextInputFormatter> _getInputFormatters() {
    List<TextInputFormatter> formatters = widget.inputFormatters ?? [];

    switch (widget.type) {
      case TextFieldType.phone:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        formatters.add(LengthLimitingTextInputFormatter(15));
        break;
      case TextFieldType.number:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;
      case TextFieldType.email:
        formatters.add(FilteringTextInputFormatter.deny(RegExp(r'\s')));
        break;
      default:
        break;
    }

    return formatters;
  }

  Widget? _getPrefixIcon() {
    if (widget.prefixIcon != null) return widget.prefixIcon;

    switch (widget.type) {
      case TextFieldType.email:
        return const Icon(Icons.email_outlined);
      case TextFieldType.phone:
        return const Icon(Icons.phone_outlined);
      case TextFieldType.password:
        return const Icon(Icons.lock_outline);
      default:
        return null;
    }
  }

  Widget? _getSuffixIcon() {
    if (widget.suffixIcon != null) return widget.suffixIcon;

    if (widget.type == TextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      );
    }

    return null;
  }
}

// Validators
class TextFieldValidators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    
    final phoneRegex = RegExp(r'^(\+967|967|0)?[1-9][0-9]{7,8}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'يرجى إدخال رقم هاتف صحيح';
    }
    
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير وصغير ورقم';
    }
    
    return null;
  }

  static String? nationalId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهوية الوطنية مطلوب';
    }
    
    final nationalIdRegex = RegExp(r'^[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{7}$');
    if (!nationalIdRegex.hasMatch(value.trim())) {
      return 'يرجى إدخال رقم هوية وطنية صحيح (XX-XX-XX-XXXXXXX)';
    }
    
    return null;
  }

  static String? minLength(int minLength) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'هذا الحقل مطلوب';
      }
      
      if (value.trim().length < minLength) {
        return 'يجب أن يكون النص $minLength أحرف على الأقل';
      }
      
      return null;
    };
  }

  static String? maxLength(int maxLength) {
    return (String? value) {
      if (value != null && value.trim().length > maxLength) {
        return 'يجب أن يكون النص $maxLength حرف كحد أقصى';
      }
      
      return null;
    };
  }

  static String? combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}