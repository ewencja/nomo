var intervals = [];

console.log('import snoflakes');

function startMagic(icon, color) {

  function create() {

    var heart = {
      x: Math.random() * 100,
      y: Math.random() * 100,
      speed: Math.random() / 15
    };

    heart.elem = $('<i class="magic-stuff fa fa-' + icon + '-o" style="position: fixed; top: ' + heart.y + '%; left: ' + heart.x + '%; z-index: -1; opacity: 0.2; color: ' + color + '"></i>');
    $('body').append(heart.elem);

    return function() {
      heart.y += heart.speed;
      if (heart.y > 100) {
        heart.y = 0;
      }
      heart.elem.css('top', heart.y + '%');
    }

  }

  for(var i=0; i<50; i++) {
    intervals.push(setInterval(create(), 10));
  }

}

function stopMagic() {
  var i;
  while(!!(i = intervals.pop())) {
    clearInterval(i);
  }
  $('.magic-stuff').remove();
}

(function() {

  this.App || (this.App = {});

  App.magic = App.magic || {
    start: startMagic,
    stop: stopMagic
  };

}).call(this);
