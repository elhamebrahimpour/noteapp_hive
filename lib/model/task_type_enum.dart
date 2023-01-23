import 'package:hive/hive.dart';
part 'task_type_enum.g.dart';

@HiveType(typeId: 3)
enum TaskTypeEnum {
  @HiveField(0)
  focus,
  @HiveField(1)
  meditation,
  @HiveField(2)
  excercise,
  @HiveField(3)
  working,
}
