DOCUMENTATION

General (How and where to compile, How it is configured):

Camino Claro, the IOS app, is compiled in a Library folder within our MacOS. The process to compile the app can also be known as a "build". To build the app, the project owner must open the project in Xcode first. Xcode translates the source code, in the language Swift for our app, into binary code, and gathers all the Swift files created by us. Xcode then linkes the code and these assets, or files. Xcode then performs code signing, which the project owner must initiate by choosing their Apple ID as their team in the Signing and Capabilities settings of the CS50 Project. To intiate a build, the project owner opens the project in Xcode and must choose the destination of the app (we will put an iPhone simulator as the destination during the fair), and click the run button (displayed as a play icon) in the top left corner. If the destination is chosen to be a simulator, an iPhone simulator will then pop up on the screen and display the app. The app is configured using the Build Settings, Schemes, and Build Phases settings of the CS50 app target in Xcode.

How to:

Use the Map tab -
The Map tab has the following buttons: A zoom in button (displayed as a plus sign) that zooms in when clicked, a zoom out button that zooms out when clicked (displayed as a minus sign), a button that takes the user to their present location when clicked once and displays a compass when clicked again (displayed as an arrow). The user can move around the map by dragging the screen. If wishing to create a report for an ICE sighting, the user must double click on the location on the map that the sighting occurred. This double click will trigger a form that can then be filled out with a detailed report. The user is only permitted to update the description. There is a save and cancel button. If the user wishes to save their report, they can click the save button. If they wish to update a pin that already exists, the user must click on the pin that they wish to update, change the description as desired and click save, again. The pin will be updated for the user and display the new description on the map pin but will be displayed as an additional report on the Reports tab. To view the description of a pin, the user must click the pin.

Use the Resource tab -
The Resources tab is denoted by a little book icon on the main navigation bar on the app interface. The page features a title "Resources to Support you" and three subheadings: "Know Your Rights","Boston/Cambridge Community Resources", and "Legal Services". Under each of these subheadings are a series of buttons labeled with the corresponding resource titles (ie. "Center to Support Immigrant Organizing"). When pressed, any of these buttons direct the user to a page that outlines contact information (phone numbers) for each of the organizations. One of the key features of the Resources Page is the toggle switch at the top of the page. It defaults to the off setting, but can be toggled on and is denoted by a blue accent color that appears behind the switch. When toggled on, the text on screen switches from English translations to Spanish. This feature was piloted with this page specifically and meant to be an effort to increase accesibility. 

Use the Reports tab -
The Reports tab is denoted by a little three-line icon on the main navigation bar. When the user clicks on the icon, a page opens up featuring recent ICE activity reports in chronological order. Each report is showcased inside of a white box with a red alert icon on the left-hand side of the box. Users can click on any of the white report boxes to be redirected to more details about that specific report. The details included in the redirection are the date and time the report was made as well as a brief description. Users use arrow buttons to navigate into details for each report and out of these details back into the list view of all recent reports. This report tab feature was our way of incorporating data aggregration into the app, but we feel in the future additional privacy measures could be added to better protect users. 







URL TO YOUTUBE VIDEO: 






















