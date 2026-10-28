import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/utils/extensions.dart';

class DialogForm extends HookConsumerWidget {
  const DialogForm({
    super.key,
    required this.children,
  });
  final List<Widget> children;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final isModified = useState(false);
    return Dialog(
      alignment: Alignment.bottomCenter,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
        side: BorderSide(
          color: context.colorScheme.outline.withOpacity(.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: formKey,
          onChanged: () => isModified.value = true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...children,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).maybePop();
                    },
                    child: const Text("Cancel"),
                  ),
                  Container(
                    width: 1,
                    height: context.textTheme.labelMedium?.fontSize,
                    color: context.colorScheme.outline,
                  ),
                  TextButton(
                    onPressed: isModified.value
                        ? () async {
                            final currentState = formKey.currentState;

                            if (currentState == null) {
                              Navigator.of(context).maybePop();
                              return;
                            }

                            if (!currentState.saveAndValidate()) {
                              Navigator.of(context).maybePop();
                              return;
                            }

                            final values = currentState.value;

                            Navigator.of(context).maybePop(values);
                          }
                        : null,
                    child: const Text("Confirm"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
