import 'package:boat_player/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class PrivacyDialog extends StatefulWidget {
  const PrivacyDialog({super.key});

  @override
  State<PrivacyDialog> createState() => _PrivacyDialogState();
}

class _PrivacyDialogState extends State<PrivacyDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.width * 0.86,
            maxHeight: context.height * 0.72,
            minWidth: 280,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.privacy_tip_outlined, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '使用须知',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Text(
                        desc,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.45,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => SmartDialog.dismiss(),
                    child: const Text('我已知悉'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const String desc = """
1) 本应用为个人兴趣开发，仅供学习与个人使用，不以商业目的使用。

2) 登录时会读取并在本地保存 Bilibili Cookie（如 SESSDATA），用于访问接口与获取播放资源；Cookie 属于敏感信息，请勿泄露。

3) 应用不提供自建服务端，不会将你的 Cookie/个人信息上传到作者服务器；不接入广告或统计分析 SDK（以仓库依赖为准）。

4) 使用时请遵守 Bilibili 的相关条款与法律法规；禁止绕过登录/会员权限、DRM/加密措施，或进行批量抓取等违规行为。

5) 如需删除本地数据，可在系统设置中清除应用数据/卸载应用，以移除 Cookie、缓存与离线下载。
""";
}
