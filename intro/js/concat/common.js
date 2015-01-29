(function() {


}).call(this);

(function() {
  var adjustFontSize, html;

  html = document.querySelector("html");

  adjustFontSize = function() {
    var heightSize, widthSize;
    widthSize = parseInt(window.innerWidth * 0.3);
    heightSize = parseInt(window.innerHeight * 0.4);
    if (heightSize < widthSize) {
      return html.style.fontSize = heightSize + "%";
    } else {
      return html.style.fontSize = widthSize + "%";
    }
  };

  window.addEventListener("resize", adjustFontSize);

  adjustFontSize();

}).call(this);
