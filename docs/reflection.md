# Project Reflection

## Course Topics Applied
We used what we learned from the Journal and Weather assignments to make this app. We refactored code from those assignments to suit the needs of our app, utilizing views, providers, models, and adding helpers to support the models and providers.

### Accessibility Implementation
Our accessibility work focused on text-to-speech and color contrast. While we initially failed in some areas (as our audit suggested), we addressed these issues. The main improvement was adding a bar around the high and low temperature display to provide better contrast against our changing app bar.

### Technical Implementation
Our main technical features came from the weather and data persistence components. We had to refactor the weather logic to get the high and low temperatures for display. In the database, we originally used a Color type in the clothing item class, but Isar does not recognize this, so we changed it to a string and created a helper to convert between strings and colors.

## Resources and Acknowledgments
- [IsarLinks documentation](https://pub.dev/documentation/isar/latest/isar/IsarLinks-class.html)
- Most of our resources came from previous assignments

### External Resources
- Flutter/Dart documentation
- Isar documentation

### Course Resources
- Journal assignment
- Food Finder assignment

### AI Tools
We used ChatGPT when we were stuck on a database issue where only one wardrobe and item would display at a time. The issue was that we accidentally set the ID to 0 upon initialization, so only the last item would be retrieved. We also used AI for help when Flutter would not run due to changes in pubspec, which required us to update our settings in Android Studio.

## Learning Outcomes
This project helped us learn how to work in a team environment and improve our use of Git and Jira to work efficiently and stay on top of tasks.

## Design Evolution
The overall design stayed mostly the same, but we changed some icons and widgets to improve contrast, such as the widget for high and low temperatures.

## Refinement

## Future Work
Making it so that you can reuse articles of clothing (like a search bar that filters by word) so that if you are already adding the same thing we can reduce the number of items in Isar.

Then making it so that users can add their own colors into the app.

## CSE 340 Reflection
Learn how to work with Git and establish a workflow, as that will make life a lot easier.