# on-the-map

app with a map that shows information posted by other students. The map will contain pins that show the location where other students have reported studying. By tapping on the pin users can see a URL for something the student finds interesting. The user will be able to add their own data by posting a string that can be reverse geocoded to a location, and a URL.
[The app use Udacity API](https://www.udacity.com)


First, the user logs in to the app using their Udacity username and password. After login, the app downloads locations and links previously posted by other students. These links can point to any URL that a student chooses. We encourage students to share something about their work or interests.

After viewing the information posted by other students, a user can post their own location and link. The locations are specified with a string and forward geocoded.

## the app have three view controller :

**- Login View:**
Allows the user to log in using their Udacity credentials, The login view accepts the email address and password that students use to login to the Udacity site. User credentials are not required to be saved upon successful login.Clicking on the Sign Up link will open Safari to the Udacity [Sign Up](https://www.udacity.com)

<img src="https://github.com/Abdu11a/on-the-map/blob/master/On%20The%20Map/on%20the%20map%20screen/Screen%201.png" width=400>

If the connection is made and the email and password are good, the app will segue to the Map and Table Tabbed View.


**- map View:** 

 This view has two tabs at the bottom: one specifying a map, and the other a table.


When the map tab is selected, the view displays a map with pins specifying the last 100 locations posted by students.


The user is able to zoom and scroll the map to any location using standard pinch and drag gestures.
 it displays the pin annotation popup, with the student’s name. Tapping anywhere within the annotation will launch Safari and direct it to the link associated with the pin.

<img src="https://github.com/Abdu11a/on-the-map/blob/master/On%20The%20Map/on%20the%20map%20screen/Screen%202.png" width=400>


**-table View:**

When the table tab is selected, the most recent 100 locations posted by students are displayed in a table. Each row displays the name from the student’s Udacity profile. Tapping on the row launches Safari and opens the link associated with the student.


Both the map tab and the table tab share the same top navigation bar.


<img src="https://github.com/Abdu11a/on-the-map/blob/master/On%20The%20Map/on%20the%20map%20screen/Screen%204.png" width=400>

**- PostingView:** 
The PostingView View allows users to input their own data.


When thePostingView View is modally presented, the user sees two text fields: one asks for a location and the other asks for a link.
When the user clicks on the “Find Location” button, the app will forward geocode the string. If the forward geocode fails, the app will display an alert view notifying the user. Likewise, an alert will be displayed if the link is empty.


<img src="https://github.com/Abdu11a/on-the-map/blob/master/On%20The%20Map/on%20the%20map%20screen/Screen%203.png" width=400>




**- MapPinLocationView:** 
f the forward geocode succeeds then text fields will be hidden, and a map showing the entered location will be displayed. Tapping the “Finish” button will post the location and link to the server.
If the submission fails to post the data to the server, then the user should see an alert with an error message describing the failure.
If at any point the user clicks on the “Cancel” button, then the Information Posting View should be dismissed, returning the app to the Map and Table Tabbed View.

Likewise, if the submission succeeds, then the Information Posting View should be dismissed, returning the app to the Map and Table Tabbed View.

<img src="https://github.com/Abdu11a/on-the-map/blob/master/On%20The%20Map/on%20the%20map%20screen/Screen%205.png" width=400>




