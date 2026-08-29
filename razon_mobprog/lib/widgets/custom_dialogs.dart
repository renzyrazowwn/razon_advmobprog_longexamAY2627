import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'custom_font.dart';

bool _isNetwork(String path) {
  return path.startsWith('http://') ||
      path.startsWith('https://');
}

Widget _buildDynamicImage(String path) {
  if (_isNetwork(path)) {
    return CachedNetworkImage(
      imageUrl: path,
      fit: BoxFit.contain,
      errorWidget: (_, __, ___) =>
          const Icon(Icons.error),
    );
  }

  return Image.asset(
    path,
    fit: BoxFit.contain,
  );
}

void customDialog(
  BuildContext context, {
  required String title,
  required String content,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  PEACE_DARK_PRIMARY,
              foregroundColor:
                  Colors.white,
            ),
            onPressed: () =>
                Navigator.pop(context),
            child: const Text('Okay'),
          ),
        ],
      );
    },
  );
}

void customShowImageDialog(
  BuildContext context, {
  required String imageUrl,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor:
            Theme.of(context).cardColor,
        child: Stack(
          children: [
            SizedBox(
              height: 340,
              width: double.infinity,
              child: Center(
                child: _buildDynamicImage(
                  imageUrl,
                ),
              ),
            ),

            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                ),
                onPressed: () =>
                    Navigator.pop(
                  context,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}