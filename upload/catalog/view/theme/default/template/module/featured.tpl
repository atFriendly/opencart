<!--
<h3>
    <?php echo $heading_title; ?>
</h3>
-->
<!--
<div id="flow-buttons" class="flow-buttons" >
    <button type="button" class="btn btn-primary btn-lg" onclick="updateProductToCart();">
        <i class="fa fa-shopping-cart"></i>
        <span class="hidden-xs hidden-sm"><?php echo $button_checkout; ?></span>
    </button>
</div>
-->
<div class="row">
    <div class="col-sm-12">
        <div class="table-responsive">
            <table class="products table table-bordered">
                <thead>
                    <tr>
                        <td class="text-center"><?php echo "$text_sn" ?></td>
                        <td class="text-center"><?php echo $text_image; ?></td>
                        <td class="text-center"><?php echo $text_model; ?></td>
                        <td class="text-center"><?php echo $text_name; ?></td>
                        <td class="text-center"><?php echo $text_price; ?></td>
                        <td class="text-center"><?php echo $text_quantity; ?></td>
                        <td class="text-center"><?php echo $text_sub_total; ?></td>
                    </tr>
                </thead>
                <tbody>
                    <?php
                        $row_index = 0;
                        foreach ($products as $product) {
                            $row_index++;
                    ?>
                    <tr>
                        <td class="row-number text-right  text-v-align-middle">
                            <?php echo $row_index; ?>
                        </td>
                        <td class="text-center text-v-align-middle" style="padding: 0px;">
                            <?php if ($product['thumb']) { ?>
                            <a href="<?php echo $product['href']; ?>">
                                <img src="<?php echo $product['thumb']; ?>" alt="<?php echo $product['name']; ?>"
                                     title="<?php echo $product['name']; ?>" class="img-thumbnail" style="padding: 0px; border: none;"/>
                            </a>
                            <?php } ?>
                        </td>
                        <td class="model text-left text-v-align-middle" data-id="<?php echo $product['product_id']; ?>">
                            <span class="model">
                                <?php echo $product['model']; ?>
                            </span>
                        </td>
                        <td class="name text-left text-v-align-middle">
                            <a href="<?php echo $product['href']; ?>">
                                <?php echo $product['name']; ?>
                            </a>
                        </td>
                        <td class="price text-right text-v-align-middle">
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
                        <td class="text-right text-v-align-middle">
                            <input class="form-control text-right" type="number" id="quantity" min="0" max="999" value="0" style="display: inline; font-size: 15px; padding: 4px;"/>
                        </td>
                        <td class="subtotal text-right text-v-align-middle">
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
            <span class="hidden-xs hidden-sm"><?php echo $button_checkout; ?></span>
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
        //先移除之前購物車的內容
        cart.removeAll(function (success) {
            //將畫面上的訂購內容加到購物車
            var orders = [];
            for (var i = 0; i < rows.length; i++) {
                var productId = $($(rows[i]).find("td.model")[0]).data("id");
                var productName = $(rows[i]).find("td.name")[0].innerText;
                var qty = $(rows[i]).find("#quantity").val();
                if (qty > 0) {
//                    console.log("訂購產品:[" + productName + "], id:[" + productId + "], 數量:[" + qty + "]");
//                    cart.add(productId, qty);
                    var order = {
                        "product_id": productId,
                        "quantity": qty
                    };
                    orders.push(order);
                }
            }
            console.log("訂購商品資訊:" + JSON.stringify(orders));
            if (orders.length > 0) {
                cart.addAll(JSON.stringify(orders), function () {
                    //訂購callback再轉址到結帳頁面
                    document.location.href = "<?php echo $checkout; ?>";
                });
            }
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
            $(rows[i]).find("td.subtotal")[0].innerText = subTotal;
            totalPrice += subTotal;
        }
        console.log("目前訂單總金額:" + totalPrice);
        $("#totalPrice").text(totalPrice);
    }
    //取得商品小計
    function getSubTotal(qty, price) {
        try {
//            console.log("price:" + price.replace(/\$/gi, '').replace(/,/gi, ''));
            return parseInt(Number(qty) * Number(price.replace(/\$/gi, '').replace(/,/gi, '')));
        }
        catch (e) {
            console.error("取商品小計發生錯誤！\n" + e);
            return 0;
        }
    }
    //數量範圍、型態控制
    $(document).delegate("#quantity", "change", function () {
        var min = Number($(this).attr('min'));
        var max = Number($(this).attr('max'));
        var quantity = parseInt($(this).val());
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
        /*
        $(document).bind("scroll resize", function () {
            var _this = $(this);
            var _this_top = _this.scrollTop();

            if (_this_top < 100) {
                $('#flow-buttons').stop().animate({top: "93px"});
            }
            if (_this_top > 100) {
                $('#flow-buttons').stop().animate({top: "10px"});
            }
        }).scroll();
        */
        console.log('總產品數量:' + '<?php echo count($products); ?>');

        var cart_products = JSON.parse('<?php echo json_encode($cart_products); ?>');
        for (var i = 0; i < cart_products.length; i++) {
            var product = cart_products[i];
            restoreProductQtyFromCart(product.product_id, product.quantity);
        }
        countTotalPrice();
    });
//--></script>
