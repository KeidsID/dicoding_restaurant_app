[dicodingclass]: https://www.dicoding.com/academies/195
[jsonassets]: https://github.com/dicodingacademy/assets/blob/main/flutter_fundamental_academy/local_restaurant.json
[apilink]: https://restaurant-api.dicoding.dev/
[apppreview]: https://raw.githubusercontent.com/KeidsID/KeidsID/main/assets/other/flutter-repo/RESTAURantS_App_Preview.gif

# **restaurant_app_project**

Submission project task from [dicoding.com Intermediate Flutter class][dicodingclass].

It is hoped that with this assignment, students can create Flutter applications by implementing common features such as retrieving data from the internet, local storage, notifications, and testing.

Run these commands before build:

```
flutter pub get
flutter pub run flutter_native_splash:create
```

### **Note:**

- Web build is not possible for now.
- Never test IOS build yet, because owner is Android and Windows user.

## **App Preview**

![App Preview Gif][apppreview]

## **1st Submission Task**

Create an app with a Restaurant Theme.

The app displays a list of restaurants along with their details. The Data used is local data that you can get [at this link][jsonassets].

Must have features in the app:

### 1. Restaurant list

- Displays a list of restaurants with brief information.

### 2. Restaurant details

- Displays detailed information when an item is pressed.

## **2nd Submission Task**

Use restaurant data from API for the app.

Use the following API to get restaurant data:  
https://restaurant-api.dicoding.dev/

Must have features in the app:

### 1. Restaurant List

- Displays a list of restaurants with brief information from the API.
- Displays restaurant images retrieved from the API.

### 2. Restaurant Details

- Displays detailed information when an item is pressed, such as description, city, rating, food menu, and drink menu.
- Displays restaurant images retrieved from the API.

### 3. Restaurant Search

- Displays restaurant search results by menu or restaurant name.

### 4. There is a loading indicator when the application loads data.

### 5. Displays error messages that are easily understood by the user when the application is accessed without an internet connection.

### 6. Using one of the state management libraries such as provider, block, redux, etc.

## **3rd Submission Task**

Must have feature in the app:

### 1. Favorite Restaurant

- Users can add and remove the restaurant from their favorite list.
- The application must have a page to display a list of favorites.
- Displays the detail page of the favorites list (when the favorite item pressed).

### 2. Daily Reminder

- There is a setting to turn the reminder on and off on the settings page.
- Daily reminder to display restaurants randomly at 11.00 AM.

### 3. Testing

- Write at least one test scenario to verify the json parsing was successful.
