import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.style.transition = "opacity 0.5s"
      this.element.style.opacity = 0

      // フェードアウトのアニメーションが終わった後に要素を削除
      setTimeout(() => {
        this.element.remove()
      }, 500)
    }, 3000)
  }
}
