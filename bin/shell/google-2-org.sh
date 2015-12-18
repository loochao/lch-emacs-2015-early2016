#!/bin/bash

# customize these
WGET=/usr/texbin/wget
ICS2ORG=/usr/texbin/ical2org
ICSFILE=~/Dropbox/Org/org/Agenda/lch-google.ics
ORGFILE=~/Dropbox/Org/org/Agenda/lch-google.org
URL=https://www.google.com/calendar/ical/loochao%40gmail.com/private-e1772f77aff1e1a5048bdd35de9838c9/basic.ics

# no customization needed below
$WGET -O $ICSFILE $URL
$ICS2ORG < $ICSFILE > $ORGFILE
