<?php

function addNumbers($chap, int $a, int $b)
{

   if ($chap == "t") {
      echo $a / 2 * $b;
   } elseif ($chap == "s") {
      echo $a * 2;
   } elseif ($chap == "c") {
      echo $a / 2 * 3.14;
   } else {
      echo "none sanse";
   }
}
addNumbers("c", 20, 0);


function tripziod()
{
   
}

#function trg(){
 # return [
  
  # "the space of your triangle is L/2 x H"
 # ]
#}

#function sq(){
#   "the space of your squar is L x 2"
#}

#function ci(){
 #  "the space of your circil is R/2 x 3.14"
#}

#function getchap(){

#}