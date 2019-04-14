<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require_once('/../managers/GithubManager.php');
require_once('/../utils/Utils.php');

/******************************************************************************
*******************************    HOME   *************************************
******************************************************************************/
$app->get('/', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);
  error_reporting( error_reporting() & ~E_NOTICE );

  // Managers
  $githubManager = new \managers\GithubManager();
  // Parameters
  $org = 'CCAFS';
  $repo = 'MARLO';

  $listOfmilestones = array();
  $listOfmilestones['open'] =  $githubManager->getMilestones($org, $repo, "open");
  $listOfmilestones['closed'] =  $githubManager->getMilestones($org, $repo, "closed");

  return $this->view->render($response, 'index.html', [
    'sprints' => $listOfmilestones,
  ]);
})->setName('index');

/******************************************************************************
*******************************   REPORT  *************************************
******************************************************************************/

$app->get('/{organization}/{repo}', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);
  error_reporting( error_reporting() & ~E_NOTICE );
  // Managers
  $githubManager = new \managers\GithubManager();
  $utils = new \utils\Utils();

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


  $repoInfo =  $githubManager->getRepository($org, $repo);
  $milestones = $githubManager->getMilestones($org, $repo, "open");

  if(($milestoneID != "")){
    $milestoneInfo = $githubManager->getMilestoneByID($org, $repo, $milestoneID);

    if($zenhubActive){
      $milestoneInfo['dates'] = zenhubRequest($ZH_URL.'/repositories/'.$repoInfo['id'].'/milestones/'.$milestoneInfo['number'].'/start_date');
      $milestoneInfo['dates']['end_date'] = $milestoneInfo['due_on'];
    }
  }

  // Get all milestone issues
  $allIssues = $githubManager->getIssues($org, $repo, $milestoneID , $state);

  // Get Issues information from Zenhub
  $issuesTemp = array();
  $issuesWithEpic = array();
  $chartsData = array();

  foreach ($allIssues as $issue) {
      $issueEstimate = 1;

      $issue['priority'] = $utils->getLabelValue($issue['labels'], "Priority");
      $issue['type'] = $utils->getLabelValue($issue['labels'], "Type");
      $issue['assigneAcronym'] = $utils->getAcronyms($issue['assignee']['login']);

      $issue['isNew'] = ($milestoneInfo['dates']['start_date'] < $issue['created_at']);

      // Assignees
      $assignees = array();
      foreach ($issue['assignees'] as $assignee) {
        $assignee['assigneAcronym'] = $utils->getAcronyms($assignee['login']);
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
  $utils = new \utils\Utils();

  $agents = freshdeskRequest("https://marlo.freshdesk.com/api/v2/agents");
  $tickets = freshdeskRequest("https://marlo.freshdesk.com/api/v2/tickets");

  $ticketsTemp = array();

  foreach ($tickets as $ticket) {
      $ticket['requesterInfo'] = $utils->getArrayByKeyValue($agents, 'id', $ticket['requester_id']);
      $ticket['responderInfo'] = $utils->getArrayByKeyValue($agents, 'id', $ticket['responder_id']);
      $ticketsTemp[] = $ticket;
  }
  $tickets = $ticketsTemp;

  return $this->view->render($response, 'freshdesk.html', [
    'tickets' => $tickets,
    'agents' => $agents,
  ]);
})->setName('freshdesk');


/****************************************************************************/

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







?>
