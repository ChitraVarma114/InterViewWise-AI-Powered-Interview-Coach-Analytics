# InterViewWise — AI-Powered Interview Analytics Platform

A **Flask + MySQL** platform that quantifies interview performance through NLP- and CV-derived metrics — sentiment scores, confidence signals, answer-quality ratings, and posture/face-presence checks — and surfaces them through an interactive **Chart.js** dashboard that tracks a user's progress over time.

**The core idea:** most interview-prep tools are subjective. This project asks a different question — *what if improvement could be measured?* Every mock interview becomes a structured row of data the user can analyze, turning a fuzzy "I think I did better" into a number you can chart.

⚠️ **Project status: MVP / solo learning project.** The core analytics pipeline (quiz module, speech-to-text, sentiment scoring, LLM answer evaluation, MediaPipe face/pose detection, dashboards, chatbot) is functional. Real-time *live* video streaming in the browser is only partially wired — see Limitations. Built solo as a final-year exploration project.

---

## What This Project Actually Does (Data Pipeline)

```
User attempts a mock interview (audio / video)
        │
        ▼
Speech-to-text  (AssemblyAI REST API)      ──►  raw transcript
        │
        ▼
Sentiment scoring  (NLTK VADER)            ──►  positive / negative / neutral + confidence signal
        │
        ▼
Answer evaluation  (OpenAI GPT-4o-mini)    ──►  answer-quality rating + written feedback
        │
        ▼
Face & posture check  (MediaPipe + OpenCV) ──►  face-presence count + posture-detected signal
        │
        ▼
Persistence  (MySQL)                       ──►  attempt history (scores, sentiment, transcript, timestamp)
        │
        ▼
Dashboard  (Chart.js)                      ──►  trends, role-wise comparisons, weak-area analysis
```

Each attempt is stored as structured data, building a longitudinal record the user can analyze to spot patterns in their own performance over time.

---

## Key Features

- **Performance dashboard** — Chart.js line, bar, and doughnut charts of quiz scores over time, sentiment trends per attempt, and role-wise breakdowns.
- **Role-based tracking** — compare attempts across roles (HR, SDE, Data Science, Product Management) to surface strongest and weakest areas.
- **Sentiment time series** — VADER-based positive/negative/neutral scoring of each recorded answer, charted against attempt history.
- **Quiz analytics** — per-topic accuracy, attempt frequency, and score distributions.
- **Face & posture signals** — MediaPipe face-detection and pose-detection over video frames (presence count + posture detected).
- **Resume → skill extraction** — PyPDF2 / python-docx parse an uploaded resume to extract skills that feed role-specific question generation.
- **AI chatbot** — a GPT-backed career assistant with persistent, multi-session chat history.

---

## Tech Stack

**Application layer**
- **Flask (Python)** — routes, session management, server-side logic
- **Jinja2** — server-rendered HTML templates
- **Werkzeug** — password hashing and security

**Data layer**
- **MySQL** (via `mysql-connector-python`) — relational schema for users, attempts, scores, transcripts, sentiment, and chat data, designed for analytical queries (joins across attempts, users, roles, topics)

**NLP & ML pipeline**
- **AssemblyAI** — speech-to-text (called over its REST API with `requests`)
- **OpenAI GPT-4o-mini** — answer-quality evaluation and question generation
- **NLTK VADER** — sentiment analysis on transcribed responses
- **MediaPipe + OpenCV** — face-detection and pose-detection on video frames

**Visualization**
- **Chart.js** — dashboards (line, bar, doughnut charts)

**Supporting**
- **FFmpeg** — audio format conversion (`.webm` → `.wav`) via subprocess
- **PyPDF2 / python-docx** — resume parsing (PDF / Word)
- **BeautifulSoup** — optional LinkedIn profile scraping pathway

---

## Database Schema (analytics-friendly design)

The MySQL schema is built for analytical queries. Key tables:

- `users` — profiles, role preferences, signup dates
- `quizzes` / `quiz_attempts` — question bank and every attempt (score, role, topic, timestamp)
- `interview_questions` / `dynamic_questions` — static and AI-generated question sets
- `live_interview_attempts` — every mock interview with sentiment, confidence, body-language signals, transcript, and GPT feedback
- `interview_feedback_detailed` — per-category feedback (technical / communication / body language)
- `chat_sessions` / `chat_messages` — multi-session chatbot history
- `resume_analysis` — parsed skills, experience, and AI resume review

This structure supports queries such as *"average sentiment score per role over the last 30 days"* or *"which topic has the lowest quiz accuracy"* — the kind of analysis you'd run on production data.

---

## Setup

**Prerequisites:** Python 3.10+, MySQL, and FFmpeg installed on your system.

```bash
git clone https://github.com/ChitraVarma114/interviewwise.git
cd interviewwise
pip install -r requirements.txt
```

Create a `.env` file based on `.env.example` and fill in your own values:

```env
SECRET_KEY=your-secret-key
OPENAI_API_KEY=your-openai-api-key
ASSEMBLYAI_API_KEY=your-assemblyai-api-key
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=your-password
MYSQL_DATABASE=interviewwise_db
FFMPEG_PATH=ffmpeg
```

Set up the database:

```bash
mysql -u root -p -e "CREATE DATABASE interviewwise_db;"
mysql -u root -p interviewwise_db < migrations/schema.sql
mysql -u root -p interviewwise_db < migrations/sample_data.sql
```

Run the app:

```bash
flask run
```

> On first run, NLTK downloads the `vader_lexicon` automatically if it isn't already present. The `static/uploads/` folder is created automatically.

---

## Project Structure

```
interviewwise/
├── app.py                    # Flask routes, pipeline logic, API integrations
├── requirements.txt
├── .env.example              # Template for keys/config (.env is gitignored)
├── .gitignore
├── migrations/
│   ├── schema.sql            # MySQL schema (all tables)
│   └── sample_data.sql       # Seed data for testing
├── static/
│   ├── style.css
│   └── uploads/              # Resume + audio/video uploads (gitignored, auto-created)
└── templates/
    ├── base.html             # shared layout (all pages extend this)
    ├── index.html, login.html, register.html
    ├── profile.html, edit_profile.html
    ├── quiz.html, quiz_result.html
    ├── mock_interview.html   # live AI interview UI (webcam + recording)
    ├── chatbot.html
    └── review.html, resume_review.html   # AI resume feedback
```

---

## What I Learned

- **End-to-end data pipeline design** — from raw user input (audio) through preprocessing (FFmpeg), processing (AssemblyAI, NLTK, GPT-4o-mini), to analytics-ready storage (MySQL) and visualization (Chart.js).
- **Schema design for analytical queries** — structuring tables and relationships specifically to support role-wise comparison and time-series tracking, not just storage.
- **Working with NLP outputs as data** — treating sentiment scores and LLM ratings as quantitative metrics to be charted and compared, not just one-off qualitative outputs.
- **API integration patterns** — environment-based key management, REST polling (AssemblyAI), and format conversion across services.
- **Solo scope management** — recognizing when to ship an MVP versus chase feature creep; deciding which metrics were realistic to deliver under a timeline.

---

## Limitations & Honest Disclosures

- **Live real-time video** — the MediaPipe face/pose functions run on recorded/uploaded video; the in-browser *live* streaming UI is only partially wired.
- **Face/pose, not emotion** — MediaPipe here detects face presence and posture; it does **not** classify emotions or measure eye-contact percentage. Those were design goals, not shipped metrics.
- **GPT ratings are not benchmarked** — answer-quality scores are LLM-derived and have **not** been validated against human ground-truth labels.
- **LinkedIn scraping is fragile** — LinkedIn actively blocks scraping; a production version should use the official API with OAuth.
- **MVP scope** — a solo learning project, not a production system.

---

## What I'd Build Next

- A/B test GPT evaluation prompts to find which produce ratings best aligned with self-assessment.
- Add a Power BI layer on top of MySQL for richer analytics (e.g. practice-frequency vs improvement rate).
- Funnel and cohort analysis — where users drop off, which cohorts improve fastest.
- Finish the live MediaPipe pipeline with eye-contact %, expression, and posture-stability metrics.

---

## About

Built solo by **Chitra Varma** — B.Sc Computer Science, Pillai HOC College.

- LinkedIn: https://www.linkedin.com/in/chitra-varma-12aa28323
- Email: chitravarma.cyv@gmail.com
