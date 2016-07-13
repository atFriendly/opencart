<!--
<h3>
    <?php echo $heading_title; ?>
</h3>
-->
<div class="row">
    <?php foreach ($products as $product) { ?>
    <div class="product-layout col-lg-3 col-md-3 col-sm-6 col-xs-12" style="padding-left: 10px; padding-right: 10px;">
        <div class="product-thumb transition">
            <!--
            <div class="image">
                <a href="<?php echo $product['href']; ?>">
                    <img src="<?php echo $product['thumb']; ?>" alt="<?php echo $product['name']; ?>" title="<?php echo $product['name']; ?>" class="img-responsive"/>
                </a>
            </div>
            -->
            <div class="caption">
                <h4>
                    <a href="<?php echo $product['href']; ?>"><?php echo $product['name']; ?></a>
                </h4>
                <!--
                <p>
                    <?php echo $product['description']; ?>
                </p>
                -->
                <!--
                <?php if ($product['rating']) { ?>
                <div class="rating">
                    <?php for ($i = 1; $i <= 5; $i++) { ?>
                    <?php if ($product['rating'] < $i) { ?>
                    <span class="fa fa-stack"><i class="fa fa-star-o fa-stack-2x"></i></span>
                    <?php } else { ?>
                    <span class="fa fa-stack"><i class="fa fa-star fa-stack-2x"></i><i
                                class="fa fa-star-o fa-stack-2x"></i></span>
                    <?php } ?>
                    <?php } ?>
                </div>
                <?php } ?>
                -->
                <?php if ($product['price']) { ?>
                <p class="price">
                    <?php if (!$product['special']) { ?>
                    <?php echo $product['price']; ?>
                    <?php } else { ?>
                    <span class="price-new"><?php echo $product['special']; ?></span>
                    <span class="price-old"><?php echo $product['price']; ?></span>
                    <?php } ?>
                    <!--
                    <?php if ($product['tax']) { ?>
                    <span class="price-tax"><?php echo $text_tax; ?> <?php echo $product['tax']; ?></span>
                    <?php } ?>
                    -->
                </p>
                <?php } ?>
            </div>
            <div style="background-color: #EEE;">
                <table>
                    <tr>
                        <td>
                            <input class="form-control" type="number" id="quantity" min="1" max="999" value="1" style="font-size: 15px; width:80px; height: 41px;"/>
                        </td>
                        <td width="100%">
                            <div class="button-group" style="white-space: nowrap;">
                                <button type="button" style="width: 100%;"
                                        onclick="cart.add('<?php echo $product['product_id']; ?>', $('#quantity').val());">
                                    <i class="fa fa-shopping-cart"></i>
                                    <span class="hidden-xs hidden-sm hidden-md"><?php echo $button_cart; ?></span>
                                </button>
                                <!--
                                <button type="button" data-toggle="tooltip" title="<?php echo $button_wishlist; ?>"
                                        onclick="wishlist.add('<?php echo $product['product_id']; ?>');"><i class="fa fa-heart"></i>
                                </button>
                                <button type="button" data-toggle="tooltip" title="<?php echo $button_compare; ?>"
                                        onclick="compare.add('<?php echo $product['product_id']; ?>');"><i class="fa fa-exchange"></i>
                                </button>
                                -->
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <?php } ?>
</div>
<script type="text/javascript"><!--
    $(document).delegate("#quantity", "blur", function () {
        var min = Number($('#quantity').attr('min'));
        var max = Number($('#quantity').attr('max'));
        var quantity = $('#quantity').val();
        console.debug('Qty:' + quantity + ', min:' + min + ', max:' + max + ', Qty > max:' + (quantity > max));
        if (!quantity || quantity < 1) {
            $('#quantity').val(min);
        }
        else if (quantity > max) {
            $('#quantity').val(max);
        }
    });
//--></script>