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
  $freshdeskService = new \services\FreshdeskService();
  $utils = new \utils\Utils();

  $org = $request->getAttribute('organization');
  $repo = $request->getAttribute('repo');

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

      // Getting Freshdesk Tickets
      $startDate = (new DateTime($milestoneInfo['dates']['start_date']))->format('Y-m-d');
      $endDate = (new DateTime($milestoneInfo['dates']['end_date']))->format('Y-m-d');
      $milestoneInfo['tickets'] = $freshdeskService->getTicketsByDates($startDate, $endDate);
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

      if($zenhubActive){
        // Getting Zenhub data
        $issue['zenhub'] = $zenhubService->getIssueData($repoInfo['id'], $issue['number']);

        // Is epic
        if ($issue['zenhub']['is_epic']){
          // Getting Epic Data
          $issue['zenhub']['epicData'] = $zenhubService->getEpicData($repoInfo['id'], $issue['number']);
          // Getting Information from github
          foreach ($issue['zenhub']['epicData']['issues'] as $subIssue) {
            $issuesWithEpic[$subIssue['issue_number']] = $issue;
          }
        }
        // Set Estimate
        $issueEstimate = $issue['zenhub']['estimate']['value'];
      }

      // Filter Issues and Build Charts Data
      if((!$issue['pull_request']) && (!$issue['zenhub']['is_epic'])){
        $chartsData['totalEstimate'] += $issueEstimate;
        if($issue['isNew'])
          $chartsData['issuesEstimate']['Not Planned'] += $issueEstimate;
        else{
          $chartsData['issuesEstimate']['Planned'] += $issueEstimate;
        }
        $chartsData['priorities'][$issue['priority']] += $issueEstimate;
        $chartsData['types'][$issue['type']] += $issueEstimate;
        $chartsData['users'][$issue['assignee']['acronym']] += $issueEstimate;
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

  $startDate = "2018-04-16";
  $endDate = "2019-04-17";
  $tickets = $freshdeskService->getTicketsByDates($startDate, $endDate);

  return $this->view->render($response, 'freshdesk.html', [
    'tickets' => $tickets
  ]);
})->setName('freshdesk');









?>
