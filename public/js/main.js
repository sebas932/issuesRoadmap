var issuesList;
$(document).ready( function () {

  setDatatable();

  // Materialize select
  $('select').formSelect();


  // Charts.js
  setChart('0', 'doughnut', true);
  setChart('1', 'doughnut', true);
  setChart('2', 'horizontalBar', false);
  setChart('3', 'horizontalBar', false);

});


function setDatatable(){
  issuesList = $('#issuesList').DataTable({
    "pageLength": 100,
    paging: false
  });
}


function setChart(id, chartType, displayLegend){
  var chartData = JSON.parse($('.chartData-'+ id).text());
  var chart = new Chart(document.getElementById('chartCanvas-'+ id).getContext('2d'), {
      type: chartType,
      data:  {
          datasets: [{
              data: $.map(chartData, function(value,label) {return value}),
              backgroundColor: $.map(chartData, function(value,label) {return getColorRandom()})
          }],
          labels: $.map(chartData, function(value,label) {return label})
      },
      options: {
        legend: {
           display: displayLegend,
           position: "left",
           labels: {
             boxWidth: 8,
           }
        }
      }
  });
}

function getColorRandom(){
  return '#'+(Math.random()*0xFFFFFF<<0).toString(16);
}
