import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../theme/app_theme.dart';
import '../models/role.dart';
import '../models/game_provider.dart';

class RoleEditScreen extends StatefulWidget {
  final Role? role;
  const RoleEditScreen({super.key, this.role});

  @override
  State<RoleEditScreen> createState() => _RoleEditScreenState();
}

class _RoleEditScreenState extends State<RoleEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _abilityCtrl;
  late TextEditingController _emojiCtrl;
  RoleTeam _team = RoleTeam.citizen;
  RoleType _type = RoleType.normal;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.role?.name ?? '');
    _descCtrl = TextEditingController(text: widget.role?.description ?? '');
    _abilityCtrl = TextEditingController(text: widget.role?.ability ?? '');
    _emojiCtrl = TextEditingController(text: widget.role?.emoji ?? '🎭');
    _team = widget.role?.team ?? RoleTeam.citizen;
    _type = widget.role?.type ?? RoleType.normal;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.role != null;
    return Scaffold(
      backgroundColor: SarkoobTheme.background,
      appBar: AppBar(
        title: Text(isEdit ? 'ویرایش نقش' : 'نقش جدید'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ایموجی
            Center(
              child: GestureDetector(
                onTap: _pickEmoji,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SarkoobTheme.surfaceVariant,
                    border: Border.all(color: SarkoobTheme.primary, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      _emojiCtrl.text,
                      style: const TextStyle(fontSize: 44),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'برای تغییر ضربه بزنید',
                style: TextStyle(
                    color: SarkoobTheme.textMuted,
                    fontSize: 12,
                    fontFamily: 'Vazirmatn'),
              ),
            ),
            const SizedBox(height: 28),

            _buildField(_nameCtrl, 'نام نقش', required: true),
            const SizedBox(height: 16),
            _buildField(_descCtrl, 'توضیحات', maxLines: 2),
            const SizedBox(height: 16),
            _buildField(_abilityCtrl, 'توانایی / قابلیت', maxLines: 3),
            const SizedBox(height: 24),

            // تیم
            _buildLabel('تیم'),
            const SizedBox(height: 8),
            _buildTeamSelector(),
            const SizedBox(height: 24),

            // نوع
            _buildLabel('نوع نقش'),
            const SizedBox(height: 8),
            _buildTypeSelector(),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _save,
              child: Text(isEdit ? 'ذخیره تغییرات' : 'افزودن نقش'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label,
      {bool required = false, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      textAlign: TextAlign.right,
      style: const TextStyle(color: SarkoobTheme.textPrimary, fontFamily: 'Vazirmatn'),
      decoration: InputDecoration(labelText: label),
      validator: required ? (v) => v!.isEmpty ? 'این فیلد الزامی است' : null : null,
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: SarkoobTheme.textSecondary,
        fontFamily: 'Vazirmatn',
        fontSize: 14,
      ),
    );
  }

  Widget _buildTeamSelector() {
    return Row(
      children: RoleTeam.values.map((team) {
        final names = ['مافیا', 'شهروند', 'مستقل'];
        final emojis = ['🔴', '🟢', '🟡'];
        final selected = _team == team;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _team = team),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: selected
                    ? SarkoobTheme.primary.withOpacity(0.2)
                    : SarkoobTheme.surfaceVariant,
                border: Border.all(
                  color: selected ? SarkoobTheme.primary : SarkoobTheme.border,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(emojis[team.index], style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(
                    names[team.index],
                    style: TextStyle(
                      color: selected
                          ? SarkoobTheme.primary
                          : SarkoobTheme.textSecondary,
                      fontFamily: 'Vazirmatn',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _type = RoleType.normal),
            child: _typeOption('ساده', '👤', _type == RoleType.normal),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _type = RoleType.special),
            child: _typeOption('ویژه', '⭐', _type == RoleType.special),
          ),
        ),
      ],
    );
  }

  Widget _typeOption(String label, String emoji, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: selected
            ? SarkoobTheme.primary.withOpacity(0.2)
            : SarkoobTheme.surfaceVariant,
        border: Border.all(
          color: selected ? SarkoobTheme.primary : SarkoobTheme.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: selected ? SarkoobTheme.primary : SarkoobTheme.textSecondary,
              fontFamily: 'Vazirmatn',
            ),
          ),
        ],
      ),
    );
  }

  void _pickEmoji() {
    final emojis = [
      '🎭', '🔫', '🎯', '🤐', '👤', '🔍', '⚕️', '🏹', '🧠', '👑',
      '🃏', '🔪', '👮', '🕵️', '🤵', '💣', '🗡️', '🛡️', '⚔️', '🦹',
    ];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: SarkoobTheme.surfaceVariant,
        title: const Text('انتخاب آیکون',
            style: TextStyle(color: SarkoobTheme.textPrimary, fontFamily: 'Vazirmatn')),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: emojis
              .map((e) => GestureDetector(
                    onTap: () {
                      setState(() => _emojiCtrl.text = e);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: SarkoobTheme.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(e, style: const TextStyle(fontSize: 28)),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<GameProvider>();
    final role = Role(
      id: widget.role?.id ?? const Uuid().v4(),
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      ability: _abilityCtrl.text.trim(),
      team: _team,
      type: _type,
      emoji: _emojiCtrl.text,
    );
    if (widget.role != null) {
      provider.updateRole(role);
    } else {
      provider.addRole(role);
    }
    Navigator.pop(context);
  }
}
