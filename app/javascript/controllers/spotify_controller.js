import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="spotify"
export default class extends Controller {
  static targets = [ 'episode', 'timestamp', 'timestampLabel', 'textArea' ]
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
          const playBackPositionBroadcast = (playbackEvent) => {
            this.timestampTarget.value = playbackEvent.data.position;
            let milliseconds = playbackEvent.data.position;
            let seconds = Math.floor((milliseconds / 1000) % 60);
            let minutes = Math.floor((milliseconds / 1000 / 60) % 60);
            let hours = Math.floor((milliseconds / (1000 * 60 * 60)) % 24);
            hours = (hours < 10) ? "0" + hours : hours;
            minutes = (minutes < 10) ? "0" + minutes : minutes;
            seconds = (seconds < 10) ? "0" + seconds : seconds;
            this.timestampLabelTarget.innerHTML = hours + ":" + minutes + ":" + seconds;
          };

          const removePlaybackListener = () => {
            if (EmbedController._listeners['playback_update'] || EmbedController._listeners['playback_update'].length) {
              EmbedController._listeners['playback_update'] = EmbedController._listeners['playback_update'].filter(storedHandler => playBackPositionBroadcast !== storedHandler);
              };
            };
          const addPlaybackListener = () => {
            EmbedController.addListener('playback_update', playBackPositionBroadcast);
          } 
    
          
          this.textAreaTarget.addEventListener('focus', removePlaybackListener);
          this.textAreaTarget.addEventListener('blur', addPlaybackListener);
          EmbedController.addListener('playback_update', playBackPositionBroadcast);
        };
        IFrameAPI.createController(element, options, callback);
      };
      
    } catch (error) {
      console.error('Error initializing Spotify Embed:', error);
    }
  }
}
