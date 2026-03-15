import 'package:flutter/material.dart';

final class DottoTextField extends StatelessWidget {
  const DottoTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.onCleared,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final VoidCallback? onCleared;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    if (controller == null) {
      return TextField(
        focusNode: focusNode,
        decoration: InputDecoration(hintText: placeholder),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      );
    }

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: placeholder,
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.clear();
                      onCleared?.call();
                    },
                  )
                : null,
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        );
      },
    );
  }
}
