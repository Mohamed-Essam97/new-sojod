import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/group_member_entity.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({
    super.key,
    required this.member,
    required this.isOwner,
    required this.isDark,
  });

  final GroupMemberEntity member;
  final bool isOwner;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2332) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isOwner ? AppColors.amber : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: member.photoUrl != null && member.photoUrl!.isNotEmpty
                      ? Image.network(
                          member.photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _DefaultAvatar(isDark: isDark),
                        )
                      : _DefaultAvatar(isDark: isDark),
                ),
              ),
              if (isOwner)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.amber,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFF1A2332) : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.displayName.isNotEmpty ? member.displayName : 'User',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getRoleLabel(member.role),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getRoleColor(member.role),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'owner':
        return 'Owner';
      case 'admin':
        return 'Admin';
      default:
        return 'Member';
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'owner':
        return AppColors.amber;
      case 'admin':
        return AppColors.violet;
      default:
        return isDark ? Colors.white60 : Colors.grey[600]!;
    }
  }
}

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? Colors.grey[800] : Colors.grey[300],
      child: Icon(
        Icons.person,
        color: isDark ? Colors.white54 : Colors.grey[600],
        size: 28,
      ),
    );
  }
}
