part of '../home.dart';

class _PickedFilesPreview extends StatelessWidget {
  const _PickedFilesPreview();

  @override
  Widget build(BuildContext context) {
    return _filesPicked.listenVal((files) {
      return AnimatedContainer(
        height: files.isEmpty ? 0 : 45,
        width: MediaQuery.sizeOf(context).width - 22,
        duration: Durations.long3,
        curve: Curves.fastEaseInToSlowEaseOut,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          scrollDirection: Axis.horizontal,
          itemCount: files.length,
          separatorBuilder: (_, _) => UIs.width7,
          itemBuilder: (context, index) {
            final file = files[index];
            return _buildFileItem(context, file);
          },
        ),
      );
    });
  }

  Widget _buildFileItem(BuildContext context, String file) {
    final fileName = file.fileNameGetter;
    return Tooltip(
      message: fileName,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: RNodes.dark.value ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.file_copy, size: 19),
                UIs.width7,
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100),
                  child: Text(
                    fileName ?? libL10n.file,
                    overflow: TextOverflow.ellipsis,
                    style: UIs.text13,
                  ),
                ),
              ],
            ),
          ),
          // Remove button
          InkWell(
            onTap: () {
              _filesPicked.value.remove(file);
              _filesPicked.notify();
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 10,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
