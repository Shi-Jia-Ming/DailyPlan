import systemDateTime from '@ohos.systemDateTime';
import router from '@ohos.router';
import { WeekDaysList, Weekday } from '../constant/WeekDaysList';
import { getDayList, DateItem } from '../datalist/CurrentDateList';
import { TodoItem } from '../datalist/TodoItemList';
import TodoTable from '../databaseability/tables/TodoTable';
import hilog from '@ohos.hilog';

// 注册为软件状态
AppStorage.SetAndLink('todoList', []);

@Component
export struct HomeContent {

  numList: Array<number> = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34];

  // 今天的日期
  @State currentDate: DateItem = { year: 2023, month: 11, date: 22, day: 3, type: 'none', todoList: null };

  // 当前选中的日期
  @State @Watch('onSelectedChanged') selectedDate: DateItem = { year: 0, month: 0, date: 0, day: 0, type: 'none', todoList: null  };
  // @Watch 选中的日期更新后重新查找日期对应的代办列表
  onSelectedChanged() {
    this.getCurrentDayTodo();
  }

  @State isShown: boolean = true;

  @State currentDateList: Array<DateItem> = getDayList(this.currentDate);

  @StorageLink('todoList') todoList: TodoItem[] = [];

  @State addPopup: boolean = false;

  firstDay: number = this.currentDateList[0].day;
  lastDay: number = this.currentDateList[this.currentDateList.length - 1].day;

  @StorageLink('todoTable') todoTable: TodoTable = new TodoTable();

  @State @Watch('stackState') state: router.RouterState = router.getState();

  private index: number = -1;

  // @Watch
  stackState() {
    this.index = this.state.index;
    hilog.info(0x0000, '[Debug.HomeContent]', this.index.toString())
    this.getCurrentDayTodo();
  }


  aboutToAppear() {
    this.getCurrentTime();
    this.getCurrentDayTodo();
  }

  onPageShow() {
    this.getCurrentTime();
    this.getCurrentDayTodo();
  }


  getCurrentDayTodo() {
    hilog.info(0x0000, '[Debug.HomeContent]', this.selectedDate.year.toString() + this.selectedDate.month.toString() + this.selectedDate.date.toString())
    this.todoTable.queryByDate(this.selectedDate.year, this.selectedDate.month, this.selectedDate.date, (result: TodoItem[]) => {
      this.todoList = result;
    });
  }

  getCurrentTime() {
    try {
      systemDateTime.getDate().then((date) => {
        // 年
        console.info(`Succeeded in getting year : ${date.getFullYear()}`);
        // 月
        console.info(`Succeeded in getting month : ${date.getMonth() + 1}`);
        // 日
        console.info(`Succeeded in getting date : ${date.getDate()}`);
        // 周
        console.info(`Succeeded in getting day : ${date.getDay()}`);

        // 为 currentDate 赋值
        this.currentDate.year = date.getFullYear();
        this.currentDate.month = date.getMonth() + 1;
        this.currentDate.date = date.getDate();
        this.currentDate.day = date.getDay();

        this.selectedDate = this.currentDate;

      }).catch((error) => {
        console.info(`Failed to get date. message:${error.message}, code:${error.code}`);
      });
    } catch (e) {
      console.info(`Failed to get date. message:${e.message}, code:${e.code}`);
    }
  }

  // 封装 ButtonGroup
  @Builder ButtonGroup() {
    Row() {
      Image($r('app.media.ic_public_add'))
        .width('30vp')
        .onHover(() => {
          this.addPopup = true;
        })
        // TODO
        .bindPopup(this.addPopup, {
          message: 'This is a popup with PopupOptions',
        })
        .onClick(() => {
            router.pushUrl({
              url: 'pages/AddTodoPage' // 目标url
            }, router.RouterMode.Standard, (err) => {
              if (err) {
                console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                return;
              }
              console.info('Invoke pushUrl succeeded.');
            });
        })

      Image(this.isShown ? $r('app.media.ic_public_calendar_filled') : $r('app.media.ic_public_calendar'))
        .width('30vp')
        .onClick(() => {
          animateTo({ duration: 300, curve: Curve.EaseInOut }, () => {
            this.isShown = !this.isShown;
          })
        })

      Image($r('app.media.ic_public_search_filled'))
        .width('30vp')

      Image($r('app.media.ic_public_more'))
        .width('30vp')

    }
    .width('20%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // 封装新增按钮的菜单栏组件
  @Builder addMenu() {
    Menu() {
      MenuItem({ content: '新建代办', labelInfo: 'Ctrl+T'})
    }
    .height('20vp')
    .borderRadius(0)
  }

  // 封装该页面的代办列表
  @Builder todoItem(todoItem: TodoItem) {
    Row() {
      Row() {
        Text(todoItem.title)
          .fontSize(18)
        // 设置最大长度
          .maxLines(1)
        // 设置截断方式
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('80%')
        Blank();
        Checkbox({ name: 'checkbox' })
          .select(false)
          .selectedColor(0x39a2db)
      }
      .width('95%')
    }
    .width('100%')
    .height('140px')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
  }

  // 封装日历中的单条内容
  @Builder dateItem(dateItem: DateItem) {
    Column() {
      Row() {
        Row() {
          Text(dateItem.date.toString())
            .height('100%')
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontColor(dateItem.date == this.selectedDate.date ? dateItem.date == this.currentDate.date ? "#FFFFFF" : "#0A59F7" : dateItem.date == this.currentDate.date ? "#0A59F7" : "#000000")
            .fontSize(20)
            .fontWeight(600)
        }
        .width('55vp')
        .height('55vp')
        .borderRadius(100)
        .borderColor(dateItem.date == this.selectedDate.date ? "#0A59F7" : "#F1F2F3")
        .borderWidth(2)
        .backgroundColor(dateItem.date == this.selectedDate.date && dateItem.date == this.currentDate.date ? "#0A59F7" : "#F1F2F3")
      }
      .height('60%')
      .width('100%')
      .justifyContent(FlexAlign.Center)

      Row() {
        Column({ space: 4 }) {
          Row() {
            Text()
          }
          .backgroundColor("#ff99bbf1")
          .width('100%')
          .height('30px')

          Row() {
            Text()
          }
          .backgroundColor("#ff99bbf1")
          .width('100%')
          .height('30px')
        }
        .width('90%')
        .height('100%')
      }
      .height('40%')
    }
    .justifyContent(FlexAlign.Start)
    .onClick(() => {
      animateTo({ duration: 100, curve: Curve.EaseInOut }, () => {
        this.selectedDate = dateItem;
      })
    })
  }


  build() {
    Column() {
      Row() {
        Text(this.currentDate.year.toString() + "年" + this.currentDate.month.toString() + "月" +this.currentDate.date.toString() + "日")
          .fontSize('30fp')
          .height('100%')

        this.ButtonGroup();
      }
      .width('97%')
      .height('10%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row({ space: 15 }) {
        Column() {
          Row() {
            Grid() {
              ForEach(WeekDaysList, (weekday: Weekday) => {
                GridItem() {
                  Text(weekday.value)
                }
              })
            }
            .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
          }
          .height('5%')

          Row() {
            // 日历视图
            Grid() {
              ForEach(this.numList, (num: number) => {
                GridItem() {
                  if (num < this.firstDay) {
                    Text()
                  } else if (num > this.lastDay) {
                    Text()
                  } else {
                    this.dateItem(this.currentDateList[num - this.firstDay]);
                  }
                }
                .borderStyle(BorderStyle.Solid)
                .borderRadius('0vp')
                .borderWidth('0vp')
              })
            }
            .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
            .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
          }
          .justifyContent(FlexAlign.SpaceEvenly)
          .height('95%')
        }
        .width(this.isShown ? '64%' : '100%')

        if (this.isShown) {
          Column({ space: 15 }) {
            // 每日的代办列表概览
            Row() {
              Text('代办列表')
                .fontSize('20vp')
            }
            .width('100%')

            Row() {
              List({ space: 10 }) {
                ForEach(this.todoList, (todoItem) => {
                  ListItem() {
                    this.todoItem(todoItem);
                  }
                })
              }
              .height('100%')
              .width('95%')
            }
            .width('100%')
          }
          // 定义平移动画
          .transition({ type: TransitionType.Insert, translate: { x: 500, y: 0 }})
          .transition({ type: TransitionType.Delete, opacity: 0, scale: { x: 0, y: 0 } })
          .height('100%')
          .width('35%')
        }
      }
      .justifyContent(FlexAlign.Start)
      .width('100%')
      .height('90%')

    }.height('100%')
    .width('100%')
    .backgroundColor('#F1F3F5')

  }
}