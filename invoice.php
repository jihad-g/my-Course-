<?php



$product = [
    
        'chess' =>5,
        'juice' =>6, 
        'milk' =>4.5
    
    ];
$rule = ['discount','summar'];

function calacTotalRule($product,$rule=[],$tax = true)
{


    $total = array_sum($product);
    
    $total = getRules($total,$rule);
    
    

    
    return $total;


}
function calacTotalTax($product,$rule=[],$tax = true)
{


    $total = array_sum($product);
    
    $total = getRules($total,$rule);
    
    $total = ($tax)? $total+$total*.05:$total;

    
    return $total;


}

function calacTotalRow($product,$rule=[],$tax = true)
{

    $total = array_sum($product);
    

    
    return $total;


}

function getRules($total,$rule)
{
    foreach ($rule as $key=>$value)
    {
       $total= call_user_func($value.'Rule',$total);
    
    }return $total;
}

function discountRule ($total)
{
   return $total - ($total * 0.1);
}
function summarRule ($total)
{
   return $total - ($total * 0.2);
}