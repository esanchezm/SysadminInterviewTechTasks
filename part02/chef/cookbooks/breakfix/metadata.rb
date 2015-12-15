name                "breakfix"
maintainer          "Kodify"
maintainer_email    "ryan@kodify.io"
license             "No License"
description         "Sysadmin Tech Test breakfix"
version             "0.1.0"

recipe              "default",   		    "Configure all breakfix scenarios"
recipe              "users",   		        "Configure users for breakfix scenarios"

recipe              "1-ping",   		    "Breakfix scenario 001"
recipe              "2-mysql",   		    "Breakfix scenario 002"
recipe              "3-problemz",   	    "Breakfix scenario 003"
recipe              "4-fullmount",   	    "Breakfix scenario 004"
recipe              "5-fullbutspace",       "Breakfix scenario 005"
recipe              "6-sudo",   		    "Breakfix scenario 006"
recipe              "7-brokenraid",   	    "Breakfix scenario 007"
recipe              "8-savetheserver",      "Breakfix scenario 008"
recipe              "9-webservererror",     "Breakfix scenario 009"

%w{ubuntu}.each do |os|
    supports os
end
