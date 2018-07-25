var issuesList;
$(document).ready( function () {


  setDatatable();

  $('.refreshData').on('click', refreshData);

});

function refreshData(){
  issuesList.ajax.reload();
}

function setDatatable(){
  issuesList = $('#issuesList').DataTable( {
      ajax: {
        url: $('#repo').val(),
        "dataSrc": ""
      },
      "pageLength": 100,
      columns: [
        { data: 'milestone.title',
          render: function(data,type,full,meta) {
            return data || '<i>None<i>';
          }
        },
        { data: 'number' },
        { data: 'title' },
        { data: 'assignee.login',
          render: function(data,type,full,meta) {
            return data || '<i>None<i>';
          }
        },
        { data: 'state' }

      ]
  });
}
