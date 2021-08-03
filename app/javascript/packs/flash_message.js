document.addEventListener('DOMContentLoaded', function() {
  var flashMessage = document.getElementById('flash_message');

  if (flashMessage) {
    setTimeout(function() {
      var fadeEffect = setInterval(function() {
        if (!flashMessage.style.opacity) {
            flashMessage.style.opacity = 1;
        }
        if (flashMessage.style.opacity > 0) {
            flashMessage.style.opacity -= 0.1;
        } else {
            clearInterval(fadeEffect);
        }
      }, 50);
    }, 2000);
  }
}, false);
