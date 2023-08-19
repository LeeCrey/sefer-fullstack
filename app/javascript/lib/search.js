// navigate back if it's not in mobile phone or user resized
// if you wanna implement search function like instagram in larger devise you are welcome.
// comment out the bellow codes or delete this file and disconnect from search.html.erb

const body = document.body;

var observer = null;

function callBack() {
  if (body.clientWidth > 600) {
    disconnectObserver();
    history.back()
  }
}

observer = new ResizeObserver(callBack);

if ("ResizeObserver" in window) {
  observer.observe(body)
}

function disconnectObserver() {
  observer.disconnect()
}
