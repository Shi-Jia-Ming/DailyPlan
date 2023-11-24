import { HomeContent } from '../tabcontent/HomeContent';
import TodoTable from '../databaseability/tables/TodoTable';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  aboutToAppear() {
    // TODO AppStorage好像没用
    AppStorage.SetOrCreate('todoTable', new TodoTable(() => {}));
  }

  build() {
    Row() {
      HomeContent();
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}