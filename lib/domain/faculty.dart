import 'package:freezed_annotation/freezed_annotation.dart';

part 'faculty.freezed.dart';

@freezed
abstract class Faculty with _$Faculty {
  const factory Faculty({required String id, required String name, required String email}) = _Faculty;
}
