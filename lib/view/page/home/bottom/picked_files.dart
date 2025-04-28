part of '../home.dart';

class _PickedFilesPreview extends StatelessWidget {
  const _PickedFilesPreview();

  @override
  Widget build(BuildContext context) {
    return _filePicked.listenVal((files) {
      if (files.isEmpty) {
        return UIs.placeholder;
      }

      return SizedBox(
        height: 60,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          scrollDirection: Axis.horizontal,
          itemCount: files.length,
          separatorBuilder: (_, __) => UIs.width7,
          itemBuilder: (context, index) {
            final file = files[index];
            return _buildFileItem(context, file);
          },
        ),
      );
    });
  }

  Widget _buildFileItem(BuildContext context, PlatformFile file) {
    return Tooltip(
      message: file.name,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: RNodes.dark.value
                  ? Colors.grey[800]
                  : Colors.grey[200],
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
                    file.name,
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
              _filePicked.value =
                  _filePicked.value.where((f) => f != file).toList();
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

