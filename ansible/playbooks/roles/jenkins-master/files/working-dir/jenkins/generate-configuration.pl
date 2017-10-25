 #!/usr/bin/env perl
use strict;
use warnings;
use Env qw(http_proxy);

############## proxy.xml
if (defined $http_proxy && $http_proxy =~ m/[a-z]*:\/\/((.*?):(.*?)@)?(.*):(.*)/) {	
   open(my $fh, '>', '/usr/share/jenkins/ref/proxy.xml.override');
   print $fh "<?xml version='1.0' encoding='UTF-8'?><proxy>";
   
   if (defined $2) {
       print $fh "<userName>$2</userName>";
   }

   if (defined $3) {
       print $fh "<password>$3</password>";
   }
   print $fh "<name>$4</name><port>$5</port><testUrl>http://www.google.fr</testUrl></proxy>";
   close $fh;
}
