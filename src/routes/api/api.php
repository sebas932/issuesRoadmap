<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

$app->options('/{routes:.+}', function ($request, $response, $args) {
    return $response;
});
$app->add(function ($req, $res, $next) {
    $response = $next($req, $res);
    return $response
    ->withHeader('Access-Control-Allow-Origin', '*')
    ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
    ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
});

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
        ->withHeader('Content-Type', 'application/json; charset=utf-8')
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
        ->withHeader('Content-Type', 'application/json; charset=utf-8')
        ->write(json_encode($output));
});
