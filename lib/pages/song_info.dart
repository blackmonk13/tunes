
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/join_btns.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class SongInfo extends HookConsumerWidget {
  final SongModel songInfo;
  const SongInfo({super.key, required this.songInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final decoded = useState("");
    final isModified = useState(false);

    ref.listen(metadataControllerProvider(songInfo), (previous, next) {
      final nextValue = next.valueOrNull;

      if (next.hasError) {
        context.showErrorSnackBar(
          message: "Error updating metadata.",
        );
      }
      if (nextValue == null) {
        return;
      }

      if (nextValue) {
        context.showSnackBar(
          message: "Metadata Updated.",
        );
      } else {
        context.showErrorSnackBar(
          message: "Error updating metadata.",
        );
      }
    });

    final asyncMetadataController =
        ref.watch(metadataControllerProvider(songInfo));

    return FormBuilder(
      key: formKey,
      onChanged: () => isModified.value = true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Song Info"),
          bottom: asyncMetadataController.when(
            data: (data) => null,
            error: (error, stackTrace) => null,
            loading: () {
              return const PreferredSize(
                preferredSize: Size.fromHeight(2.0),
                child: LinearProgressIndicator(
                  minHeight: 2.0,
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'title',
                  initialValue: songInfo.title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: FormBuilderValidators.compose(
                    [],
                  ),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'artist',
                  initialValue: songInfo.artist,
                  decoration: const InputDecoration(
                    labelText: 'Artist',
                  ),
                  validator: FormBuilderValidators.compose(
                    [],
                  ),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'album',
                  initialValue: songInfo.album,
                  decoration: const InputDecoration(
                    labelText: 'Album',
                  ),
                  validator: FormBuilderValidators.compose(
                    [],
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: decoded.value,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: AnimatedSlide(
          offset: (() {
            if (isModified.value) {
              debugPrint("Form is dirty");
              return const Offset(0, 0);
            }
            return const Offset(0, 1);
          })(),
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: JoinBtns(
              elevation: 0.0,
              color: context.colorScheme.background,
              height: 48.0,
              textStyle: context.textTheme.bodyLarge,
              buttons: [
                JoinBtn(
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  label: "Cancel",
                ),
                JoinBtn(
                  onPressed: () async {
                    if (formKey.currentState?.saveAndValidate() ?? false) {
                      final values = formKey.currentState?.value;
                      debugPrint(values.toString());

                      if (values == null) {
                        return;
                      }

                      await ref
                          .read(metadataControllerProvider(songInfo).notifier)
                          .encodeSongMetadata(values);
                    }
                  },
                  label: "Confirm",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
