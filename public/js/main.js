var issuesList;
$(document).ready( function () {

  setDatatable();

  $(document).ready(function(){
    $('select').formSelect();
  });


});


function setDatatable(){
  issuesList = $('#issuesList').DataTable({
    "pageLength": 100,
    paging: false
  });
}
