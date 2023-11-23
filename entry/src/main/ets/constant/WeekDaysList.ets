export type Weekday = {
  index: number;
  value: Resource
};

export const WeekDaysList: Array<Weekday> = [
  {
    index: 0,
    value: $r('app.string.SUNDAY')
  },
  {
    index: 1,
    value: $r('app.string.MONDAY')
  },
  {
    index: 2,
    value: $r('app.string.TUESDAY')
  },
  {
    index: 3,
    value: $r('app.string.WEDNESDAY')
  },
  {
    index: 4,
    value: $r('app.string.THURSDAY')
  },
  {
    index: 5,
    value: $r('app.string.FRIDAY')
  },
  {
    index: 6,
    value: $r('app.string.SATURDAY')
  }
]