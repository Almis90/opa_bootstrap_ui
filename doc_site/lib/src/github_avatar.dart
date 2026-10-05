import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// The same avatar Bootstrap's own dropdown examples use (`github.com/mdo.png`
/// as an `<img class="rounded-circle">`), [size] px square. That URL redirects
/// to `avatars.githubusercontent.com` without CORS headers on the redirect,
/// which Flutter web's canvas image loader needs, so the final URL is used
/// directly.
class GithubAvatar extends StatelessWidget {
  const GithubAvatar({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        'https://avatars.githubusercontent.com/u/98681?v=4',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          color: BsColors.gray400,
          child: Text(
            'M',
            style: TextStyle(
              color: BsColors.white,
              fontSize: size * 13 / 32,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
