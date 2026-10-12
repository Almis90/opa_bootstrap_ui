/// What a browser writes in an `<input type="file">`: its button and what it
/// says while no file is chosen. Each browser has its own words.
typedef FileInputLabels = ({String button, String noFile});

/// Chrome, Edge and the rest of the Chromium family.
const chromeFileInputLabels = (button: 'Choose File', noFile: 'No file chosen');

/// Safari: the same button, and its own lowercase wording.
const safariFileInputLabels = (
  button: 'Choose File',
  noFile: 'no file selected',
);

/// Firefox.
const firefoxFileInputLabels = (button: 'Browse…', noFile: 'No file selected.');

/// The labels of the browser whose user-agent string is [userAgent] (Chrome's
/// when it isn't known: off the web, or any other Chromium).
FileInputLabels fileInputLabelsFor(String userAgent) {
  if (userAgent.contains('Firefox/') || userAgent.contains('FxiOS/')) {
    return firefoxFileInputLabels;
  }
  // Every Chromium browser also says "Safari"; only Safari itself lacks the
  // others' own tokens.
  final chromium = RegExp(
    r'Chrome/|Chromium/|CriOS/|Edg/|EdgA/|EdgiOS/|OPR/|SamsungBrowser/',
  );
  if (userAgent.contains('Safari/') && !chromium.hasMatch(userAgent)) {
    return safariFileInputLabels;
  }
  return chromeFileInputLabels;
}
