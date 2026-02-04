import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/logic/controller/comments_controller.dart';
import 'package:movies/logic/services/trailer_service.dart';

class CommentsSection extends StatefulWidget {
  const CommentsSection({
    super.key,
    required this.type,
    required this.id,
  });

  final MediaType type;
  final int id;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  late final CommentsController _ctr;
  final _text = TextEditingController();
  final _sending = false.obs;

  @override
  void initState() {
    super.initState();
    _ctr = Get.isRegistered<CommentsController>()
        ? Get.find<CommentsController>()
        : Get.put(CommentsController(), permanent: true);
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
          stream: _ctr.watch(widget.type, widget.id),
          builder: (context, snap) {
            if (snap.hasError) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Failed to load comments: ${snap.error}',
                  style: TextStyle(color: scheme.error),
                ),
              );
            }

            if (snap.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final list = snap.data ?? const [];
            if (list.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'noComments'.tr,
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => Divider(
                height: 16,
                color: scheme.outlineVariant.withValues(alpha: .6),
              ),
              itemBuilder: (context, i) {
                final c = list[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c.text,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ],
                );
              },
            );
          },
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _text,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'writeComment'.tr,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Obx(() {
              return FilledButton(
                onPressed: _sending.value
                    ? null
                    : () async {
                        final value = _text.text.trim();
                        if (value.isEmpty) return;

                        try {
                          _sending.value = true;
                          await _ctr.add(
                            type: widget.type,
                            id: widget.id,
                            text: value,
                          );
                          _text.clear();
                        } catch (e) {
                          Get.snackbar('Error', e.toString());
                        } finally {
                          _sending.value = false;
                        }
                      },
                child: Text('send'.tr),
              );
            }),
          ],
        ),
      ],
    );
  }
}
