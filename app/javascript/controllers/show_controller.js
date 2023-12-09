import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show"
export default class extends Controller {
  static targets = [ 'episode', 'timeStamp' ]
  static values = { uri: String }
  connect() {
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

  episodeClick(event) {
    const spotifyId = event.currentTarget.dataset.spotifyId;
    this.embedController.loadUri(spotifyId);
  }

  get embedController() {
    return this.data.get('embedController');
  }
}
