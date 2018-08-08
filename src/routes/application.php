<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

// Render Twig template in route
$app->get('/', function ($request, $response, $args) {

  return $this->view->render($response, 'index.html', [
  ]);
})->setName('index');

$app->get('/{organization}/{repo}', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);

  $GH_URL = 'https://api.github.com';
  $org = $request->getAttribute('organization');
  $repo = $request->getAttribute('repo');
  $repoURL = $GH_URL.'/repos/'.$org.'/'.$repo;

  // Parameters
  $milestoneID = $request->getQueryParam('milestoneID');
  $milestoneID = (isset($milestoneID)? $milestoneID : "");
  $zenhubActive = $request->getQueryParam('zenhubActive') == "true";
  $state = $request->getQueryParam('state');
  $state = (isset($state)? $state : "open");

  $repoInfo = githubRequest($repoURL);
  $milestones = githubRequest($repoURL.'/milestones');
  $allIssues = array();
  $stopRequest = false;
  $page = 1;
  $perPage = 100;


  // Get all issues from Github
  do {
    $query = $repoURL.'/issues?state='.$state.'&page='.$page.'&per_page='.$perPage;
    if(($milestoneID != "")){
      $query = $query.'&milestone='.$milestoneID;
    }
    $issues = githubRequest($query);
    if(count($issues) < $perPage){
      $stopRequest = true;
    }else{
      $page = $page + 1;
    }
    $allIssues =  array_merge($allIssues, $issues);
  } while ($stopRequest == false);

  // Get Issues information from Zenhub

    $issuesTemp = array();
    foreach ($allIssues as $issue) {
        if($zenhubActive){
          $issue['zenhub'] = zenhubRequest('https://api.zenhub.io/p1/repositories/'.$repoInfo['id'].'/issues/'.$issue['number']);
          }
        $issue['priority'] = getLabelValue($issue['labels'], "Priority");
        $issue['type'] = getLabelValue($issue['labels'], "Type");

        $issuesTemp[] = $issue;
    }
    $allIssues = $issuesTemp;


  return $this->view->render($response, 'repo.html', [
    'repoInfo' => $repoInfo,
    'milestones' => $milestones,
    'issues' => $allIssues,
    'milestoneID' => $milestoneID,
    'pages' => $page,
    'zenhubActive' => $zenhubActive,
    'state' => $state,
    'query' => $query
  ]);
})->setName('repo');


$app->get('/freshdesk', function ($request, $response, $args) {

  $tickets = freshdeskRequest("https://marlo.freshdesk.com/api/v2/tickets");

  return $this->view->render($response, 'freshdesk.html', [
    'tickets' => $tickets,
  ]);
})->setName('freshdesk');


/****************************************************************************/

function getLabelValue($arrayLabels, $string){
  foreach ($arrayLabels as $label) {
    if (strpos($label['name'], $string) !== false) {
      return explode('-',$label['name'])[1] ;
    }
  }
}
// Github REST API
function githubRequest($url){
    global $settings;
    $ch = curl_init();
    // Basic Authentication with token
    // https://developer.github.com/v3/auth/
    // https://github.com/blog/1509-personal-api-tokens
    // https://github.com/settings/tokens
    $access = $settings['github']['username'].':'.$settings['github']['token'];

    curl_setopt($ch, CURLOPT_URL, $url);
    //curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/xml'));
    curl_setopt($ch, CURLOPT_USERAGENT, 'Agent smith');
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_USERPWD, $access);
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
    $output = curl_exec($ch);
    curl_close($ch);
    $result = json_decode(trim($output), true);
    return $result;
}

// ZenHubIO/API REST API
function zenhubRequest($url){
    global $settings;
    $ch = curl_init();
    // Basic Authentication with token
    // https://github.com/ZenHubIO/API
    // curl -H 'X-Authentication-Token: TOKEN' https://api.zenhub.io/p1/repositories/:repo_id/issues/:issue_id
    $access = $settings['zenhub']['token'];

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('X-Authentication-Token: '.$access));
    curl_setopt($ch, CURLOPT_USERAGENT, 'Agent smith');
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_USERPWD, $access);
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
    $output = curl_exec($ch);
    curl_close($ch);
    $result = json_decode(trim($output), true);
    return $result;
}

// Freshdesk REST API
function freshdeskRequest($url){
    global $settings;
    $ch = curl_init();
    // Basic Authentication with token
    // curl -v -u sebas932:IlRyulZofEubvo7 -X GET 'https://marlo.freshdesk.com/api/v2/tickets'
    $access = $settings['freshdesk']['username'].":".$settings['freshdesk']['password'];

    curl_setopt($ch, CURLOPT_URL, $url);
    //curl_setopt($ch, CURLOPT_HTTPHEADER, array('X-Authentication-Token: '.$access));
    curl_setopt($ch, CURLOPT_USERAGENT, 'Agent smith');
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_USERPWD, $access);
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
    $output = curl_exec($ch);
    curl_close($ch);
    $result = json_decode(trim($output), true);
    return $result;
}

?>
