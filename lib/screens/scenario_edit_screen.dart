import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/role.dart';
import '../models/game_models.dart';
import '../models/game_provider.dart';

class ScenarioEditScreen extends StatefulWidget {
  final Scenario? scenario;
  const ScenarioEditScreen({super.key, this.scenario});

  @override
  State<ScenarioEditScreen> createState() => _ScenarioEditScreenState();
}

class _ScenarioEditScreenState extends State<ScenarioEditScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  late Map<String, int> _roleCounts; // roleId -> count

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.scenario?.name ?? '';
    _descCtrl.text = widget.scenario?.description ?? '';
    _roleCounts = {};
    if (widget.scenario != null) {
      for (final sr in widget.scenario!.roles) {
        _roleCounts[sr.roleId] = sr.count;
      }
    }
  }

  int get _totalPlayers => _roleCounts.values.fold(0, (s, c) => s + c);

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.scenario != null;
    return Scaffold(
      backgroundColor: SarkoobTheme.background,
      appBar: AppBar(
        title: Text(isEdit ? 'ویرایش سناریو' : 'سناریو جدید'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'ذخیره',
              style: TextStyle(
                  color: SarkoobTheme.primary,
                  fontFamily: 'Vazirmatn',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // اطلاعات سناریو
              TextFormField(
                controller: _nameCtrl,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    color: SarkoobTheme.textPrimary, fontFamily: 'Vazirmatn'),
                decoration: const InputDecoration(labelText: 'نام سناریو'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                textAlign: TextAlign.right,
                maxLines: 2,
                style: const TextStyle(
                    color: SarkoobTheme.textPrimary, fontFamily: 'Vazirmatn'),
                decoration: const InputDecoration(labelText: 'توضیحات (اختیاری)'),
              ),
              const SizedBox(height: 24),

              // تعداد کل
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: SarkoobTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: SarkoobTheme.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('👥',
                        style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      'تعداد کل بازیکنان: $_totalPlayers نفر',
                      style: const TextStyle(
                        color: SarkoobTheme.primary,
                        fontFamily: 'Vazirmatn',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // نقش‌های مافیا
              _buildSection('مافیا 🔴', provider.mafiaRoles),
              const SizedBox(height: 20),
              _buildSection('شهروند 🟢', provider.citizenRoles),
              const SizedBox(height: 20),
              _buildSection('مستقل 🟡', provider.independentRoles),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? 'ذخیره تغییرات' : 'ساخت سناریو'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Role> roles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: SarkoobTheme.textPrimary,
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        ...roles.map((role) => _RoleCountRow(
              role: role,
              count: _roleCounts[role.id] ?? 0,
              onChanged: (val) =>
                  setState(() => _roleCounts[role.id] = val),
            )),
      ],
    );
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لطفاً نام سناریو را وارد کنید',
              style: TextStyle(fontFamily: 'Vazirmatn')),
          backgroundColor: SarkoobTheme.accent,
        ),
      );
      return;
    }
    final provider = context.read<GameProvider>();
    final roles = _roleCounts.entries
        .where((e) => e.value > 0)
        .map((e) => ScenarioRole(roleId: e.key, count: e.value))
        .toList();

    if (widget.scenario != null) {
      widget.scenario!.name = _nameCtrl.text.trim();
      widget.scenario!.description = _descCtrl.text.trim();
      widget.scenario!.roles = roles;
      provider.updateScenario(widget.scenario!);
    } else {
      final scenario = provider.createScenario(
        _nameCtrl.text.trim(),
        _descCtrl.text.trim(),
      );
      scenario.roles = roles;
      provider.addScenario(scenario);
    }
    Navigator.pop(context);
  }
}

class _RoleCountRow extends StatelessWidget {
  final Role role;
  final int count;
  final ValueChanged<int> onChanged;
  const _RoleCountRow(
      {required this.role, required this.count, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: SarkoobTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: count > 0
              ? role.teamColor.withOpacity(0.4)
              : SarkoobTheme.border,
        ),
      ),
      child: Row(
        children: [
          Text(role.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              role.name,
              style: const TextStyle(
                color: SarkoobTheme.textPrimary,
                fontFamily: 'Vazirmatn',
              ),
            ),
          ),
          // کنترل تعداد
          IconButton(
            icon: const Icon(Icons.remove_circle_outline,
                color: SarkoobTheme.accentLight),
            onPressed: count > 0 ? () => onChanged(count - 1) : null,
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: count > 0
                    ? SarkoobTheme.primary
                    : SarkoobTheme.textMuted,
                fontFamily: 'Vazirmatn',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: SarkoobTheme.primary),
            onPressed: () => onChanged(count + 1),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
