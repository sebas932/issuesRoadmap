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
    $this->repoInfo = $this->loadSprintRepository();
  }

  public function getSprint($milestoneID){
    // Load Milestong Information
    $sprintInfo = $this->githubService->getMilestoneByID($this->org, $this->repo, $milestoneID);
    // Load Repository
    $sprintInfo['repository'] = $this->repoInfo;
    // Load Dates
    $sprintInfo['dates'] = $this->loadSprintDates($sprintInfo);
    return $sprintInfo;
  }

  public function getIssues($milestoneID){
    // Load Milestone Information
    $sprintInfo = $this->getSprint($milestoneID);
    // Load Issues
    $issues = $this->loadSprintIssues($sprintInfo);
    foreach ($issues as $i => $issue) {
      $issues[$i]['isNew'] = ($sprintInfo['dates']['start_date'] < $issue['created_at']);
    }
    return $issues;
  }

  public function getTickets($milestoneID){
    // Load MilestoneInformation
    $sprintInfo = $this->getSprint($milestoneID);
    // Load Tickets
    $tickets = $this->loadSprintTickets($sprintInfo);
    return $tickets;
  }

  public function loadSprintRepository(){
    return $this->githubService->getRepository($this->org, $this->repo);
  }

  public function loadSprintDates($sprint){
    $dates = $this->zenhubService->getStartDate($this->repoInfo['id'], $sprint['number']);
    $dates['end_date'] = $sprint['due_on'];
    return $dates;
  }

  public function loadSprintTickets($sprint){
    // Load Freshdesk Tickets
    if(isset($sprint['dates']['start_date'])){
      $startDate = (new DateTime($sprint['dates']['start_date']))->format('Y-m-d');
      $endDate = (new DateTime($sprint['dates']['end_date']))->format('Y-m-d');
      return $this->freshdeskService->getTicketsByDates($startDate, $endDate);
    }
    return [];
  }

  public function loadSprintIssues($sprint){
    $allIssues = $this->githubService->getIssues($this->org, $this->repo, $sprint['number']);
    // Load ZenhubData
    foreach ($allIssues as $i => $issue) {
      $allIssues[$i]['zenhub'] = $this->zenhubService->getIssueData($this->repoInfo['id'], $issue['number']);
    }
    return $allIssues;
  }



}

?>
