<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require '../vendor/autoload.php';
require '../src/config/settings.php';
require '../src/config/db.php';

// Loadind clasess
require_once('./../src/services/GithubService.php');
require_once('./../src/services/ZenhubService.php');
require_once('./../src/services/FreshdeskService.php');
require_once('./../src/utils/Utils.php');

$settings = require __DIR__ . '/../src/config/settings.php';
$app = new \Slim\App($settings);

/******************************************************************************/
// Get container
$container = $app->getContainer();

// Register component on container
$container['view'] = function ($container) {
    $view = new \Slim\Views\Twig('views');

    // Instantiate and add Slim specific extension
    $basePath = rtrim(str_ireplace('index.php', '', $container['request']->getUri()->getBasePath()), '/');
    $view->addExtension(new Slim\Views\TwigExtension($container['router'], $basePath));

    return $view;
};

/******************************************************************************/

// Homepage
require '../src/routes/application.php';

// Homepage
require '../src/routes/api/api.php';

$app->run();
