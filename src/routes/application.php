<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

/******************************************************************************
*******************************    HOME   *************************************
******************************************************************************/
$app->get('/', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);
  error_reporting( error_reporting() & ~E_NOTICE );
  // Managers
  $githubService = new \services\GithubService();
  // Parameters
  $org = 'CCAFS';
  $repo = 'MARLO';

  $listOfmilestones = array();
  $listOfmilestones['open'] =  $githubService->getMilestones($org, $repo, "open");
  $listOfmilestones['closed'] =  $githubService->getMilestones($org, $repo, "closed");

  return $this->view->render($response, 'index.html', [
    'sprints' => $listOfmilestones,
  ]);
})->setName('index');

/******************************************************************************
**************************  MILESTONE REPORT  *********************************
******************************************************************************/

$app->get('/{organization}/{repo}', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);
  error_reporting( error_reporting() & ~E_NOTICE );
  // Managers
  $githubService = new \services\GithubService();
  $zenhubService = new \services\ZenhubService();
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


  $repoInfo =  $githubService->getRepository($org, $repo);
  $milestones = $githubService->getMilestones($org, $repo, "open");

  if(($milestoneID != "")){
    $milestoneInfo = $githubService->getMilestoneByID($org, $repo, $milestoneID);

    if($zenhubActive){
      $milestoneInfo['dates'] = $zenhubService->getStartDate($repoInfo['id'], $milestoneInfo['number']);
      $milestoneInfo['dates']['end_date'] = $milestoneInfo['due_on'];
    }
  }

  // Get all milestone issues
  $allIssues = $githubService->getIssues($org, $repo, $milestoneID , $state);

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
        $issue['zenhub'] = $zenhubService->getIssueData($repoInfo['id'], $issue['number']);

        // Is epic
        if ($issue['zenhub']['is_epic']){
          // Getting Epic Data
          $issue['zenhub']['epicData'] = $zenhubService->getEpicData($repoInfo['id'], $issue['number']);
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

/******************************************************************************
**************************  FRESHDESK REPORT  *********************************
******************************************************************************/

$app->get('/freshdesk', function ($request, $response, $args) {
  // Managers
  $freshdeskService = new \services\FreshdeskService();
  $utils = new \utils\Utils();

  $agents = $freshdeskService->getAgents();
  $tickets = $freshdeskService->getTickets();

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









?>
