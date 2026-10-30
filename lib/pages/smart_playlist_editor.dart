import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/models/smart_rules.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

typedef _KeyedRule = ({int key, SmartRule rule});

/// Make a smart playlist from rules, or change one: match all or any of the
/// rules, and optionally limit the songs and choose their order.
class SmartPlaylistEditorPage extends HookConsumerWidget {
  const SmartPlaylistEditorPage({super.key, this.definition});

  /// The playlist being changed, or null to make a new one.
  final SmartPlaylistDefinition? definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useTextEditingController(text: definition?.name ?? '');
    final matchAll = useState(definition?.matchAll ?? true);

    final counter = useRef(0);
    final initialRules = useMemoized(
      () => <_KeyedRule>[
        for (final rule
            in definition?.rules ?? [SmartRule.forField(RuleField.genre)])
          (key: counter.value++, rule: rule),
      ],
    );
    final rules = useState<List<_KeyedRule>>(initialRules);

    final limitEnabled = useState(definition?.limit != null);
    final limitText = useTextEditingController(
      text: (definition?.limit ?? 25).toString(),
    );
    final sort = useState(definition?.sort ?? SmartSort.title);
    final ascending = useState(definition?.ascending ?? true);

    void say(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }

    Future<void> save() async {
      final title = name.text.trim();
      if (title.isEmpty) return say('Give the playlist a name');

      final chosen = [for (final entry in rules.value) entry.rule];
      if (chosen.isEmpty || chosen.any((rule) => !rule.isComplete)) {
        return say('Fill in every rule');
      }

      final limit =
          limitEnabled.value ? int.tryParse(limitText.text.trim()) : null;
      if (limitEnabled.value && (limit == null || limit <= 0)) {
        return say('The limit must be a number above 0');
      }

      final store = ref.read(smartPlaylistStoreProvider.notifier);
      await store.save(
        SmartPlaylistDefinition(
          id: definition?.id ?? store.newId(),
          name: title,
          matchAll: matchAll.value,
          rules: chosen,
          limit: limit,
          sort: sort.value,
          ascending: ascending.value,
        ),
      );
      if (context.mounted) Navigator.of(context).pop();
    }

    Future<void> delete() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete "${definition!.name}"?'),
            content: const Text('Only the playlist is deleted, not the songs.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
      if (confirmed != true) return;

      await ref
          .read(smartPlaylistStoreProvider.notifier)
          .remove(definition!.id);
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }

    void changeRule(int key, SmartRule rule) {
      rules.value = [
        for (final entry in rules.value)
          entry.key == key ? (key: key, rule: rule) : entry,
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(definition == null ? 'New smart playlist' : 'Edit rules'),
        actions: [
          if (definition != null)
            IconButton(
              tooltip: 'Delete playlist',
              icon: const Icon(FluentIcons.delete_24_regular),
              onPressed: delete,
            ),
          TextButton(onPressed: save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: name,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              const Text('Match'),
              const SizedBox(width: 12.0),
              DropdownButton<bool>(
                value: matchAll.value,
                items: const [
                  DropdownMenuItem(value: true, child: Text('all')),
                  DropdownMenuItem(value: false, child: Text('any')),
                ],
                onChanged: (value) => matchAll.value = value ?? true,
              ),
              const SizedBox(width: 12.0),
              const Text('of the rules'),
            ],
          ),
          const SizedBox(height: 8.0),
          for (final entry in rules.value)
            _RuleRow(
              key: ValueKey(entry.key),
              rule: entry.rule,
              onChanged: (rule) => changeRule(entry.key, rule),
              onRemove: rules.value.length < 2
                  ? null
                  : () {
                      rules.value = [
                        for (final other in rules.value)
                          if (other.key != entry.key) other,
                      ];
                    },
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(FluentIcons.add_20_regular),
              label: const Text('Add a rule'),
              onPressed: () {
                rules.value = [
                  ...rules.value,
                  (
                    key: counter.value++,
                    rule: SmartRule.forField(RuleField.genre),
                  ),
                ];
              },
            ),
          ),
          const Divider(height: 32.0),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Limit the number of songs'),
            value: limitEnabled.value,
            onChanged: (value) => limitEnabled.value = value,
          ),
          if (limitEnabled.value)
            TextField(
              controller: limitText,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Songs',
              ),
            ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              const Text('Order by'),
              const SizedBox(width: 12.0),
              DropdownButton<SmartSort>(
                value: sort.value,
                items: [
                  for (final option in SmartSort.values)
                    DropdownMenuItem(value: option, child: Text(option.label)),
                ],
                onChanged: (value) => sort.value = value ?? SmartSort.title,
              ),
              const Spacer(),
              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: true,
                    icon: Icon(FluentIcons.text_sort_ascending_24_regular),
                  ),
                  ButtonSegment(
                    value: false,
                    icon: Icon(FluentIcons.text_sort_descending_24_regular),
                  ),
                ],
                selected: {ascending.value},
                onSelectionChanged: (selection) =>
                    ascending.value = selection.first,
              ),
            ],
          ),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}

/// One rule: a field, an operator and a value.
class _RuleRow extends HookWidget {
  const _RuleRow({
    super.key,
    required this.rule,
    required this.onChanged,
    required this.onRemove,
  });

  final SmartRule rule;
  final ValueChanged<SmartRule> onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final value = useTextEditingController(text: rule.value);
    final unit = rule.field.unit;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: context.colorScheme.outline.withOpacity(.4),
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<RuleField>(
                      isExpanded: true,
                      value: rule.field,
                      items: [
                        for (final field in RuleField.values)
                          DropdownMenuItem(
                            value: field,
                            child: Text(field.label),
                          ),
                      ],
                      onChanged: (field) {
                        if (field == null || field == rule.field) return;

                        // The old value rarely makes sense for another field.
                        value.clear();
                        onChanged(SmartRule.forField(field));
                      },
                    ),
                  ),
                  IconButton(
                    tooltip: 'Remove rule',
                    icon: const Icon(FluentIcons.dismiss_20_regular),
                    onPressed: onRemove,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<RuleOperator>(
                      isExpanded: true,
                      value: rule.operator,
                      items: [
                        for (final operator in rule.field.operators)
                          DropdownMenuItem(
                            value: operator,
                            child: Text(operator.label),
                          ),
                      ],
                      onChanged: (operator) {
                        if (operator == null) return;
                        onChanged(rule.copyWith(operator: operator));
                      },
                    ),
                  ),
                  if (rule.needsValue) ...[
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: value,
                        keyboardType: rule.field.isNumber
                            ? TextInputType.number
                            : TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Value',
                          suffixText: unit,
                        ),
                        onChanged: (text) {
                          onChanged(rule.copyWith(value: text));
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
