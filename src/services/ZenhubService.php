<?php
namespace services;

class ZenhubService {

  private $zenhubToken;

  public function __construct(){
    global $settings;
    $this->zenhubToken = $settings['zenhub']['token'];
  }

  public function getStartDate($repoID, $milestoneNumber){
    return $this->zenhubRequest('/repositories/'.$repoID.'/milestones/'.$milestoneNumber.'/start_date');
  }

  // Get the data for a specific issue.
  public function getIssueData($repoID, $issueNumber){
    $data = $this->zenhubRequest('/repositories/'.$repoID.'/issues/'.$issueNumber);
    if(isset($data['pipeline']['name'])){
      $data['pipeline']['name'] = "Closed";
    }
    return $data;
  }

  // Get the data for an Epic issue.
  public function getEpicData($repoID, $issueNumber){
    $data = $this->zenhubRequest('/repositories/'.$repoID.'/epics/'.$issueNumber);
    return $data;
  }

  // Get all Epics for a repository
  public function getEpics($repoID){
    $data = $this->zenhubRequest('/repositories/'.$repoID.'/epics');
    return $data;
  }


  // ZenHubIO/API REST API
  private function zenhubRequest($url){
    $ch = curl_init();
    // Basic Authentication with token
    // https://github.com/ZenHubIO/API
    // curl -H 'X-Authentication-Token: TOKEN' https://api.zenhub.io/p1/repositories/:repo_id/issues/:issue_id
    $access = $this->zenhubToken;

    curl_setopt($ch, CURLOPT_URL, "https://api.zenhub.io/p1".$url);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('X-Authentication-Token: '.$access));
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
     $access = $this->zenhubToken;
     // array of curl handles
     $multiCurl = array();
     // data to be returned
     $result = array();
     // multi handle
     $mh = curl_multi_init();
     foreach ($queries as $i => $query) {
       // URL from which data will be fetched
       $fetchURL = 'https://api.zenhub.io/p1'.$query;

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
