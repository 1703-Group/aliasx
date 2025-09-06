# Alias Game Functionality Specification

## Overview
A minimalistic real-time Alias game built with Phoenix LiveView, utilizing PubSub and GenServers for state management. All game logic contained within a single LiveView file for simplicity.

## Core Features

### 1. Session Management
- **Create Session**: Simple button to create new game session
- **Unique Links**: Each session gets a unique hash-based URL (`/game/:session_id`)
- **Difficulty Selection**: Choose word set difficulty (Easy/Medium/Hard) during session creation
- **No Authentication**: No logins, registrations, or persistent user accounts

### 2. Lobby System
- **Join via Link**: Users join by visiting the unique session URL
- **Nickname Entry**: Each user can set their display name (must be unique)
- **Team Management**: 
  - Join existing teams (automatically numbered: Team 1, Team 2, etc.)
  - Create new teams with "Join New Team" button
  - Waiting room for unassigned players (AFK tolerance)
- **Ready State**: Only team members must press "Ready" to start game
- **AFK Handling**: Players in waiting room don't block game start
- **Flexible Start**: Can start with just 1 team (2+ players) or multiple teams

### 3. Game Flow
- **Turn-based Gameplay**: Teams take turns explaining words
- **Timed Rounds**: Each turn has a 60-second timer
- **Timer Audio**: Sound notification when time expires
- **Word Presentation**: Current explainer sees words at bottom of screen
- **Action Buttons**: "Next" button to progress through words (disabled after timer expires)
- **Real-time Visibility**: All actions immediately visible to all players
- **Word States**: Words can be explained (correct) or skipped
- **Auto Turn End**: Round automatically ends when timer reaches zero

### 4. Technical Architecture
- **Single LiveView**: All game logic in `AliasxWeb.GameLive`
- **GenServer per Session**: Manages game state and word sets
- **PubSub Integration**: Real-time updates to all session participants
- **In-Memory Storage**: No database persistence required
- **AFK Tolerance**: Only team members count for ready state, waiting room ignored
- **Single Team Support**: Allows 1 team with 2+ players to play cooperatively

## Game States
1. **Lobby** - Players joining, forming teams, setting ready status
2. **Playing** - Active game with word explanation
3. **Round End** - Score display and team rotation
4. **Game Over** - Final scores and restart options

## Data Structure
```elixir
%GameState{
  session_id: string(),
  difficulty: :easy | :medium | :hard,
  phase: :lobby | :playing | :round_end | :game_over,
  players: %{user_id => %{nickname: string(), team: string() | nil, ready: boolean()}},
  teams: [%{name: string(), members: [user_id], score: integer()}],
  current_team: integer(),
  current_explainer: user_id,
  current_word: string() | nil,
  words_used: [%{word: string(), status: :explained | :skipped}],
  remaining_words: [string()],
  round_start_time: DateTime.t() | nil,
  timer_ref: reference() | nil,
  time_remaining: integer() | nil
}
```

## Word Sets
- **Easy**: Common everyday objects and actions (100+ words)
- **Medium**: Mix of concrete and abstract concepts (100+ words)  
- **Hard**: Complex concepts, technical terms, cultural references (100+ words)

## User Interface
- **DaisyUI Components**: Buttons, cards, badges for clean design
- **Tailwind Styling**: Responsive layout with proper spacing
- **Real-time Updates**: Immediate feedback for all user actions
- **Mobile Friendly**: Works well on phones and tablets

## Technical Requirements
- Phoenix LiveView with real-time updates
- PubSub for session-wide broadcasting
- GenServer supervision for game state management
- Minimal external dependencies (only built-in Phoenix features)
- Fast, responsive user experience