import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// One field on a `BsXStyle` class: the Bootstrap variable it mirrors and
/// its default value.
class DocStyleRow {
  const DocStyleRow({required this.field, required this.bootstrapVar, required this.defaultValue});

  /// The Dart field name on the style class, e.g. `'color'`.
  final String field;

  /// The Bootstrap variable it mirrors, e.g. `'--bs-btn-color'`.
  final String bootstrapVar;

  /// The default value. For a flat `BsXStyle.defaults` class this is a
  /// literal value; for a variant/size-derived class (no single
  /// `.defaults` — e.g. `BsButtonStyle`) this is the value the widget's
  /// own default parameters actually resolve to (e.g. `BsButton`'s
  /// `variant: BsVariant.primary`), not a generic "varies by variant".
  final String defaultValue;
}

/// A "Style tokens" reference section mirroring the variables tables on
/// Bootstrap's own docs site — except every row here is sourced from this
/// repo's own `vendor/bootstrap/scss/` and the matching `BsXStyle` class,
/// so it documents what this port actually implements rather than
/// re-deriving it from upstream each time.
class DocStyleTable extends StatelessWidget {
  const DocStyleTable({super.key, required this.styleClass, required this.sassFile, this.defaultsNote, required this.rows});

  /// The Dart style class this documents, e.g. `'BsButtonStyle'`.
  final String styleClass;

  /// Where in `vendor/bootstrap/scss/` the mirrored variables live, e.g.
  /// `'scss/_buttons.scss'`.
  final String sassFile;

  /// Extra context for [DocStyleRow.defaultValue] when it isn't a flat,
  /// always-the-same value — e.g. clarifying that the "Default" column
  /// shows values for the widget's own default parameters, which vary if
  /// you pass something else.
  final String? defaultsNote;

  final List<DocStyleRow> rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Style tokens',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: BsBody.colorOf(context)),
          ),
          const SizedBox(height: 8),
          DefaultTextStyle.merge(
            style: TextStyle(fontSize: 14, color: BsBody.secondaryColorOf(context), height: 1.5),
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Every field on '),
                  WidgetSpan(alignment: PlaceholderAlignment.middle, child: BsCode(child: Text(styleClass))),
                  const TextSpan(text: ' mirrors one of Bootstrap\'s own style variables, defined in '),
                  WidgetSpan(alignment: PlaceholderAlignment.middle, child: BsCode(child: Text(sassFile))),
                  const TextSpan(text: '.'),
                  if (defaultsNote != null) TextSpan(text: ' $defaultsNote'),
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
