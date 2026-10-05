import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_logo.dart';
import '../../src/example_container960.dart';

/// The "Checkout" example: a port of Bootstrap's own `examples/checkout` page —
/// a `bg-body-tertiary` page with a 960px container holding a logo and intro,
/// a cart (list group and promo code) beside a billing, payment form whose
/// required fields show their validation state once the form is submitted
/// (`needs-validation` / `was-validated`), and a footer.
class CheckoutExamplePage extends StatefulWidget {
  const CheckoutExamplePage({super.key});

  @override
  State<CheckoutExamplePage> createState() => _CheckoutExamplePageState();
}

class _CheckoutExamplePageState extends State<CheckoutExamplePage> {
  /// `form.classList.add('was-validated')` once a submit has been attempted.
  bool _validated = false;

  final _text = <String, TextEditingController>{};
  String? _country;
  String? _state;
  bool _sameAddress = false;
  bool _saveInfo = false;
  String _payment = 'credit';

  TextEditingController _controller(String name) =>
      _text.putIfAbsent(name, TextEditingController.new);

  @override
  void dispose() {
    for (final controller in _text.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _invalid(String name) =>
      _validated && _controller(name).text.trim().isEmpty;

  /// `form.checkValidity()`: every required field filled in.
  void _submit() {
    setState(() => _validated = true);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
      child: BsBox(
        bg: BsBg.bodyTertiary,
        child: Container960(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_main(context), _footer(context)],
          ),
        ),
      ),
    );
  }

  // --- <main> ---

  Widget _main(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // <div class="py-5 text-center">
        BsBox(
          py: BsSpacing.s5,
          textAlign: BsTextAlign.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: BootstrapLogo(),
                ),
              ),
              BsHeading(BsHeadingLevel.h2, child: Text('Checkout form')),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: BsLead(
                  child: Text(
                    'Below is an example form built entirely with Bootstrap’s '
                    'form controls. Each required form group has a validation '
                    'state that can be triggered by attempting to submit the '
                    'form without completing it.',
                  ),
                ),
              ),
            ],
          ),
        ),
        BsRow(
          g: BsSpacing.s5,
          direction: const BsResponsiveValue(
            xs: BsFlexDirection.row,
            md: BsFlexDirection.rowReverse,
          ),
          children: [
            // <div class="col-md-5 col-lg-4 order-md-last">
            BsFlexItem(
              col: const BsResponsiveValue(
                xs: BsCol(12),
                md: BsCol(5),
                lg: BsCol(4),
              ),
              child: _cart(context),
            ),
            // <div class="col-md-7 col-lg-8">
            BsFlexItem(
              col: const BsResponsiveValue(
                xs: BsCol(12),
                md: BsCol(7),
                lg: BsCol(8),
              ),
              child: _form(context),
            ),
          ],
        ),
      ],
    );
  }

  // --- the cart ---

  Widget _cart(BuildContext context) {
    final secondary = BsTextColor.bodySecondary.of(context);
    final success = BsVariant.success.color;

    BsListGroupItem item(
      String name,
      String description,
      String price, {
      Color? color,
      bool tertiary = false,
    }) {
      final muted = color ?? secondary;
      return BsListGroupItem(
        bg: tertiary ? BsBg.bodyTertiary : null,
        child: DefaultTextStyle.merge(
          // lh-sm (but not on the promo code item)
          style: TextStyle(height: tertiary ? null : 1.25),
          child: BsFlex(
            justifyContent: BsJustify.between,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle.merge(
                    style: TextStyle(color: color),
                    child: BsHeading(
                      BsHeadingLevel.h6,
                      mb: BsSpacing.s0,
                      child: Text(name),
                    ),
                  ),
                  DefaultTextStyle.merge(
                    style: TextStyle(color: muted),
                    child: BsSmall(child: Text(description)),
                  ),
                ],
              ),
              DefaultTextStyle.merge(
                style: TextStyle(color: muted),
                child: Text(price),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // <h4 class="d-flex justify-content-between align-items-center mb-3">
        BsHeading(
          BsHeadingLevel.h4,
          mb: BsSpacing.s3,
          child: BsFlex(
            justifyContent: BsJustify.between,
            alignItems: BsAlign.center,
            children: [
              DefaultTextStyle.merge(
                style: TextStyle(color: BsVariant.primary.color),
                child: const Text('Your cart'),
              ),
              const BsBadge(pill: true, child: Text('3')),
            ],
          ),
        ),
        BsBox(
          mb: BsSpacing.s3,
          child: BsListGroup(
            items: [
              item('Product name', 'Brief description', r'$12'),
              item('Second product', 'Brief description', r'$8'),
              item('Third item', 'Brief description', r'$5'),
              item(
                'Promo code',
                'EXAMPLECODE',
                '−\$5',
                color: success,
                tertiary: true,
              ),
              BsListGroupItem(
                child: BsFlex(
                  justifyContent: BsJustify.between,
                  children: const [
                    Text('Total (USD)'),
                    Text(r'$20', style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
        // <form class="card p-2"><div class="input-group">
        BsCard(
          child: BsBox(
            p: BsSpacing.s2,
            // (an `.input-group`: the control squares its right corners, the
            // button its left ones)
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Expanded(
                    child: BsFormControl(
                      placeholder: 'Promo code',
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(6),
                      ),
                    ),
                  ),
                  BsButton(
                    variant: BsVariant.secondary,
                    style: const BsButtonStyle(
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(6),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Redeem'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- the form ---

  /// A form group: `<div class="col-*"><label class="form-label">…</label>`
  /// [control], [hint] (`<small class="text-body-secondary">`) and, when it is
  /// [invalid] after validation, the `.invalid-feedback`.
  Widget _group({
    required BsResponsive<BsCol> col,
    required String label,
    String? optional,
    required Widget control,
    bool invalid = false,
    String? feedback,
    String? hint,
  }) {
    final secondary = BsTextColor.bodySecondary.of(context);
    return BsFlexItem(
      col: col,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsFormLabel(
            child: optional == null
                ? Text(label)
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '$label '),
                        TextSpan(
                          text: optional,
                          style: TextStyle(color: secondary),
                        ),
                      ],
                    ),
                  ),
          ),
          control,
          if (hint != null)
            DefaultTextStyle.merge(
              style: TextStyle(color: secondary),
              child: BsSmall(child: Text(hint)),
            ),
          if (invalid && feedback != null)
            // .invalid-feedback { margin-top: .25rem; font-size: .875em }
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  color: BsVariant.danger.color,
                  fontSize: 14,
                  height: 1.5,
                ),
                child: Text(feedback),
              ),
            ),
        ],
      ),
    );
  }

  /// A required (or optional) text input group.
  Widget _input(
    String name,
    String label, {
    required BsResponsive<BsCol> col,
    String? optional,
    String? placeholder,
    String? feedback,
    String? hint,
    TextInputType? keyboardType,
  }) {
    final required = feedback != null;
    final invalid = required && _invalid(name);
    return _group(
      col: col,
      label: label,
      optional: optional,
      invalid: invalid,
      feedback: feedback,
      hint: hint,
      control: BsFormControl(
        controller: _controller(name),
        placeholder: placeholder,
        keyboardType: keyboardType,
        valid: _validated ? !invalid : null,
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _select(
    String label,
    String option, {
    required BsResponsive<BsCol> col,
    required String? value,
    required ValueChanged<String> onChanged,
    required String feedback,
  }) {
    return _group(
      col: col,
      label: label,
      invalid: _validated && value == null,
      feedback: feedback,
      control: BsFormSelect<String>(
        valid: _validated ? value != null : null,
        items: [BsFormSelectItem(value: option, label: Text(option))],
        value: value,
        placeholder: const Text('Choose...'),
        onChanged: (v) => setState(() => onChanged(v)),
      ),
    );
  }

  Widget _form(BuildContext context) {
    const half = BsResponsiveValue<BsCol>(sm: BsCol(6));
    const full = BsResponsiveValue<BsCol>(xs: BsCol(12));
    const medium6 = BsResponsiveValue<BsCol>(md: BsCol(6));
    const medium3 = BsResponsiveValue<BsCol>(md: BsCol(3));
    // .form-check { margin-bottom: .125rem }
    Widget check(Widget child) =>
        Padding(padding: const EdgeInsets.only(bottom: 2), child: child);
    // (the last one's margin collapses into whatever follows)
    Widget radio(String id, String label, {bool last = false}) {
      final radio = BsFormCheck(
        valid: _validated ? true : null,
        type: BsFormCheckType.radio,
        value: _payment == id,
        onChanged: (_) => setState(() => _payment = id),
        label: Text(label),
      );
      return last ? radio : check(radio);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BsHeading(
          BsHeadingLevel.h4,
          mb: BsSpacing.s3,
          child: Text('Billing address'),
        ),
        BsRow(
          g: BsSpacing.s3,
          children: [
            _input(
              'firstName',
              'First name',
              col: half,
              feedback: 'Valid first name is required.',
            ),
            _input(
              'lastName',
              'Last name',
              col: half,
              feedback: 'Valid last name is required.',
            ),
            // <div class="input-group has-validation"><span class="input-group-text">@
            _group(
              col: full,
              label: 'Username',
              invalid: _invalid('username'),
              feedback: 'Your username is required.',
              control: BsInputGroup(
                valid: _validated ? !_invalid('username') : null,
                children: [
                  const BsInputGroupText(child: Text('@')),
                  Expanded(
                    child: BsFormControl(
                      showBorder: false,
                      controller: _controller('username'),
                      placeholder: 'Username',
                      valid: _validated ? !_invalid('username') : null,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),
            _input(
              'email',
              'Email',
              col: full,
              optional: '(Optional)',
              placeholder: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            _input(
              'address',
              'Address',
              col: full,
              placeholder: '1234 Main St',
              feedback: 'Please enter your shipping address.',
            ),
            _input(
              'address2',
              'Address 2',
              col: full,
              optional: '(Optional)',
              placeholder: 'Apartment or suite',
            ),
            _select(
              'Country',
              'United States',
              col: const BsResponsiveValue<BsCol>(md: BsCol(5)),
              value: _country,
              onChanged: (v) => _country = v,
              feedback: 'Please select a valid country.',
            ),
            _select(
              'State',
              'California',
              col: const BsResponsiveValue<BsCol>(md: BsCol(4)),
              value: _state,
              onChanged: (v) => _state = v,
              feedback: 'Please provide a valid state.',
            ),
            _input('zip', 'Zip', col: medium3, feedback: 'Zip code required.'),
          ],
        ),
        const BsHr(my: BsSpacing.s4),
        check(
          BsFormCheck(
            valid: _validated ? true : null,
            value: _sameAddress,
            onChanged: (v) => setState(() => _sameAddress = v),
            label: const Text(
              'Shipping address is the same as my billing address',
            ),
          ),
        ),
        BsFormCheck(
          valid: _validated ? true : null,
          value: _saveInfo,
          onChanged: (v) => setState(() => _saveInfo = v),
          label: const Text('Save this information for next time'),
        ),
        const BsHr(my: BsSpacing.s4),
        const BsHeading(
          BsHeadingLevel.h4,
          mb: BsSpacing.s3,
          child: Text('Payment'),
        ),
        // <div class="my-3"> (its top margin collapses with the heading's)
        BsBox(
          mb: BsSpacing.s3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              radio('credit', 'Credit card'),
              radio('debit', 'Debit card'),
              radio('paypal', 'PayPal', last: true),
            ],
          ),
        ),
        BsRow(
          gy: BsSpacing.s3,
          children: [
            _input(
              'cc-name',
              'Name on card',
              col: medium6,
              hint: 'Full name as displayed on card',
              feedback: 'Name on card is required',
            ),
            _input(
              'cc-number',
              'Credit card number',
              col: medium6,
              feedback: 'Credit card number is required',
            ),
            _input(
              'cc-expiration',
              'Expiration',
              col: medium3,
              feedback: 'Expiration date required',
            ),
            _input(
              'cc-cvv',
              'CVV',
              col: medium3,
              feedback: 'Security code required',
            ),
          ],
        ),
        const BsHr(my: BsSpacing.s4),
        BsButton(
          size: BsSize.lg,
          onPressed: _submit,
          child: const Text('Continue to checkout'),
        ),
      ],
    );
  }

  // --- <footer class="my-5 pt-5 text-body-secondary text-center"> ---

  Widget _footer(BuildContext context) {
    final link = BsLink.colorOf(context);
    Widget item(String text) => Text(
      text,
      style: TextStyle(color: link, decoration: TextDecoration.underline),
    );
    return BsBox(
      my: BsSpacing.s5,
      pt: BsSpacing.s5,
      textColor: BsTextColor.bodySecondary,
      textAlign: BsTextAlign.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('© 2017–${DateTime.now().year} Company Name'),
          ),
          // <ul class="list-inline"> (the items are inline-blocks, with a
          // space between them and a `.5rem` margin after all but the last)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8 + 3.92,
              children: [item('Privacy'), item('Terms'), item('Support')],
            ),
          ),
        ],
      ),
    );
  }
}
