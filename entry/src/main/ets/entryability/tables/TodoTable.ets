import relationalStore from '@ohos.data.relationalStore';
import hilog from '@ohos.hilog';
import Rdb from '../../datalist/DatabaseAbility'
import { TodoItem } from '../../datalist/TodoItemList';

const TODO_TABLE = {
  tableName: 'todoTable',
  sqlCreate: 'CREATE TABLE IF NOT EXISTS todoTable(' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
  'date TEXT,' +
  'title TEXT,' +
  'content TEXT,' +
  'startTime TEXT,' +
  'endTime TEXT',
  columns: ['id', 'date', 'title', 'content', 'startTime', 'endTime']
};


export default class TodoTable {
  private todoTable = new Rdb(TODO_TABLE.tableName, TODO_TABLE.sqlCreate, TODO_TABLE.columns);

  constructor(callback: Function = () => {}) {
    this.todoTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {}) {
    this.todoTable.getRdbStore(callback);
  }

  insertData(todoItem: TodoItem, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(todoItem);
    this.todoTable.insertData(valueBucket, callback);
  }

  deleteData(todoItem: TodoItem, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(TODO_TABLE.tableName);
    predicates.equalTo('id', todoItem.id);
    this.todoTable.deleteData(predicates, callback);
  }

  updateData(todoItem: TodoItem, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(todoItem);
    let predicates = new relationalStore.RdbPredicates(TODO_TABLE.tableName);
    predicates.equalTo('id', todoItem.id);
    this.todoTable.updateData(predicates, valueBucket, callback);
  }

  // 通过日期查找
  queryByDate(year: number, month: number, day: number, callback: Function, isAll: boolean = true) {
    let predicates = new relationalStore.RdbPredicates(TODO_TABLE.tableName);
    const date = year.toString()  + ',' + month.toString() + ',' + day.toString();
    if (!isAll) {
      predicates.equalTo('date', date);
    }
    // 查询语句
    this.todoTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        hilog.info(0x0000, '[Debug.TodoTable]', 'Query no results!');
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: TodoItem[] = [];
        for (let i = 0; i < count; ++i) {
          let tmp: TodoItem = {
            id: 0,
            year: 0,
            month: 0,
            day: 0,
            title: '',
            content: '',
            startTime: null,
            endTime: null
          };
          const date: string = resultSet.getString(resultSet.getColumnIndex('date'));

          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.year = Number(date.split(',')[0]);
          tmp.month = Number(date.split(',')[1]);
          tmp.day = Number(date.split(',')[2]);
          tmp.title = resultSet.getString(resultSet.getColumnIndex('title'));
          tmp.content = resultSet.getString(resultSet.getColumnIndex('content'));
          tmp.startTime = new Date(resultSet.getString(resultSet.getColumnIndex('startTime')));
          tmp.endTime = new Date(resultSet.getString(resultSet.getColumnIndex('endTime')));
          result[i] = tmp;
        }
        resultSet.goToNextRow();
      }
    });
  }
}

function generateBucket(todoItem: TodoItem): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.date = todoItem.year.toString() + ',' + todoItem.month.toString() + ',' + todoItem.day.toString();
  obj.title = todoItem.title;
  obj.content = todoItem.content;
  obj.startTime = todoItem.startTime.toLocaleDateString();
  obj.endTime = todoItem.endTime.toLocaleDateString();
  return obj;
}