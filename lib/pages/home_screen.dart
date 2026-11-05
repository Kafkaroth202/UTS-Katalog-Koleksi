import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/database_helper.dart';
import '../models/item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 240,
    childAspectRatio: 0.58,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
  );

  List<Item> _items = [];

  String _query = '';
  String? _categoryFilter; // null = All

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await DatabaseHelper.instance.getItems();
    setState(() => _items = items);
  }

  Future<void> _saveItem(Item item) async {
    if (item.id == null) {
      await DatabaseHelper.instance.insertItem(item);
    } else {
      await DatabaseHelper.instance.updateItem(item);
    }
    await _loadItems();
  }

  bool get _filtering => _query.isNotEmpty || _categoryFilter != null;

  List<Item> _withStatus(String status) {
    return _items.where((i) {
      if (i.status != status) return false;
      if (_categoryFilter != null && i.category != _categoryFilter) {
        return false;
      }
      if (_query.isNotEmpty &&
          !i.title.toLowerCase().contains(_query.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  String? _nullIfEmpty(String text) {
    final t = text.trim();
    return t.isEmpty ? null : t;
  }

  // ---------- Form (add now, edit is wired in the next phase) ----------

  void _showItemForm({Item? item}) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: item?.title ?? '');
    final creatorCtrl = TextEditingController(text: item?.creator ?? '');
    final yearCtrl = TextEditingController(text: item?.year?.toString() ?? '');
    final descCtrl = TextEditingController(text: item?.description ?? '');
    final imageCtrl = TextEditingController(text: item?.imageUrl ?? '');
    String category = item?.category ?? 'book';
    String status = item?.status ?? 'finished';
    double? rating = item?.rating;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 520),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(item == null ? 'Add item' : 'Edit item',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: Item.categories
                          .map((c) => DropdownMenuItem(
                              value: c, child: Text(Item.categoryLabelFor(c))))
                          .toList(),
                      onChanged: (v) => setSheetState(() => category = v!),
                    ),
                    TextFormField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Name is required'
                          : null,
                    ),
                    TextFormField(
                      controller: creatorCtrl,
                      decoration: InputDecoration(
                          labelText: Item.creatorLabelFor(category)),
                    ),
                    TextFormField(
                      controller: yearCtrl,
                      decoration: const InputDecoration(labelText: 'Year'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null;
                        return v.trim().length == 4
                            ? null
                            : 'Enter a 4-digit year';
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: Item.statuses
                          .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(Item.statusLabelFor(category, s))))
                          .toList(),
                      onChanged: (v) => setSheetState(() => status = v!),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Rating'),
                        Text(rating == null
                            ? 'Not rated'
                            : '${Item.formatRating(rating!)}/10'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(10, (i) {
                        final value = i + 1;
                        final IconData icon;
                        if (rating != null && rating! >= value) {
                          icon = Icons.star;
                        } else if (rating != null && rating! >= value - 0.5) {
                          icon = Icons.star_half;
                        } else {
                          icon = Icons.star_border;
                        }
                        return GestureDetector(
                          // Left half of the star = half point, right half =
                          // full point. Tapping the current rating clears it.
                          onTapDown: (details) {
                            final picked = details.localPosition.dx < 15
                                ? value - 0.5
                                : value.toDouble();
                            setSheetState(
                                () => rating = rating == picked ? null : picked);
                          },
                          child: Icon(icon, color: Colors.amber, size: 30),
                        );
                      }),
                    ),
                    TextFormField(
                      controller: imageCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Image URL (optional)'),
                    ),
                    TextFormField(
                      controller: descCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        await _saveItem(Item(
                          id: item?.id,
                          category: category,
                          title: titleCtrl.text.trim(),
                          creator: _nullIfEmpty(creatorCtrl.text),
                          year: int.tryParse(yearCtrl.text.trim()),
                          status: status,
                          rating: rating,
                          description: _nullIfEmpty(descCtrl.text),
                          imageUrl: _nullIfEmpty(imageCtrl.text),
                        ));
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------- Detail and delete ----------

  Future<void> _confirmDelete(Item item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete item'),
        content: Text('Delete "${item.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await DatabaseHelper.instance.deleteItem(item.id!);
      await _loadItems();
    }
  }

  void _showDetail(Item item) {
    final hasDesc =
        item.description != null && item.description!.trim().isNotEmpty;
    final meta = [
      item.categoryLabel,
      if (item.year != null) '${item.year}',
      item.statusLabel,
    ].join(' • ');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(item.title, textAlign: TextAlign.center)),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 420),
                    child: _image(item, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 12),
                Text(meta),
                if (item.creator != null)
                  Text('${item.creatorLabel}: ${item.creator}'),
                if (item.rating != null)
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${Item.formatRating(item.rating!)}/10'),
                    ],
                  ),
                const SizedBox(height: 12),
                Text(
                  hasDesc ? item.description! : 'No description',
                  style: TextStyle(
                    fontStyle: hasDesc ? FontStyle.normal : FontStyle.italic,
                    color: hasDesc ? null : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDelete(item);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showItemForm(item: item);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ---------- Card ----------

  Widget _image(Item item, {BoxFit fit = BoxFit.cover}) {
    final placeholder = Container(
      color: Colors.grey.shade300,
      child: const Center(child: Icon(Icons.image_not_supported, size: 40)),
    );
    final url = item.imageUrl;
    if (url == null || url.isEmpty) return placeholder;
    return Image.network(
      url,
      fit: fit,
      width: double.infinity,
      errorBuilder: (context, error, stack) => placeholder,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _card(Item item) {
    final hasDesc =
        item.description != null && item.description!.trim().isNotEmpty;
    final meta = item.year == null
        ? item.categoryLabel
        : '${item.categoryLabel} • ${item.year}';
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetail(item),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              child: _image(item, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                if (item.status != 'finished')
                  Text(
                    item.statusLabel,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                if (item.rating != null)
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text('${Item.formatRating(item.rating!)}/10',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                const SizedBox(height: 6),
                Text(
                  hasDesc ? item.description! : 'No description',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: hasDesc ? FontStyle.normal : FontStyle.italic,
                    color: hasDesc ? null : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _filterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search by name',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _categoryFilter == null,
                onSelected: (_) => setState(() => _categoryFilter = null),
              ),
              for (final c in Item.categories)
                ChoiceChip(
                  label: Text(Item.categoryLabelFor(c)),
                  selected: _categoryFilter == c,
                  onSelected: (_) => setState(() => _categoryFilter = c),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Tabs ----------

  List<Widget> _sectionSlivers(String? title, List<Item> items) {
    if (items.isEmpty) return [];
    return [
      if (title != null)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid(
          gridDelegate: _gridDelegate,
          delegate: SliverChildBuilderDelegate(
            (context, index) => _card(items[index]),
            childCount: items.length,
          ),
        ),
      ),
    ];
  }

  Widget _emptyState(String message) {
    return Center(
      child: Text(message, style: TextStyle(color: Colors.grey.shade600)),
    );
  }

  Widget _finishedTab() {
    final finished = _withStatus('finished');
    if (finished.isEmpty) {
      return _emptyState(_filtering
        ? 'No matching items.'
        : 'Nothing here yet. Tap + to add your first item.'
      );
    }
    return CustomScrollView(slivers: _sectionSlivers(null, finished));
  }

  Widget _queueTab() {
    final ongoing = _withStatus('ongoing');
    final notYet = _withStatus('not_yet');
    if (ongoing.isEmpty && notYet.isEmpty) {
      return _emptyState(
        _filtering ? 'No matching items.' : 'Nothing in the queue yet.'
      );
    }
    return CustomScrollView(
      slivers: [
        ..._sectionSlivers('In progress', ongoing),
        ..._sectionSlivers('Not yet', notYet),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Collection Catalog'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Finished'), Tab(text: 'Queue')],
          ),
        ),
        body: Column(
          children: [
            _filterBar(),
            Expanded(
              child: TabBarView(children: [_finishedTab(), _queueTab()]),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showItemForm(),
          tooltip: 'Add item',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
