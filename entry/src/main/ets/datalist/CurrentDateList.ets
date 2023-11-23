import List from '@ohos.util.List';


export type DateItem = {
  // 基础属性
  year: number;
  month: number;
  date: number;
  day: number;
  type: string;
  // 状态属性
  isSelected: boolean;
  isToday: boolean;
  // 信息属性
  todoList: List<string>;
};

// 根据当前的年月日计算出这个月的1日是星期几

export function getDayList(currentDate: DateItem, selectedDate: DateItem): Array<DateItem> {
  const C: number = Math.floor(currentDate.year / 100);
  let Y: number = currentDate.year % 100;
  let M: number = currentDate.month;
  const D: number = 1;
  // 如果 M 小于2，则 M 加 12， Y 减1
  if (M < 2) {
    M += 12;
    Y -= 1;
  }
  // 根据当前日期计算星期几的公式
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
    currentDateList.push({
      year: currentDate.year,
      month: currentDate.month,
      date: i + 1,
      // day: (firstDay + i) % 7,
      day: firstDay + i,
      type: 'none',
      isSelected: i + 1 == selectedDate.date,
      isToday: i + 1 == currentDate.date,
      // TODO todoList的获取
      todoList: null
    })
  }

  return currentDateList;
}