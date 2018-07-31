var issuesList;
$(document).ready( function () {

  setDatatable();


});


function setDatatable(){
  issuesList = $('#issuesList').DataTable({
    "pageLength": 100
  });
}
