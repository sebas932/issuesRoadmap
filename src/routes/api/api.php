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
