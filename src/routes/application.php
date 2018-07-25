<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

// Render Twig template in route
$app->get('/', function ($request, $response, $args) {

  return $this->view->render($response, 'index.html', [
  ]);
})->setName('index');

$app->get('/{organization}/{repo}', function ($request, $response, $args) {
  $GITHUB_URL = 'https://api.github.com';
  $organization = $request->getAttribute('organization');
  $repo = $request->getAttribute('repo');

  $query = $GITHUB_URL.'/repos/'.$organization.'/'.$repo;
  $repoInfo = github_request($query);

  $query = $GITHUB_URL.'/repos/'.$organization.'/'.$repo.'/issues?state=all&milestone=36';
  $issues = github_request($query);

  return $this->view->render($response, 'repo.html', [
    'repoInfo' => $repoInfo,
    'issues' => $issues
  ]);
})->setName('repo');


// Github REST API example
function github_request($url){
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

?>
