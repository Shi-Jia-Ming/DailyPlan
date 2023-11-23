import { HomeContent } from '../tabcontent/HomeContent';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      HomeContent();
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}