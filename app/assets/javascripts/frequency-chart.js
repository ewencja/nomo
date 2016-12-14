function chart(name, elementRef) {

  var chartOptions = {
    axisX: {
      scaleMinSpace: 200
    }
  }

  function showChart(points) {
    window.points = points;
    var data = {
      labels: points.map(function(point) {
        return point.year
      }),
      series: [
        {
          data: points.map(function(point) {
            return point.frequency
          })
        }
      ]
    };
    new Chartist.Line(elementRef, data, chartOptions)
  }

  $.get({
    url: '/frequency/' + name,
    success: showChart
  });

}

(function() {

  this.App || (this.App = {});

  App.frequencies = {
    chart: chart
  }

}).call(this);
