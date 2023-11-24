import TodoTable from '../databaseability/tables/TodoTable';
import { DateItem } from './CurrentDateList';

// 代办数据类型
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
