// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
// import {hooks as colocatedHooks} from "phoenix-colocated/aliasx"
import topbar from "../vendor/topbar"

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

const Hooks = {
  NicknameForm: {
    mounted() {
      // Load saved nickname from localStorage per session
      const sessionKey = `aliasx_nickname_${window.location.pathname}`
      const savedNickname = localStorage.getItem(sessionKey)
      if (savedNickname) {
        const input = this.el.querySelector('#nickname-input')
        if (input) {
          input.value = savedNickname
        }
      }
    },
    
    updated() {
      // Also load on updates
      const sessionKey = `aliasx_nickname_${window.location.pathname}`
      const savedNickname = localStorage.getItem(sessionKey)
      if (savedNickname) {
        const input = this.el.querySelector('#nickname-input')
        if (input && !input.value) {
          input.value = savedNickname
        }
      }
    }
  },

  SettingsLoader: {
    mounted() {
      // Mark that settings have been loaded to prevent duplicate loads
      if (!this.el.dataset.settingsLoaded) {
        this.el.dataset.settingsLoaded = 'true'
        
        // Use a small delay to ensure initial render is complete
        setTimeout(() => {
          // Load saved settings from localStorage and send to LiveView
          const savedLanguage = localStorage.getItem('aliasx_language') || 'en'
          const savedDifficulty = localStorage.getItem('aliasx_difficulty') || 'medium'
          const savedTargetScore = localStorage.getItem('aliasx_target_score') || '30'
          
          // Send settings to LiveView
          this.pushEvent('restore_saved_settings', {
            language: savedLanguage,
            difficulty: savedDifficulty,
            target_score: savedTargetScore
          })
        }, 100)
      }
    }
  },

  UserDataLoader: {
    mounted() {
      // Handle loading saved user data for game sessions
      const nicknameKey = `aliasx_nickname_${window.location.pathname}`
      const savedNickname = localStorage.getItem(nicknameKey)
      const userKey = `aliasx_user_${window.location.pathname}`
      const savedUserId = localStorage.getItem(userKey)
      
      console.log('UserDataLoader mounted:', { savedUserId, savedNickname, nicknameKey, userKey })
      
      if (savedUserId || savedNickname) {
        console.log('UserDataLoader: Sending restore_session event')
        // Send to LiveView
        this.pushEvent('restore_session', {
          user_id: savedUserId || '',
          nickname: savedNickname || ''
        })
      } else {
        console.log('UserDataLoader: No saved data found')
      }
    }
  }
}

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks,
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// Handle save nickname event
window.addEventListener("phx:save-nickname", (e) => {
  if (e.detail.nickname) {
    const sessionKey = `aliasx_nickname_${window.location.pathname}`
    localStorage.setItem(sessionKey, e.detail.nickname)
  }
})

// Handle save user ID event
window.addEventListener("phx:save-user-id", (e) => {
  if (e.detail.user_id) {
    const sessionKey = `aliasx_user_${window.location.pathname}`
    localStorage.setItem(sessionKey, e.detail.user_id)
  }
})

// Handle save language preference
window.addEventListener("phx:save-language", (e) => {
  if (e.detail.language) {
    localStorage.setItem('aliasx_language', e.detail.language)
  }
})

// Handle save difficulty preference
window.addEventListener("phx:save-difficulty", (e) => {
  if (e.detail.difficulty) {
    localStorage.setItem('aliasx_difficulty', e.detail.difficulty)
  }
})

// Handle save target score preference
window.addEventListener("phx:save-target-score", (e) => {
  if (e.detail.target_score) {
    localStorage.setItem('aliasx_target_score', e.detail.target_score)
  }
})

// Handle save game settings (difficulty and target score)
window.addEventListener("phx:save-game-settings", (e) => {
  if (e.detail.difficulty) {
    localStorage.setItem('aliasx_difficulty', e.detail.difficulty)
  }
  if (e.detail.target_score) {
    localStorage.setItem('aliasx_target_score', e.detail.target_score)
  }
})

// Handle copy game URL to clipboard
window.addEventListener("phx:copy-game-url", (e) => {
  if (e.detail.url) {
    const fullUrl = window.location.origin + e.detail.url
    const message = e.detail.message || 'Game URL copied to clipboard!'
    
    // Copy to clipboard
    navigator.clipboard.writeText(fullUrl).then(() => {
      // Show success flash message
      showFlashMessage('success', message)
    }).catch(() => {
      // Fallback for older browsers
      const textArea = document.createElement('textarea')
      textArea.value = fullUrl
      document.body.appendChild(textArea)
      textArea.select()
      document.execCommand('copy')
      document.body.removeChild(textArea)
      
      showFlashMessage('success', message)
    })
  }
})

// Function to show flash messages
function showFlashMessage(type, message) {
  // Create flash message element
  const flashDiv = document.createElement('div')
  flashDiv.className = `alert alert-${type} shadow-lg fixed top-4 right-4 z-50 max-w-sm`
  
  // Different icons for different message types
  let iconSvg = ''
  if (type === 'success') {
    iconSvg = `<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="stroke-current shrink-0 w-6 h-6">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
      </svg>`
  } else {
    iconSvg = `<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="stroke-current shrink-0 w-6 h-6">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
      </svg>`
  }
  
  flashDiv.innerHTML = `
    <div>
      ${iconSvg}
      <span>${message}</span>
    </div>
  `
  
  // Add to page
  document.body.appendChild(flashDiv)
  
  // Animate in
  flashDiv.style.opacity = '0'
  flashDiv.style.transform = 'translateX(100%)'
  setTimeout(() => {
    flashDiv.style.transition = 'all 0.3s ease-out'
    flashDiv.style.opacity = '1'
    flashDiv.style.transform = 'translateX(0)'
  }, 10)
  
  // Remove after 3 seconds
  setTimeout(() => {
    flashDiv.style.opacity = '0'
    flashDiv.style.transform = 'translateX(100%)'
    setTimeout(() => {
      if (flashDiv.parentNode) {
        document.body.removeChild(flashDiv)
      }
    }, 300)
  }, 3000)
}

// Handle copy share link to clipboard  
window.addEventListener("phx:copy-share-link", (e) => {
  if (e.detail.url) {
    const fullUrl = window.location.origin + e.detail.url
    const message = e.detail.message || 'Game URL copied to clipboard!'
    
    // Copy to clipboard
    navigator.clipboard.writeText(fullUrl).then(() => {
      // Show success flash message
      showFlashMessage('success', message)
    }).catch(() => {
      // Fallback for older browsers
      const textArea = document.createElement('textarea')
      textArea.value = fullUrl
      document.body.appendChild(textArea)
      textArea.select()
      document.execCommand('copy')
      document.body.removeChild(textArea)
      
      showFlashMessage('success', message)
    })
  }
})

// Update share link display with full URL on page load
document.addEventListener("DOMContentLoaded", () => {
  const shareUrlText = document.getElementById('share-url-text')
  if (shareUrlText) {
    // Show full URL instead of just the path
    const currentPath = window.location.pathname
    const fullUrl = window.location.origin + currentPath
    shareUrlText.textContent = fullUrl
  }
})

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// The lines below enable quality of life phoenix_live_reload
// development features:
//
//     1. stream server logs to the browser console
//     2. click on elements to jump to their definitions in your code editor
//
if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    // Enable server log streaming to client.
    // Disable with reloader.disableServerLogs()
    reloader.enableServerLogs()

    // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
    //
    //   * click with "c" key pressed to open at caller location
    //   * click with "d" key pressed to open at function component definition location
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", e => keyDown = null)
    window.addEventListener("click", e => {
      if(keyDown === "c"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if(keyDown === "d"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}

