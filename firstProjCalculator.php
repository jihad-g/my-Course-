<?php
/*$old_error_handler =set_error_handler('handel');
echo 'old handel'.$old_error_handler ;
function handel($errno, $errstr, $errfile, $errline)
{
echo 'error';
}
*/
echo calculat(0,0,'/');
function calculat($num1,$num2,$sign)
{
  
    validation($num1,$num2,$sign);
    $func=[ '+'=>'ADD','-'=>'MINUS','*'=>'multiply','/'=>'division' ];
    $f=$func[$sign];
   return  call_user_func($f,$num1,$num2);
   // AfterExcution();
    
}

function validation($num1,$num2,$sign)
{
isnumrical($num1,$num2);
oparationNotFound($sign);
canNotDivideByZero($num2 ,$sign);
}
function isnumrical($num1,$num2)
{
    if ((is_numeric($num1)) && is_numeric($num2)) return ;
     throw new Exception('num1 or num2 must be number');

     
}
function oparationNotFound($sign)
{
    $func=[ '+'=>'ADD','-'=>'MINUS','*'=>'multiply','/'=>'division' ];
  
    if (isset($func[$sign])) return ;
    throw new Exception('Opration not found');
}
function canNotDivideByZero($num2,$sign)
{
    if ($num2 == 0 && $sign == "/")  
{throw new Exception("can't divide by zero"); }
return ;
}
function excuteValidation($validations)
{

}
function add($num1,$num2)
{
return $num1+$num2; 
}
function minius($num1,$num2,$bra)
{
    return $num1-$num2; 
}
function multiply ($num1,$num2)
{
    return $num1*$num2; 
}
function division($num1,$num2)
{
    return $num1/$num2; 
}

function unkown()
{
    return 'unkown opration';
}