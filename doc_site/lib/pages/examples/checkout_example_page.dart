import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_logo.dart';
import '../../src/example_container960.dart';
import '../../src/example_top_link.dart';

/// The "Checkout" example: a port of Bootstrap's own `examples/checkout` page —
/// a `bg-body-tertiary` page with a 960px container holding a logo and intro,
/// a cart (list group and promo code) beside a billing, payment form whose
/// required fields show their validation state once the form is submitted
/// (`needs-validation` / `was-validated`), and a footer.
class CheckoutExamplePage extends StatefulWidget {
  const CheckoutExamplePage({super.key, this.rtl = false});

  /// The `checkout-rtl` page: `dir="rtl"`, in Arabic (and `g-3` between the
  /// cart and the form).
  final bool rtl;

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

  _Strings get _t => widget.rtl ? _Strings.ar : _Strings.en;

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
    final page = ConstrainedBox(
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
    // <html dir="rtl">
    return widget.rtl
        ? Directionality(textDirection: TextDirection.rtl, child: page)
        : page;
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
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: BootstrapLogo(),
                ),
              ),
              BsHeading(BsHeadingLevel.h2, child: Text(_t.title)),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BsLead(child: Text(_t.lead)),
              ),
            ],
          ),
        ),
        BsRow(
          g: widget.rtl ? BsSpacing.s3 : BsSpacing.s5,
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
                style: TextStyle(
                  color: widget.rtl ? secondary : BsVariant.primary.color,
                ),
                child: Text(_t.cart),
              ),
              BsBadge(
                variant: widget.rtl ? BsVariant.secondary : BsVariant.primary,
                pill: true,
                child: const Text('3'),
              ),
            ],
          ),
        ),
        BsBox(
          mb: BsSpacing.s3,
          child: BsListGroup(
            items: [
              item(_t.product1, _t.description, r'$12'),
              item(_t.product2, _t.description, r'$8'),
              item(_t.product3, _t.description, r'$5'),
              item(
                _t.promo,
                'EXAMPLECODE',
                widget.rtl ? '-\$5' : '−\$5',
                color: success,
                tertiary: true,
              ),
              BsListGroupItem(
                child: BsFlex(
                  justifyContent: BsJustify.between,
                  children: [
                    Text(_t.total),
                    const Text(
                      r'$20',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
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
                  Expanded(
                    child: BsFormControl(
                      placeholder: _t.promo,
                      borderRadius: widget.rtl
                          ? const BorderRadius.horizontal(
                              right: Radius.circular(6),
                            )
                          : const BorderRadius.horizontal(
                              left: Radius.circular(6),
                            ),
                    ),
                  ),
                  BsButton(
                    variant: BsVariant.secondary,
                    style: BsButtonStyle(
                      borderRadius: widget.rtl
                          ? const BorderRadius.horizontal(
                              left: Radius.circular(6),
                            )
                          : const BorderRadius.horizontal(
                              right: Radius.circular(6),
                            ),
                    ),
                    onPressed: () {},
                    child: Text(_t.redeem),
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
        placeholder: Text(_t.choose),
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
        BsHeading(BsHeadingLevel.h4, mb: BsSpacing.s3, child: Text(_t.billing)),
        BsRow(
          g: BsSpacing.s3,
          children: [
            _input(
              'firstName',
              _t.firstName,
              col: half,
              feedback: _t.firstNameFeedback,
            ),
            _input(
              'lastName',
              _t.lastName,
              col: half,
              feedback: _t.lastNameFeedback,
            ),
            // <div class="input-group has-validation"><span class="input-group-text">@
            _group(
              col: full,
              label: _t.username,
              invalid: _invalid('username'),
              feedback: _t.usernameFeedback,
              control: BsInputGroup(
                valid: _validated ? !_invalid('username') : null,
                children: [
                  const BsInputGroupText(child: Text('@')),
                  Expanded(
                    child: BsFormControl(
                      showBorder: false,
                      controller: _controller('username'),
                      placeholder: _t.username,
                      valid: _validated ? !_invalid('username') : null,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),
            _input(
              'email',
              _t.email,
              col: full,
              optional: _t.optional,
              placeholder: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            _input(
              'address',
              _t.address,
              col: full,
              placeholder: _t.addressPlaceholder,
              feedback: _t.addressFeedback,
            ),
            _input(
              'address2',
              _t.address2,
              col: full,
              optional: _t.optional,
              placeholder: _t.address2Placeholder,
            ),
            _select(
              _t.country,
              _t.countryOption,
              col: const BsResponsiveValue<BsCol>(md: BsCol(5)),
              value: _country,
              onChanged: (v) => _country = v,
              feedback: _t.countryFeedback,
            ),
            _select(
              _t.state,
              _t.stateOption,
              col: const BsResponsiveValue<BsCol>(md: BsCol(4)),
              value: _state,
              onChanged: (v) => _state = v,
              feedback: _t.stateFeedback,
            ),
            _input('zip', _t.zip, col: medium3, feedback: _t.zipFeedback),
          ],
        ),
        const BsHr(my: BsSpacing.s4),
        check(
          BsFormCheck(
            valid: _validated ? true : null,
            value: _sameAddress,
            onChanged: (v) => setState(() => _sameAddress = v),
            label: Text(_t.sameAddress),
          ),
        ),
        BsFormCheck(
          valid: _validated ? true : null,
          value: _saveInfo,
          onChanged: (v) => setState(() => _saveInfo = v),
          label: Text(_t.saveInfo),
        ),
        const BsHr(my: BsSpacing.s4),
        BsHeading(BsHeadingLevel.h4, mb: BsSpacing.s3, child: Text(_t.payment)),
        // <div class="my-3"> (its top margin collapses with the heading's)
        BsBox(
          mb: BsSpacing.s3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              radio('credit', _t.credit),
              radio('debit', _t.debit),
              radio('paypal', 'PayPal', last: true),
            ],
          ),
        ),
        BsRow(
          gy: BsSpacing.s3,
          children: [
            _input(
              'cc-name',
              _t.ccName,
              col: medium6,
              hint: _t.ccNameHint,
              feedback: _t.ccNameFeedback,
            ),
            _input(
              'cc-number',
              _t.ccNumber,
              col: medium6,
              feedback: _t.ccNumberFeedback,
            ),
            _input(
              'cc-expiration',
              _t.ccExpiration,
              col: medium3,
              feedback: _t.ccExpirationFeedback,
            ),
            _input(
              'cc-cvv',
              _t.ccCvv,
              col: medium3,
              feedback: _t.ccCvvFeedback,
            ),
          ],
        ),
        const BsHr(my: BsSpacing.s4),
        BsButton(size: BsSize.lg, onPressed: _submit, child: Text(_t.submit)),
      ],
    );
  }

  // --- <footer class="my-5 pt-5 text-body-secondary text-center"> ---

  Widget _footer(BuildContext context) {
    // (`href="#"`: back to the top of the page)
    Widget item(String text) =>
        BsAnchor(onTap: () => scrollExampleToTop(context), child: Text(text));
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
            child: Text(_t.copyright(DateTime.now().year)),
          ),
          // <ul class="list-inline"> (the items are inline-blocks, with a
          // space between them and a `.5rem` margin after all but the last)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8 + 3.92,
              children: [item(_t.privacy), item(_t.terms), item(_t.support)],
            ),
          ),
        ],
      ),
    );
  }
}

/// The page's texts: the English original and the `checkout-rtl` Arabic one.
class _Strings {
  const _Strings({
    required this.title,
    required this.lead,
    required this.cart,
    required this.product1,
    required this.product2,
    required this.product3,
    required this.description,
    required this.promo,
    required this.total,
    required this.redeem,
    required this.billing,
    required this.firstName,
    required this.firstNameFeedback,
    required this.lastName,
    required this.lastNameFeedback,
    required this.username,
    required this.usernameFeedback,
    required this.email,
    required this.optional,
    required this.address,
    required this.addressPlaceholder,
    required this.addressFeedback,
    required this.address2,
    required this.address2Placeholder,
    required this.country,
    required this.countryOption,
    required this.countryFeedback,
    required this.state,
    required this.stateOption,
    required this.stateFeedback,
    required this.zip,
    required this.zipFeedback,
    required this.choose,
    required this.sameAddress,
    required this.saveInfo,
    required this.payment,
    required this.credit,
    required this.debit,
    required this.ccName,
    required this.ccNameHint,
    required this.ccNameFeedback,
    required this.ccNumber,
    required this.ccNumberFeedback,
    required this.ccExpiration,
    required this.ccExpirationFeedback,
    required this.ccCvv,
    required this.ccCvvFeedback,
    required this.submit,
    required this.copyright,
    required this.privacy,
    required this.terms,
    required this.support,
  });

  final String title, lead, cart, product1, product2, product3, description;
  final String promo, total, redeem, billing;
  final String firstName, firstNameFeedback, lastName, lastNameFeedback;
  final String username, usernameFeedback, email, optional;
  final String address, addressPlaceholder, addressFeedback;
  final String address2, address2Placeholder;
  final String country, countryOption, countryFeedback;
  final String state, stateOption, stateFeedback;
  final String zip, zipFeedback, choose, sameAddress, saveInfo;
  final String payment, credit, debit;
  final String ccName, ccNameHint, ccNameFeedback;
  final String ccNumber, ccNumberFeedback;
  final String ccExpiration, ccExpirationFeedback, ccCvv, ccCvvFeedback;
  final String submit;
  final String Function(int year) copyright;
  final String privacy, terms, support;

  static final en = _Strings(
    title: 'Checkout form',
    lead:
        'Below is an example form built entirely with Bootstrap’s form '
        'controls. Each required form group has a validation state that can be '
        'triggered by attempting to submit the form without completing it.',
    cart: 'Your cart',
    product1: 'Product name',
    product2: 'Second product',
    product3: 'Third item',
    description: 'Brief description',
    promo: 'Promo code',
    total: 'Total (USD)',
    redeem: 'Redeem',
    billing: 'Billing address',
    firstName: 'First name',
    firstNameFeedback: 'Valid first name is required.',
    lastName: 'Last name',
    lastNameFeedback: 'Valid last name is required.',
    username: 'Username',
    usernameFeedback: 'Your username is required.',
    email: 'Email',
    optional: '(Optional)',
    address: 'Address',
    addressPlaceholder: '1234 Main St',
    addressFeedback: 'Please enter your shipping address.',
    address2: 'Address 2',
    address2Placeholder: 'Apartment or suite',
    country: 'Country',
    countryOption: 'United States',
    countryFeedback: 'Please select a valid country.',
    state: 'State',
    stateOption: 'California',
    stateFeedback: 'Please provide a valid state.',
    zip: 'Zip',
    zipFeedback: 'Zip code required.',
    choose: 'Choose...',
    sameAddress: 'Shipping address is the same as my billing address',
    saveInfo: 'Save this information for next time',
    payment: 'Payment',
    credit: 'Credit card',
    debit: 'Debit card',
    ccName: 'Name on card',
    ccNameHint: 'Full name as displayed on card',
    ccNameFeedback: 'Name on card is required',
    ccNumber: 'Credit card number',
    ccNumberFeedback: 'Credit card number is required',
    ccExpiration: 'Expiration',
    ccExpirationFeedback: 'Expiration date required',
    ccCvv: 'CVV',
    ccCvvFeedback: 'Security code required',
    submit: 'Continue to checkout',
    copyright: (year) => '© 2017–$year Company Name',
    privacy: 'Privacy',
    terms: 'Terms',
    support: 'Support',
  );

  static final ar = _Strings(
    title: 'نموذج إتمام الشراء',
    lead:
        'فيما يلي مثال على نموذج تم إنشاؤه بالكامل باستخدام عناصر تحكم النموذج '
        'في Bootstrap. لكل مجموعة نماذج مطلوبة حالة تحقق يمكن تشغيلها بمحاولة '
        'إرسال النموذج دون استكماله.',
    cart: 'عربة التسوق',
    product1: 'اسم المنتج',
    product2: 'المنتج الثاني',
    product3: 'البند الثالث',
    description: 'وصف مختصر',
    promo: 'رمز ترويجي',
    total: 'مجموع (USD)',
    redeem: 'تحقق',
    billing: 'عنوان الفوترة',
    firstName: 'الاسم الأول',
    firstNameFeedback: 'يرجى إدخال اسم أول صحيح.',
    lastName: 'اسم العائلة',
    lastNameFeedback: 'يرجى إدخال اسم عائلة صحيح.',
    username: 'اسم المستخدم',
    usernameFeedback: 'اسم المستخدم الخاص بك مطلوب.',
    email: 'البريد الإلكتروني',
    optional: '(اختياري)',
    address: 'العنوان',
    addressPlaceholder: '1234 الشارع الأول',
    addressFeedback: 'يرجى إدخال عنوان الشحن الخاص بك.',
    address2: 'عنوان 2',
    address2Placeholder: 'شقة 24',
    country: 'البلد',
    countryOption: 'الولايات المتحدة الأمريكية',
    countryFeedback: 'يرجى اختيار بلد صحيح.',
    state: 'المنطقة',
    stateOption: 'كاليفورنيا',
    stateFeedback: 'يرجى اختيار اسم منطقة صحيح.',
    zip: 'الرمز البريدي',
    zipFeedback: 'الرمز البريدي مطلوب.',
    choose: 'اختر...',
    sameAddress: 'عنوان الشحن هو نفس عنوان الفوترة الخاص بي',
    saveInfo: 'احفظ هذه المعلومات في المرة القادمة',
    payment: 'طريقة الدفع',
    credit: 'بطاقة ائتمان',
    debit: 'نقد',
    ccName: 'الاسم على البطاقة',
    ccNameHint: 'الاسم الكامل كما هو معروض على البطاقة',
    ccNameFeedback: 'الاسم على البطاقة مطلوب',
    ccNumber: 'رقم البطاقة',
    ccNumberFeedback: 'رقم بطاقة الائتمان مطلوب',
    ccExpiration: 'تاريخ انتهاء الصلاحية',
    ccExpirationFeedback: 'تاريخ انتهاء الصلاحية مطلوب',
    ccCvv: 'الرمز الثلاثي (CVV)',
    ccCvvFeedback: 'رمز الحماية مطلوب',
    submit: 'الاستمرار بالدفع',
    copyright: (year) => '© $year-2017 اسم الشركة',
    privacy: 'سياسة الخصوصية',
    terms: 'اتفاقية الاستخدام',
    support: 'الدعم الفني',
  );
}
