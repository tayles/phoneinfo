<?php

class Comment_Model extends ORM {
	
	protected $belongs_to = array('number');
	
	protected $has_many = array('reports');
	
} // ssalc