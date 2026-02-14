import 'package:flutter/material.dart';

import 'package:frontend/shared/responsive.dart';
import 'package:frontend/theme/app_animations.dart';

import '../../../theme/app_sizes.dart';

class ProfileBadge extends StatefulWidget {
  const ProfileBadge({super.key});

  @override
  State<ProfileBadge> createState() => _ProfileBadgeState();
}

class _ProfileBadgeState extends State<ProfileBadge> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;
  bool _isHovered = false;

  @override
  void dispose() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    super.dispose();
  }

  void _toggleProfileMenu() {
    _isMenuOpen ? _closeMenu() : _openMenu();
  }

  void _openMenu() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isMenuOpen = true;
    });
  }

  void _closeMenu({bool notify = true}) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isMenuOpen = false;

      if (notify && mounted) {
        setState(() {});
      }
    }
  }

  OverlayEntry _createOverlayEntry() {
    final screenWidth = MediaQuery.of(context).size.width;

    final double profileMenuWidth =
        (screenWidth * AppSizes.profileMenuWidthFactor).clamp(
          AppSizes.minProfileMenuWidth,
          AppSizes.maxProfileMenuWidth,
        );
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _closeMenu,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),

            Positioned(
              width: profileMenuWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                targetAnchor: Alignment.bottomRight,
                followerAnchor: Alignment.topRight,
                child: _ProfileDropdown(onClose: _closeMenu),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: _toggleProfileMenu,
          child: AnimatedContainer(
            duration: AppAnimations.durationFast,
            curve: AppAnimations.curveSpring,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceXSmall,
              vertical: AppSizes.spaceXXSmall,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: (_isHovered || _isMenuOpen)
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
              ),

              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: AppSizes.radiusLarge,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    "AG",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                if (!context.isMobile) ...[
                  SizedBox(width: AppSizes.spaceXSmall),
                  Text(
                    "FirstName LastName ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: AppSizes.spaceXXSmall),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: AppSizes.iconSmall,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileDropdown extends StatelessWidget {
  final VoidCallback onClose;
  const _ProfileDropdown({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spaceXSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.outline)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MenuTile(
              icon: Icons.person_outline,
              label: "My Profile",
              onTap: onClose,
            ),
            _MenuTile(
              icon: Icons.settings_outlined,
              label: "Settings",
              onTap: onClose,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Divider(height: 1, thickness: 0.5),
            ),
            _MenuTile(
              icon: Icons.logout_rounded,
              label: "Sign Out",
              isDestructive: true,
              onTap: onClose,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  State<_MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<_MenuTile> {
  bool _isItemHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color hoverColor = widget.isDestructive
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;

    final Color hoverTextColor = widget.isDestructive
        ? Theme.of(context).colorScheme.onError
        : Theme.of(context).colorScheme.onPrimary;

    final Color contentColor = Theme.of(context).colorScheme.onSurface;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isItemHovered = true),
      onExit: (_) => setState(() => _isItemHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceSmall,
            vertical: AppSizes.spaceXSmall,
          ),
          decoration: BoxDecoration(
            color: _isItemHovered ? hoverColor : Colors.transparent,

            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: AppSizes.iconSmall,
                color: _isItemHovered ? hoverTextColor : contentColor,
              ),
              const SizedBox(width: AppSizes.spaceSmall),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _isItemHovered ? hoverTextColor : contentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
