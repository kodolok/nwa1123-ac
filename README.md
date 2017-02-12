========================================
NWA1123-AC - Build Instructions

Version: V211AAOX0C0
Date: "2016 Oct"
========================================

Note:
		1) This package has been built successfully on "Ubuntu 12.04.3"
		2) Compiling this package on platforms other than "Ubuntu 12.04.3"
			I may have unexpected results.
		3) The user who wants to build the code must have the privilege 
			to execute "sudo" command.

===================
 Build code
===================

1. Download  "V211AAOX0C0_GPL_src.tar.gz"


2. Run the following commands to extract source:
	- tar xzvf V211AAOX0C0_GPL_src.tar.gz

3. Change to the directory "NWA1123-AC".
	- cd NWA1123-AC
	- chmod +x scripts/*

4. Run the following command to build image
	- make V=s

5. The final image is "bin/NWA1123-AC/V211AAOX0C0".


After image is built successfully, user may upload this image to device
via WEB GUI <Firmware Upgrade> page.
