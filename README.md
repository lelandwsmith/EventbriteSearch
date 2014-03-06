EventbriteSearch
================

To run:
Pull down project
Install cocoapods
run ‘pod install’ from terminal while in the project directory
open .xcworkspace 

Searches Eventbrite for events

I considered using NSUserDefaults to keep track of searches and then retrive them from 
the database to avoid extraneous network requests, but decided that I would like to have
the most up to date results for every search. 

To avoid extraneous data model insertions, I check the results for duplicates before 
inserting. 

I chose to display the search results in a tableview controller with a fetched results
controller to simplify choosing which event to display on the map. 

Selecting an annotation displays an MKDirections line from the user's current location to 
the event.