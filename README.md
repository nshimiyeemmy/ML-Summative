# Student Performance Prediction System

## Mission

To revolutionize education through AI-powered performance prediction, empowering educators with actionable insights and students with personalized learning pathways.

**Source of Data:** [Kaggle - Students Performance Dataset](https://www.kaggle.com/datasets/spscientist/students-performance-in-exams)

## System Architecture

This project consists of three integrated components:
1. **Machine Learning Model**: Linear regression model trained on student performance data
2. **Prediction API**: FastAPI backend serving model predictions
3. **Flutter Mobile App**: User-friendly interface for making predictions

## API Endpoint

### Base URL:
`https://ml-summative-fmbr.onrender.com/`

### Swagger UI Documentation:
`https://ml-summative-fmbr.onrender.com/docs`  

### Demo Video Link:
`https://your-link-to-the-demo` 

## Key Features

- **Performance Prediction**: Predicts math scores based on 7 key factors
- **Data-Driven Insights**: Identifies patterns in student performance
- **Cross-Platform Mobile App**: Accessible on both Android and iOS
- **RESTful API**: Scalable backend service with proper documentation

## Installation Guide

### Prerequisites:
- Python 3.8+ (for API)
- Flutter SDK (for mobile app)
- Git (version control)

### 1. Machine Learning Model & API
```bash
# Clone repository
1. Clone the repository:
```
git clone https://github.com/nshimiyeemmy/ML-Summative.git
```
2. Navigate to the project directory

```
cd ML-Summative/summative/flutter_app
```

3. Install dependencies

```
flutter pub get
```

4. run the flutter app
```
flutter run
```