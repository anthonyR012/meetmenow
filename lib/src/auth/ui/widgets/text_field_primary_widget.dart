import 'package:flutter/material.dart';

class TextFieldPrimary extends StatefulWidget {
  const TextFieldPrimary(
      {super.key, required this.hint, this.hasObscure = false, required this.controller});
  final String hint;
  final bool hasObscure;
  final TextEditingController controller;

  @override
  State<TextFieldPrimary> createState() => _TextFieldPrimaryState();
}

class _TextFieldPrimaryState extends State<TextFieldPrimary> {
  bool _isObscure = true;

  @override
  void initState() {
    _isObscure = widget.hasObscure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _isObscure,
      controller: widget.controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: widget.hasObscure
            ? InkWell(
                onTap: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
                child: Icon(_isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white70))
            : null,
      ),
    );
  }
}
