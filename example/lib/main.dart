import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: BsColors.blue,
      builder: (context, child) => DefaultTextStyle(
        style: const TextStyle(color: BsColors.gray900, fontFamily: 'Roboto'),
        child: ColoredBox(
          color: BsColors.white,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Variants'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final variant in BsVariant.values)
                        BsButton(
                          variant: variant,
                          onPressed: () {},
                          child: Text(variant.name),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Outline'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final variant in BsVariant.values)
                        BsButton(
                          variant: variant,
                          outline: true,
                          onPressed: () {},
                          child: Text(variant.name),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Sizes'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      BsButton(
                        size: BsSize.sm,
                        onPressed: () {},
                        child: const Text('small'),
                      ),
                      BsButton(
                        variant: BsVariant.secondary,
                        size: BsSize.sm,
                        onPressed: () {},
                        child: const Text('small'),
                      ),
                      BsButton(
                        onPressed: () {},
                        child: const Text('default'),
                      ),
                      BsButton(
                        variant: BsVariant.secondary,
                        onPressed: () {},
                        child: const Text('default'),
                      ),
                      BsButton(
                        size: BsSize.lg,
                        onPressed: () {},
                        child: const Text('large'),
                      ),
                      BsButton(
                        variant: BsVariant.secondary,
                        size: BsSize.lg,
                        onPressed: () {},
                        child: const Text('large'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Disabled'),
                  const SizedBox(height: 8),
                  const Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      BsButton(
                        onPressed: null,
                        child: Text('primary'),
                      ),
                      BsButton(
                        variant: BsVariant.secondary,
                        onPressed: null,
                        child: Text('secondary'),
                      ),
                      BsButton(
                        outline: true,
                        onPressed: null,
                        child: Text('primary'),
                      ),
                      BsButton(
                        variant: BsVariant.secondary,
                        outline: true,
                        onPressed: null,
                        child: Text('secondary'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('No wrap'),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: BsButton(
                          onPressed: () {},
                          child: const Text('Wraps in a narrow box'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      BsButton(
                        noWrap: true,
                        onPressed: () {},
                        child: const Text('Does not wrap'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
