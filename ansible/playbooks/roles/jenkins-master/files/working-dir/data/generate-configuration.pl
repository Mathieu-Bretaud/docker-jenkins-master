 #!/usr/bin/env perl
use strict;
use warnings;
use Env qw(http_proxy);
use Env qw(JENKINS_HOME);
use File::Basename;
use File::Path qw/make_path/;

############## .ssh/config

my $file = $JENKINS_HOME . "/.ssh/config";

open(my $fh, '>', $file);
print $fh "Host github.com\n";
print $fh "    User git\n";
print $fh "    HostName github.com\n";
print $fh "    IdentityFile ~/.ssh/id_rsa\n";

if (defined $http_proxy && $http_proxy =~ m/[a-z]*:\/\/((.*?):(.*?)@)?(.*):(.*)/) {
   print $fh "    ProxyCommand socat - PROXY:$4:%h:%p,proxyport=$5";
   if (defined $2) {
       print $fh ",proxyauth=$2";
   }

   if (defined $3) {
       print $fh ":$3";
   }
}

close $fh;