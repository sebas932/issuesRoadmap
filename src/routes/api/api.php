<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

$app->get('/api/{organization}/{repo}/milestones', function ($request, $response, $args) {
  // Managers
  $githubService = new \services\GithubService();
  // URL Parameters
  $org = $request->getAttribute('organization');
  $repo = $request->getAttribute('repo');
  // Get Parameters
  $state = $request->getQueryParam('state');
  $state = (isset($state)? $state : "open");

  $milestones = $githubService->getMilestones($org, $repo, $state);

  return $response->withStatus(200)
        ->withHeader('Content-Type', 'application/json')
        ->write(json_encode($milestones));
});


$app->get('/api/{organization}/{repo}/sprint/{milestoneID}', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);
  $startTime = new DateTime();

  // URL Parameters
  $org = $request->getAttribute('organization');
  $repo = $request->getAttribute('repo');
  $milestoneID = $request->getAttribute('milestoneID');

  // Managers
  $sprintService = new \services\SprintService($org, $repo);
  $sprint = $sprintService->getSprint($milestoneID);

  $endTime = new DateTime();
  $diffTime = $endTime->diff($startTime);
  $output['loadTime'] = $diffTime->format('%h:%i:%s');

  $output['result'] = $sprint;

  return $response->withStatus(200)
        ->withHeader('Content-Type', 'application/json')
        ->withHeader('Access-Control-Allow-Origin', '*')
        ->write(json_encode($output));
});
