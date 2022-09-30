import 'package:alura_flutter_curso_1/components/tasks.dart';
import 'package:alura_flutter_curso_1/data/database.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  static const String _tablename = 'tasks';
  static const String _name = 'name';
  static const String _difficulty = 'difficulty';
  static const String _image = 'image';

  static const String tableSql = 'CREATE TABLE $_tablename('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_image TEXT)';

  save(Task task) async {
    print('Save: ');
    final Database database = await getDatabase();
    var taskExist = await find(task.name);
    Map<String, dynamic> taskMap = toMap(task);
    if (taskExist.isEmpty) {
      print('A tarefa foi criada');
      return await database.insert(_tablename, taskMap);
    } else {
      print('A tarefa foi atualizada');
      return await database.update(_tablename, taskMap,
          where: '$_name = ?', whereArgs: [task.name]);
    }
  }

  delete(String taskName) async {
    print('Delete: ');
    final Database database = await getDatabase();
    print('A tarefa foi deletada');
    return await database
        .delete(_tablename, where: '$_name = ?', whereArgs: [taskName]);
  }

  Map<String, dynamic> toMap(Task task) {
    print('Convertendo Tarefa em Map...');
    final Map<String, dynamic> tasksMap = {};
    tasksMap[_name] = task.name;
    tasksMap[_difficulty] = task.difficulty;
    tasksMap[_image] = task.image;
    print('Mapa de tarefas: $tasksMap');
    return tasksMap;
  }

  Future<List<Task>> findAll() async {
    print('FindAll: ');
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(_tablename);
    print('Procurando dados no banco...');
    print('Encontrado: ${toTaskList(result)}');
    return toTaskList(result);
  }

  Future<List<Task>> find(String taskName) async {
    print('Find: ');
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database
        .query(_tablename, where: '$_name = ?', whereArgs: [taskName]);
    print('Procurando dados no banco...');
    print('Encontrado: ${toTaskList(result)}');
    return toTaskList(result);
  }

  List<Task> toTaskList(List<Map<String, dynamic>> mapsList) {
    print('Convertendo Map para Lista de Tarefas...');
    final List<Task> tasksList = [];
    for (Map<String, dynamic> line in mapsList) {
      final Task task = Task(line[_name], line[_image], line[_difficulty]);
      tasksList.add(task);
    }
    print('Lista de Taferas');
    print('$tasksList');
    return tasksList;
  }
}
