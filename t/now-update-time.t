use strict;
use warnings;
use Test::More;

use UV;

{
    my $before = UV::now();
	isnt $before, 0;
	sleep(0.01);
	UV::update_time();
    my $after = UV::now();
	isnt $before, $after;
}

done_testing;
