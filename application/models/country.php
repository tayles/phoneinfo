<?php

class Country_Model extends ORM {
	
	protected $has_many = array('companies', 'numbers', 'area_codes', 'calling_codes', 'intl_prefixes');
	
} // ssalc