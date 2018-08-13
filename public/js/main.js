var issuesList;
var RED = "#e74c3c";
var GREEN = "#27ae60";
var YELLOW = "#f1c40f";
var BLUE = "#3498db";
var GRAY = "#bdc3c7";

var colorMap ={
  "closed": GREEN,
  "open": RED,
  "new issues": RED,
  "bug": RED,
  "in progress": YELLOW,
  "review/qa": BLUE,
  "low": GRAY,
  "high": RED,
  "medium": YELLOW,
  "task": GRAY,
  "enhancement": GREEN
}

$(document).ready( function () {

  setDatatable();

  // Materialize select
  $('select').formSelect();


  // Charts.js
  // State
  setChart('0', 'doughnut', true);
  // Type
  setChart('1', 'doughnut', true);
  // Priority
  setChart('2', 'bar', false);
  // Responsible
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
              backgroundColor: $.map(chartData, function(value,label) {return getColor(label)})
          }],
          labels: $.map(chartData, function(value,label) {return label})
      },
      options: {
        //responsive: false,
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

function getColor(label){
  var string = $.trim(label).toLowerCase();
  return colorMap[string] || '#'+(Math.random()*0xFFFFFF<<0).toString(16);
}
