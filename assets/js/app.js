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

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let Hooks = {
  YMap: {
    mounted() {
      var myMap;
      var sendPoint = (data) => {this.pushEvent('pvz', data)};
      ymaps.ready(init);
      function init () {
      // Создание экземпляра карты и его привязка к контейнеру с
      // заданным id ("map").
      myMap = new ymaps.Map('map', {
        center: [55.76, 37.64], // Москва
        zoom: 6
        }, {
            searchControlProvider: 'yandex#search'
        });
      var objManager = new ymaps.ObjectManager({
        clusterize: true,
        gridSize: 128,
        hasBalloon: false,
        clusterDisableClickZoom: true
      });

        fetch('/assets/data22.json')
          .then(resp => resp.json())
          .then(resp => {
              objManager.objects.options.set({ hasHint: false, hasBalloon: false });
              // objManager.objects.options.set('preset', 'islands#greenDotIcon');
              objManager.add(resp);
              objManager.objects.events.add('click',  (e) => {
                var el = e.get('objectId');
                // var address = objManager.objects.getById(el).properties.balloonContent;
                sendPoint( {id: el, address: 'address' });
              });
              myMap.geoObjects.add(objManager);
              console.log("mounted")
          })
      }
    }
  }
}
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.delayedShow(200))
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


