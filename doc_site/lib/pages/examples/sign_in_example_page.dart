import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_logo.dart';

/// The "Sign-in" example: a port of Bootstrap's own `examples/sign-in` page —
/// a `body.d-flex.align-items-center.py-4.bg-body-tertiary` holding a
/// `main.form-signin.w-100.m-auto` (`max-width: 330px; padding: 1rem`) with a
/// logo, a heading, two stacked floating-label fields, a checkbox and a
/// full-width button.
class SignInExamplePage extends StatefulWidget {
  const SignInExamplePage({super.key});

  @override
  State<SignInExamplePage> createState() => _SignInExamplePageState();
}

class _SignInExamplePageState extends State<SignInExamplePage> {
  bool _remember = false;

  @override
  Widget build(BuildContext context) {
    // html, body { height: 100% } — and the page grows past it when the form
    // (plus the body's py-4) is taller.
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
      child: BsBox(
        bg: BsBg.bodyTertiary,
        py: BsSpacing.s4,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 330),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _form(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // <img class="mb-4" width="72" height="57">
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: BootstrapLogo(),
          ),
        ),
        const BsHeading(
          BsHeadingLevel.h3,
          fw: BsFw.normal,
          mb: BsSpacing.s3,
          child: Text('Please sign in'),
        ),
        // .form-signin input[type="email"] { margin-bottom: -1px; … }
        // The password field's top border sits over the email's bottom one.
        const Align(
          alignment: Alignment.topCenter,
          heightFactor: 57 / 58,
          child: BsFormFloating(
            label: Text('Email address'),
            roundedBottom: BsRounded.r0,
          ),
        ),
        // margin-bottom: 10px, then `my-3` on the checkbox: the larger wins.
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: BsFormFloating(
            label: Text('Password'),
            obscureText: true,
            roundedTop: BsRounded.r0,
          ),
        ),
        // <div class="form-check text-start my-3"> (the top margin is the one
        // above)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: BsFormCheck(
            value: _remember,
            onChanged: (v) => setState(() => _remember = v),
            label: const Text('Remember me'),
          ),
        ),
        BsButton(
          onPressed: () {},
          py: BsSpacing.s2,
          child: const Center(child: Text('Sign in')),
        ),
        // <p class="mt-5 mb-3 text-body-secondary">
        Padding(
          padding: const EdgeInsets.only(top: 48, bottom: 16),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: BsTextColor.bodySecondary.of(context)),
            child: Text('© 2017–${DateTime.now().year}'),
          ),
        ),
      ],
    );
  }
}
