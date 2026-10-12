import 'package:flutter_test/flutter_test.dart';

import 'package:doc_site/src/file_input_labels.dart';

void main() {
  test("each browser's own words for an empty file input", () {
    const chrome =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36';
    const safari =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15';
    const edge =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0';
    const firefox =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:125.0) Gecko/20100101 Firefox/125.0';

    expect(fileInputLabelsFor(chrome).noFile, 'No file chosen');
    expect(fileInputLabelsFor(edge).noFile, 'No file chosen');
    expect(fileInputLabelsFor(safari).noFile, 'no file selected');
    expect(fileInputLabelsFor(safari).button, 'Choose File');
    expect(fileInputLabelsFor(firefox).noFile, 'No file selected.');
    expect(fileInputLabelsFor(firefox).button, 'Browse…');
    expect(
      fileInputLabelsFor('').noFile,
      'No file chosen',
      reason: 'Chrome\'s when unknown',
    );
  });
}
