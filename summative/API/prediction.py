from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, validator
import joblib
import pandas as pd
import uvicorn
import os
from typing import Literal
from pathlib import Path

app = FastAPI(
    title="Student Performance Prediction API",
    description="API for predicting student math scores based on various factors",
    version="1.0.0",
    docs_url="/docs"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define the input data model
class StudentData(BaseModel):
    gender: Literal["male", "female"] = Field(..., description="Student's gender")
    race_ethnicity: Literal["group A", "group B", "group C", "group D", "group E"] = Field(..., description="Race/ethnicity group")
    parental_level_of_education: Literal["some high school", "high school", "some college", "associate's degree", "bachelor's degree", "master's degree"] = Field(..., description="Parental education level")
    lunch: Literal["standard", "free/reduced"] = Field(..., description="Type of lunch")
    test_preparation_course: Literal["none", "completed"] = Field(..., description="Test preparation course status")
    reading_score: int = Field(..., ge=0, le=100, description="Reading score (0-100)")
    writing_score: int = Field(..., ge=0, le=100, description="Writing score (0-100)")

# Prediction response model
class PredictionResponse(BaseModel):
    predicted_math_score: float
    message: str

# Load model - improved version
def load_model():
    try:
        # Try multiple possible locations for the model file
        possible_paths = [
            Path(__file__).parent.parent / "linear_regression" / "models" / "best_student_performance_model.pkl"
        ]
        
        model = None
        for path in possible_paths:
            if path.exists():
                print(f"Found model at: {path}")
                model = joblib.load(path)
                break
        
        if model is None:
            raise FileNotFoundError("Could not find model file in any of the searched locations")
        
        print("Model loaded successfully")
        return model
        
    except Exception as e:
        print(f"Error loading model: {str(e)}")
        return None

# Load the model when starting the app
model = load_model()

@app.on_event("startup")
async def startup_event():
    # This will print the current working directory and verify model loading
    print(f"Current working directory: {os.getcwd()}")
    print(f"Model is {'loaded' if model is not None else 'NOT loaded'}")

@app.post("/predict", response_model=PredictionResponse)
def predict(student_data: StudentData):
    if model is None:
        raise HTTPException(
            status_code=500,
            detail="Model not loaded. Please check server logs for loading errors."
        )
    
    try:
        # Convert to DataFrame with correct column names
        input_data = student_data.dict()
        
        # Map the field names to match what the model expects
        input_data_mapped = {
            'gender': input_data['gender'],
            'race/ethnicity': input_data['race_ethnicity'],
            'parental level of education': input_data['parental_level_of_education'],
            'lunch': input_data['lunch'],
            'test preparation course': input_data['test_preparation_course'],
            'reading score': input_data['reading_score'],
            'writing score': input_data['writing_score']
        }
        
        input_df = pd.DataFrame([input_data_mapped])
        
        # Make prediction
        prediction = model.predict(input_df)[0]
        
        return {
            "predicted_math_score": round(float(prediction), 2),
            "message": "Prediction successful"
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/")
def read_root():
    return {"message": "Student Performance Prediction API - Visit /docs for documentation"}

@app.get("/health")
def health_check():
    return {
        "status": "ready" if model is not None else "model not loaded",
        "model_loaded": model is not None
    }

if __name__ == "__main__":
    uvicorn.run("prediction:app", host="0.0.0.0", port=8000, reload=True)