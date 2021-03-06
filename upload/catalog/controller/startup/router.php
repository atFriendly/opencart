<?php
class ControllerStartupRouter extends Controller {
	public function index() {
		// Route
		if (isset($this->request->get['route']) && $this->request->get['route'] != 'startup/router') {
			$route = $this->request->get['route'];
		} else {
			$route = $this->config->get('action_default');
		}

		//非登入行為下, 需要例外放行的連結 加在這裡
		$this->load->model('account/customer');
		if (!$this->customer->isLogged() ) {
			if(!isset($this->request->get['route'])){
				$route = $this->config->get('action_login');
			}else if(isset($this->request->get['route']) && ($this->request->get['route'] != 'account/register' && $this->request->get['route'] != 'account/account'
					&& $this->request->get['route'] != 'account/register/customfield'
					&& $this->request->get['route'] != 'account/account/country'
					&& $this->request->get['route'] != 'api/login'
				)){
				$route = $this->config->get('action_login');
			}
		}

		// Sanitize the call
		$route = str_replace('../', '', (string)$route);
		
		// Trigger the pre events
		$result = $this->event->trigger('controller/' . $route . '/before', array(&$route, &$data));
		
		if (!is_null($result)) {
			return $result;
		}
		
		// We dont want to use the loader class as it would make an controller callable.
		$action = new Action($route);
		
		// Any output needs to be another Action object.
		$output = $action->execute($this->registry); 
		
		// Trigger the post events
		$result = $this->event->trigger('controller/' . $route . '/after', array(&$route, &$data, &$output));
		
		if (!is_null($result)) {
			return $result;
		}
		
		return $output;
	}
}
