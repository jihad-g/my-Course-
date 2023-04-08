<?php
include_once "calculator.php";

if(isset($_POST['submit'])) {
    $num1 = $_POST['num1'];
    $num2 = $_POST['num2'];
    $sign = $_POST['sign'];

    try {
        $result = calculat($num1, $num2, $sign);
    } catch (Exception $e) {
        $result = $e->getMessage();
    }
}
?>

<form method="POST">
    <input type="text" class="calculator-screen z-depth-1" value="<?php echo isset($result) ? $result : ''; ?>" disabled />

    <div class="calculator-keys">
        <input type="number" name="num1" value="<?php echo isset($num1) ? $num1 : ''; ?>" placeholder="Enter first number" required>
        <select name="sign">
            <option value="+">+</option>
            <option value="-">-</option>
            <option value="*">&times;</option>
            <option value="/">/</option>
            <option value="sqr">Square</option>
            <option value="cubeRoot">Cube Root</option>
            <option value="twice">Twice</option>
            <option value="circle">Circle</option>
            <option value="pow">Power</option>
        </select>
        <input type="number" name="num2" value="<?php echo isset($num2) ? $num2 : ''; ?>" placeholder="Enter second number" required>
        <button type="submit" name="submit" class="equal-sign operator btn btn-default" value="=">=</button>
    </div>
</form>