<?php
namespace services;

class FreshdeskService {

  public function call()
    {
        $this->next->call();
    }

  public function getAgents(){
    return $this->freshdeskRequest("https://marlo.freshdesk.com/api/v2/agents");
  }

  public function getTickets(){
    return $this->freshdeskRequest("https://marlo.freshdesk.com/api/v2/tickets");
  }

  // Freshdesk REST API
  private function freshdeskRequest($url){
    global $settings;
    $ch = curl_init();
    // Basic Authentication with token
    // curl -v -u sebas932:IlRyulZofEubvo7 -X GET 'https://marlo.freshdesk.com/api/v2/tickets'
    $access = $settings['freshdesk']['username'].":".$settings['freshdesk']['password'];

    curl_setopt($ch, CURLOPT_URL, $url);
    //curl_setopt($ch, CURLOPT_HTTPHEADER, array('X-Authentication-Token: '.$access));
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
    print_r($result);
    return $result;
  }

}

?>
