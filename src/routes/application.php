<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

// Render Twig template in route
$app->get('/', function ($request, $response, $args) {

  return $this->view->render($response, 'index.html', [
  ]);
})->setName('index');

$app->get('/{organization}/{repo}', function ($request, $response, $args) {

  $GH_URL = 'https://api.github.com';
  $org = $request->getAttribute('organization');
  $repo = $request->getAttribute('repo');
  $repoURL = $GH_URL.'/repos/'.$org.'/'.$repo;
  $milestoneID = $request->getQueryParam('milestoneID');

  $repoInfo = api_request($repoURL);
  $milestones = api_request($repoURL.'/milestones');


  if($milestoneID == ""){
    $issues = api_request($repoURL.'/issues?state=all&per_page=100');
  }else{
    $issues = api_request($repoURL.'/issues?state=all&per_page=100&milestone='.$milestoneID);
  }


  return $this->view->render($response, 'repo.html', [
    'repoInfo' => $repoInfo,
    'milestones' => $milestones,
    'issues' => $issues,
    'milestoneID' => $milestoneID
  ]);
})->setName('repo');


// Github REST API example
function api_request($url){
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
