<?php
include("invoice.php");
$total_sum= calacTotalRule($product,$rule);
$total_row= calacTotalRow($product,$rule);
$total_tax = calacTotalTax($product,$rule);
?>


<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</head>

<div class="card">
<div class="card-header">
    invoice 
  </div>
    <div class="card-body mx-4">
      <div class="container">
        <p class="my-5 mx-5" style="font-size: 30px;">Thank for your purchase</p>
        <div class="row">
          <ul class="list-unstyled">
            <li class="text-black">John Doe</li>
            <li class="text-muted mt-1"><span class="text-black">Invoice</span> #12345</li>
            <li class="text-black mt-1">April 17 2021</li>
          </ul>
       
        </div>
<hr>
<?php
  foreach($product as $key=>$value)
echo'        <div class="row">
          <div class="col-xl-10">
            <p>'.$key.'</p>
          </div>
          <div class="col-xl-2">
            <p class="float-end">'.$value.'
            </p>
          </div>
          <hr>
        </div>
'?>
        <div class="row text-black">
  
          <div class="col-xl-12">
            <p class="float-end fw-bold">Row Total: <?=$total_row?>
            </p>
          </div>
          <hr style="border: 2px solid black;">
        </div>
        <div class="row text-black">
  
  <div class="col-xl-12">
    <p class="float-end fw-bold">Total: <?=$total_sum?>
    </p>
  </div>
  <hr style="border: 2px solid black;">
</div>
        <div class="row text-black">
  
          <div class="col-xl-12">
            <p class="float-end fw-bold">after taxes: <?=$total_tax?>
            </p>
          </div>
          <hr style="border: 2px solid black;">
        </div>
        
       
        <div class="text-center" style="margin-top: 90px;">
          <a><u class="text-info">View in browser</u></a>
          <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. </p>
        </div>
  
      </div>
    </div>
  </div>