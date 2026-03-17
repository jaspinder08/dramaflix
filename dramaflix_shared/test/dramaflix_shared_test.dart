import 'package:flutter_test/flutter_test.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';

void main() {
  test('Shared constants are accessible', () {
    expect(AppColors.dramaPink, isNotNull);
    expect(AppTypography.h1, isNotNull);
  });
}
