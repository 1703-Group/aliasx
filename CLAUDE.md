# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Phoenix LiveView application named "Aliasx" built with Elixir. The project follows standard Phoenix conventions and includes LiveView for interactive web components.

## Development Commands

### Setup and Dependencies
- `mix setup` - Install and setup dependencies, build assets
- `mix deps.get` - Install dependencies only
- `mix deps.unlock --unused` - Remove unused dependencies

### Development Server
- `mix phx.server` - Start Phoenix server (visit http://localhost:4000)
- `iex -S mix phx.server` - Start server with interactive Elixir shell

### Asset Management
- `mix assets.setup` - Install Tailwind CSS and esbuild if missing
- `mix assets.build` - Build assets (Tailwind + esbuild)
- `mix assets.deploy` - Build minified assets for production

### Code Quality and Testing
- `mix test` - Run test suite
- `mix format` - Format code according to .formatter.exs
- `mix compile --warnings-as-errors` - Compile with strict warnings
- `mix precommit` - Run full precommit check (compile, deps check, format, test)

## Architecture

### Core Structure
- **Application**: `Aliasx.Application` manages supervision tree with telemetry, PubSub, and endpoint
- **Web Layer**: `AliasxWeb` provides shared macros for controllers, LiveViews, and components
- **Router**: Simple setup with browser pipeline and basic home route
- **Components**: Uses Phoenix LiveView components with CoreComponents for UI primitives

### Key Patterns
- Uses Phoenix 1.8+ with LiveView 1.1+ 
- Follows Phoenix context pattern (domain logic in `Aliasx`, web logic in `AliasxWeb`)
- Standard Phoenix directory structure with `lib/aliasx/` for contexts and `lib/aliasx_web/` for web components
- Asset pipeline uses esbuild and Tailwind CSS
- Heroicons for UI icons

### Configuration
- Standard Phoenix environments: dev, test, prod
- Uses Bandit web server
- Includes LiveDashboard for development debugging
- Telemetry setup for metrics and monitoring