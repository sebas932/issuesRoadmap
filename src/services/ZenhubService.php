<?php
namespace services;

class ZenhubService {

  public function call()
    {
        $this->next->call();
    }

  public function getStartDate($repoID, $milestoneNumber){
    return $this->zenhubRequest('/repositories/'.$repoID.'/milestones/'.$milestoneNumber.'/start_date');
  }

  public function getIssueData($repoID, $issueNumber){
    return $this->zenhubRequest('/repositories/'.$repoID.'/issues/'.$issueNumber);
  }

  public function getEpicData($repoID, $issueNumber){
    return $this->zenhubRequest('/repositories/'.$repoID.'/epics/'.$issueNumber);
  }


  // ZenHubIO/API REST API
  private function zenhubRequest($url){
    global $settings;
    $ZH_URL = 'https://api.zenhub.io/p1';
    $ch = curl_init();
    // Basic Authentication with token
    // https://github.com/ZenHubIO/API
    // curl -H 'X-Authentication-Token: TOKEN' https://api.zenhub.io/p1/repositories/:repo_id/issues/:issue_id
    $access = $settings['zenhub']['token'];

    curl_setopt($ch, CURLOPT_URL, $ZH_URL.$url);
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

}

?>
