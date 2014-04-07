<div id="vis"><noscript><img src="parsets.png"></noscript></div>


<script src="d3.min.js"></script>
<script src="d3.parsets.js"></script>
<script src="highlight.min.js"></script>
<style>
@import url(d3.parsets.css);
</style>


<script>
var chart = d3.parsets()
      .dimensions(["Skullcandy","Beats","Monster","Bose","yurbuds"])
      .value(function (d,v) {
                return d.values;
            })
      .height(400);

var vis = d3.select("#vis").append("svg")
    .attr("width", chart.width())
    .attr("height", chart.height());


  Shiny.addCustomMessageHandler("cat_data",
    function(message) {
      //alert(message.data);
      var data = JSON.parse(message.data)
      vis.datum(data).call(chart);
    }
  );

</script>