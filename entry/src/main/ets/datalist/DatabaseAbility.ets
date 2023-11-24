
import relationalStore from '@ohos.data.relationalStore'
import hilog from '@ohos.hilog';


export default class Rdb {
  private rdbStore: relationalStore.RdbStore | null = null;

  private tableName: string;

  private sqlCreateTable: string;

  private columns: Array<string>;

  constructor(tableName: string, sqlCreateTable: string, columns: Array<string>) {
    this.tableName = tableName;
    this.sqlCreateTable = sqlCreateTable;
    this.columns = columns;
  }

  getRdbStore(callback: Function = () => {}) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      hilog.info(0x0000, '[Debug.Rdb]', 'getRdbStore() has no callback!');
      return;
    } else if (this.rdbStore !== null) {
      hilog.info(0x0000, '[Debug.Rdb]', 'The rdbStore already exists');
      callback();
      return;
    } else {
      let context: Context = getContext(this) as Context;

      const STORE_CONFIG: relationalStore.StoreConfig = {
        name: 'RdbMain.db',
        securityLevel: relationalStore.SecurityLevel.S1
      };

      relationalStore.getRdbStore(context, STORE_CONFIG, (err, rdb) => {
        if (err) {
          hilog.info(0x0000, '[Debug.Rdb]', `create rdbStore failed, err: ${err}`);
          return;
        } else {
          this.rdbStore = rdb;
          this.rdbStore.executeSql(this.sqlCreateTable);
          hilog.info(0x0000, '[Debug.Rdb]', 'create rdbStore finished.');
          callback();
        }
      })
    }
  }

  // 添加数据
  insertData(data: relationalStore.ValuesBucket, callback: Function = () => {}) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      hilog.info(0x0000, '[Debug.Rdb]', 'insertData() has no callback!');
      return;
    }
    let resFlag: boolean = false;
    const valueBucket: relationalStore.ValuesBucket = data;
    if (this.rdbStore) {
      this.rdbStore.insert(this.tableName, valueBucket, (err, ret) => {
        if (err) {
          hilog.info(0x0000, '[Debug.Rdb]', `insertData() failed, err: ${JSON.stringify(err)}`);

          callback(resFlag);
          return;
        }
        hilog.info(0x0000, '[Debug.Rdb]', `insertData() finished: ${ret}`);

        callback(ret);
      });
    }
  }

  // 删除数据
  deleteData(predicates: relationalStore.RdbPredicates, callback: Function = () => {}) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      hilog.info(0x0000, '[Debug.Rdb]', 'deleteData() has no callback!');
      return;
    }
    let resFlag: boolean = false;
    if (this.rdbStore) {
      this.rdbStore.delete(predicates, (err, ret) => {
        if (err) {
          hilog.info(0x0000, '[Debug.Rdb]', `deleteData() failed, err: ${err}`);
          callback(resFlag);
          return;
        }
        hilog.info(0x0000, '[Debug.Rdb]', `deleteData() finished: ${ret}`);
        callback(!resFlag);
      });
    }
  }

  // 更新数据
  updateData(predicates: relationalStore.RdbPredicates, data: relationalStore.ValuesBucket, callback: Function = () => {}) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      hilog.info(0x0000, '[Debug.Rdb]', 'updateDate() has no callback!');
      return;
    }
    let resFlag: boolean = false;
    const valueBucket: relationalStore.ValuesBucket = data;
    if (this.rdbStore) {
      this.rdbStore.update(valueBucket, predicates, (err, ret) => {
        if (err) {
          hilog.info(0x0000, '[Debug.Rdb]', `updateData failed, err: ${err}`);
          callback(resFlag);
          return;
        }
        hilog.info(0x0000, '[Debug.Rdb]', `updateData() finished: ${ret}`);
        callback(!resFlag);
      });
    }
  }

  // 查询数据
  query(predicates: relationalStore.RdbPredicates, callback: Function = () => {}) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      hilog.info(0x0000, '[Debug.Rdb]', 'query() has no callback!');
      return;
    } else if (this.rdbStore) {
      this.rdbStore.query(predicates, this.columns, (err, resultSet) => {
        if (err) {
          hilog.info(0x0000, '[Debug.Rdb]', `query() failed, err: ${err}`);
          return;
        }
        hilog.info(0x0000, '[Debug.Rdb]', 'query() finished');
        callback(resultSet);
        resultSet.close();
      });
    }
  }
}