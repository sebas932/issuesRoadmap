<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require_once('/../../managers/GithubManager.php');
require_once('/../../utils/Utils.php');

$app->get('/api/{organization}/{repo}/milestones', function ($request, $response, $args) {
  // Managers
  $githubManager = new \managers\GithubManager();
  // Parameters
  $org = $request->getAttribute('organization');
  $repo = $request->getAttribute('repo');

  $milestones = $githubManager->getMilestones($org, $repo, "all");

  return $response->withStatus(200)
        ->withHeader('Content-Type', 'application/json')
        ->write(json_encode($milestones));
});
