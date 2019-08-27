<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

$app->options('/{routes:.+}', function ($request, $response, $args) {
    return $response;
});

$app->add(function ($req, $res, $next) {
    error_reporting( error_reporting() & ~E_NOTICE );
    $response = $next($req, $res);
    return $response
    ->withHeader('Access-Control-Allow-Origin', '*')
    ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
    ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
});

$app->get('/api/{organization}/{repo}/repo', function ($request, $response, $args) {
  // Managers
  $githubService = new \services\GithubService();
  // URL Parameters
  $org = $request->getAttribute('organization');
  $repo = $request->getAttribute('repo');

  $repo = $githubService->getRepository($org, $repo);

  return $response->withStatus(200)
        ->withHeader('Content-Type', 'application/json; charset=utf-8')
        ->write(json_encode($repo));
});


$app->get('/api/{organization}/{repo}/sprints', function ($request, $response, $args) {
  // Managers
  $githubService = new \services\GithubService();
  // URL Parameters
  $org = $request->getAttribute('organization');
  $repo = $request->getAttribute('repo');
  // Get Parameters
  $state = $request->getQueryParam('state');
  $state = (isset($state)? $state : "open");

  $sprints = $githubService->getMilestones($org, $repo, $state);

  return $response->withStatus(200)
        ->withHeader('Content-Type', 'application/json; charset=utf-8')
        ->write(json_encode($sprints));
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

$app->get('/api/{organization}/{repo}/sprint/{milestoneID}/issues', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);
  $startTime = new DateTime();

  // URL Parameters
  $org = $request->getAttribute('organization');
  $repo = $request->getAttribute('repo');
  $milestoneID = $request->getAttribute('milestoneID');

  // Managers
  $sprintService = new \services\SprintService($org, $repo);
  $sprint = $sprintService->getIssues($milestoneID);

  $endTime = new DateTime();
  $diffTime = $endTime->diff($startTime);
  $output['loadTime'] = $diffTime->format('%h:%i:%s');
  $output['result'] = $sprint;

  return $response->withStatus(200)
        ->withHeader('Content-Type', 'application/json; charset=utf-8')
        ->write(json_encode($output));
});

$app->get('/api/{organization}/{repo}/sprint/{milestoneID}/tickets', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);
  $startTime = new DateTime();

  // URL Parameters
  $org = $request->getAttribute('organization');
  $repo = $request->getAttribute('repo');
  $milestoneID = $request->getAttribute('milestoneID');

  // Managers
  $sprintService = new \services\SprintService($org, $repo);
  $sprint = $sprintService->getTickets($milestoneID);

  $endTime = new DateTime();
  $diffTime = $endTime->diff($startTime);
  $output['loadTime'] = $diffTime->format('%h:%i:%s');
  $output['result'] = $sprint;

  return $response->withStatus(200)
        ->withHeader('Content-Type', 'application/json; charset=utf-8')
        ->write(json_encode($output));
});

$app->get('/api/clarisa/getProxy', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);
  $startTime = new DateTime();

  // URL Parameters
  $url = $request->getQueryParam('url');

  // Managers
  $clarisaService = new \services\ClarisaProxyService();
  $result = $clarisaService->getQuery($url);

  $endTime = new DateTime();
  $diffTime = $endTime->diff($startTime);
  $output['loadTime'] = $diffTime->format('%h:%i:%s');
  $output['result'] = $result;

  return $response->withStatus(200)
        ->withHeader('Content-Type', 'application/json; charset=utf-8')
        ->write(json_encode($output));
});

$app->post('/api/clarisa/postProxy', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);
  $startTime = new DateTime();

  // URL Parameters
  $url = $request->getQueryParam('url');
  $data = $request->getParsedBody();
  //print_r($result);

  // Managers
  $clarisaService = new \services\ClarisaProxyService();
  $result = $clarisaService->postQuery($url, $data);


  $endTime = new DateTime();
  $diffTime = $endTime->diff($startTime);
  $output['loadTime'] = $diffTime->format('%h:%i:%s');
  $output['result'] = $result;

  return $response->withStatus(200)
        ->withHeader('Content-Type', 'application/json; charset=utf-8')
        ->write(json_encode($output));
});

$app->delete('/api/clarisa/deleteProxy', function ($request, $response, $args) {
  ini_set('max_execution_time', 600);
  $startTime = new DateTime();

  // URL Parameters
  $url = $request->getQueryParam('url');
  $data = $request->getParsedBody();
  //print_r($result);

  // Managers
  $clarisaService = new \services\ClarisaProxyService();
  $result = $clarisaService->deleteQuery($url);


  $endTime = new DateTime();
  $diffTime = $endTime->diff($startTime);
  $output['loadTime'] = $diffTime->format('%h:%i:%s');
  $output['result'] = $result;

  return $response->withStatus(200)
        ->withHeader('Content-Type', 'application/json; charset=utf-8')
        ->write(json_encode($output));
});
