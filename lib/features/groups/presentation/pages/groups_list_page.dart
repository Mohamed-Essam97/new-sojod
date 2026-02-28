import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wird/features/auth/presentation/pages/login_page.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/group_cubit.dart';
import '../cubit/group_state.dart';
import '../widgets/create_group_dialog.dart';
import '../widgets/group_card.dart';

class GroupsListPage extends StatelessWidget {
  const GroupsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GroupCubit>(),
      child: const _GroupsListView(),
    );
  }
}

class _GroupsListView extends StatefulWidget {
  const _GroupsListView();

  @override
  State<_GroupsListView> createState() => _GroupsListViewState();
}

class _GroupsListViewState extends State<_GroupsListView> {
  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<GroupCubit>().loadUserGroups(authState.user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = l10n.locale.languageCode == 'ar';
    
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      return LoginPage(key: Key('login_page'));
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A1929) : Colors.grey[50],
      appBar: AppBar(
        title: Text(isAr ? 'مجموعاتي' : 'My Groups'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateGroupDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<GroupCubit, GroupState>(
        listener: (context, state) {
          if (state is GroupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is GroupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.teal,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GroupLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GroupsLoaded) {
            if (state.groups.isEmpty) {
              return _EmptyGroupsView(
                isAr: isAr,
                isDark: isDark,
                onCreatePressed: () => _showCreateGroupDialog(context),
                onJoinPressed: () => context.push('/groups/join'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _loadGroups(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.groups.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.groups.length) {
                    return _JoinGroupCard(isAr: isAr, isDark: isDark);
                  }

                  final group = state.groups[index];
                  return GroupCard(
                    group: group,
                    onTap: () => context.push('/groups/${group.id}'),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) return;

    showDialog(
      context: context,
      builder: (dialogContext) => CreateGroupDialog(
        onCreateGroup: (name, description, photoUrl) {
          context.read<GroupCubit>().createNewGroup(
                name: name,
                ownerId: authState.user.uid,
                description: description,
                photoUrl: photoUrl,
              );
        },
      ),
    );
  }
}

class _EmptyGroupsView extends StatelessWidget {
  const _EmptyGroupsView({
    required this.isAr,
    required this.isDark,
    required this.onCreatePressed,
    required this.onJoinPressed,
  });

  final bool isAr;
  final bool isDark;
  final VoidCallback onCreatePressed;
  final VoidCallback onJoinPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.violet.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.groups_rounded,
                size: 60,
                color: AppColors.violet,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isAr ? 'لا توجد مجموعات بعد' : 'No groups yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isAr
                  ? 'أنشئ مجموعة أو انضم لمجموعة موجودة لمشاركة وِردك اليومي'
                  : 'Create or join a group to share your daily wird',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onCreatePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.violet,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_circle_outline),
                  const SizedBox(width: 8),
                  Text(
                    isAr ? 'إنشاء مجموعة' : 'Create Group',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onJoinPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.violet,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                side: const BorderSide(color: AppColors.violet, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.login_rounded),
                  const SizedBox(width: 8),
                  Text(
                    isAr ? 'الانضمام لمجموعة' : 'Join Group',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
}

class _JoinGroupCard extends StatelessWidget {
  const _JoinGroupCard({required this.isAr, required this.isDark});

  final bool isAr;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.violet.withValues(alpha: 0.8), AppColors.violet],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => context.push('/groups/join'),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'الانضمام لمجموعة' : 'Join a Group',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAr ? 'أدخل كود الدعوة' : 'Enter invite code',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
