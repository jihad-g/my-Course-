<?php






echo calcShapeArea('circil', ["4,d5"]);


function isValid($shape_name, $parms =[] )
{

    foreach ($parms as $element) {
        if (!is_numeric($element)) {
           
            return "$element is not numeric";
       
        }

        if (!function_exists($shape_name)) return "the shape not found ";
       
        if (get_func_argNames($shape_name) != count($parms)) return "check paramert number ";
        
        
        return  true;
    }
   
}


function get_func_argNames($funcName)
{
    
    $pa = new ReflectionFunction($funcName);
   // echo '<pre>' . print_r(get_class_methods($pa), true);

    return count($pa->getParameters());
}


function calcShapeArea($shape_name, $parms = [])
{

   $r= isValid($shape_name,$parms);
   
   if (is_string($r)) return $r;
    
  return  call_user_func_array($shape_name, $parms);
    
    
   
}



function rect($w, $h)
{
    return $w * $h;
}
function circil($r)
{
    return $r * $r * 3.14;
}
function squar($w)
{
    return $w * $w;
}
function tripziod($w)
{
    return $w * $w;
}
function defualt()
{
    return "not found ,do you want to add it!";
}

