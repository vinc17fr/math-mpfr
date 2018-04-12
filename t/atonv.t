use strict;
use warnings;
use Math::MPFR qw(:mpfr);

my $t = 4;

print "1..$t\n";

my $have_atonv;

$have_atonv = MPFR_VERSION <= 196869 ? 0 : 1;

if($have_atonv) {

  my($nv1, $nv2);

  my $ws = Rmpfr_init2($Math::MPFR::BITS);

  if($Config::Config{nvtype} eq 'double' ||
      ($Config::Config{nvtype} eq 'long double' && ($Config::Config{nvsize} == 8 ||
                                                    Math::MPFR::_required_ldbl_mant_dig() == 2098))) {
    $nv1 = atonv($ws, '0b0.100001e-1074');
    $nv2 = atonv($ws, '4.96e-324');
    if($nv1 == $nv2 && $nv1 > 0) {print "ok 1\n"}
    else {
      warn "\n \$nv1: $nv1\n \$nv2: $nv2\n";
      print "not ok 1\n";
    }

    if(Rmpfr_get_prec($ws) == $Math::MPFR::BITS) {print "ok 2\n"}
    else {
      warn "\n Precision has changed from $Math::MPFR::BITS to ", Rmpfr_get_prec($ws), "\n";
      print "not ok 2\n";
    }
  }

  elsif($Config::Config{nvtype} eq 'long double') {
    $nv1 = atonv($ws, '0b0.100001e-16445');
    $nv2 = atonv($ws, '3.7e-4951');
    if($nv1 == $nv2 && $nv1 > 0) {print "ok 1\n"}
    else {
      warn "\n \$nv1: $nv1\n \$nv2: $nv2\n";
      print "not ok 1\n";
    }

    if(Rmpfr_get_prec($ws) == $Math::MPFR::BITS) {print "ok 2\n"}
    else {
      warn "\n Precision has changed from $Math::MPFR::BITS to ", Rmpfr_get_prec($ws), "\n";
      print "not ok 2\n";
    }
  }

  elsif($Config::Config{nvtype} eq '__float128') {
    $nv1 = atonv($ws, '0b0.100001e-16494');
    $nv2 = atonv($ws, '6.5e-4966');
    if($nv1 == $nv2 && $nv1 > 0) {print "ok 1\n"}
    else {
      warn "\n \$nv1: $nv1\n \$nv2: $nv2\n";
      print "not ok 1\n";
    }

    if(Rmpfr_get_prec($ws) == $Math::MPFR::BITS) {print "ok 2\n"}
    else {
      warn "\n Precision has changed from $Math::MPFR::BITS to ", Rmpfr_get_prec($ws), "\n";
      print "not ok 2\n";
    }
  }

  else {
    warn "\n Unrecognized nvtype in atonv.t\n";
    print "not ok 1\nnot ok 2\n";
  }

  $nv1 = atonv($ws, '0.625');
  if($nv1 == 5 / 8) { print "ok 3\n"}
  else {
    warn "\n $nv1 != ", 5 / 8, "\n";
    print "not ok 3\n";
  }

  if(Rmpfr_get_prec($ws) == $Math::MPFR::BITS) {print "ok 4\n"}
  else {
    warn "\n Precision has changed from $Math::MPFR::BITS to ", Rmpfr_get_prec($ws), "\n";
    print "not ok 4\n";
  }
}
else {
  my $ws = Rmpfr_init2($Math::MPFR::BITS);
  eval{atonv($ws, '1234.5');};

  if($@ =~ /^The atonv function requires mpfr-3.1.6 or later/) {print "ok 1\n"}
  else {
    warn "\n \$\@: $@\n";
    print "not ok 1\n";
  }

  warn "\n Skipping tests 2 to $t - nothing else to check\n";
  print "ok $_\n" for 2 .. $t;
}

