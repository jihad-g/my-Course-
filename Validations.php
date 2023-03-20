<?php

function number($value)
{
    return is_numeric($value);
}
function requirde($value)
{
    return isset($value);
}

function In($value,$array)
{
return isset($array[$value]);
}