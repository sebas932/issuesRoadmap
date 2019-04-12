<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

/******************************************************************************
*******************************    HOME   *************************************
******************************************************************************/
$app->get('/', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);
  error_reporting( error_reporting() & ~E_NOTICE );

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

    if($zenhubActive){
      $milestoneInfo['dates'] = zenhubRequest($ZH_URL.'/repositories/'.$repoInfo['id'].'/milestones/'.$milestoneInfo['number'].'/start_date');
      $milestoneInfo['dates']['end_date'] = $milestoneInfo['due_on'];
    }
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
  $issuesWithEpic = array();
  $chartsData = array();

  foreach ($allIssues as $issue) {
      $issueEstimate = 1;

      $issue['priority'] = getLabelValue($issue['labels'], "Priority");
      $issue['type'] = getLabelValue($issue['labels'], "Type");
      $issue['assigneAcronym'] = getAcronyms($issue['assignee']['login']);

      $issue['isNew'] = ($milestoneInfo['dates']['start_date'] < $issue['created_at']);

      // Assignees
      $assignees = array();
      foreach ($issue['assignees'] as $assignee) {
        $assignee['assigneAcronym'] = getAcronyms($assignee['login']);
        $assignees[] = $assignee;
      }
      $issue['assignees'] = $assignees;

      if($zenhubActive){
        // Getting Zenhub data
        $issue['zenhub'] = zenhubRequest($ZH_URL.'/repositories/'.$repoInfo['id'].'/issues/'.$issue['number']);

        // Is epic
        if ($issue['zenhub']['is_epic']){
          // Getting Epic Data
          $issue['zenhub']['epicData'] = zenhubRequest($ZH_URL.'/repositories/'.$repoInfo['id'].'/epics/'.$issue['number']);

          // Getting Information from github
          // $subIssues = array();
          foreach ($issue['zenhub']['epicData']['issues'] as $subIssue) {
            //$subIssue['githubData'] = githubRequest($repoURL.'/issues/'.$subIssue['issue_number']);
            //$subIssues[] = $subIssue;
            $issuesWithEpic[$subIssue['issue_number']] = $issue;
          }
          // $issue['zenhub']['epicData']['issues'] = $subIssues;
        }

        // Set Estimate
        $issueEstimate = $issue['zenhub']['estimate']['value'];
      }

      //
      if((!$issue['pull_request']) && (!$issue['zenhub']['is_epic'])){
        //Build Charts
        $chartsData['totalEstimate'] += $issueEstimate;
        if($issue['isNew'])
          $chartsData['issuesEstimate']['Not Planned'] += $issueEstimate;
        else{
          $chartsData['issuesEstimate']['Planned'] += $issueEstimate;
        }
        $chartsData['priorities'][$issue['priority']] += $issueEstimate;
        $chartsData['types'][$issue['type']] += $issueEstimate;
        $chartsData['users'][$issue['assigneAcronym']] += $issueEstimate;
        $chartsData['states'][$issue['zenhub']['pipeline']['name']] += $issueEstimate;
        $issuesTemp[] = $issue;
      }
  }
  $allIssues = $issuesTemp;

  // Fill Epic Data
  $issuesTemp = array();
  foreach ($allIssues as $issue) {
    if($issuesWithEpic[$issue['number']]){
      $issue['epicIssue'] = $issuesWithEpic[$issue['number']];
    }
    $issuesTemp[] = $issue;
  }
  $allIssues = $issuesTemp;



  return $this->view->render($response, 'repo.html', [
    'org' => $org,
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


$app->get('/freshdesk', function ($request, $response, $args) {
  $agents = freshdeskRequest("https://marlo.freshdesk.com/api/v2/agents");
  $tickets = freshdeskRequest("https://marlo.freshdesk.com/api/v2/tickets");

  // $agent1 = getArrayByKeyValue($agents, 'id', '42000028957');
  // print_r($agent1['contact']['name']);


  $ticketsTemp = array();

  foreach ($tickets as $ticket) {
      $ticket['requesterInfo'] = getArrayByKeyValue($agents, 'id', $ticket['requester_id']);
      $ticket['responderInfo'] = getArrayByKeyValue($agents, 'id', $ticket['responder_id']);
      $ticketsTemp[] = $ticket;
  }
  $tickets = $ticketsTemp;

  return $this->view->render($response, 'freshdesk.html', [
    'tickets' => $tickets,
    'agents' => $agents,
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

function getArrayByKeyValue($array, $key, $value){
  foreach ($array as $element) {
    if ( $element[$key] == $value) {
      return $element;
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
    print_r($result);
    return $result;
}

function getAcronyms($s){
    if($s != null){
      $users['sebas932'] = 'SA';
      $users['AndresFVR'] = 'AV';
      $users['HermesJim'] = 'HJ';
      $users['mralmanzar'] = 'MA';
      $users['cgarcia9106'] = 'CG';
      $users['jhanzuro'] = 'JZ';
      $users['Grant-Lay'] = 'GL';
      $users['jurodca'] = 'JR';
      $users['htobon'] = 'HT';
      $users['kenjitm'] = 'KT';
      $users['anamp07'] = 'AP';
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

function getRandomColor(){
  $rand = array('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
  return '#'.$rand[rand(0,15)].$rand[rand(0,15)].$rand[rand(0,15)].$rand[rand(0,15)].$rand[rand(0,15)].$rand[rand(0,15)];
}
?>
