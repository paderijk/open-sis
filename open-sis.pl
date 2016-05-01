#####################################################################
## Perl Information Scanner
## Version.........: 0.0.4
## Author..........: Pieter de Rijk
## E-mail..........: pieter@de-rijk.com
##
## Copyright (C) 2005-2007 Pieter de Rijk
## 
## Version History
## ===============
##
## 0.0.1 26-07-2006 (Pieter de Rijk)
##       First concept ready, although if no DISPLAYNAME or something
##       else is available the script picks up the previous value.
##
## 0.0.2 27-07-2006 (Pieter de Rijk)
##       - Solved the problem if nothing was found.
##			 - Added the feature to save it to XML or CSV by using
##         the -o flag, default is XML
##       - Added the feature that the file will be saved to 
##         a filename with computername and timestamp.
##			 - The possibility to define with the -s flag where
##         the file must be stored
##
## 0.0.3 25-09-2006 (Pieter de Rijk)
##       - If from an application the name is 'not-defined' let's 
##         take a port of the registry-key
##       - Read OS Information (Name/Version/ServicePack)
##			 - Name changed from "Software Installed Scanner" into
##         "System Information Scanner", because of a lot of features
##         extra into the script.
##       - Speeding up the registry reading and making other 
##         subroutines for reading data out of the registry
##         obsolete
##       - Also implemented a new output formatting, version 0.2
##         It is bachwards compatible with output version 0.1
##
## 0.0.4 27-02-2007 (Pieter de Rijk)
##       - Rewrote certain parts of the code (reengineerd almost 90%
##         of the code in private time with private systems). This
##         version is GPLv2 licensed.
##       - Renamed the tool into Open System Information Scanner (Open-SIS)
#####################################################################


# Call the win32 registry module
use Win32::Registry;

# Use The option reader
use Getopt::Std;

#####################################################################
# Read the options
# -o [xml|csv] Output type (default is XML)
# -s [path]		 Output path (default is present working directory)
getopts ('h:o:s:', \%options);

# Check what type of output is defined
my $XMLOutput = "1";
if ( $options{o} eq "csv" ) { $XMLOutput = "0"; }
	
# Show the Help-message
if ( $options{h} eq "show" )
{
	ShowHelpMessage();
	exit 1;
}

# Read the output path
if ( $options{s} eq "" ) 
{
	# If outputpath is not defined, use the current folder .\
	$OutputPath = ".\\";
} else {
	$OutputPath = "$options{s}\\";
}

# Set the place where uninstall information can be found
my $Register = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall";

# Define current version
my $Version = "0.0.4";

# Define output version
my $OutputVersion = "0.3-xml";

# URL of the XSL
my $XSL_url = "	open-sis.$OutputVersion.xsl";

# Define default values
my $DisplayName = "not-defined";
my $DisplayVersion = "not-defined";
my $Locationkey = "not-defined";

# Define dat as i.e. 'Thu 27 Jul 2006 12:46:51'
@months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
@weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
$year = 1900 + $yearOffset;


if ( $second < 10 ) { 
	$ssecond = "0$second"; 
} else { 
	$ssecond = "$second"; 
}
if ( $minute < 10 ) { 
	$sminute = "0$minute"; 
} else { 
	$sminute = "$minute"; 
}
if ( $hour < 10 ) { 
	$shour = "0$hour"; 
} else { 
	$shour = "$hour"; 
}
if ( $dayOfMonth < 10 ) { 
	$sday = "0$dayOfMonth"; 
} else { 
	$sday = "$dayOfMonth"; 
}
$tmonth = $month+1;
if ( $tmonth < 10 ) { 
	$smonth = "0$tmonth"; 
} else { 
	$smonth = "$tmonth"; 
}
$CurrentTime = "$weekDays[$dayOfWeek] $dayOfMonth $months[$month] $year $shour:$sminute:$ssecond ";
$TimeStampFile = "$year$smonth$sday$shour$sminute$ssecond";
# Define some strings and array
my ($hkey, @key_list, $key);

my @Output;

if ( $XMLOutput eq "1"   ) {
 	# Create header stuff for the XML output
	@Output = ( @Output, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
	@Output = ( @Output, "<?xml-stylesheet type=\"text/xsl\" href=\"$XSL_url\"?>\n");
	@Output = ( @Output, "<scaninformation>\n");
}

### Details regarding this computer
# Computername
my $hkey_ComputerName = "SYSTEM\\CurrentControlSet\\Control\\ComputerName\\ComputerName\\ComputerName";
my $ComputerName = HTMLSpecialEntities(HKLM_ReadKeyData("$hkey_ComputerName"));

# OS Productname
my $hkey_Os = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\ProductName";
my $OS = HKLM_ReadKeyData("$hkey_Os");

my $hkey_CSDVersion = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\CSDVersion";
my $CSDVersion = HKLM_ReadKeyData("$hkey_CSDVersion");
$OS = $OS . " " . $CSDVersion;

# OS Product version
my $hkey_OSVersion = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\CurrentVersion";
my $OS_Version = HKLM_ReadKeyData("$hkey_OSVersion");

# Buildlab data, ie 2600.xpsp_sp2_gdr.050301-1519
my $hkey_BuildLab = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\BuildLab";

# Registered organisation
my $hkey_OsRegOrg = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\RegisteredOrganization";
my $OS_Reg_Org = HKLM_ReadKeyData("$hkey_OsRegOrg");

# Registered owner
my $hkey_OsRegOwn = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\RegisteredOwner";
my $OS_Reg_owner = HKLM_ReadKeyData("$hkey_OsRegOwn");


# Registered product ID
my $hkey_ProductID = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\ProductId";
my $OS_Product_ID = HKLM_ReadKeyData("$hkey_ProductID");

if ( $XMLOutput eq "1"   ) {
  @Output = ( @Output, "<details>");
	@Output = ( @Output, "<computername>$ComputerName</computername>\n");
	@Output = ( @Output, "<operatingsystem>$OS</operatingsystem>\n");
	@Output = ( @Output, "<os-version>$OS_Version</os-version>\n");
  @Output = ( @Output, "<os-product-id>$OS_Product_ID</os-product-id>\n");
  @Output = ( @Output, "<os-reg-org>$OS_Reg_Org</os-reg-org>\n");
  @Output = ( @Output, "<os-reg-owner>$OS_Reg_owner</os-reg-owner>\n");
	@Output = ( @Output, "<open-sis-timestamp>$CurrentTime</open-sis-timestamp>\n");
	@Output = ( @Output, "<open-sis-scriptversion>$Version</open-sis-scriptversion>\n");
	@Output = ( @Output, "<pis-outputversion>$OutputVersion</open-sis-outputversion>\n");
	@Output = ( @Output, "</details>\n");
} else {
	@Output = ( @Output, "DETAILS\n");
	@Output = ( @Output, "================\n");
	@Output = ( @Output, "Computername............: $ComputerName\n"); 
	@Output = ( @Output, "Operatingsystem.........: $OS\n");
	@Output = ( @Output, "OS Product ID...........: $OS_Product_ID\n");
	@Output = ( @Output, "OS Registered Org.......: $OS_Reg_Org\n");
	@Output = ( @Output, "OS Registered owner.....: $OS_Reg_owner\n");
	@Output = ( @Output, "Open-SIS Timestamp......: $CurrentTime\n");
	@Output = ( @Output, "Open-SIS Scriptverion...: $Version\n");
}
##############################################################
### READ THE INSTALLED SOFTWARE STUFF FROM THE REGISTRY
# Read all the subkeys
if ( $XMLOutput eq "1"   ) {
  @Output = ( @Output, "<software>");
} else {
	@Output = ( @Output, "==SOFTWARE===================\n");
}
# Open the registry
$HKEY_LOCAL_MACHINE->Open($Register,$hkey)|| die $!;
$hkey->GetKeys(\@key_list);
foreach $key (@key_list)
	{
		$DisplayName = HKLM_ReadKeyData("$Register\\$key\\DisplayName");
 	  $DisplayVersion = HKLM_ReadKeyData("$Register\\$key\\DisplayVersion");
		$Locationkey = "$Register\\$key";
		
	
		if ( $DisplayName eq "not-defined" ) {
			  # Mostely the key contains more information regarding  the application
			  # So if the $DISPLAYNAME is not defined, take the key value.
				$DisplayName = $key;
		}
		
		if ( $XMLOutput eq "1"   ) {
			
			$DisplayVersion = HTMLSpecialEntities($DisplayVersion);
			$Locationkey = HTMLSpecialEntities($Locationkey);
			$DisplayName = HTMLSpecialEntities($DisplayName);
			
			@Output = ( @Output, "  <application>\n");
			@Output = ( @Output, "    <version>$DisplayVersion</version>\n"); 
			@Output = ( @Output, "    <hkey>$Locationkey</hkey>\n");
			@Output = ( @Output, "    <name>$DisplayName</name>\n");
			@Output = ( @Output, "</application>\n");
		} else {
			@Output = ( @Output, "$DisplayName|$DisplayVersion|$Locationkey\n");
		}
	}
# Close the registry
$hkey->Close();
if ( $XMLOutput eq "1"  ) {
 	@Output = ( @Output, "</software>\n" );
} else {
	@Output = ( @Output, "=============================\n" );
}

##############################################################
### READ ALL THE USBSTOR DEVICES IN
# HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceClasses\{53f56307-b6bf-11d0-94f2-00a0c91efb8b}
##############################################################
my $hkey_EXTERNAL_STOR = "SYSTEM\\CurrentControlSet\\Control\\DeviceClasses\\{53f56307-b6bf-11d0-94f2-00a0c91efb8b}";

if ( $XMLOutput eq "1"  ) {
 	@Output = ( @Output, "<hardware>\n" );
	@Output = ( @Output, "<storage>\n" );
} else {
	@Output = ( @Output, "==STORAGE====================\n" );
}
$HKEY_LOCAL_MACHINE->Open($hkey_EXTERNAL_STOR,$hkey)|| die $!;
$hkey->GetKeys(\@keylist);
foreach $key (@keylist)
	{
		#$key = HTMLSpecialEntities($key);
		my @device = split("#", $key);
		my @info_split = split("&", $device[4]);

		if ( $device[3] eq "USBSTOR" ) { 
			$interface = "USB"; 
			$vendor = $info_split[1];
			$vendor =~ s/^Ven\_//g;

			$product = "$info_split[2] $info_split[3]";
			$product =~ s/^Prod_//g;

		}
		elsif ( $device[3] eq "IDE" ) {
			$interface = "IDE";
			$vendor = "not-defined";
			$product = $device[4];
			$product =~ s/^Disk//g;
		}
		elsif ( $device[3] eq "SBP2" ) {
			$interface = "Firewire";
			$vendor = $info_split[0];
			$product = $info_split[1];
		} else { 
			$interface = "not-defined"; 
			$vendor = "not-defined";
			$product = "not-defined";
		}
		$product =~ s/\_/\x20/g;
		$vendor =~ s/\_/\x20/g;
		if ( $vendor eq "" ) { $vendor = "not-defined"; }
		if ( $product eq "" ) { $product = "not-defined"; }
		if ( $XMLOutput eq "1"  ) {
			@Output = ( @Output, "<device>\n");
			@Output = ( @Output, "<interface>\n");
			@Output = ( @Output, "$interface\n");
			@Output = ( @Output, "</interface>\n");
			@Output = ( @Output, "<vendor>$vendor</vendor>\n");
			@Output = ( @Output, "<product>$product</product>\n");
			$xmlkey = HTMLSpecialEntities($key);
			@Output = ( @Output, "<regkey>$xmlkey</regkey>\n");
			
			#Note: Some Maxtor OneTouch devices put their fingerprint
			#      into the register, although they do not contain
			#      any information regarding the device.
			#      So we don't implement it.
			@Output = ( @Output, "</device>\n");
		} else {
		  @Output = ( @Output, "$interface|$vendor|$product\n");
		}
	}
$hkey->Close();

if ( $XMLOutput eq "1"  )
{
		@Output = ( @Output, "</storage>\n");
		@Output = ( @Output, "</hardware>\n");
		@Output = ( @Output, "</scaninformation>\n");
} else {
		@Output = ( @Output, "=============================\n");
}	

### Write the stuff to a file
if ( $XMLOutput eq "1"  ) {
	$OutputFile = "$OutputPath\\$ComputerName-$TimeStampFile.xml";
} else {
	$OutputFile = "$OutputPath\\$ComputerName-$TimeStampFile.csv";
}

# Open the file to write to
open FILEOUT, ">$OutputFile";
foreach (@Output) {
	# Write each line to the file (CSV or XML)
	print FILEOUT "$_";
	
}
#Close the file
close FILEOUT;

##############################################################
## SUB ROUTINES
##############################################################

sub HKLM_ReadKeyData
{
	# Read the key data
	# this must become a new feature where the other read subroutines
	# becomes obsolete.
	my $readval = "@_";
	my @splitstuff = split(/\\/, $readval);
	my $hkey_keys = "";
	my $number_of_objects = @splitstuff - 1;
	my $object_tree = "";
	my $object_key;
	
	my $count = 0;
	
	do {
		# In here we search for the registry key
		$object_tree = $object_tree ."". $splitstuff[$count] . "\\";
		$count++;
	} while ( $count < ( $number_of_objects ));
  
  $hkey_keys_wanted =  $splitstuff[$number_of_objects];

  $object_tree =~ s/^\\//;
  $object_tree =~ s/\\$//;

  my %values;
	my $ReturnValue = "not-defined";

	$HKEY_LOCAL_MACHINE->Open($object_tree, $hkey_keys) || die $!;

	$hkey_keys->GetValues(\%values);

	foreach $value (keys(%values))
	{
		$RegValue  = $values{$value}->[2]; 
		$RegKey    = $values{$value}->[0];
		$RegType   = $values{$value}->[1];
		next if ( $RegType eq '' );
		
		if ( $RegKey eq	$hkey_keys_wanted ) {
			$ReturnValue = $RegValue;
		}
		
	}	
	$hkey_keys->Close();
	return $ReturnValue;
}

sub HTMLSpecialEntities
{
	# Change i.e. & into &amp;
	# Read the data and replace it.
	# List of entities can be found at:
	# http://www.htmlhelp.com/reference/html40/entities/special.html
	$tr = "@_";
	$tr =~ s/\x22/&quot\;/g; 
	$tr =~ s/\x26/&amp\;/g; 
	$tr =~ s/\x3c/&lt\;/g;
	$tr =~ s/\x3e/&gt\;/g;
	$tr =~ s/\x152/&OElig\;/g;
	$tr =~ s/\x153/&oelig\;/g;
	$tr =~ s/\x160/&Scaron\;/g;
	$tr =~ s/\x161/&scaron\;/g;
	$tr =~ s/\x178/&Yuml\;/g;
	$tr =~ s/\x2c6/&circ\;/g;
	$tr =~ s/\x2dc/&tilde\;/g;
	
	## Replace the copyright and registerd symbols into (C) and (R)
	$tr =~ s/\xA9/\(C\)\;/g;
	$tr =~ s/\xAe/\(R\)\;/g;

	return $tr;
}

sub ShowHelpMessage
{
	# Show some error stuff
	print "Open System Information Scanner version $Version\n\n";
	print "Please use:\n\t$0 -o [xml|csv] {-s c:\\somepath}";
  print "\n\nEXAMPLE:\n\t$0 -o xml -s x:\\audit\\\n";
	print "\n\nCopyright (C) 2003-2007 FiWeb Communications [www.adslweb.net/tools/open-sis]\n";
}