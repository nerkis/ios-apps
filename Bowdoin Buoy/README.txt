Project Name: 		Bowdoin Buoy App
Project Authors: 	Peter Yaworsky, Bowdoin College '14
			Nicole Erkis, Bowdoin College '12



VERSION 1.0 (12-18-11)	

This is an iOS app that manipulates and displays data from the Bowdoin Oceanographic buoy. The data is hosted online by The University of Maine School of Marine Sciences. It is being developed for the Bowdoin College's Fall 2011 Mobile Computing Course, taught by Professor Eric Chown. The app has  been developed at the request of Professor Collin Roesler for her research and for use in her classes.

HOW TO USE:

To run this program, you need an internet-connected Macintosh computer with Xcode 4 or higher installed. Note: this has only been tested in Xcode 4.1 so far. Open the project file, and press build. The app will take a little while to download and organize the data, but then a tab bar controller will show up. The two controllers in the tab bar are the summary (the default) and the graph. The summary displays the current conditions at the Bowdoin Buoy, while the graph displays data from the most recent deployment (03-09-11 through the time of this writing… and beyond). The graph has options for showing a week or a single day, and can graph three different things. It can graph the temperature readings at three depths (2M, 10M, and 20M), salinity readings at those depths, and chlorophyll readings at 2.5M. The graphs are color coded, with blue corresponding to temperature, red to salinity, and green to chlorophyll. Darker colors indicate readings from greater depths. The graph view also supports pinching to change the scale of the y-axis, panning vertically, and a triple tap to reset the origin position and y-axis scale to default. There is also support for a double tap gesture that is supposed to center the screen on the data being graphed, but it doesn't yet work. The app functions as desired on the iPhone, but has not yet been fully implemented on an iPad. The day the graphed data will start on can be changed, but you must modify a line of code in the viewDidLoad method of Bowdoin_Buoy_App_iPhone_Graph_View_Controller to change the date, entering a new date with the format @"MM-DD_YY".

KNOWN BUGS:

The double tap method does not center the data being graphed, but rather weirdly positions the origin. There is also a lot of functionality that should be added eventually.

THINGS TO ADD/IMPROVE:

1. Make everything work on the iPad as well as it does on the iPhone.
2. Use threading wherever internet access is required so the app doesn't crash/brick the device while trying to access the internet.
3. The graphs need titles, as well as some sort of labels for the axes. 
4. Add an option for the user to select which day the graph should use as the start of the data that it is graphing.
5. Fix the double tap method so it centers the graph
6. Store the downloaded data permanently, with an option to download updated data when the user wants
7. Convert the timestamps of the readings from GMT to the current local time
8. Add an option to graph data for a whole month, which will require an averaging function for the data.
9. Write an averaging function in the Bowdoin_Buoy_App_iPhone_Graph_Data class that takes an average of the readings over a few hours to get the right number of data points to graph a whole month of data.
10. Add a catch that prevents a crash when the user asks for data that doesn't exist (for example, wanting a week of data starting on 12-16-11 when the date is 12-18-11).
11. There is a whole network of these buoys, possibly extend the functionality of this app to more than just Bowdoin's buoy. 


DETAILED OVERVIEW OF STRUCTURE AND FUNCTIONALITY: (for those who care)

When the app is launched, the Bowdoin_Buoy_App_iPhone_Graph_Data class downloads four .csv files from the internet that contain data for water temperature and salinity at 2M, 10M, and 20M, as well as one with data with the chlorophyll level readings at 2.5M. After converting these files to strings, the same class then parses the files into dictionaries that use the date and time as a string for the key, with the object being an array of readings for that time from the various sensors. The data is further subdivided into a dictionary that uses the date as a string for a key, with its object being an array of 24 arrays (one for each hour), each of which is an array of all the sensor data for that hour. All of this data is stored in NSMutableDictionary properties for easy access once they are built.

Additionally, the Bowdoin_Buoy_App_iPhone_Summary_View_Controller class grabs the HTML of a web page with the most recent sensor data and converts it to a string. It then goes through the string looking for the relevant bits of data, which it removes and displays in a summary of all the relevant conditions at the buoy (latitude, longitude, air temperature, water temperature, and more).

The Bowdoin_Buoy_App_iPhone_Graph_View_Controller class has instances of Bowdoin_Buoy_App_iPhone_Graph_Data and of Graph_View as properties, and communicates with them to store and to graph the data. The Bowdoin_Buoy_App_iPhone_Graph_View_Controller is the delegate for the Graph_View.

These two controllers (summary and graph) appear inside a tab bar controller, with the option to switch between them. The default controller displayed is the summary. To force the graph to be in landscape mode, both controllers were put in landscape mode. When the graph is selected, the default mode graph shown is that of all three temperature readings (2M, 10M, 20M) over the course of a fixed day. The day is currently fixed in code in the Bowdoin_Buoy_App_iPhone_Graph_View_Controller's viewDidLoad method. Eventually this will be selectable by the user in the graph interface. The graph view has two UISegmentedControls in the title bar, one to choose the timeframe (currently week or day), and one to choose the graph type (triple salinity, triple temperature, or chlorophyll).

The graph supports pinching to change the scale (on the y-axis only), panning vertically, and a triple tap that resets the origin and scale to the default settings. There is a double tap method that is supposed to center the data's graph on the screen, but it does not work (yet).


CREDITS:

The AxesDrawer code was borrowed from the CS 193 iPhone Application Development course at Stanford University and modified to fit this project.