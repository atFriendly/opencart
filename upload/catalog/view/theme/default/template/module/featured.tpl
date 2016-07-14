<!--
<h3>
    <?php echo $heading_title; ?>
</h3>
-->
<div class="row">
    <div class="col-sm-12">
        <div class="table-responsive">
            <table class="products table table-bordered">
                <thead>
                    <tr>
                        <td class="text-right"><?php echo "No." ?></td>
                        <td class="text-left"><?php echo $text_model; ?></td>
                        <td class="text-left"><?php echo $text_name; ?></td>
                        <td class="text-right"><?php echo $text_price; ?></td>
                        <td class="text-right"><?php echo $text_quantity; ?></td>
                        <td class="text-right"><?php echo $text_sub_total; ?></td>
                    </tr>
                </thead>
                <tbody>
                    <?php
                        $row_index = 0;
                        foreach ($products as $product) {
                            $row_index++;
                    ?>
                    <tr>
                        <td class="row-number text-right">
                            <?php echo $row_index; ?>
                        </td>
                        <td class="model text-left" data-id="<?php echo $product['product_id']; ?>">
                            <span class="model">
                                <?php echo $product['model']; ?>
                            </span>
                        </td>
                        <td class="name text-left">
                            <a href="<?php echo $product['href']; ?>">
                                <?php echo $product['name']; ?>
                            </a>
                        </td>
                        <td class="price text-right">
                            <?php
                            if ($product['price'] or $product['special']) {
                                if ($product['special']) {
                                    echo $product['special'];
                                }
                                else {
                                    echo $product['price'];
                                }
                            }
                            ?>
                        </td>
                        <td class="text-right" align="right">
                            <input class="form-control" type="number" id="quantity" min="0" max="999" value="0" style="display: inline; font-size: 15px; "/>
                        </td>
                        <td class="subtotal text-right">
                            0
                        </td>
                    </tr>
                    <?php } ?>
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-sm-4 col-sm-offset-8">
        <table class="table table-bordered">
            <tr>
                <td class="text-right">
                    <strong><?php echo $text_total; ?></strong>
                </td>
                <td class="text-right">
                    <span id="totalPrice" class="total-price">
                        0
                    </span>
                </td>
            </tr>
        </table>
    </div>
</div>
<div class="buttons">
    <div class="pull-right">
        <button type="button" class="btn btn-primary btn-lg" onclick="updateProductToCart();">
            <i class="fa fa-shopping-cart"></i>
            <span class="hidden-xs hidden-sm hidden-md"><?php echo $button_checkout; ?></span>
        </button>
    </div>
</div>
<script type="text/javascript"><!--
    //將購物車上的商品訂購資訊還原到畫面上
    function restoreProductQtyFromCart(productId, qty) {
        var rows = $('table.products.table-bordered tbody tr');
        for (var i = 0; i < rows.length; i++) {
            var rowProductId = $($(rows[i]).find("td.model")[0]).data("id");
//            console.log("rowProductId:" + rowProductId + ", productId:" + productId);
            if (rowProductId == productId) {
                $(rows[i]).find("#quantity").val(qty);
                break;
            }
        }
    }
    //將所有商品的訂購數量更新到購物車上
    function updateProductToCart() {
        var rows = $('table.products.table-bordered tbody tr');
//        for (var i = 0; i < rows.length; i++) {
//            var productId = $($(rows[i]).find("td")[0]).data("id");
//            cart.remove(productId);
//        }
        cart.removeAll(function (success) {
            //alert(success);
            for (var i = 0; i < rows.length; i++) {
                var productId = $($(rows[i]).find("td.model")[0]).data("id");
                var productName = $(rows[i]).find("td.name")[0].innerText;
                var qty = $(rows[i]).find("#quantity").val();
                if (qty > 0) {
                    console.log("訂購產品:[" + productName + "], id:[" + productId + "], 數量:[" + qty + "]");
                    cart.add(productId, qty);
                }
            }

//            setTimeout(function () {
//                document.location.href = "<?php echo $checkout; ?>";
//            }, 1000);
        });
    }
    //計算每個產品的小計及總金額
    function countTotalPrice() {
        var rows = $('table.products.table-bordered tbody tr');
        var totalPrice = 0;
        for (var i = 0; i < rows.length; i++) {
            var qty = $(rows[i]).find("#quantity").val();
            var price = $(rows[i]).find("td.price")[0].innerText;
            var subTotal = getSubTotal(qty, price);
//            console.debug($($(rows[i]).find("td")[0]).data("id"));
            $(rows[i]).find("td.subtotal")[0].innerText = subTotal;
            totalPrice += subTotal;
        }
        console.log("目前訂單總金額:" + totalPrice);
        $("#totalPrice").text(totalPrice);
    }
    //取得商品小計
    function getSubTotal(qty, price) {
        try {
            return parseInt(Number(qty) * Number(price.replace(/,/gi, '')));
        }
        catch (e) {
            console.error("取商品小計發生錯誤！\n" + e);
            return 0;
        }
    }
    //數量範圍、型態控制
    $(document).delegate("#quantity", "blur", function () {
        var min = Number($(this).attr('min'));
        var max = Number($(this).attr('max'));
        var quantity = parseInt($(this).val());
//        console.debug('Qty:' + quantity + ', min:' + min + ', max:' + max + ', Qty > max:' + (quantity > max));
        if (!quantity || quantity < 0) {
            $(this).val(min);
        }
        else if (quantity > max) {
            $(this).val(max);
        }
        else {
            $(this).val(quantity);
        }
        countTotalPrice();
    });

    $(document).ready(function () {
        console.log('總產品數量:' + '<?php echo count($products); ?>');

        var cart_products = JSON.parse('<?php echo json_encode($cart_products); ?>');
//        console.log(cart_products.length);
        for (var i = 0; i < cart_products.length; i++) {
            var product = cart_products[i];
//            console.log("product_id:" + product.product_id + ", qty:" + product.quantity);
            restoreProductQtyFromCart(product.product_id, product.quantity);
        }
        countTotalPrice();
    });
//--></script>
