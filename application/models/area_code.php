<?php

class Area_Code_Model extends ORM {
	
	protected $belongs_to = array('country', 'number_type');
	
	protected $has_many = array('numbers');
	
} // ssalc