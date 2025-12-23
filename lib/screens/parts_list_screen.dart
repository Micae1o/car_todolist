import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/part_item.dart';
import '../providers/parts_provider.dart';
import 'edit_part_screen.dart';

class PartsListScreen extends StatefulWidget {
  const PartsListScreen({super.key});

  @override
  State<PartsListScreen> createState() => _PartsListScreenState();
}

class _PartsListScreenState extends State<PartsListScreen> {
  final TextEditingController _searchController = TextEditingController();

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

  List<DropdownMenuItem<PartCategory?>> _buildCategoryMenuItems() {
    final items = <DropdownMenuItem<PartCategory?>>[
      const DropdownMenuItem<PartCategory?>(
        value: null,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Text('Усі категорії', style: TextStyle(fontSize: 13)),
        ),
      ),
    ];
    for (final entry in _categoryNames.entries) {
      items.add(
        DropdownMenuItem<PartCategory?>(
          value: entry.key,
          child: Text(entry.value, style: TextStyle(fontSize: 13)),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final parts = context.watch<PartsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Планувальник автозапчастин'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: parts.setQuery,
                    decoration: InputDecoration(
                      hintText: 'Пошук...',
                      hintStyle: TextStyle(fontSize: 16),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface.blend(
                        Theme.of(context).colorScheme.primary,
                        6,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButtonHideUnderline(
                  child: Container(
                    height: 53,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.blend(
                        Theme.of(context).colorScheme.primary,
                        6,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButton<PartCategory?>(
                      value: parts.categoryFilter,
                      items: _buildCategoryMenuItems(),
                      onChanged: parts.setCategory,
                      icon: const Icon(Icons.filter_alt, size: 20),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Очистити фільтри',
                  onPressed: () {
                    _searchController.clear();
                    parts.setQuery('');
                    parts.setCategory(null);
                  },
                  icon: const Icon(Icons.delete, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
      body: parts.filteredItems.isEmpty
          ? const _EmptyState()
          : ListView.separated(
              itemCount: parts.filteredItems.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = parts.filteredItems[index];
                return ListTile(
                  leading: IconButton(
                    icon: Icon(
                      item.purchased
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                    ),
                    onPressed: () => parts.togglePurchased(item),
                  ),
                  title: Text(item.name),
                  subtitle: Text(_categoryNames[item.category] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(label: Text('x${item.quantity}')),
                      IconButton(
                        tooltip: 'Редагувати',
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPartScreen(item: item),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        tooltip: 'Видалити',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDelete(context, parts, item),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditPartScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    PartsProvider parts,
    PartItem item,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Видалити запис?'),
        content: Text('"${item.name}" буде видалено.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Скасувати'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Видалити'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await parts.remove(item);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          const Text('Список порожній'),
          const SizedBox(height: 8),
          const Text('Додайте перший запис за допомогою "+"'),
        ],
      ),
    );
  }
}
