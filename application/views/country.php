A page all about: <?=$country->name;?>



<ul>
<? foreach( $countries as $country ) : ?>
<li><img src="http://static01.pubjury.com/images/flags/<?=$country->iso;?>.png" /> <?=html::anchor('phoneinfo/country/' . $country->iso, $country->name);?></li>

<? endforeach; ?>
</ul>