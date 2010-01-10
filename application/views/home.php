Call from
<?=form::dropdown('call_from', $countries, 'gb');?>
to
<?=form::dropdown('call_from', $countries, 'us');?>
<?=form::submit('Go');?>



<?=html::anchor('phoneinfo/countries', 'All countries');?>