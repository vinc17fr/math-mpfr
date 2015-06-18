use warnings;
use strict;
use Math::MPFR qw(:mpfr);

print"1..3\n";

print  "# Using Math::MPFR version ", $Math::MPFR::VERSION, "\n";
print  "# Using mpfr library version ", MPFR_VERSION_STRING, "\n";
print  "# Using gmp library version ", Math::MPFR::gmp_v(), "\n";

my ($sum, @obj);
my $rop = Math::MPFR->new();

for(my $i = int(rand(201)); $i < 10000; $i++) {
   push @obj, Math::MPFR->new($i);
   $sum += $i;
}

my $ret = Rmpfr_sum($rop, \@obj, scalar(@obj), GMP_RNDN);

if($sum == $rop) {print "ok 1\n"}
else {
  warn "\n   Got $rop\n   Expected $sum\n";
  print "not ok 1\n";
}

Rmpfr_add_si($rop, $rop, -1, GMP_RNDN);

if($rop == $sum - 1) {print "ok 2\n"}
else {
  warn "\n   Got $rop\n   Expected ", $sum - 1, "\n";
  print "not ok 2\n";
}

my $size = @obj + 1;
my $max = $size - 1;
eval {Rmpfr_sum($rop, \@obj, $size, GMP_RNDN)};

if($@ =~ /2nd last arg \($size\) needs to be between 0 and $max \(inclusive\)/) {print "ok 3\n"}
else {
  warn "\n\$\@: $@\n";
  print "not ok 3\n";
}
