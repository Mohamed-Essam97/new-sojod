import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadGroups());
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
    final isAr = l10n.locale.languageCode == 'ar';

    final authState = context.watch<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.login_rounded, size: 64, color: AppColors.violet.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                isAr ? 'سجّل الدخول لعرض مجموعاتك' : 'Sign in to view your groups',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurfaceMutedColor(context),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: AppBar(
        title: Text(isAr ? 'مجموعاتي' : 'My Groups'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.onSurfaceColor(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showCreateGroupDialog(context, authState),
          ),
        ],
      ),
      body: BlocConsumer<GroupCubit, GroupState>(
        listenWhen: (prev, curr) =>
            curr is GroupError || curr is GroupSuccess,
        listener: (context, state) {
          if (state is GroupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is GroupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.teal,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        buildWhen: (prev, curr) =>
            curr is GroupLoading || curr is GroupsLoaded || curr is GroupInitial,
        builder: (context, state) {
          if (state is GroupLoading || state is GroupInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.violet),
            );
          }

          if (state is GroupsLoaded) {
            if (state.groups.isEmpty) {
              return _EmptyGroupsView(
                isAr: isAr,
                onCreatePressed: () => _showCreateGroupDialog(context, authState),
                onJoinPressed: () => context.push('/groups/join'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _loadGroups(),
              color: AppColors.violet,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                cacheExtent: 400,
                itemCount: state.groups.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.groups.length) {
                    return const _JoinGroupCard();
                  }
                  final group = state.groups[index];
                  return GroupCard(
                    key: ValueKey(group.id),
                    group: group,
                    onTap: () => context.push('/groups/${group.id}'),
                  );
                },
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: AppColors.violet),
          );
        },
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, AuthAuthenticated authState) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => CreateGroupDialog(
        onCreateGroup: (name, description, photoUrl) async {
          await context.read<GroupCubit>().createNewGroup(
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
    required this.onCreatePressed,
    required this.onJoinPressed,
  });

  final bool isAr;
  final VoidCallback onCreatePressed;
  final VoidCallback onJoinPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.violet.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.groups_rounded,
                size: 56,
                color: AppColors.violet,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isAr ? 'لا توجد مجموعات بعد' : 'No groups yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isAr
                  ? 'أنشئ مجموعة أو انضم لمجموعة لمشاركة وِردك اليومي'
                  : 'Create or join a group to share your daily wird',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceMutedColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onCreatePressed,
              icon: const Icon(Icons.add_rounded, size: 22),
              label: Text(isAr ? 'إنشاء مجموعة' : 'Create Group'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.violet,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onJoinPressed,
              icon: const Icon(Icons.login_rounded, size: 20),
              label: Text(isAr ? 'الانضمام لمجموعة' : 'Join Group'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.violet,
                side: const BorderSide(color: AppColors.violet, width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JoinGroupCard extends StatelessWidget {
  const _JoinGroupCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAr = l10n.locale.languageCode == 'ar';

    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.violet.withValues(alpha: 0.85),
            AppColors.violet,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.violet.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/groups/join'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
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
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
