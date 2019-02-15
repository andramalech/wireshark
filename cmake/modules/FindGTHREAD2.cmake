# - Try to find GThread2
#
# Find GThread headers, libraries and the answer to all questions.
#
#  GTHREAD2_FOUND               True if GTHREAD2 got found
#  GTHREAD2_INCLUDE_DIRS        Location of GTHREAD2 headers
#  GTHREAD2_LIBRARIES           List of libraries to use GTHREAD2
#
#  Copyright (c) 2008 Bjoern Ricks <bjoern.ricks@googlemail.com>
#
#  Redistribution and use is allowed according to the terms of the New
#  BSD license.
#  For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

if( WIN32 )
	include( FindWSWinLibs )
	if( BUILD_wireshark_gtk )
		#
		# GLib is in a directory underneath the top-level
		# directory for GTK+; pick the GTK+ version with
		# which we'll be building.
		#
		if( ENABLE_GTK3 )
			FindWSWinLibs( "gtk3" "GTHREAD2_HINTS" )
		else()
			FindWSWinLibs( "gtk2" "GTHREAD2_HINTS" )
		endif()
	else()
		#
		# GLib is in a directory underneath the top-level
		# directory for GTK+; pick whatever GTK+ version
		# we find first.
		#
		FindWSWinLibs( "gtk3" "GTHREAD2_HINTS" )
		if(NOT GTHREAD2_HINTS )
			FindWSWinLibs( "gtk2" "GTHREAD2_HINTS" )
		endif()
	endif()
else()
	include( FindPkgConfig )

	if( GTHREAD2_MIN_VERSION )
		PKG_SEARCH_MODULE( GTHREAD2 gthread-2.0>=${GTHREAD2_MIN_VERSION} )
	else()
		PKG_SEARCH_MODULE( GTHREAD2 gthread-2.0 )
	endif()
endif()

if( GTHREAD2_FOUND )
	if( GTHREAD2_LIBRARY_DIRS )
		LINK_DIRECTORIES( ${GTHREAD2_LIBRARY_DIRS} )
	endif()
else()
	find_path( GTHREAD2_INCLUDE_DIRS gthread.h PATH_SUFFIXES glib-2.0 glib GLib.framework/Headers/glib glib-2.0/glib HINTS "${GTHREAD2_HINTS}/include" )
	find_library( GTHREAD2_LIBRARIES gthread-2.0 HINTS "${GTHREAD2_HINTS}/lib" )
	if( NOT GTHREAD2_LIBRARIES )
		# GLib contains GThread in some cases.
		if( APPLE )
			# Fallback as APPLE glib libs already contain this - except
			# Homebrew which needs the non-Apple setup
			find_library( GTHREAD2_LIBRARIES glib )
		elseif( WIN32 )
			find_library( GTHREAD2_LIBRARIES glib-2.0 HINTS "${GTHREAD2_HINTS}/lib" )
		endif()
	endif()
	include( FindPackageHandleStandardArgs )
	find_package_handle_standard_args( GTHREAD2 DEFAULT_MSG GTHREAD2_LIBRARIES GTHREAD2_INCLUDE_DIRS )
	if( NOT GTHREAD2_FOUND AND GTHREAD2_FIND_REQUIRED )
		message( SEND_ERROR "Package required but not found" )
	endif()
endif()


mark_as_advanced( GTHREAD2_LIBRARIES GTHREAD2_INCLUDE_DIRS )
