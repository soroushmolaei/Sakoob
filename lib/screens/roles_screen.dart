import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/role.dart';
import '../models/game_provider.dart';
import 'role_edit_screen.dart';

class RolesScreen extends StatelessWidget {
  const RolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: SarkoobTheme.background,
        appBar: AppBar(
          title: const Text('نقش‌ها'),
          bottom: const TabBar(
            labelColor: SarkoobTheme.primary,
            unselectedLabelColor: SarkoobTheme.textSecondary,
            indicatorColor: SarkoobTheme.primary,
            labelStyle: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'مافیا'),
              Tab(text: 'شهروند'),
              Tab(text: 'مستقل'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: SarkoobTheme.primary,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RoleEditScreen()),
          ),
          child: const Icon(Icons.add, color: Colors.black),
        ),
        body: Consumer<GameProvider>(
          builder: (context, provider, _) => TabBarView(
            children: [
              _RolesList(roles: provider.mafiaRoles),
              _RolesList(roles: provider.citizenRoles),
              _RolesList(roles: provider.independentRoles),
            ],
          ),
        ),
      ),
    );
  }
}

class _RolesList extends StatelessWidget {
  final List<Role> roles;
  const _RolesList({required this.roles});

  @override
  Widget build(BuildContext context) {
    if (roles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📭', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text(
              'هنوز نقشی اضافه نشده',
              style: TextStyle(
                color: SarkoobTheme.textSecondary,
                fontFamily: 'Vazirmatn',
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: roles.length,
      itemBuilder: (context, i) => _RoleCard(role: roles[i])
          .animate(delay: Duration(milliseconds: i * 60))
          .fadeIn()
          .slideX(begin: 0.1, end: 0),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final Role role;
  const _RoleCard({required this.role});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<GameProvider>();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A26), Color(0xFF12121A)],
        ),
        border: Border.all(
          color: role.teamColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: role.teamColor.withOpacity(0.15),
            border: Border.all(color: role.teamColor.withOpacity(0.4)),
          ),
          child: Center(
            child: Text(role.emoji, style: const TextStyle(fontSize: 26)),
          ),
        ),
        title: Row(
          children: [
            Text(
              role.name,
              style: const TextStyle(
                color: SarkoobTheme.textPrimary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            if (role.type == RoleType.special)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: SarkoobTheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: SarkoobTheme.primary.withOpacity(0.4)),
                ),
                child: const Text(
                  'ویژه',
                  style: TextStyle(
                    color: SarkoobTheme.primary,
                    fontSize: 10,
                    fontFamily: 'Vazirmatn',
                  ),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            role.description,
            style: const TextStyle(
              color: SarkoobTheme.textSecondary,
              fontFamily: 'Vazirmatn',
              fontSize: 13,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  color: SarkoobTheme.primary, size: 20),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => RoleEditScreen(role: role)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: SarkoobTheme.accentLight, size: 20),
              onPressed: () => _confirmDelete(context, provider),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: SarkoobTheme.surfaceVariant,
        title: const Text(
          'حذف نقش',
          style: TextStyle(
              color: SarkoobTheme.textPrimary, fontFamily: 'Vazirmatn'),
        ),
        content: Text(
          'نقش "${role.name}" حذف شود؟',
          style: const TextStyle(
              color: SarkoobTheme.textSecondary, fontFamily: 'Vazirmatn'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف',
                style: TextStyle(
                    color: SarkoobTheme.textSecondary,
                    fontFamily: 'Vazirmatn')),
          ),
          TextButton(
            onPressed: () {
              provider.deleteRole(role.id);
              Navigator.pop(context);
            },
            child: const Text('حذف',
                style: TextStyle(
                    color: SarkoobTheme.accentLight, fontFamily: 'Vazirmatn')),
          ),
        ],
      ),
    );
  }
}
