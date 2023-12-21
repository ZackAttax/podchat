import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    this.setupTurboStreamListener();
  }

  setupTurboStreamListener() {
    document.addEventListener("turbo:before-stream-render", (event) => {
      const fallbackToDefaultActions = event.detail.render
      const targetId = event.detail.newStream.target
      const targetElement = document.getElementById(targetId)
      event.detail.render = (streamElement) => {
          if (targetElement && targetElement.tagName === 'LI') {
          event.preventDefault()
          const templateContent = streamElement.innerHTML;
          const parser = new DOMParser();
          const doc = parser.parseFromString(templateContent, 'text/html');
          const newTemplateContent = doc.querySelector('template').content;
          const clone = newTemplateContent.cloneNode(true);
          targetElement.parentElement.insertBefore(clone, targetElement.nextSibling)
        } else {
          fallbackToDefaultActions(streamElement)
        }
      }
    })
  }
}
