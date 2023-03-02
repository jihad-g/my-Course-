<?php

echo fact(5);



   function fact($number) {    
    return ($number <= 1)?1: ($number*fact($number-1)); 
   }