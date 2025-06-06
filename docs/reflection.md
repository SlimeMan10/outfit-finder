# Project Reflection

## Course Topics Applied
We used what we learned from the Journal and Weather assignments to make this app. We refactored code from those assignments to suit the needs of our app, utilizing views, providers, models, and adding helpers to support the models and providers.

o	Accessing phone sensors – getting current location for the weather query 
o	Querying web services – getting weather condition and hi/low for the day from National Weather Service
o	Undo and Redo – undo and redo for clothing item deletions 
o	Data persistence – using Isar to store and maintain all the outfits persistently 
o	Internationalization – supports Spanish and English (button to toggle either language) 


### Accessibility Implementation
Our accessibility work focused on text-to-speech and color contrast. While we initially failed in some areas (as our audit suggested), we addressed these issues. The main improvement was adding a bar around the high and low temperature display to provide better contrast against our changing app bar.

-	Design principles used: 
o	Make changes obvious 
	Visually: color change for selecting a weather tag in outfit view, black border around selected color for clothing item
	Orally: semantics label change for selected vs unselected weather tag in outfit view, semantics label change for selected color for clothing item 
o	Tap targets large enough: Padding for all buttons and large sizing for the actual icons 
o	Make Items Distinct: 
	Different icons and text for weather tags 
	Different colors available for clothing items
	Different boxes and sizes for different inputs and types (ie Outfit box, add clothing item box, current items box) 
o	Don’t rely on bleu for small objects : For smaller blue objects we included text and semantics label to help identify the objects (ie current items with blue hanger, blue clothing item with text description and blue rainy weather tag with semantics labels)
o	Minimize saturated colors: main colors of the app are white with the only saturated colors being the weather tags and clothing item colors which are small objects 


### Technical Implementation
Our main technical features came from the weather and data persistence components. We had to refactor the weather logic to get the high and low temperatures for display. In the database, we originally used a Color type in the clothing item class, but Isar does not recognize this, so we changed it to a string and created a helper to convert between strings and colors.


## Resources and Acknowledgments
- [IsarLinks documentation](https://pub.dev/documentation/isar/latest/isar/IsarLinks-class.html)
- Most of our resources came from previous assignments

### External Resources
- Flutter/Dart documentation
- Isar documentation
- Figma: for creating our Wireframes and poster
- Jira: for organizing tasks 


### Course Resources

o	Starter Code from previous assignments 
	Journal: used the majority of the backend of this (provider, entry like outfit, wardrobe like journal, Isar) 
	Food Finder: weather and position provider 
	Drawing: undo redo feature 


### AI Tools
	Copilot: for searching up certain methods / Widgets to use, helpful in suggesting Widgets to use and showing available methods (and their syntax) 
•	Ie is there a concise way to add 3 items to a list in flutter => response helpful telling me about addAll() method 
	We used ChatGPT when we were stuck on a database issue where only one wardrobe and item would display at a time. The issue was that we accidentally set the ID to 0 upon initialization, so only the last item would be retrieved. 
	We also used AI for help when Flutter would not run due to changes in pubspec, which required us to update our settings in Android Studio.


## Learning Outcomes
This project helped us learn how to work in a team environment and improve our use of Git and Jira to work efficiently and stay on top of tasks.

-	Challenge/Deepening understanding of course topics: 
o	Understanding how to use weather API to query new weather information from NWS and adjust weather checker 
o	Data persistence: learning how to use IsarLinks so we don’t have to maintain a local database in addition to persistent Isar database 
o	Internationalization: implementing support for another language, (all new since we didn’t have an assignment with this) 


## Design Evolution
The overall design stayed mostly the same, but we changed some icons and widgets to improve contrast, such as the widget for high and low temperatures.

-	Changes: 
o	We were going to implement undo/redo for deleting outfits but felt like it would be easier to implement the undo/redo for item deletions as it gave the user more flexibility and seemed more reasonable. Also we thought it’d be easier to implement because we would have to keep track of less information (outfit vs clothing item) and for less time (in outfit view vs during entire app duration). 
o	We were going to show the average temperature for the day but decided that it was more helpful and reasonable for user experience to show the hi and the low temp for the day. It gives better information forecast for the day then just a average. 


## Refinement

## Future Work
Making it so that you can reuse articles of clothing (like a search bar that filters by word) so that if you are already adding the same thing we can reduce the number of items in Isar.

Then making it so that users can add their own colors into the app.

## CSE 340 Reflection

o	Most valuable thing: I think the most valuable thing I learned was the general process for creating a project and group workflow with git. I hadn’t done those things before, and I think they reflected how software developers and projects work in industry which is extremely valuable. 

o	Advice:
	Do the resubmissions as they were really helpful for learning and getting a good grade back. 
	Start everyone working on the group project earlier and work on things you can test visually/run. I think my group started a little late and I kind of did the work out of order. The final project is the most important for learning and grade wise too. There are many components to it. 
Learn how to work with Git and establish a workflow, as that will make life a lot easier.
