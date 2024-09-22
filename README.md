# Diabecare App


Diabecare is a comprehensive Flutter application designed to help users monitor their diabetes risk and health. The app leverages machine learning to predict diabetes risk based on user inputs and provides personalized health recommendations.



## Key Features
- User Profile: Users can create and update their profiles, including personal information and health data.
- Diabetes Prediction: Users input medical data, and the app uses a machine learning model to predict diabetes risk.
- Health Recommendations: Based on the prediction and user data, the app provides tailored health and dietary recommendations.
- Records Management: Users can view past records of their health data and predictions.



## Tech Stack
- Frontend: Flutter
- Backend: Flask
- Database: Hive (for local storage)
- Machine Learning: Logistic Regression model for diabetes prediction

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Widgets Included](#widgets-included)
- [Contributing](#contributing)
- [License](#license)

## Installation


1. Clone this repository to your local machine:

```bash
git clone https://github.com/yourusername/diabecare-app.git
cd diabecare-app
```
2. Install Flutter dependencies:
```bash
flutter pub get
```
3. Install Python dependencies:

- Ensure you have Python 3 installed.
- Navigate to the flask_backend directory.
- Install Flask and other dependencies:
```bash
flutter pub get
```



4. Set up Hive:
- Ensure that Hive is set up correctly by following the instructions in the lib/utils/hive_setup.dart file.
  5. Run the Flask backend:

- Navigate to the flask_backend directory.
- Start the Flask server:
```bash
python app.py
```
6. Run the Flutter app:
```bash
flutter run

```
 
## Configuration
- Backend URL: Ensure that the URL for the Flask backend is
   correctly set in the Flutter app's configuration files.



## Usage
- Create a Profile: Navigate to the profile page to create or update your user profile.
- Enter Health Data: Input your health data to get predictions and recommendations.
- View Records: Access the records page to see past health data and predictions.


## Contributing
Contributions to the Diabecare app are welcome! If you have suggestions, bug reports, or want to contribute code, please follow these guidelines:

- Fork the repository.
- Create a feature branch:
```bash
git checkout -b feature/your-feature
```
- Commit your changes:
```bash
git commit -am 'Add new feature'
```
- Push to the branch:
```bash
git push origin feature/your-feature
```
- Create a new Pull Request.
  # Demo:
  https://drive.google.com/file/d/1m3E2KXDQ9abuxEuNZdTF8x54SRFJYdPl/view?usp=sharing
