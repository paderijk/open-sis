======================================================================
 _____                        _____ _____ _____   _____  _____    ___ 
|  _  |                      /  ___|_   _/  ___| |  _  ||  _  |  /   |
| | | |_ __   ___ _ __ ______\ `--.  | | \ `--.  | |/' || |/' | / /| |
| | | | '_ \ / _ \ '_ \______|`--. \ | |  `--. \ |  /| ||  /| |/ /_| |
\ \_/ / |_) |  __/ | | |     /\__/ /_| |_/\__/ / \ |_/ /\ |_/ /\___  |
 \___/| .__/ \___|_| |_|     \____/ \___/\____/   \___(_)\___(_)   |_/
      | |                                                             
      |_|                                                             
                                                     
======================================================================

Program name......: Open System Information Scanner (Open-SIS)
License...........: GPLv2
Version...........: 0.0.4
Author............: P.A. de Rijk
E-mail............: pieter@de-rijk.com
Website...........: https://github.com/paderijk/open-sis/ 

== LICENSE ===========================================================
This program is licensed under GPLv2. For license please read 
the LICENSE.txt file which is distributed by this program.

== Preface ===========================================================
This application scan's the Windows registry to retreive
values regarding the installed applications on the machine.
Also does this application scan for storage devices who have
been attached to the system.

== Change log =======================================================
0.0.1 26-07-2006 (Pieter de Rijk)
      First concept ready, although if no DISPLAYNAME or something
      else is available the script picks up the previous value.

0.0.2 27-07-2006 (Pieter de Rijk)
     - Solved the problem if nothing was found.
		 - Added the feature to save it to XML or CSV by using
       the -o flag, default is XML
     - Added the feature that the file will be saved to 
       a filename with computername and timestamp.
	   - The possibility to define with the -s flag where
       the file must be stored

0.0.3 25-09-2006 (Pieter de Rijk)
      - If from an application the name is 'not-defined' let's 
        take a port of the registry-key
      - Read OS Information (Name/Version/ServicePack)
  		- Name changed from "Software Installed Scanner" into
        "System Information Scanner", because of a lot of features
        extra into the script.
      - Speeding up the registry reading and making other 
        subroutines for reading data out of the registry
        obsolete
      - Also implemented a new output formatting, version 0.2
        It is backwards compatible with output version 0.1
        
0.0.4 27-02-2007 (Pieter de Rijk)
      - Rewrote a major (95%) part of the code in private time and with
        private resources, so decided to redistribute the code using
        the GPLv2 license.
      - Renamed the tool to Open System Information Scanner.

== Usage =============================================================
Because of the purpose of this application, you will only be able to
run it on a Windows machine. The application is written in PERL so you
need the Win32 port of PERL. You do _not_ need to install PERL on the
computer you want to scan. In this zip file perl is already available,
so you can run it by calling the PERL.EXE with a absolute or relative
path like:

g:\sample\perl\bin\perl.exe open-sis.pl
-or-
.\sample\perl\bin\perl.exe open-sis.pl

Within this zip file their are a few dot-BAT files with examples

open-sis-xml.bat	Executes the application and output a XML output
		to the directory output
open-sis-csv.bat	Executes the application and output a CSV output
		to the directory output
open-sis-help.bat	Executes the application and shows the help message

The application supports the next flags:

-o [xml|csv]	Define the output type, default is xml. csv exports
		it with a pipe (|) delimeted file
-s [path]	Define the path where to store the output

-h show		Shows the helpmessage and exit the application

Example:
========

open-sis.pl -o xml //some-server/audit/open-sis-audit/


The output will allways be 
		[ComputerName]-[Timestamp YYYYMMDDhhmmss].xml 
		-or-
		[ComputerName]-[Timestamp YYYYMMDDhhmmss].csv

Example:
========
		My_Computer-20060728090412.xml

== XML Definition ====================================================
The XML output is defined like:

<scaninformation>
Is the root element within the XML output.

<details>
This element contains the detail information about the scan like:
		
		<computername>
		Computername which is scanned
		
		<operatingsystem>
		Productname of the OS

    <os-version>
    Version of the OS

	  <os-product-id]
		Product ID of the Windows OS

    <os-reg-org>
    Registered organisation of the scanned Windows version.

    <os-reg-own>
    Registered owner of the scanned Windows version
		
		<open-sis-timestamp>
		Timestamp of the scan
		
		<open-sis-scriptversion>
		Version of the application
		
		<open-sis-outputversion>
		Output version of the XML/CSV

<software>
This element contains subelements regarding the installed applications

	<application>
	A new element for a application
		
		<version>
		Version of the installed application, if not defined the value
		not-defined will appear
		
		<hkey>
		Key of the location in HKEY_LOCALMACHINE (hklm)
		
		<name>
		Name of the application
		
<hardware>
This element contains hardware information

	<storage>
		Element contains subelements
		
			<device>
			A new device-element conaining information of the attached
			storage device
				
				<interface>
				Interface type of the device.
				
				<vendor>
				Vendor of the device
				
				<product>
				Productname/model and revision if available
				
NOTE: Due to XML restrictions the application changes i.e. the & to
&amp; the registered mark and copyright mark are changed into (R) and
(C).
== CSV Definition ====================================================
The CSV definitions is defined as:

The CSV exist out of 3 parts:

*Details
The first 6 lines contains the detail information regarding the scan.

*Application list
The header of this section is: 

	==SOFTWARE===================

The details are defined like:
		
	Applicationname|version|registrykey

The footer of this section is marked with

	=============================
		
*STORAGE
The header of this section is:
		
	==STORAGE====================
		
The details are defined :
	Interface|Vendor|Product

The footer of this section is marked with

	=============================

=====================================================================
