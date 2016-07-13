<?php
class ControllerModuleFeatured extends Controller {
	public function index($setting) {
		$this->load->language('module/featured');
		$this->load->language('total/sub_total');
		$this->load->language('total/total');
		$this->load->language('checkout/cart');

		$data['heading_title'] = $this->language->get('heading_title');

		$data['text_tax'] = $this->language->get('text_tax');
		$data['text_name'] = $this->language->get('column_name');
		$data['text_model'] = $this->language->get('column_model');
		$data['text_quantity'] = $this->language->get('column_quantity');
		$data['text_price'] = $this->language->get('column_price');
		$data['text_sub_total'] = $this->language->get('text_sub_total');
		$data['text_total'] = $this->language->get('text_total');

		$data['button_cart'] = $this->language->get('button_cart');
		$data['button_wishlist'] = $this->language->get('button_wishlist');
		$data['button_compare'] = $this->language->get('button_compare');
		$data['button_checkout'] = $this->language->get('button_checkout');

		$this->load->model('catalog/product');

		$this->load->model('tool/image');

		$data['products'] = array();

		//取購物車已訂購的商品
		$data['cart_products'] = $this->cart->getProducts();
		//結帳頁面導向連結
		$data['checkout'] = $this->url->link('checkout/checkout', '', true);

		if (!$setting['limit']) {
			$setting['limit'] = 4;
		}

		if (!empty($setting['product'])) {
			$products = array_slice($setting['product'], 0, (int)$setting['limit']);

			foreach ($products as $product_id) {
				$product_info = $this->model_catalog_product->getProduct($product_id);

				if ($product_info) {
					if ($product_info['image']) {
						$image = $this->model_tool_image->resize($product_info['image'], $setting['width'], $setting['height']);
					} else {
						$image = $this->model_tool_image->resize('placeholder.png', $setting['width'], $setting['height']);
					}

					if ($this->customer->isLogged() || !$this->config->get('config_customer_price')) {
						$price = $this->currency->format($this->tax->calculate($product_info['price'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					} else {
						$price = false;
					}

					if ((float)$product_info['special']) {
						$special = $this->currency->format($this->tax->calculate($product_info['special'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					} else {
						$special = false;
					}

					if ($this->config->get('config_tax')) {
						$tax = $this->currency->format((float)$product_info['special'] ? $product_info['special'] : $product_info['price'], $this->session->data['currency']);
					} else {
						$tax = false;
					}

					if ($this->config->get('config_review_status')) {
						$rating = $product_info['rating'];
					} else {
						$rating = false;
					}

					$data['products'][] = array(
						'product_id'  => $product_info['product_id'],
						'thumb'       => $image,
						'name'        => $product_info['name'],
						'model'       => $product_info['model'],
						'description' => utf8_substr(strip_tags(html_entity_decode($product_info['description'], ENT_QUOTES, 'UTF-8')), 0, $this->config->get($this->config->get('config_theme') . '_product_description_length')) . '..',
						'price'       => $price,
						'special'     => $special,
						'tax'         => $tax,
						'rating'      => $rating,
						'href'        => $this->url->link('product/product', 'product_id=' . $product_info['product_id'])
					);
				}
			}
		}

		if ($data['products']) {
			return $this->load->view('module/featured', $data);
		}
	}
}