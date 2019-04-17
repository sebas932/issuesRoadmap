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

  public function getTicketsByDates($startDate, $endDate){
    $data = $this->getTicketsByQuery("(created_at:>%27".$startDate."%27%20AND%20created_at:<%27".$endDate."%27)");
    return $data;
  }

  public function getTicketsByQuery($query){
    $utils = new \utils\Utils();

    $agents = $this->getAgents();

    $stopRequest = false;
    $page = 1;
    $perPage = 30;
    $tickets = array();
    do {
     $data = $this->freshdeskRequest('https://marlo.freshdesk.com/api/v2/search/tickets?query="'.$query.'"&page='.$page);
     $results = $data['results'];
     if((count($results) < $perPage) || ($page == 10)){
       $stopRequest = true;
     }else{
       $page = $page + 1;
     }
     $tickets =  array_merge($tickets, $results);
    } while ($stopRequest == false);

    $ticketsTemp = array();
    foreach ($tickets as $ticket) {
      $ticket['requesterInfo'] = $utils->getArrayByKeyValue($agents, 'id', $ticket['requester_id']);
      $ticket['responderInfo'] = $utils->getArrayByKeyValue($agents, 'id', $ticket['responder_id']);
      $ticket['statusName'] = $this->getStatusName($ticket['status']);
      $ticket['priorityName'] = $this->getPriorityName($ticket['priority']);
      $ticketsTemp[] = $ticket;
    }
    $tickets = $ticketsTemp;

    return $tickets;
  }

  function getStatusName($id){
      $status[2] = "Open";
      $status[3] = "Pending";
      $status[4] = "Resolved";
      $status[5] = "Closed";
      return $status[$id];
  }

  function getPriorityName($id){
      $priorities[1] = "Low";
      $priorities[2] = "Medium";
      $priorities[3] = "High";
      $priorities[4] = "Urgent";
      return $priorities[$id];
  }

  // Freshdesk REST API
  private function freshdeskRequest($url){
    global $settings;
    $ch = curl_init();
    // Basic Authentication with token
    // curl -v -u sebas932:IlRyulZofEubvo7 -X GET 'https://marlo.freshdesk.com/api/v2/tickets'
    $access = $settings['freshdesk']['username'].":".$settings['freshdesk']['password'];

    //echo $url;

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json; charset=utf-8'));
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
