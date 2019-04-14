<?php
namespace managers;

class GithubManager {
  public function call()
    {
        $this->next->call();
    }

 // Get Issues
 public function getIssues($org, $repo, $milestoneID = "" , $state = "all"){
   $GH_URL = 'https://api.github.com';
   $repoURL = $GH_URL.'/repos/'.$org.'/'.$repo;

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
     $issues = $this->githubRequest($query);
     if(count($issues) < $perPage){
       $stopRequest = true;
     }else{
       $page = $page + 1;
     }
     $allIssues =  array_merge($allIssues, $issues);
   } while ($stopRequest == false);

   return $allIssues;
 }

 // Get Repository
 public function getRepository($org, $repo){
   $GH_URL = 'https://api.github.com';
   $repoURL = $GH_URL.'/repos/'.$org.'/'.$repo;
   return $this->githubRequest($repoURL);
 }

 // Get Milestone By ID
 public function getMilestoneByID($org, $repo, $milestoneID){
   $GH_URL = 'https://api.github.com';
   $repoURL = $GH_URL.'/repos/'.$org.'/'.$repo;
   return $this->githubRequest($repoURL.'/milestones/'.$milestoneID);
 }

 // Get List of Milestones
 public function getMilestones($org, $repo, $state = "all"){
    $GH_URL = 'https://api.github.com';
    $repoURL = $GH_URL.'/repos/'.$org.'/'.$repo;

    $milestones = $this->githubRequest($repoURL.'/milestones?state='.$state.'&per_page=100&direction=desc');

    $milestonesTemp = array();
    foreach ($milestones as $milestoneInfo) {
      $query = $repoURL.'/milestones/'.$milestoneInfo['number'];
      //$milestoneInfo['github'] = $this->githubRequest($query);
      $milestoneInfo['report_url'] = './'.$org.'/'.$repo.'?milestoneID='.$milestoneInfo['number'].'&zenhubActive=true&state=all&hideFilters=true';
      $milestonesTemp[]= $milestoneInfo;
    }
   return $milestonesTemp;
 }

 // Github REST API
 public function githubRequest($url){
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

}

?>
