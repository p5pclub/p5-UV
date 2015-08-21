use strict;
use warnings;
use UV;

my $port = $ARGV[0] || 0;

my $server = UV::tcp_init();
my $ret;

$ret = UV::tcp_bind($server, '0.0.0.0', $port);
die UV::strerror($ret) if $ret < 0;

$ret = UV::listen($server, 128, sub {
    my $client = UV::tcp_init();
    $ret = UV::accept($server, $client);
    die UV::strerror($ret) if $ret < 0;

    UV::read_start($client, sub {
        my ($nread, $buf) = @_;

        if ($nread < 0) {
            if ($nread != UV::EOF) {
                warn UV::strerror($nread);
            }
            UV::close($client);
        }
        elsif ($nread > 0) {
            UV::write($client, $buf);
        }
    });

});
die UV::strerror($ret) if $ret < 0;

UV::run();
