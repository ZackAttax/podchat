import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show"
export default class extends Controller {
  static targets = [ 'episode', 'timeStamp' ]
  static values = { uri: String }

  connect() {

    this.setupTurboStreamListener();
    this.initializeEmbed();
  }

  async initializeEmbed() {
    try {
      window.onSpotifyIframeApiReady = (IFrameAPI) => {
        const element = this.episodeTarget;
        const options = {
          width: '300',
          height: '200',
          uri: this.uriValue
        };
        const callback = (EmbedController) => {
          EmbedController.addListener('playback_update', e => {
            this.timeStampTarget.value = e.data.position
            });
        };
        IFrameAPI.createController(element, options, callback)
        ;
      };
      
    } catch (error) {
      console.error('Error initializing Spotify Embed:', error);
    }
  }

  get embedController() {
    return this.data.get('embedController');
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
