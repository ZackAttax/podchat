import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="spotify"
export default class extends Controller {
  connect() {
      this.renderSpotifySDK();
  }
  renderSpotifySDK() {
    // Create the main container div
    const container = document.createElement('div');

    // Set the HTML content
    container.innerHTML = `
      <h1>Spotify Web Playback SDK Quick Start</h1>
      <button data-action="click->spotify#togglePlay">Toggle Play</button>
    `;

    // Create the script element for the Spotify SDK
    const spotifyScript = document.createElement('script');
    spotifyScript.src = 'https://sdk.scdn.co/spotify-player.js';

    // Create the script element for the inline JavaScript
    const inlineScript = document.createElement('script');
    inlineScript.innerHTML = `
      window.onSpotifyWebPlaybackSDKReady = () => {
          const token = 'BQBRjjIU60MyNvdA1Dj_F2zOWi9dnUGbFjIznK6yLg2bXb3T0ieHvAklhrpkMkj62uyZM-KyC-YjsdcMzw4I-n0AN-NmgNO19FyLjBhljpdPpfJJggvVGCCkXnqPdGxSdwGUbJKS5EdDfzb5diAUvHJggaHj_A34EbDYSRYfYkwpnyTPAT4hBzvL7hITDVncTZTC';
          const player = new Spotify.Player({
              name: 'Web Playback SDK Quick Start Player',
              getOAuthToken: cb => { cb(token); },
              volume: 0.5
          });

          // ... (the rest of your Spotify SDK logic)
      }
    `;

    // Append the created elements to the element associated with this controller
    this.element.appendChild(container);
    this.element.appendChild(spotifyScript);
    this.element.appendChild(inlineScript);
  }

  togglePlay() {
    // Handle the toggle play logic here
  }
}
