loadJSON();

function loadJSON() {
    var data_file = document.getElementById("repo").value;
    var http_request = new XMLHttpRequest();
    try {
        // Opera 8.0+, Firefox, Chrome, Safari
        http_request = new XMLHttpRequest();
    } catch (e) {
        // Internet Explorer Browsers
        try {
            http_request = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                http_request = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {
                // Something went wrong
                alert("Your browser broke!");
                return false;
            }
        }
    }
    http_request.onreadystatechange = function() {
        if (http_request.readyState == 4)
        {
            // Javascript function JSON.parse to parse JSON data
            var jsonObj = JSON.parse(http_request.responseText);
            var results = '';
            var insert = document.getElementById('insert');
            insert.innerHTML = '';
            results = "";
            jsonObj.forEach(function(entry) {
                // Opening row.
                results += "<tr>";
                // Id
                results += "<td><a href='" + entry.html_url + "'>" + entry.number + "</a></td>";
                
                // Milestone
                if (entry.milestone) {
                    results += "<td>" + entry.milestone.title + "</td>";
                } else {
                    results += "<td>None</td>";
                }                
                // Title
                results += "<td>" + entry.title + "</td>";
                // Closing row.
                results += "</tr>";

            });
            insert.innerHTML = results;
            $(function() { 
        // call the tablesorter plugin 
        $("table").tablesorter();
    });

            
        }
    }
    http_request.open("GET", data_file, true);
    http_request.send();
    
}


