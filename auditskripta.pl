#!/usr/bin/perl 

# i found this script somewhere and modified it a bit 
# usage in kali: open terminal, go to root dir of webapp and then type ./auditskripta.pl > out.txt

use warnings;	
use strict;	
use File::Find;	#doing shit with many files
use Cwd;	#for getting the working directory
use Term::ANSIColor; #makes the output colored :)

my @dangercalls=qw( apache_child_terminate apache_setenv define_syslog_variables escapeshellarg escapeshellcmd eval exec fp fput ftp_connect ftp_exec ftp_get ftp_login ftp_nb_fput ftp_put ftp_raw ftp_rawlist highlight_file include ini_alter ini_get_all ini_restore inject_code mysql_pconnect openlog passthru php_uname phpAds_remoteInfo phpAds_XmlRpc phpAds_xmlrpcDecode phpAds_xmlrpcEncode popen posix_getpwuid posix_kill posix_mkfifo posix_setpgid posix_setsid posix_setuid posix_setuid posix_uname proc_close proc_get_status proc_nice proc_open proc_terminate shell_exec syslog system xmlrpc_entity_decode create_function require $_get $_post $_request ); #list of string
my $dir;
my $matchref;
my $line;
my $File;

unless (defined $ARGV[0]) {$dir = getcwd;} #if no directory is given, it works recursively from the current dir
else { $dir = $ARGV[0];}

my $pattern = join '|', map "($_)", @dangercalls; #make a monster-regex out of @dangercalls and wrap a () around every entry, join logical regex OR "|" 
						 #$pattern looks like: (apache_child_terminate)|(apache_setenv)| and so on

print "directory which files will be search recursively: ";
print colored ['blue'], "$dir";
print "\n";

sub wanted { 					#each file will be performed against the function(subroutine called in perl) wanted
	open (FILE, $File::Find::name) or die "can't open File: $!\n"; 				
		while($line= <FILE> ){	
			if ($line =~ /$pattern/i) {
    				$matchref = $#-;		#$#- is the perl built variable that holds the last matched regex-group					
    				
				print "Line #$.  matched $dangercalls[$matchref - 1] in $File::Find::name \n\n"; #output without color
				
				#print "line #";
				#print colored ['yellow'],"$. ";
				#print "matched ";
				#print colored ['green'], "$dangercalls[$matchref] ";
				#print "in ";
				#print colored ['blue'], "$File::Find::name";
				#print "\n";
						};
					};
		close FILE; 	
		};

find({wanted => \&wanted}, $dir);
