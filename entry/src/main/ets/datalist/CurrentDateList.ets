import List from '@ohos.util.List';
import TodoTable from '../databaseability/tables/TodoTable';
import { TodoItem } from './TodoItemList';

// 日期数据类型，主要用于在日历上显示
export type DateItem = {
  // 基础属性
  year: number;
  month: number;
  date: number;
  day: number;
  type: string;
  // 信息属性
  todoList: List<string>;
};

// 返回本月的 DateItem 列表
export function getDayList(currentDate: DateItem): Array<DateItem> {
  const C: number = Math.floor(currentDate.year / 100);
  let Y: number = currentDate.year % 100;
  let M: number = currentDate.month;
  const D: number = 1;
  // 如果 M 小于2，则 M 加 12， Y 减1
  if (M < 2) {
    M += 12;
    Y -= 1;
  }
  // 根据当前的年月日计算出这个月的1日是星期几
  const firstDay: number = Math.abs(Math.floor(C / 4) - 2 * C + Y + Math.floor(Y / 4) + Math.floor(13 * (M + 1) / 5) + D - 1) % 7;

  let currentDateList = new Array<DateItem>();

  // 判断当月的天数
  let day = 0;
  switch(M) {
    case 1:
    case 3:
    case 5:
    case 7:
    case 8:
    case 10:
    case 12: {
      day = 31;
      break;
    }
    case 4:
    case 6:
    case 9:
    case 11: {
      day = 30;
      break;
    }
    case 2: {
      if ((currentDate.year % 4 == 0 && currentDate.year % 100 != 0) || currentDate.year % 400 == 0) {
        // 闰年
        day = 29;
      } else {
        // 平年
        day = 28;
      }
    }
  }

  for (let i = 0; i < day; ++i) {
    let dateItem = {
      year: currentDate.year,
      month: currentDate.month,
      date: i + 1,
      // day: (firstDay + i) % 7,
      day: firstDay + i,
      type: 'none',
      todoList: null
    };
    // 查询并为 todoList 赋值
    const todoTable: TodoTable = new TodoTable(() => {})
    todoTable.queryByDate(dateItem.year, dateItem.month, dateItem.date, (result: TodoItem[]) => {
      dateItem.todoList = result;
    });
    currentDateList.push(dateItem);
  }

  return currentDateList;
}