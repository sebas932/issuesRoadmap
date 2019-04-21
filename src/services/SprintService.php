<?php
namespace services;
use DateTime;

class SprintService {

  // Managers
  private $githubService;
  private $zenhubService;
  private $freshdeskService;
  // Private Variables
  private $org;
  private $repo;
  private $repoInfo;
  private $sprintInfo;


  public function __construct($org, $repo){
    $this->githubService = new \services\GithubService();
    $this->zenhubService = new \services\ZenhubService();
    $this->freshdeskService = new \services\FreshdeskService();

    $this->org = $org;
    $this->repo = $repo;
    $this->repoInfo = $this->getSprintRepository();
  }

  public function getSprint($milestoneID){
    // Load Milestong Information
    $sprintInfo = $this->githubService->getMilestoneByID($this->org, $this->repo, $milestoneID);

    // Load Repository
    $sprintInfo['repository'] = $this->repoInfo;

    // Load Dates
    $sprintInfo['dates'] = $this->getSprintDates($sprintInfo);

    // Load Tickets
    $sprintInfo['tickets'] = $this->getSprintTickets($sprintInfo);

    // Load Issues
    $sprintInfo['issues'] = $this->getSprintIssues($sprintInfo);

    /**** Finished! ****/
    $this->sprintInfo = $sprintInfo;
    return $this->sprintInfo;
  }

  public function getSprintRepository(){
    return $this->githubService->getRepository($this->org, $this->repo);
  }

  public function getSprintDates($sprint){
    $dates = $this->zenhubService->getStartDate($this->repoInfo['id'], $sprint['number']);
    $dates['end_date'] = $sprint['due_on'];
    return $dates;
  }

  public function getSprintTickets($sprint){
    // Load Freshdesk Tickets
    if(isset($sprint['dates']['start_date'])){
      $startDate = (new DateTime($sprint['dates']['start_date']))->format('Y-m-d');
      $endDate = (new DateTime($sprint['dates']['end_date']))->format('Y-m-d');
      return $this->freshdeskService->getTicketsByDates($startDate, $endDate);
    }
    return [];
  }

  public function getSprintIssues($sprint){
    $allIssues = $this->githubService->getIssues($this->org, $this->repo, $sprint['number']);
    // Load ZenhubData
    foreach ($allIssues as $i => $issue) {
      $allIssues[$i]['zenhub'] = $this->zenhubService->getIssueData($this->repoInfo['id'], $issue['number']);
    }
    return $allIssues;
  }



}

?>
