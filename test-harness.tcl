#!/usr/bin/env tclsh8.5

source main.tcl
catch {source config.tcl}

proc rule {} {
	puts "-- "
}

proc main {} {
	parray ::fogbugz::config
	lassign [::fogbugz::login] logged_in token
	if {!$logged_in} {
		puts "Unable to log in: $token"
		exit -1
	}
	puts "Logged in with token $token"

	rule

	foreach listType [array names ::fogbugz::listResult] {
		set result [::fogbugz::getList $listType [dict create token $token]]
		puts "list$listType returned [llength $result] items"
	}

}

if !$tcl_interactive main
