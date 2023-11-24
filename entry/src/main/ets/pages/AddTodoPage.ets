import router from '@ohos.router'
import hilog from '@ohos.hilog';
import TodoTable from '../databaseability/tables/TodoTable';
import { TodoItem } from '../datalist/TodoItemList';


@Entry
@Preview
@Component
// 新增todo的页面
struct AddTodoPage {

  // TODO 时间同步
  selectedStartTime: Date = new Date();
  selectedEndTime: Date = new Date();

  @State title: string = '';
  @State content: string = '';

  controller: TextInputController = new TextInputController();

  @StorageLink('todoTable') todoTable: TodoTable = new TodoTable();

  @StorageLink('todoList') todoList: TodoItem[] = [];


  // TODO 参数类型
  @Builder InputItem(img: Resource, placeholder: Resource | string, $$: { text: string }) {
    Row({ space: 15 }) {
      Image(img)
        .width('40vp')
      Column() {
        TextInput({ placeholder: placeholder, controller: this.controller })
          .height('55vp')
          .backgroundColor("#F1F2F3")
          .onChange((value) => {
            $$.text = value;
            hilog.info(0x0000, '[Debug.AddTodoPage]', $$.text)
          })
        Divider()
      }
      .width('90%')

    }
    .backgroundColor("#F1F2F3")
    .justifyContent(FlexAlign.Start)
    .height('60vp')
    .width('100%')
    .margin({"top":"20.00vp","right":"0.00vp","bottom":"10.00vp","left":"0.00vp"})
  }

  // @Builder TimePicker(img: Resource, text: Resource | string, $$: { selectedTime: Date }) {
  //   Row({ space: 15 }) {
  //     // 图标
  //     Image(img)
  //       .width('40vp')
  //     Column() {
  //       // 要显示的提示文本
  //       Row() {
  //         Text(text)
  //           .height('55vp')
  //           .backgroundColor("#F1F2F3")
  //           .margin({"top":"0.00vp","right":"0.00vp","bottom":"0.00vp","left":"17.00vp"})
  //
  //         Row() {
  //           // 显示当前选择的时间
  //           Text($$.selectedTime.getFullYear().toString() + "." + ($$.selectedTime.getMonth() + 1).toString() + "." + $$.selectedTime.getDate().toString()
  //           + "  " + $$.selectedTime.getHours().toString() + ":" + $$.selectedTime.getMinutes())
  //             .height('55vp')
  //             .backgroundColor("#F1F2F3")
  //             .margin({"top":"0.00vp","right":"10.00vp","bottom":"0.00vp","left":"0.00vp"})
  //
  //           Image($r('app.media.ic_public_arrow_right'))
  //             .width('27vp')
  //         }
  //
  //
  //       }
  //       .justifyContent(FlexAlign.SpaceBetween)
  //       .width('100%')
  //
  //       Divider()
  //     }
  //     .width('550vp')
  //   }
  //   .backgroundColor("#F1F2F3")
  //   .justifyContent(FlexAlign.Start)
  //   .height('60vp')
  //   .width('100%')
  //   .margin({"top":"20.00vp","right":"0.00vp","bottom":"10.00vp","left":"0.00vp"})
  //   .onClick(() => {
  //     TimePickerDialog.show({
  //       selected: $$.selectedTime,
  //       useMilitaryTime: true,
  //       onAccept: (value: TimePickerResult) => {
  //         $$.selectedTime.setHours(value.hour, value.minute);
  //         hilog.info(0x0000, '[Debug.AddTodoPage]', $$.selectedTime.toString());
  //       }
  //     })
  //   })
  // }

  @Builder TimePicker(img: Resource, text: Resource | string,  selectedTime: Date, callback: Function = () => {}) {
    Row({ space: 15 }) {
      // 图标
      Image(img)
        .width('40vp')
      Column() {
        // 要显示的提示文本
        Row() {
          Text(text)
            .height('55vp')
            .backgroundColor("#F1F2F3")
            .margin({"top":"0.00vp","right":"0.00vp","bottom":"0.00vp","left":"17.00vp"})

          Row() {
            // 显示当前选择的时间
            Text(selectedTime.getFullYear().toString() + "年" + (selectedTime.getMonth() + 1).toString() + "月" + selectedTime.getDate().toString()
            + "日  " + selectedTime.getHours().toString() + ":" + selectedTime.getMinutes())
              .height('55vp')
              .backgroundColor("#F1F2F3")
              .margin({"top":"0.00vp","right":"10.00vp","bottom":"0.00vp","left":"0.00vp"})

            Image($r('app.media.ic_public_arrow_right'))
              .width('27vp')
          }


        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')

        Divider()
      }
      .width('90%')
    }
    .backgroundColor("#F1F2F3")
    .justifyContent(FlexAlign.Start)
    .height('60vp')
    .width('100%')
    .margin({"top":"20.00vp","right":"0.00vp","bottom":"10.00vp","left":"0.00vp"})
    .onClick(() => {
      TimePickerDialog.show({
        selected: selectedTime,
        useMilitaryTime: true,
        onAccept: (value: TimePickerResult) => {
          selectedTime.setHours(value.hour, value.minute);
          callback(value);
        }
      })
    })
  }

  build() {
    Column() {
      Row({ space: 20 }) {
        Image($r('app.media.ic_public_back'))
          .width('37vp')
          .height('35vp')
          .margin({"top":"0.00vp","right":"0.00vp","bottom":"0.00vp","left":"15.00vp"})
          .onClick(() => {
            router.back({
              url: "pages/Index",
              params: false
            })
          })

        Text('新建任务')
          .height('100%')
          .fontSize(26)
      }
      .width('100%')
      .height('70vp')

      Row() {
        // 代办题目
        Column() {
          Column() {
            // this.InputItem($r('app.media.ic_gallery_search_title'), '任务标题', { text: this.title })
            Row({ space: 15 }) {
              Image($r('app.media.ic_gallery_search_title'))
                .width('40vp')
              Column() {
                TextInput({ placeholder: '任务标题', controller: this.controller })
                  .height('55vp')
                  .backgroundColor("#F1F2F3")
                  .onChange((value) => {
                    this.title = value;
                  })
                Divider()
              }
              .width('90%')

            }
            .backgroundColor("#F1F2F3")
            .justifyContent(FlexAlign.Start)
            .height('60vp')
            .width('100%')
            .margin({"top":"20.00vp","right":"0.00vp","bottom":"10.00vp","left":"0.00vp"})

            this.TimePicker($r('app.media.ic_public_time'), "开始时间", this.selectedStartTime)
            this.TimePicker(null, "结束时间", this.selectedEndTime)

            // this.InputItem($r('app.media.ic_public_notes'), '任务详情', { text: this.content })
            Row({ space: 15 }) {
              Image($r('app.media.ic_public_notes'))
                .width('40vp')
              Column() {
                TextInput({ placeholder: '任务详情', controller: this.controller })
                  .height('55vp')
                  .backgroundColor("#F1F2F3")
                  .onChange((value) => {
                    this.content = value;
                  })
                Divider()
              }
              .width('90%')

            }
            .backgroundColor("#F1F2F3")
            .justifyContent(FlexAlign.Start)
            .height('60vp')
            .width('100%')
            .margin({"top":"20.00vp","right":"0.00vp","bottom":"10.00vp","left":"0.00vp"})
          }
          .width('90%')

          Button("确定")
            .margin({"top":"0.00vp","right":"0.00vp","bottom":"40.00vp","left":"0.00vp"})
            .width('40%')
            .onClick(() => {
              let todoItem: TodoItem = {
                id: 0,
                year: this.selectedStartTime.getFullYear(),
                month: this.selectedStartTime.getMonth() + 1,
                day: this.selectedStartTime.getDate(),
                title: this.title,
                content: this.content,
                startTime: this.selectedStartTime,
                endTime: this.selectedEndTime
              }
              this.todoList.push(todoItem);
              this.todoTable.insertData(todoItem, () => {});
              this.title = '';
              this.content = '';
              router.back({
                url: "pages/Index",
                params: true
              })
            })

        }
        .backgroundColor("#F1F2F3")
        .width('65%')
        .height('80%')
        .borderRadius(30)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
  }

  pageTransition() {
    // 定义页面进入时的效果，从右侧滑入，时长为1000ms，页面栈发生push操作时该效果才生效
    PageTransitionEnter({ type: RouteType.Push, duration: 200 })
      .slide(SlideEffect.Right)
    // 定义页面进入时的效果，从左侧滑入，时长为1000ms，页面栈发生pop操作时该效果才生效
    PageTransitionEnter({ type: RouteType.Pop, duration: 200 })
      .slide(SlideEffect.Left)
    // 定义页面退出时的效果，向左侧滑出，时长为1000ms，页面栈发生push操作时该效果才生效
    PageTransitionExit({ type: RouteType.Push, duration: 200 })
      .slide(SlideEffect.Left)
    // 定义页面退出时的效果，向右侧滑出，时长为1000ms，页面栈发生pop操作时该效果才生效
    PageTransitionExit({ type: RouteType.Pop, duration: 200 })
      .slide(SlideEffect.Right)
  }
}