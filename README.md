# InterViewWise — AI-Powered Interview Analytics Platform

A Flask + MySQL platform that quantifies interview performance through 
NLP-derived metrics — sentiment scores, confidence indices, response 
quality ratings — and surfaces them through an interactive dashboard 
that tracks user progress over time.

The core idea most interview prep tools are subjective. This project 
asks what if we could measure improvement — turning every mock 
interview into structured data the user can analyze.

⚠️ Project status MVP — core analytics pipeline (quiz module, 
sentiment scoring, dashboard, chatbot) is functional. Live video 
analysis with MediaPipe was scoped but not implemented in this version.

---

## What This Project Actually Does (Data Pipeline)
User attempts interview
↓
Speech-to-text (AssemblyAI)  →  Raw transcript
↓
NLP processing (NLTK VADER)  →  Sentiment + confidence scores
↓
LLM evaluation (GPT-4o-mini) →  Answer quality rating + feedback
↓
MySQL logging               →  Persistent attempt history
↓
Dashboard (Chart.js)        →  Trends, comparisons, weak-area analysis

Every interview attempt becomes a structured row of data with 
sentiment scores, confidence ratings, quality ratings, and timestamps. 
Over time, this builds a longitudinal dataset the user can analyze 
to spot patterns in their own performance.

## Key Analytics Features

- Performance Dashboard — Chart.js visualizations of quiz scores 
  over time, sentiment trends per attempt, role-wise performance breakdowns
- Cohort-style Tracking — Compare attempts across roles (HR, SDE, 
  Data Science, PM) to identify strongest and weakest skill areas
- Sentiment Score Time Series — VADER-based positivenegativeneutral 
  scoring of every recorded answer, charted against attempt history
- Quiz Analytics — Per-topic accuracy, attempt frequency, score 
  distributions
- Resume → Skill Extraction — PyPDF2  python-docx parsing extracts 
  skills, feeds into role-specific question generation

## Tech Stack

Data Layer
- MySQL — relational schema for users, attempts, scores, transcripts, sentiment data
- Schema designed for analytical queries (joins across attempts, users, roles, topics)

Application Layer
- Flask (Python) — REST endpoints, session management, route handling
- Werkzeug — password hashing, security
- Jinja2 — server-side templating

NLP & ML Pipeline
- OpenAI GPT-4o-mini — answer quality evaluation, question generation
- NLTK VADER — sentiment analysis on transcribed responses
- AssemblyAI — speech-to-text conversion
- FFmpeg — audio format conversion (.webm → .wav)

Visualization
- Chart.js — performance dashboards with line charts, bar charts, doughnut charts

Document Processing
- PyPDF2 — PDF resume parsing
- python-docx — Word resume parsing
- BeautifulSoup — LinkedIn profile scraping (optional pathway)

## Database Schema (Analytics-Friendly Design)

The MySQL schema was deliberately designed for analytical queries

- `users` — profiles, role preferences, signup dates
- `quiz_attempts` — every attempt with score, role, topic, timestamp
- `interview_attempts` — every mock interview with sentiment scores, 
  transcript, GPT feedback, role
- `chatbot_history` — query logs for usage pattern analysis

This structure supports queries like What's the average sentiment 
score per role over the last 30 days or Which topic has the lowest 
quiz accuracy across all users — exactly the kind of analysis a 
data analyst would run on production data.

## What I Learned

- End-to-end data pipeline design — from raw user input (audio) 
  through preprocessing (FFmpeg), processing (AssemblyAI, NLTK), to 
  analytics-ready storage (MySQL) and visualization (Chart.js)
- Schema design for analytical queries — structured tables and 
  relationships specifically to support cohort analysis and time-series tracking
- Working with NLP outputs as data — treating sentiment scores and 
  GPT ratings as quantitative metrics, not just qualitative outputs
- Quantifying subjective experiences — translating interview 
  performance into measurable dimensions (sentiment, confidence, accuracy)
- API integration patterns — environment-based key management, 
  retry logic, format conversion across services
- Solo project scope management — recognizing when to ship MVP vs 
  pursue feature creep; MediaPipe was scoped out when timeline pressure made it unrealistic

## Project Structure
interviewwise
├── app.py                    # Flask routes & API endpoints
├── requirements.txt
├── .env.example              # Template for API keys (real .env not committed)
├── migrations
│   ├── schema.sql            # MySQL schema definition
│   └── sample_data.sql       # Seed data for testing
├── static
│   ├── style.css
│   └── uploads              # Resume + audio uploads
└── templates
├── index.html, login.html, register.html
├── profile.html, edit_profile.html
├── quiz.html, quiz_result.html
├── mock_interview.html, interview_feedback.html
├── live_interview.html   # Scaffolded; not connected to MediaPipe
├── chatbot.html
└── about.html, roles.html

## Setup

```bash
git clone httpsgithub.comChitraVarma114interviewwise.git
cd interviewwise
pip install -r requirements.txt
```

Create `.env` based on `.env.example`
FLASK_APP=app.py
FLASK_ENV=development
SECRET_KEY=your-secret-key
OPENAI_API_KEY=your-openai-api-key
ASSEMBLYAI_API_KEY=your-assemblyai-api-key
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=your-password
MYSQL_DATABASE=interviewwise_db

Set up the database
```bash
mysql -u root -p
CREATE DATABASE interviewwise_db;
exit;
mysql -u root -p interviewwise_db  migrationsschema.sql
mysql -u root -p interviewwise_db  migrationssample_data.sql
```

Run
```bash
flask run
```

## Limitations & Honest Disclosures

- MediaPipe body-language analysis was scoped but not implemented — 
  the live_interview template exists as scaffolding but does not 
  currently connect to MediaPipe. Building this requires significant 
  additional work in computer vision pipelines.
- LinkedIn scraping is fragile (LinkedIn actively blocks scraping); 
  in production this should use the official API with OAuth.
- GPT-4o-mini ratings are not validated against human ground truth 
  — interview quality scores are LLM-derived, not benchmarked.
- MVP scope — this was a solo learning project, not a production system.

## What I'd Build Next (If Resumed)

- AB test prompt strategies for GPT evaluation to see which prompts 
  produce ratings most aligned with self-assessment
- Add Power BI  dashboard layer on top of MySQL for richer analytics 
  — e.g., users who improve fastest typically practice X timesweek
- Cohort analysis do users from certain backgrounds improve faster 
  than others Where in the funnel do users drop off
- Implement MediaPipe properly with eye-contact %, smile frequency, 
  and posture-stability metrics

## About

Built solo by Chitra Varma as a final-year exploration project — 
B.Sc Computer Science, Pillai HOC College.

🔗 LinkedIn httpswww.linkedin.cominchitra-varma-12aa28323  
📧 chitravarma.cyv@gmail.com