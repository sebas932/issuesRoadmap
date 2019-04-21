<?php
namespace services;

class GithubService {
  private $utils;
  private $userName;
  private $token;

  public function __construct(){
    global $settings;
    $this->utils = new \utils\Utils();
    $this->userName = $settings['github']['username'];
    $this->token = $settings['github']['token'];
  }

  // Get Issues
  public function getIssues($org, $repo, $milestoneID = "" , $state = "all"){
    $repoURL = '/repos/'.$org.'/'.$repo;

    $stopRequest = false;
    $page = 1;
    $perPage = 100;
    $allIssues = array();

    // Get all issues from Github
    do {
     $query = $repoURL.'/issues?state='.$state.'&page='.$page.'&per_page='.$perPage;
     if(($milestoneID != "")){
        $query = $query.'&milestone='.$milestoneID;
     }
     $issues = $this->singleRequest($query);
     if(count($issues) < $perPage){
       $stopRequest = true;
     }else{
       $page = $page + 1;
     }
     $allIssues =  array_merge($allIssues, $issues);
    } while ($stopRequest == false);

    foreach ($allIssues as $i => $issue) {
      $allIssues[$i]['assignee']['acronym'] = $this->utils->getAcronyms($issue['assignee']['login']);
      // Assignees
      $assignees = array();
      foreach ($issue['assignees'] as $assignee) {
        $assignee['acronym'] = $this->utils->getAcronyms($assignee['login']);
        $assignees[] = $assignee;
      }
      $allIssues[$i]['assignees'] = $assignees;
    }

    return $allIssues;
 }

 // Get Repository
 public function getRepository($org, $repo){
   $repoURL = '/repos/'.$org.'/'.$repo;
   return $this->singleRequest($repoURL);
 }

 // Get Milestone By ID
 public function getMilestoneByID($org, $repo, $milestoneID){
   $repoURL = '/repos/'.$org.'/'.$repo;
   return $this->singleRequest($repoURL.'/milestones/'.$milestoneID);
 }

 // Get List of Milestones
 public function getMilestones($org, $repo, $state = "all"){
    $milestones = $this->singleRequest('/repos/'.$org.'/'.$repo.'/milestones?state='.$state.'&per_page=100&direction=desc');
    $milestonesTemp = array();
    foreach ($milestones as $milestoneInfo) {
      $milestoneInfo['report_url'] = './'.$org.'/'.$repo.'?milestoneID='.$milestoneInfo['number'].'&zenhubActive=true&state=all&hideFilters=true';
      $milestonesTemp[]= $milestoneInfo;
    }
   return $milestonesTemp;
 }

  // Github REST API
  private function singleRequest($query){
    // Basic Authentication with token
    // https://developer.github.com/v3/auth/
    // https://github.com/blog/1509-personal-api-tokens
    // https://github.com/settings/tokens
    $access = $this->userName.':'.$this->token;
    $fetchURL = 'https://api.github.com'.$query;

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $fetchURL);
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

 private function requestMultiple($queries){
    $access = $this->$userName.':'.$this->$token;
    // array of curl handles
    $multiCurl = array();
    // data to be returned
    $result = array();
    // multi handle
    $mh = curl_multi_init();
    foreach ($queries as $i => $query) {
      // URL from which data will be fetched
      $fetchURL = 'https://api.github.com'.$query;

      $multiCurl[$i] = curl_init();
      curl_setopt($multiCurl[$i], CURLOPT_URL,$fetchURL);
      curl_setopt($multiCurl[$i], CURLOPT_HEADER,0);
      curl_setopt($multiCurl[$i], CURLOPT_USERPWD, $access);
      curl_setopt($multiCurl[$i], CURLOPT_RETURNTRANSFER,1);
      curl_setopt($multiCurl[$i], CURLOPT_USERAGENT, 'Agent smith');
      curl_setopt($multiCurl[$i], CURLOPT_TIMEOUT, 30);
      curl_setopt($multiCurl[$i], CURLOPT_SSL_VERIFYHOST, 0);
      curl_setopt($multiCurl[$i], CURLOPT_SSL_VERIFYPEER, 0);

      curl_multi_add_handle($mh, $multiCurl[$i]);
    }
    $index=null;
    do {
      curl_multi_exec($mh,$index);
    } while($index > 0);
    // get content and remove handles
    foreach($multiCurl as $k => $ch) {
      $result[$k] = curl_multi_getcontent($ch);
      $result[$k] = json_decode(trim($result[$k]), true);
      curl_multi_remove_handle($mh, $ch);
    }
    // close
    curl_multi_close($mh);

    return $result;
  }

}

?>
