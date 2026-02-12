import 'package:boat_player/pages/dialog/privacy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              '通用设置',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            title: const Text('使用须知'),
            trailing: const Icon(Icons.privacy_tip, size: 16),
            onTap: () {
              _showPrivacyDialog();
            },
          ),
          ListTile(
            title: const Text('清除缓存'),
            subtitle: const Text('清除所有本地缓存数据'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showClearCacheDialog(ref);
            },
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(WidgetRef ref) {
    SmartDialog.show(
      builder: (_) {
        return Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '确认删除',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              const Text('是否确认清除所有本地缓存数据？此操作不可撤销。'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => SmartDialog.dismiss(),
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () async {
                      await ref
                          .read(settingsControllerProvider.notifier)
                          .clearAllCache();
                      SmartDialog.dismiss();
                      SmartDialog.showToast('缓存已清除');
                    },
                    child: const Text('确认'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyDialog() {
    SmartDialog.show(builder: (c) => PrivacyDialog());
  }
}
