from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import pandas as pd

# Load the saved model
model = joblib.load('diabetes_model.pkl')

app = Flask(__name__)
CORS(app)

# Define the home route
@app.route('/')
def index():
    return "Diabetes Prediction API"

# Prediction route
@app.route('/predict', methods=['GET'])
def predict():
    try:
        # Get form data from the POST request
        pregnancies = request.args['pregnancies']
        glucose = request.args['glucose']
        diastolic = request.args['diastolic']
        triceps = request.args['triceps']
        insulin = request.args['insulin']
        bmi = request.args['bmi']
        dpf = request.args['dpf']
        age = request.args['age']
        
        # Create a DataFrame for the model
        user_input = pd.DataFrame([[pregnancies, glucose, diastolic, triceps, insulin, bmi, dpf, age]],
                                  columns=['pregnancies', 'glucose', 'diastolic', 'triceps', 'insulin', 'bmi', 'dpf', 'age'])

        # Make the prediction
        prediction = model.predict(user_input)[0]

        # Return the result
        return jsonify({'prediction': int(prediction)})

    except Exception as e:
        return jsonify({'error': str(e)})
    




# Example personalized health recommendations
def get_health_recommendations(age, weight, gender, activity_level):
    recommendations = {}

    # Example logic for diet recommendations based on age and weight
    if age < 30:
        recommendations['diet'] = "Focus on lean protein, whole grains, and lots of fruits and vegetables."
    elif 30 <= age <= 50:
        recommendations['diet'] = "Maintain a balanced diet, limit red meat, and increase fiber intake."
    else:
        recommendations['diet'] = "Ensure calcium and vitamin D intake, and eat foods low in saturated fats."

    # Example logic for exercise recommendations based on activity level
    if activity_level == "low":
        recommendations['exercise'] = "Start with light exercises like walking for 30 minutes a day."
    elif activity_level == "moderate":
        recommendations['exercise'] = "Incorporate strength training and cardio 3-4 times a week."
    else:
        recommendations['exercise'] = "Engage in high-intensity interval training and weight lifting."

    # Add personalized tips based on gender
    if gender == "female":
        recommendations['additional_tips'] = "Ensure adequate intake of iron and folic acid."
    else:
        recommendations['additional_tips'] = "Consider healthy fats like omega-3 for heart health."

    return recommendations

# Flask route to handle health recommendation requests with query params
@app.route('/health_recommendations', methods=['GET'])
def health_recommendations():
    # Get data from the query parameters
    age = request.args.get('age', type=int)
    weight = request.args.get('weight', type=float)
    gender = request.args.get('gender')
    activity_level = request.args.get('activity_level')

    # Validate input
    if not all([age, weight, gender, activity_level]):
        return jsonify({"error": "Missing input data"}), 400

    # Get personalized recommendations
    recommendations = get_health_recommendations(age, weight, gender, activity_level)

    # Return the recommendations as JSON response
    return jsonify(recommendations), 200
if __name__ == '__main__':
    app.run(debug=True)
