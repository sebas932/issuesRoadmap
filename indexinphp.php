<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Issues GitGub</title>
        <link rel="stylesheet" href="http://yui.yahooapis.com/pure/0.3.0/pure-min.css">
    </head>
    <body>
        <table class="pure-table pure-table-bordered" id="List">
            <thead>
             <tr id="insert">
                    <td>ID</td>
                    <td>Issue</td>
                    <td>Milestone</td>
                </tr>
                </thead>
                <tbody>
        <?php
 $url = file_get_contents("https://api.github.com/repos/CCAFS/AMKN/issues?per_page=100");

 $arr = json_decode($url,true);
 
 foreach($arr as $item) {
   echo '<tr>';        
   echo '<td>'.$item['number'].'</td>';
   echo '<td>'.$item['title'].'</td>'; 
   echo '<td>'.$item['milestone']['title'].'</td>';
   echo '</tr>';   
 }
?>
                    </tbody>
                </table> 
    </body>
</html>
