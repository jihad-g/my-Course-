<?php

//test git hub

function getCar($name)
{

    $name = strtolower($name);

    switch ($name) {
        case "nissan":
            return nissan();
        case "bmw":
            return  BMW();
        case "kia":
            return  kia();
        case "alfa":
            return  Alfa();

    default:
    return defualt();
    }
}
function defualt()
{

    return [
        'barnd' => 'not found',
        'type' => 'not found',
        'eng' => 'not found',
        'hp' => 'not found',

    ];

}
function nissan()
{
    return [
        'barnd' => 'nissan',
        'type' => 'GTR',
        'eng' => 'rb26',
        'hp' => '283hp',

    ];
}
function Bmw()
{
    return [
        'barnd' => 'Bmw',
        'type' => 'F10',
        'eng' => '535i',
        'hp' => '450',

    ];
}
function kia()
{
    return [
        'barnd' => 'kia',
        'type' => 'rio',
        'eng' => '16doch',
        'hp' => '120',

    ];
}
function Alfa()
{
    return [
        'barnd' => 'Alfa',
        'type' => 'Giulia',
        'eng' => 'gmet4',
        'hp' => '280',

    ];
}


$data = getCar('bMjjw');

echo "<h1>car brand is " . $data['barnd'] . "</h1>";
echo "<p>modle =" . $data['type'] . "</p>";
echo "<p>eng =" . $data['eng'] . "</p>";
echo "<p>hp =" . $data['hp'] . "</p>";
