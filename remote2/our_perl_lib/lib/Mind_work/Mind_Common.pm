package Mind_Common;

use warnings;
use strict;

use XML::Simple;

sub generate_random_string {
  my $length_of_randomstring=shift;
  my @chars=('a'..'z','A'..'Z','0'..'9','_');
  my $random_string;
  foreach (1..$length_of_randomstring) {
    $random_string.=$chars[rand @chars];
  }
  return $random_string;
}

sub xmlfile_to_hash {
    my $file = shift;
    my $xml = new XML::Simple;
    return $xml->XMLin("$file");
}

sub hash_to_xmlfile {
    my ($hash, $name) = @_;
    my $xs = new XML::Simple();
    my $xml = $xs->XMLout($hash,
		    NoAttr => 1,
		    RootName => "machine",
		    OutputFile => $name
		    );
}

return 1;
