import 'package:hive/hive.dart';

class Expense {
  final int id;
  String? key;
  final String title;
  final double amount;
  final DateTime date;

  Expense(
      {required this.id,
      this.key,
      required this.title,
      required this.amount,
      required this.date});
}

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 0;

  @override
  Expense read(BinaryReader reader) {
    // read fields in the same order they were written
    final id = reader.readInt();
    final key = reader.read() as String?;
    final title = reader.readString();
    final amount = reader.readDouble();
    final date = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    return Expense(id: id, key: key, title: title, amount: amount, date: date);
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    // write fields in a stable order
    writer.writeInt(obj.id);
    writer.write(obj.key);
    writer.writeString(obj.title);
    writer.writeDouble(obj.amount);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
  }
}