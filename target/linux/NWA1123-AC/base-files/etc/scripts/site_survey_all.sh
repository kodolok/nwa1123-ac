#!/bin/sh

if [ "`ifconfig ath0 2>/dev/null`" ]
then
   if [ "`ifconfig ath8 2>/dev/null`" ]
   then
       #iwlist ath0 scanning 2>/dev/null | site_survey.sh
       site_survey_2g.sh web
       echo ","
       #iwlist ath8 scanning 2>/dev/null | site_survey.sh
       site_survey_5g.sh web
   else
       #iwlist ath0 scanning 2>/dev/null | site_survey.sh
       site_survey_2g.sh web
   fi
else
   if [ "`ifconfig ath8 2>/dev/null`" ]
   then
       #iwlist ath8 scanning 2>/dev/null | site_survey.sh
       site_survey_5g.sh web
   fi
fi
