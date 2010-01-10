<?php defined('SYSPATH') OR die('No direct access allowed.');

class PhoneInfo_Controller extends Template_Controller {

	// Set the name of the template to use
	public $template = 'template';
	
	public function __construct() {
		parent::__construct();
		
		$this->countries = ORM::factory('country')->find_all();
	}

	public function index() {

		$this->template->content = new View('home');
		
		$this->template->content->countries = $this->countries;

	}
	
	public function countries() {
		
		$countries = ORM::factory('country')->select_list('iso', 'name');
		
		$this->template->content = new View('countries');
		
		$this->template->content->countries = $countries;
	}
	
	public function country( $iso ) {
		
		$country = ORM::factory('country')->where('iso', $iso)->find();

		$this->template->content = new View('country');
		
		$this->template->content->country = $country;
	}
	
	public function areaCode( $area_code ) {
		
		$area = ORM::factory('area_code')->where('code', $area_code)->find();
		
		if( !$area->loaded ) {
			url::redirect('/');
		}

		$this->template->content = new View('area_code');
		
		$this->template->content->area = $area;
	}
	
	public function phoneNumber( $tel ) {
		
		$num = ORM::factory('number')->where('tel', $tel)->find();

		$this->template->content = new View('number');
		
		$this->template->content->num = $num;
	}
	
}