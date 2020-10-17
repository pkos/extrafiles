use strict;
use warnings;
use Term::ProgressBar;
use File::Copy;

#init
my $substringmove = "-move";
my $substringh = "-h";
my $movefiles = "FALSE";
my @alllinesout;
my @linesextra;
my @linesstandard;

#check command line
foreach my $argument (@ARGV) {
  if ($argument =~ /\Q$substringh\E/) {
    print "extrafiles v0.5 - Utility to compare the filenames in two directories, the source and standard directories.\n";
    print "                  Then move extra files from the source directory to source ../extra that do not have\n";
    print "                  matching filenames in the standard directory.\n";
    print "\n";
    print "with extrafiles [options] [directory of files to move..] [directory of files to compare to..]\n";
    print "\n";
    print "Options:\n";
    print "  -move       move files to the ../extra subdirectory, otherwise just log.\n";
    print "\n";
    print "Example:\n";
    print '              extrafiles "D:/Atari - 2600/Source" "D:/Atari - 2600/Standard"' . "\n";
    print "\n";
    print "Author:\n";
    print "   Discord - Romeo#3620\n";
    print "\n";
    exit;
  }
  if ($argument =~ /\Q$substringmove\E/) {
    $movefiles = "TRUE";
  }
}

#set paths and system variables
if (scalar(@ARGV) < 2 or scalar(@ARGV) > 3) {
  print "Invalid command line.. exit\n";
  print "use: extrafiles -h\n";
  print "\n";
  exit;
}

my $extradir = $ARGV[-2];
my $standarddir = $ARGV[-1];

#debug
print "extra files directory: $extradir\n";
print "standard files directory: $standarddir\n";
my $tempstr;
$tempstr = $movefiles;
print "move files: " . $tempstr . "\n";

#exit no parameters
if ($extradir eq "" or $standarddir eq "") {
  print "Invalid command line.. exit\n";
  print "use: extrafiles -h\n";
  print "\n";
  exit;
}

#read extra directory contents
my $dirname = $extradir;
opendir(DIR, $dirname) or die "Could not open $dirname\n";
while (my $filename = readdir(DIR)) {
  if (-d $filename) {
    next;
  } else {
    push(@linesextra, $filename) unless $filename eq '.' or $filename eq '..';
  }
}
closedir(DIR);

#read standard directory contents
$dirname = $standarddir;
opendir(DIR, $dirname) or die "Could not open $dirname\n";
while (my $filename = readdir(DIR)) {
  if (-d $filename) {
    next;
  } else {
    push(@linesstandard, $filename) unless $filename eq '.' or $filename eq '..';
  }
}
closedir(DIR);

unless(mkdir $extradir . "/extra") {print "WARNING: Unable to create ../extra directory or already exists.\n"};

my $max = scalar(@linesextra);
my $progress = Term::ProgressBar->new({name => 'progress', count => $max});
my $totalmatches = 0;
my $match;

#loop though each file
OUTER: foreach my $extraline (@linesextra)
{
   $progress->update($_);
   $match = 0;
   
   foreach my $standardline (@linesstandard) 
   {
      #check for exact match between filenames
      if (lc $standardline eq lc $extraline)
      {
         $match = 1;
         $totalmatches++;
         push(@alllinesout, ["MATCHED: ", "$extraline"]);
         next OUTER;
      }
   }
   
   if ($match == 0)
   {
      push(@alllinesout, ["EXTRA FILE: ", "$extraline"]);
	  if ($movefiles eq "TRUE")
      {
         rename $extradir . "/" . $extraline, $extradir . "/extra/" . $extraline;
         push(@alllinesout, ["MOVED: ", "$extraline"]);		 
      }
   }
}

#print total have
my $totalnames = 0;
$totalnames = scalar(@linesextra);
print "\ntotal matches: $totalmatches of $totalnames\n";

#open log file and print all sorted output
open(LOG, ">", "extra.txt") or die "Could not open extra.txt\n";
print LOG "move: " . $tempstr . "\n";
print LOG "total matches: $totalmatches of $totalnames\n";
print LOG "---------------------------------------\n";
my @sortedalllinesout = sort{$a->[1] cmp $b->[1]} @alllinesout;
my $i;
my $j;

for($i=0; $i<=$#sortedalllinesout; $i++)
{
  for($j=0; $j<2; $j++)
  {
    print LOG "$sortedalllinesout[$i][$j] ";
  }
  print LOG "\n";
}
close (LOG);

#print log filename
print "log file: extra.txt\n";
exit;