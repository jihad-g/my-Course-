<?php

function calculat($num1, $num2, $sign)
{
    validation($num1, $num2, $sign);
    $func = getAvailableOperations();
    $f = $func[$sign];
    return call_user_func($f, $num1, $num2);
}

function validation($num1, $num2, $sign)
{
    isNumerical($num1, $num2);
    operationNotFound($sign);
    cannotDivideByZero($num2, $sign);
    sqrMustBePositive($num1, $sign);
    rootMustBePositive($num1, $sign);
}

function isNumerical($num1, $num2)
{
    if (!is_numeric($num1) || !is_numeric($num2)) {
        throw new Exception('num1 and num2 must be numbers');
    }
}

function getAvailableOperations()
{
    return [
        '+' => 'add',
        '-' => 'minus',
        '*' => 'multiply',
        '/' => 'division',
        'sqr' => 'sqr',
        'cubeRoot' => 'cubeRoot',
        'twice' => 'twice',
        'circle' => 'circle',
        'pow' => 'power',
    ];
}

function operationNotFound($sign)
{
    $func = getAvailableOperations();
    if (!isset($func[$sign])) {
        throw new Exception('Operation not found');
    }
}

function cannotDivideByZero($num2, $sign)
{
    if ($num2 == 0 && $sign == '/') {
        throw new Exception("Cannot divide by zero");
    }
}

function sqrMustBePositive($num1, $sign)
{
    if ($num1 < 0 && $sign == 'sqr') {
        throw new Exception("num1 must be more than zero");
    }
}

function rootMustBePositive($num1, $sign)
{
    if ($num1 < 0 && $sign == 'cubeRoot') {
        throw new Exception("num1 must be more than zero");
    }
}

function power($num1, $num2)
{
    return pow($num1, $num2);
}

function circle($num1)
{
    return $num1 * 3.14;
}

function cubeRoot($num1)
{
    return pow($num1, 1/3);
}

function sqr($num1)
{
    return $num1 * $num1;
}

function add($num1, $num2)
{
    return $num1 + $num2;
}

function minus($num1, $num2)
{
    return $num1 - $num2;
}

function multiply($num1, $num2)
{
    return $num1 * $num2;
}

function division($num1, $num2)
{
    return $num1 / $num2;
}

function twice($num1)
{
    return $num1 * 2;
}

function unknown()
{
    return 'unknown operation';
}

?>