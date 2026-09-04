# Poe_Raceday
Programming Assignment 1 
RaceDay is a full-stack, cloud-aware, API-driven event management platform built for the South African road running, walking, and cycling community. It replaces the paper-based registration, spreadsheets, and disconnected communication channels that many local road events — from parkruns to the Comrades Marathon — still rely on today.

This repository is submitted as an individual Portfolio of Evidence (PoE), built progressively across three parts, reflecting real-world software development practices used in the sports technology industry.

Table of Contents
Project Overview
Key Features
Tech Stack
Repository Structure
Database Design (ERD)
API Endpoint Plan
Status Values
Getting Started
Environment Variables
Running the Project
Project Roadmap

Project Overview

RaceDay allows two types of users to interact with the platform:

Event Organisers — create and manage events, define entry categories, and capture participant results.
Participants — browse upcoming events, enter races, track their personal performance history, and prepare for race day using live weather and route information.

The system is built as a containerised, API-driven platform with a relational database backing it, designed to scale from a single community fun run to a large multi-category event like the Cape Town Cycle Tour.

Key Features
🔐 Secure user registration and authentication (Organiser / Participant roles)
📅 Full CRUD event management for Organisers
🏷️ Multiple entry categories per event (e.g. 5km, 10km, Half Marathon)
📝 Online event entry and enrolment for Participants
🏆 Results capture and personal performance history tracking
🌦️ Live weather information for upcoming events
🗺️ Route/map information per event
📦 Fully containerised, cloud-aware deployment (Part 3)

Database Design (ERD)

The full Entity Relationship Diagram is available at /docs/raceday_erd.png.

The data model consists of 6 core entities:

Entity	Description
Users	Stores both Organisers and Participants, distinguished by a role attribute
Events	Races/events created by an Organiser
Categories	Distance/entry options within an event (e.g. 10km Open)
Routes	Route and map information tied to an event
Event_Enrolments	A Participant's entry into a specific Category
Results	The captured finish-line outcome for a single Enrolment

Relationship summary:

Relationship	Cardinality	Notes
Users → Events	1 : M	One Organiser creates many Events
Events → Categories	1 : M	One Event offers many Categories
Events → Routes	1 : M	One Event can have multiple Routes
Categories → Event_Enrolments	1 : M	One Category receives many Enrolments
Users → Event_Enrolments	1 : M	One Participant submits many Enrolments over time
Event_Enrolments → Results	1 : 1	Each Enrolment produces at most one Result

The SQL schema in Section C is built to match this ERD exactly. Any deliberate deviation between the ERD and the SQL script is documented in Deviations from the Plan below.
The SQL schema in Section C is built to match this ERD exactly. Any deliberate deviation between the ERD and the SQL script is documented in Deviations from the Plan below.

API Endpoint Plan

The full endpoint plan — covering Authentication, User Profile, Events, Categories, Event Enrolments, and Results — is available at /docs/api_endpoint_plan.md.

It documents, for every endpoint: HTTP method, route, description, required role, request body, and expected response — planned ahead of any code being written, per the PoE brief.

The implemented API in Part 2 is built to closely match this plan.

Status Values

Three entities use a status attribute as a controlled set of values rather than free text:

<details> <summary><strong>Events.status</strong></summary>

Draft · Open for Entries · Entries Closed · In Progress · Completed · Cancelled · Postponed

</details> <details> <summary><strong>Event_Enrolments.status</strong></summary>

Pending Payment · Active · Cancelled · Transferred · Waitlisted · Checked In · No Show

</details> <details> <summary><strong>Results.status</strong></summary>

Finished · DNF · DNS · DSQ · Cut-Off · Provisional · Official

</details
  Database Schema — SQL Script (Section C)

The full CREATE TABLE script lives at /docs/schema.sql (or /db/schema.sql, depending on the final repo layout) and implements the six entities from the ERD above exactly as modelled. Rather than pasting the raw SQL here, this section describes in words what that script sets up and why, so the README stays readable for anyone reviewing the design without needing to open the script itself.

Users table. Holds every account on the platform, whether Organiser or Participant. user_id is the primary key and auto-increments. email carries a uniqueness constraint so no two accounts can register with the same address, and it's also indexed since login looks it up on every request. password_hash never stores a plain-text password — only the hashed value. role is restricted to a small fixed set of values (Organiser or Participant) using a check constraint rather than free text, to stop invalid roles being inserted. created_at defaults to the current timestamp automatically, so the application never has to set it manually.
Events table. Each row is one race. event_id is the primary key. organiser_id is a foreign key back to Users, and it's set to required (not nullable) because an event can never exist without an owner; if an organiser's account were ever deleted, this relationship is set to restrict that deletion rather than silently orphaning their events. event_date is stored as a proper date/time type (not text) so the application can sort and filter events chronologically and compare them against "today" for the upcoming-events listing. status is restricted to the fixed set of event statuses described in the Status Values section, again via a check constraint.


Categories table. Each row is one distance/entry option within an event. category_id is the primary key, and event_id is a required foreign key back to Events. Because a category cannot outlive its parent event, this relationship cascades on delete — if an event is removed, its categories are removed with it. entry_fee uses a proper decimal/numeric type rather than a float, since money values need exact precision rather than the small rounding errors floating-point numbers can introduce. max_participants is a whole-number field used by the application to stop accepting entries once a category is full.


Routes table. Each row is one route/map record tied to an event. route_id is the primary key and event_id is a required foreign key back to Events, also cascading on delete for the same reason as Categories — a route only ever makes sense in the context of its parent event. elevation_gain_m is stored as a whole number in metres.

Event_Enrolments table. Each row is one participant's entry into one category. enrolment_id is the primary key. It carries two foreign keys — user_id back to Users and category_id back to Categories — both required, since an enrolment cannot exist without knowing both who entered and what they entered for. bib_number is generated by the application at enrolment time. A combined uniqueness rule across user_id and category_id prevents the same participant from accidentally entering the same category twice. status follows the fixed enrolment-status list described below, and payment_status is tracked as its own field so entry status and payment status can change independently of each other.
