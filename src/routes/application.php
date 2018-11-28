<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

/******************************************************************************
*******************************    HOME   *************************************
******************************************************************************/
$app->get('/', function ($request, $response, $args) {
  $GH_URL = 'https://api.github.com';
  //milestoneID=37&zenhubActive=true&state=all


  $org = 'CCAFS';
  $repo = 'MARLO';
  $repoURL = $GH_URL.'/repos/'.$org.'/'.$repo;

  $sprints = githubRequest($repoURL.'/milestones?state=all&per_page=100&direction=desc');


  $sprintsTemp = array();
  foreach ($sprints as $s) {
    $query = $repoURL.'/milestones/'.$s['number'];
    $s['github'] = githubRequest($query);
    $s['report_url'] = './'.$org.'/'.$repo.'?milestoneID='.$s['number'].'&zenhubActive=true&state=all&hideFilters=true';
    $sprintsTemp[$s['state']][]= $s;
  }

  //print_r($sprintsTemp);

  return $this->view->render($response, 'index.html', [
    'sprints' => $sprintsTemp,
  ]);
})->setName('index');

/******************************************************************************
*******************************   REPORT  *************************************
******************************************************************************/

$app->get('/{organization}/{repo}', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);
  error_reporting( error_reporting() & ~E_NOTICE );

  $GH_URL = 'https://api.github.com';
  $ZH_URL = 'https://api.zenhub.io/p1';
  $org = $request->getAttribute('organization');
  $repo = $request->getAttribute('repo');
  $repoURL = $GH_URL.'/repos/'.$org.'/'.$repo;

  // Parameters
  $milestoneID = $request->getQueryParam('milestoneID');
  $milestoneID = (isset($milestoneID)? $milestoneID : "");
  $zenhubActive = $request->getQueryParam('zenhubActive') == "true";
  $hideFilters = $request->getQueryParam('hideFilters') == "true";
  $state = $request->getQueryParam('state');
  $state = (isset($state)? $state : "open");

  $repoInfo = githubRequest($repoURL);
  $milestones = githubRequest($repoURL.'/milestones');
  if(($milestoneID != "")){
    $milestoneInfo = githubRequest($repoURL.'/milestones/'.$milestoneID);
  }
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
  $chartsData = array();

  foreach ($allIssues as $issue) {

      $issue['priority'] = getLabelValue($issue['labels'], "Priority");
      $issue['type'] = getLabelValue($issue['labels'], "Type");
      $issue['assigneAcronym'] = getAcronyms($issue['assignee']['login']);

      if($zenhubActive){
        $issue['zenhub'] = zenhubRequest($ZH_URL.'/repositories/'.$repoInfo['id'].'/issues/'.$issue['number']);

        $estimate = $issue['zenhub']['estimate']['value'];

        $chartsData['totalEstimate'] += $estimate;
        $chartsData['priorities'][$issue['priority']] += $estimate;
        $chartsData['types'][$issue['type']] += $estimate;
        $chartsData['users'][$issue['assigneAcronym']] += $estimate;
        $chartsData['states'][$issue['zenhub']['pipeline']['name']] += $estimate;
      }else{
        $chartsData['states'][$issue['state']]++;
        $chartsData['priorities'][$issue['priority']]++;
        $chartsData['types'][$issue['type']]++;
        $chartsData['users'][$issue['assigneAcronym']]++;
      }

      $issuesTemp[] = $issue;
  }
  $allIssues = $issuesTemp;


  return $this->view->render($response, 'repo.html', [
    'repoInfo' => $repoInfo,
    'milestones' => $milestones,
    'issues' => $allIssues,
    'milestoneID' => $milestoneID,
    'milestoneInfo' => $milestoneInfo,
    'pages' => $page,
    'zenhubActive' => $zenhubActive,
    'state' => $state,
    'hideFilters' => $hideFilters,
    'query' => $query,
    'chartsData' => $chartsData
  ]);
})->setName('repo');

/******************************************************************************
******************************   FRESHDESK  ***********************************
******************************************************************************/
$app->get('/freshdesk', function ($request, $response, $args) {
  //ini_set('max_execution_time', 600);
  $startDate = "2018-07-01";
  $endDate= "2018-08-17";

  $allTickets = array();
  $stopRequest = false;
  $page = 1;
  $perPage = 30;

  $query = 'https://marlo.freshdesk.com/api/v2/tickets';
  //$query += '?page='.$page;
  //print_r($query);
  //$allTickets = freshdeskRequest($query);

  //print_r($allTickets);

  // Get all issues from Github
  /*
  do {
    $query = 'https://marlo.freshdesk.com/api/v2/tickets';
    //$query += '?page='.$page;
    //print_r($query);
    $tickets = freshdeskRequest($query);
    //print_r($tickets);
    if(count($tickets) < $perPage){
      $stopRequest = true;
    }else{
      $page = $page + 1;
    }
    $allTickets = array_merge($allTickets, $tickets);
  } while ($stopRequest == false);
  */

  //print_r($allTickets);
  return $this->view->render($response, 'freshdesk.html', [
    'tickets' => $allTickets
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

function getAcronyms($s){
    if($s != null){
      $users['sebas932'] = 'SA';
      $users['AndresFVR'] = 'AV';
      $users['HermesJim'] = 'HJ';
      $users['mralmanzar'] = 'MRA';
      $users['cgarcia9106'] = 'CG';
      $users['jhanzuro'] = 'JZ';
      $users['Grant-Lay'] = 'GL';
      $users['jurodca'] = 'JR';
      $users['htobon'] = 'HT';
      $users['kenjitm'] = 'KT';
      $users['anamp70'] = 'AMP';
      $users['carios1usb'] = 'CR';

      $acronym = $users[$s];

      if ($acronym != null){
        return $acronym;
      }else{
        return $s;
      }
    }else{
      return "Not Defined";
    }

}

?>
