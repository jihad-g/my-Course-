<?php
/*$old_error_handler =set_error_handler('handel');
echo 'old handel'.$old_error_handler ;
function handel($errno, $errstr, $errfile, $errline)
{
echo 'error';
}
*/
echo calculat(30,0,'cubeRoot');
function calculat($num1,$num2,$sign)
{
  
    validation($num1,$num2,$sign);
    $func=getAvlibaleOpartion();
    $f=$func[$sign];
   return  call_user_func($f,$num1,$num2);
   // AfterExcution();
    
}

function validation($num1,$num2,$sign)
{
isnumrical($num1,$num2);
oparationNotFound($sign);
canNotDivideByZero($num2 ,$sign);
sqrMustBePostive($num1,$sign);
rootMustBePostive($num1,$sign);
rMustBePostive($num1,$sign);
}
function isnumrical($num1,$num2)
{
    if ((is_numeric($num1)) && is_numeric($num2)) return ;
     throw new Exception('num1 or num2 must be number');

     
}
function getAvlibaleOpartion()
{
    return [ '+'=>'ADD','-'=>'MINUS','*'=>'multiply','/'=>'division','sqr'=>'sqr','cubeRoot'=>'cubeRoot','twice'=>'twice','circle'=>'circle' ];
}
function oparationNotFound($sign)
{
    $func=getAvlibaleOpartion();
  
    if (isset($func[$sign])) return ;
    throw new Exception('Opration not found');
}
function canNotDivideByZero($num2,$sign)
{
    if ($num2 == 0 && $sign == "/")  
{throw new Exception("can't divide by zero"); }
return ;
}
function sqrMustBePostive($num1,$sign){
    if ($num1 < 0 && $sign == "sqr")  
    {throw new Exception("num1 must be more than zero"); }
}
function rootMustBePostive($num1,$sign){
    if ($num1 < 0 && $sign == "cubeRoot")  
    {throw new Exception("num1 must be more than zero"); }
}
function rMustBePostive($num1,$sign){
    if ($num1 < 0 && $sign == "circle")  
    {throw new Exception("num1 must be more than zero"); }
}
function circle($num1)
{
    return circle($num1*3.14);
}
function cubeRoot($num1)
{
    return cubeRoot($num1*0.3);
}
function sqr($num1)
{
    return sqr($num1);
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
function twice($num1)
{
    return twice($num1*$num1);
}

function unkown()
{
    return 'unkown opration';
}