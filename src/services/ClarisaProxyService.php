<?php
namespace services;

class ClarisaProxyService {

  public function __construct(){
    global $settings;
  }

  // Get Repository
  public function getQuery($url){
    return $this->singleRequest($url);
  }

  // Github REST API
  private function singleRequest($url){
    $access = 'marlosadmin:6723646';
    $fetchURL = $url;

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
}

?>
