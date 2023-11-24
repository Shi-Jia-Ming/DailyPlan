import TodoTable from './tables/TodoTable';
import { DateItem } from './CurrentDateList';


export type CommonTime = {
  year: number;
  month: number;
  day: number;
  hour: number;
  minute: number;
}


export type TodoItem = {
  id: number;
  year: number;
  month: number;
  day: number;
  title: string;
  content: string;
  startTime: Date;
  endTime: Date;
}

export function dateToCommonTime(date: Date): CommonTime {
  const commonTime = {
    year: date.getFullYear(),
    month: date.getMonth() + 1,
    day: date.getDate(),
    hour: date.getHours(),
    minute: date.getMinutes()
  }

  return commonTime;
}

export function commonTimeToDate(commonTime: CommonTime): Date {
  const date: Date = new Date(commonTime.year, commonTime.month, commonTime.day, commonTime.hour, commonTime.minute);
  return date;
}

// 通过 DateItem 查找对应的 TodoItem
export function getTodoItemByDate(dateItem: DateItem): TodoItem[] {
  let todoList: TodoItem[];
  const todoTable: TodoTable = new TodoTable(() => {});
  todoTable.queryByDate(dateItem.year, dateItem.month, dateItem.date, (result: TodoItem[]) => {
    todoList = result;
  }, true);

  return todoList;
}