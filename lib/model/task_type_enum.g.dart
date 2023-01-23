// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_type_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskTypeEnumAdapter extends TypeAdapter<TaskTypeEnum> {
  @override
  final int typeId = 3;

  @override
  TaskTypeEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskTypeEnum.focus;
      case 1:
        return TaskTypeEnum.meditation;
      case 2:
        return TaskTypeEnum.excercise;
      case 3:
        return TaskTypeEnum.working;
      default:
        return TaskTypeEnum.focus;
    }
  }

  @override
  void write(BinaryWriter writer, TaskTypeEnum obj) {
    switch (obj) {
      case TaskTypeEnum.focus:
        writer.writeByte(0);
        break;
      case TaskTypeEnum.meditation:
        writer.writeByte(1);
        break;
      case TaskTypeEnum.excercise:
        writer.writeByte(2);
        break;
      case TaskTypeEnum.working:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskTypeEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
