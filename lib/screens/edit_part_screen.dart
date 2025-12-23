import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/part_item.dart';
import '../providers/parts_provider.dart';

class EditPartScreen extends StatefulWidget {
  final PartItem? item;
  const EditPartScreen({super.key, this.item});

  @override
  State<EditPartScreen> createState() => _EditPartScreenState();
}

class _EditPartScreenState extends State<EditPartScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _notesCtrl;
  PartCategory _category = PartCategory.other;
  bool _purchased = false;

  static const Map<PartCategory, String> _categoryNames = {
    PartCategory.engine: 'Двигун',
    PartCategory.transmission: 'Трансмісія',
    PartCategory.suspension: 'Підвіска',
    PartCategory.brakes: 'Гальма',
    PartCategory.electrics: 'Електрика',
    PartCategory.body: 'Кузов',
    PartCategory.fluids: 'Рідини',
    PartCategory.other: 'Інше',
  };

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.item?.name ?? '');
    _qtyCtrl = TextEditingController(
      text: (widget.item?.quantity ?? 1).toString(),
    );
    _notesCtrl = TextEditingController(text: widget.item?.notes ?? '');
    _category = widget.item?.category ?? PartCategory.other;
    _purchased = widget.item?.purchased ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<PartsProvider>();
    final qty = int.tryParse(_qtyCtrl.text.trim()) ?? 1;

    if (widget.item == null) {
      final item = PartItem(
        name: _nameCtrl.text.trim(),
        category: _category,
        quantity: qty,
        purchased: _purchased,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
      await provider.addOrUpdate(item);
    } else {
      widget.item!
        ..name = _nameCtrl.text.trim()
        ..category = _category
        ..quantity = qty
        ..purchased = _purchased
        ..notes = _notesCtrl.text.trim().isEmpty
            ? null
            : _notesCtrl.text.trim();
      await provider.addOrUpdate(widget.item!);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item == null ? 'Додати запчастину' : 'Редагувати запчастину',
        ),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Назва',
                prefixIcon: Icon(Icons.build_outlined),
              ),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Вкажіть назву' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PartCategory>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Категорія',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: PartCategory.values
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(_categoryNames[c] ?? c.name),
                    ),
                  )
                  .toList(),
              onChanged: (c) =>
                  setState(() => _category = c ?? PartCategory.other),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _qtyCtrl,
              decoration: const InputDecoration(
                labelText: 'Кількість',
                prefixIcon: Icon(Icons.onetwothree),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n <= 0) return 'Кількість має бути > 0';
                return null;
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _purchased,
              onChanged: (v) => setState(() => _purchased = v),
              title: const Text('Придбано'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Примітки',
                prefixIcon: Icon(Icons.notes_outlined),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Зберегти'),
            ),
          ],
        ),
      ),
    );
  }
}
