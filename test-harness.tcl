#!/usr/bin/env tclsh8.6

#
# Normally you'd just do a 'package require fogbugz' like a normal person.
#
# But we want the test-harness to be able to work from the current directory
# repo checkout to simplify testing.
#
# Source the stuff by hand below:
#
source main.tcl
if {[catch {source config.tcl} err]} {
	puts "No configuration found: $err"
	exit -1
}


proc rule {} {
	puts "-- "
}

proc main {} {
	set verbose 0

	parray ::fogbugz::config
	lassign [::fogbugz::login] logged_in token
	if {!$logged_in} {
		puts "Unable to log in: $token"
		exit -1
	}
	puts "Logged in with token $token"

	rule

	if {1} {
		#
		# Example of using the getList proc for obtaining a list of objects
		# from the FogBugz server.
		#
		foreach listType [array names ::fogbugz::listResult] {
			set result [::fogbugz::getList $listType [dict create token $token]]
			puts "list$listType returned [llength $result] items"
			if {$verbose} {
				foreach item $result {
					puts "- $item"
				}
			}
		}
		rule
	}

	if {1} {
		#
		# Examples of using raw_cmd proc for running a raw API method and returning
		# the result data into an array/dict suitable string
		#
		puts "ixPerson 2:"
		array set person [::fogbugz::view Person [dict create token $token ixPerson 2]]
		parray person

		rule

		puts "ixStatus 2:"
		array set status [::fogbugz::view Status [dict create token $token ixStatus 2]]
		parray status
		rule
	}

	if {1} {
		set cols [join {ixBug sTitle sTags sProject sArea sPriority sPersonAssignedTo dtDue} ","]
		::fogbugz::raw_cmd  setCurrentFilter [dict create token $token sFilter 48]
		foreach casebuf [::fogbugz::search [dict create token $token cols $cols]] {
			array set case $casebuf
			parray case
			rule
		}
	}

	#
	# Logging off.  It's not just a good idea, it's the spec.
	#
	::fogbugz::logoff $token
}

if !$tcl_interactive main
