function chart(name, elementRef) {

  let chartOptions = {
    axisX: {
      scaleMinSpace: 200
    }
  }

  function showChart(points) {
    window.points = points;
    var data = {
      labels: points.map(point => point.year),
      series: [
        {
          data: points.map(point => point.frequency)
        }
      ]
    };
    new Chartist.Line(elementRef, data, chartOptions)
  }

  $.get({
    url: `/frequency/${name}`,
    success: showChart
  });

}

(function() {

  this.App || (this.App = {});

  App.frequencies = {
    chart: chart
  }

}).call(this);
