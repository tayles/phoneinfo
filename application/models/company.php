<?php

class Company_Model extends ORM {
	
	protected $belongs_to = array('country');
	
	protected $has_many = array('comments');
	
} // ssalc