import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/providers/providers.dart';

class ScanList extends HookConsumerWidget {
  const ScanList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAudios = ref.watch(scanControllerProvider);
    return CustomScrollView(
      slivers: <Widget>[
        asyncAudios.when(
          data: (data) {
            return SliverList.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data.elementAt(index);
                return ListTile(
                  title: Text(item.toString()),
                );
              },
            );
          },
          error: (error, stackTrace) {
            return SliverFillRemaining(
              child: AsyncErrorView(
                error: error,
                stackTrace: stackTrace,
              ),
            );
          },
          loading: () {
            return const SliverFillRemaining(
              child: Center(
                child: ProgressRing(),
              ),
            );
          },
        ),
      ],
    );
  }
}