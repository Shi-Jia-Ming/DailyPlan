import relationalStore from '@ohos.data.relationalStore';
import hilog from '@ohos.hilog';
import Rdb from '../DatabaseAbility'
import { TodoItem } from '../../datalist/TodoItemList';

// TodoTable表的相关信息
const TODO_TABLE = {
  tableName: 'todoTable',
  sqlCreate: 'CREATE TABLE IF NOT EXISTS todoTable(' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
  'date TEXT,' +
  'title TEXT,' +
  'content TEXT,' +
  'startTime TEXT,' +
  'endTime TEXT)',
  columns: ['id', 'date', 'title', 'content', 'startTime', 'endTime']
};


export default class TodoTable {
  private todoTable = new Rdb(TODO_TABLE.tableName, TODO_TABLE.sqlCreate, TODO_TABLE.columns);

  constructor(callback: Function = () => {}) {
    this.todoTable.getRdbStore(callback);
  }

  // 获取数据库操作变量
  getRdbStore(callback: Function = () => {}) {
    this.todoTable.getRdbStore(callback);
  }

  // 插入数据
  insertData(todoItem: TodoItem, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(todoItem);
    this.todoTable.insertData(valueBucket, callback);
  }

  // 删除数据
  deleteData(todoItem: TodoItem, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(TODO_TABLE.tableName);
    predicates.equalTo('id', todoItem.id);
    this.todoTable.deleteData(predicates, callback);
  }

  // 更新数据
  updateData(todoItem: TodoItem, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(todoItem);
    let predicates = new relationalStore.RdbPredicates(TODO_TABLE.tableName);
    predicates.equalTo('id', todoItem.id);
    this.todoTable.updateData(predicates, valueBucket, callback);
  }

  // 通过日期查找数据
  queryByDate(year: number, month: number, day: number, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(TODO_TABLE.tableName);
    // 将日期转换为特定格式
    const date: string = year.toString()  + ',' + month.toString() + ',' + day.toString();
    predicates.equalTo('date', date);

    // 查询语句
    this.todoTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        // 没有匹配的查询结果
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
          // 从字符串中解析 年
          tmp.year = Number(date.split(',')[0]);
          // 从字符串中解析 月
          tmp.month = Number(date.split(',')[1]);
          // 从字符串中解析 日
          tmp.day = Number(date.split(',')[2]);
          tmp.title = resultSet.getString(resultSet.getColumnIndex('title'));
          tmp.content = resultSet.getString(resultSet.getColumnIndex('content'));
          tmp.startTime = new Date(resultSet.getString(resultSet.getColumnIndex('startTime')));
          tmp.endTime = new Date(resultSet.getString(resultSet.getColumnIndex('endTime')));
          result[i] = tmp;
          resultSet.goToNextRow();
        }
        // 在回调函数中返回结果
        callback(result);
      }
    });
  }
}

// 从 TodoItem 数据类型中产生数据库查询条件
function generateBucket(todoItem: TodoItem): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.date = todoItem.year.toString() + ',' + todoItem.month.toString() + ',' + todoItem.day.toString();
  obj.title = todoItem.title;
  obj.content = todoItem.content;
  obj.startTime = todoItem.startTime.toLocaleTimeString();
  obj.endTime = todoItem.endTime.toLocaleTimeString();
  return obj;
}