import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// One field on a `BsXStyle` class: its Bootstrap CSS/Sass variable
/// equivalent and its default value.
class DocStyleRow {
  const DocStyleRow({required this.field, required this.bootstrapVar, required this.defaultValue});

  /// The Dart field name on the style class, e.g. `'color'`.
  final String field;

  /// The Bootstrap CSS custom property (or Sass variable, for values that
  /// only exist at the Sass layer, like transition timing) it mirrors,
  /// e.g. `'--bs-btn-color'`.
  final String bootstrapVar;

  /// The default value, as prose — often "derived from variant/size"
  /// rather than one fixed value, since several `BsXStyle` classes (like
  /// `BsButtonStyle`) don't have a single flat set of defaults the way
  /// most others do.
  final String defaultValue;
}

/// A "CSS" reference section mirroring the "Variables"/"Sass variables"
/// tables on Bootstrap's own docs site (`getbootstrap.com/docs/.../CSS`) —
/// except every row here is sourced from this repo's own
/// `vendor/bootstrap/scss/` and the matching `BsXStyle` class, so it
/// documents what this port actually implements rather than re-deriving
/// it from upstream each time.
class DocStyleTable extends StatelessWidget {
  const DocStyleTable({super.key, required this.styleClass, required this.sassFile, required this.rows});

  /// The Dart style class this documents, e.g. `'BsButtonStyle'`.
  final String styleClass;

  /// Where in `vendor/bootstrap/scss/` the mirrored variables live, e.g.
  /// `'scss/_buttons.scss'`.
  final String sassFile;

  final List<DocStyleRow> rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CSS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: BsBody.colorOf(context))),
          const SizedBox(height: 4),
          Text('Variables', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: BsBody.colorOf(context))),
          const SizedBox(height: 8),
          DefaultTextStyle.merge(
            style: TextStyle(fontSize: 14, color: BsBody.secondaryColorOf(context), height: 1.5),
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Every field on '),
                  WidgetSpan(alignment: PlaceholderAlignment.middle, child: BsCode(child: Text(styleClass))),
                  const TextSpan(text: ' mirrors one of Bootstrap\'s own CSS custom properties or Sass variables in '),
                  WidgetSpan(alignment: PlaceholderAlignment.middle, child: BsCode(child: Text(sassFile))),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          BsTable(
            bordered: true,
            small: true,
            columns: const [Text('Field'), Text('Bootstrap'), Text('Default')],
            rows: [
              for (final row in rows)
                BsTableRow(
                  cells: [
                    BsCode(child: Text(row.field)),
                    BsCode(child: Text(row.bootstrapVar)),
                    Text(row.defaultValue),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
