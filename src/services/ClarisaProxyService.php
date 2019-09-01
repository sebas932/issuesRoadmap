<?php
namespace services;

class ClarisaProxyService {

  public function __construct(){
    global $settings;
  }

  // Get Repository
  public function getQuery($url){
    $url = urldecode($url);
    return $this->getRequest($url);
  }

  public function postQuery($url, $data){
    $url = urldecode($url);

    $payload = json_encode($data);
    // Prepare new cURL resource
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLINFO_HEADER_OUT, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    // Set HTTP Header for POST request
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
      'Content-Type: application/json',
      'Authorization: Basic bWFybG9zYWRtaW46NjcyMzY0Ng==',
      'Content-Length: ' . strlen($payload))
    );
    // Submit the POST request
    $result = curl_exec($ch);
    // Close cURL session handle
    curl_close($ch);
    return $result;
  }

  public function putQuery($url, $data){
    $url = urldecode($url);
    $payload = json_encode($data);

    //Initiate cURL
    $ch = curl_init($url);
    //Use the CURLOPT_PUT option to tell cURL that
    curl_setopt($ch, CURLOPT_PUT, true);
    //We want the result / output returned.
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    // Set HTTP Header for POST request
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
      'Content-Type: application/json',
      'Authorization: Basic bWFybG9zYWRtaW46NjcyMzY0Ng==',
      'Content-Length: ' . strlen($payload))
    );
    //Our fields.
    curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);

    //Execute the request.
    $result = curl_exec($ch);

    return $result;
  }

  public function deleteQuery($url){
    $url = urldecode($url);
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Authorization: Basic bWFybG9zYWRtaW46NjcyMzY0Ng=='));
    $result = curl_exec($ch);
    $result = json_decode($result);
    curl_close($ch);
    return $result;
  }

  // Github REST API
  private function getRequest($url){
    $fetchURL = $url;

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $fetchURL);
    curl_setopt($ch, CURLOPT_USERAGENT, 'Agent smith');
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Authorization: Basic bWFybG9zYWRtaW46NjcyMzY0Ng=='));
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
