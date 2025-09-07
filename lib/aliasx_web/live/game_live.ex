defmodule AliasxWeb.GameLive do
  use AliasxWeb, :live_view
  alias Aliasx.GameServer

  @impl true
  def mount(params, _session, socket) do
    case Map.get(params, "session_id") do
      nil ->
        # Home page
        # Set default locale
        Gettext.put_locale(AliasxWeb.Gettext, "en")

        socket_with_assigns =
          assign(socket,
            difficulty: :medium,
            language: :en,
            locale: "en",
            target_score: 30,
            session_id: nil,
            creating_session: false,
            timer_sound: false,
            nickname_set: false,
            game_state: %{teams: [], players: %{}, phase: :lobby}
          )

        {:ok, socket_with_assigns}

      session_id ->
        # Game session page
        # Generate a new user_id for now, will be replaced if we get one from localStorage
        user_id = generate_user_id()

        case GameServer.get_state(session_id) do
          {:ok, state} ->
            Phoenix.PubSub.subscribe(Aliasx.PubSub, "game:#{session_id}")

            # Set locale based on game language
            game_language = Map.get(state, :language, :en)

            locale =
              case game_language do
                :en -> "en"
                :ru -> "ru"
                "en" -> "en"
                "ru" -> "ru"
                _ -> "en"
              end

            Gettext.put_locale(AliasxWeb.Gettext, locale)

            final_socket =
              assign(socket,
                session_id: session_id,
                user_id: user_id,
                game_state: state,
                nickname: "",
                nickname_set: false,
                timer_sound: false,
                difficulty: state.difficulty,
                language: game_language,
                locale: locale,
                creating_session: false
              )

            {:ok, final_socket}

          {:error, :not_found} ->
            {:ok,
             socket
             |> put_flash(:error, gettext("Game session not found"))
             |> push_navigate(to: ~p"/")}
        end
    end
  end

  @impl true
  def handle_event(
        "restore_session",
        %{"user_id" => stored_user_id, "nickname" => nickname},
        socket
      ) do
    IO.inspect(
      {:restore_session_called, stored_user_id, nickname, session_id: socket.assigns.session_id},
      label: "RESTORE_SESSION_DEBUG"
    )

    # Use the stored user_id if available, check if this user is still in the game
    if socket.assigns.session_id do
      {:ok, game_state} = GameServer.get_state(socket.assigns.session_id)

      IO.inspect({:game_state_players, Map.keys(game_state.players)},
        label: "RESTORE_SESSION_DEBUG"
      )

      IO.inspect(
        {:looking_for_user, stored_user_id,
         found: Map.has_key?(game_state.players, stored_user_id)},
        label: "RESTORE_SESSION_DEBUG"
      )

      # Check if the stored user still exists in the game
      if Map.has_key?(game_state.players, stored_user_id) do
        IO.inspect(:user_found_in_game, label: "RESTORE_SESSION_DEBUG")
        # User still exists, restore their session
        player = Map.get(game_state.players, stored_user_id)

        # Always rejoin the team if they had one, regardless of connected status
        restored_state =
          if player.team do
            case GameServer.rejoin_team(socket.assigns.session_id, stored_user_id, player.team) do
              {:ok, state} ->
                state

              _ ->
                # If rejoin fails, mark them as connected anyway
                case GameServer.mark_connected(socket.assigns.session_id, stored_user_id) do
                  {:ok, state} -> state
                  _ -> game_state
                end
            end
          else
            # No team, just mark as connected
            case GameServer.mark_connected(socket.assigns.session_id, stored_user_id) do
              {:ok, state} -> state
              _ -> game_state
            end
          end

        updated_socket =
          socket
          |> assign(:user_id, stored_user_id)
          |> assign(:nickname, player.nickname)
          |> assign(:nickname_set, true)
          |> assign(:game_state, restored_state)

        {:noreply, updated_socket}
      else
        # User doesn't exist anymore but we have a nickname, try to join
        IO.inspect(:user_not_found_trying_nickname, label: "RESTORE_SESSION_DEBUG")

        if nickname && String.trim(nickname) != "" do
          # Check if nickname is taken by someone else (not including disconnected players)
          case GameServer.check_nickname_availability(
                 socket.assigns.session_id,
                 String.trim(nickname)
               ) do
            :available ->
              case GameServer.join_session(
                     socket.assigns.session_id,
                     socket.assigns.user_id,
                     String.trim(nickname)
                   ) do
                {:ok, state} ->
                  updated_socket =
                    socket
                    |> assign(:nickname, String.trim(nickname))
                    |> assign(:nickname_set, true)
                    |> assign(:game_state, state)
                    |> push_event("save-user-id", %{user_id: socket.assigns.user_id})

                  {:noreply, updated_socket}

                {:error, _} ->
                  # Join failed, show nickname form
                  {:noreply, socket}
              end

            :taken_by_connected ->
              # Nickname truly taken by active player, show form
              {:noreply, socket}

            :taken_by_disconnected ->
              # Nickname taken by disconnected player, we can reclaim it
              case GameServer.reclaim_nickname(
                     socket.assigns.session_id,
                     socket.assigns.user_id,
                     String.trim(nickname)
                   ) do
                {:ok, state} ->
                  updated_socket =
                    socket
                    |> assign(:nickname, String.trim(nickname))
                    |> assign(:nickname_set, true)
                    |> assign(:game_state, state)
                    |> push_event("save-user-id", %{user_id: socket.assigns.user_id})

                  {:noreply, updated_socket}

                {:error, _} ->
                  {:noreply, socket}
              end
          end
        else
          {:noreply, socket}
        end
      end
    else
      IO.inspect(:no_session_id, label: "RESTORE_SESSION_DEBUG")
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("try_auto_join", %{"nickname" => nickname}, socket) do
    # Only attempt auto-join if nickname is not already set and we're in a game session
    if !socket.assigns.nickname_set && socket.assigns.session_id do
      case GameServer.join_session(
             socket.assigns.session_id,
             socket.assigns.user_id,
             String.trim(nickname)
           ) do
        {:ok, state} ->
          updated_socket =
            socket
            |> assign(:nickname, String.trim(nickname))
            |> assign(:nickname_set, true)
            |> assign(:game_state, state)

          {:noreply, updated_socket}

        {:error, :nickname_taken} ->
          # If nickname is taken, just proceed with normal flow (show nickname form)
          {:noreply, socket}

        {:error, _reason} ->
          # For any other error, proceed with normal flow
          {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("change_language", %{"language" => language}, socket) do
    # Convert language to locale string
    locale =
      case language do
        "ru" -> "ru"
        "en" -> "en"
        _ -> "en"
      end

    # Set the locale for gettext for this process
    Gettext.put_locale(AliasxWeb.Gettext, locale)

    # Update socket assigns and force a re-render
    updated_socket =
      socket
      |> assign(:language, String.to_atom(language))
      |> assign(:locale, locale)
      |> push_event("save-language", %{language: language})

    # The LiveView will re-render with the new locale automatically
    {:noreply, updated_socket}
  end

  @impl true
  def handle_event(
        "restore_saved_settings",
        %{"language" => language, "difficulty" => difficulty, "target_score" => target_score},
        socket
      ) do
    # Only restore settings on home page
    if socket.assigns.session_id == nil do
      # Convert language to locale string and atom
      locale =
        case language do
          "ru" -> "ru"
          "en" -> "en"
          _ -> "en"
        end

      language_atom = String.to_atom(language)
      difficulty_atom = String.to_atom(difficulty)
      target_score_int = String.to_integer(target_score)

      # Set the locale for gettext for this process
      Gettext.put_locale(AliasxWeb.Gettext, locale)

      # Update socket assigns
      updated_socket =
        socket
        |> assign(:language, language_atom)
        |> assign(:locale, locale)
        |> assign(:difficulty, difficulty_atom)
        |> assign(:target_score, target_score_int)

      {:noreply, updated_socket}
    else
      {:noreply, socket}
    end
  end

  # Fallback when no saved settings are found
  @impl true
  def handle_event("restore_saved_settings", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("copy_share_link", _params, socket) do
    if socket.assigns.session_id do
      updated_socket =
        socket
        |> push_event("copy-share-link", %{
          url: "/#{socket.assigns.session_id}",
          message: gettext("Game URL copied to clipboard!")
        })

      {:noreply, updated_socket}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event(
        "create_session",
        %{"difficulty" => difficulty, "target-score" => target_score, "language" => language},
        socket
      ) do
    session_id = generate_session_id()
    difficulty_atom = String.to_atom(difficulty)
    target_score_int = String.to_integer(target_score)
    language_atom = String.to_atom(language)

    case GameServer.create_session(session_id, difficulty_atom, target_score_int, language_atom) do
      {:ok, _session_id} ->
        updated_socket =
          socket
          |> push_event("save-game-settings", %{
            difficulty: difficulty,
            target_score: target_score
          })
          |> push_event("save-language", %{language: language})
          |> push_event("copy-game-url", %{
            url: "/#{session_id}",
            message: gettext("Game URL copied to clipboard!")
          })
          |> push_navigate(to: ~p"/#{session_id}")

        {:noreply, updated_socket}
    end
  end

  # Fallback for when language is not provided (backwards compatibility)
  @impl true
  def handle_event(
        "create_session",
        %{"difficulty" => difficulty, "target-score" => target_score},
        socket
      ) do
    session_id = generate_session_id()
    difficulty_atom = String.to_atom(difficulty)
    target_score_int = String.to_integer(target_score)

    case GameServer.create_session(session_id, difficulty_atom, target_score_int, :en) do
      {:ok, _session_id} ->
        updated_socket =
          socket
          |> push_event("copy-game-url", %{
            url: "/#{session_id}",
            message: gettext("Game URL copied to clipboard!")
          })
          |> push_navigate(to: ~p"/#{session_id}")

        {:noreply, updated_socket}
    end
  end

  @impl true
  def handle_event("set_nickname", %{"nickname" => nickname}, socket) do
    IO.inspect(
      {:set_nickname_start,
       session_id: socket.assigns.session_id, user_id: socket.assigns.user_id},
      label: "SET_NICKNAME_DEBUG"
    )

    if String.length(String.trim(nickname)) > 0 do
      case GameServer.join_session(
             socket.assigns.session_id,
             socket.assigns.user_id,
             String.trim(nickname)
           ) do
        {:ok, state} ->
          updated_socket =
            socket
            |> assign(:nickname, String.trim(nickname))
            |> assign(:nickname_set, true)
            |> assign(:game_state, state)
            |> push_event("save-nickname", %{nickname: String.trim(nickname)})
            |> push_event("save-user-id", %{user_id: socket.assigns.user_id})

          IO.inspect(
            {:set_nickname_after,
             session_id: updated_socket.assigns.session_id,
             user_id: updated_socket.assigns.user_id},
            label: "SET_NICKNAME_DEBUG"
          )

          {:noreply, updated_socket}

        {:error, :nickname_taken} ->
          {:noreply,
           put_flash(
             socket,
             :error,
             gettext("This nickname is already taken. Please choose a different one.")
           )}

        {:error, _reason} ->
          {:noreply, put_flash(socket, :error, gettext("Failed to join session"))}
      end
    else
      {:noreply, put_flash(socket, :error, gettext("Please enter a valid nickname"))}
    end
  end

  @impl true
  def handle_event("join_team", %{"team" => team_name}, socket) do
    case GameServer.join_team(socket.assigns.session_id, socket.assigns.user_id, team_name) do
      {:ok, state} ->
        {:noreply, assign(socket, game_state: state)}

      {:error, :no_team_changes_during_play} ->
        {:noreply,
         put_flash(socket, :error, gettext("Cannot change teams during active gameplay"))}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to join team")}
    end
  end

  @impl true
  def handle_event("leave_team", _params, socket) do
    case GameServer.leave_team(socket.assigns.session_id, socket.assigns.user_id) do
      {:ok, state} ->
        {:noreply, assign(socket, game_state: state)}

      {:error, :no_team_changes_during_play} ->
        {:noreply,
         put_flash(socket, :error, gettext("Cannot change teams during active gameplay"))}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to leave team")}
    end
  end

  @impl true
  def handle_event("toggle_ready", _params, socket) do
    current_ready = get_player_ready_status(socket)

    IO.inspect(
      {:toggle_ready_debug,
       session_id: socket.assigns.session_id,
       user_id: socket.assigns.user_id,
       current_ready: current_ready,
       new_ready: !current_ready},
      label: "TOGGLE_READY_DEBUG"
    )

    case GameServer.set_ready(socket.assigns.session_id, socket.assigns.user_id, !current_ready) do
      {:ok, _state} ->
        {:noreply, socket}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to update ready status")}
    end
  end

  @impl true
  def handle_event("start_game", _params, socket) do
    case GameServer.start_game(socket.assigns.session_id, socket.assigns.user_id) do
      {:ok, _state} ->
        {:noreply, socket}

      {:error, :not_first_explainer} ->
        {:noreply, put_flash(socket, :error, "Only the first explainer can start the game")}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to start game")}
    end
  end

  @impl true
  def handle_event("next_word", %{"action" => action}, socket) do
    action_atom = String.to_atom(action)

    IO.inspect(
      {:next_word_debug,
       session_id: socket.assigns.session_id, user_id: socket.assigns.user_id, action: action_atom},
      label: "NEXT_WORD_DEBUG"
    )

    case GameServer.next_word(socket.assigns.session_id, socket.assigns.user_id, action_atom) do
      {:ok, _state} ->
        IO.inspect({:next_word_success, action: action_atom}, label: "NEXT_WORD_DEBUG")
        {:noreply, socket}

      {:error, reason} ->
        IO.inspect({:next_word_error, reason: reason, action: action_atom},
          label: "NEXT_WORD_DEBUG"
        )

        {:noreply, put_flash(socket, :error, "Cannot perform action")}
    end
  end

  @impl true
  def handle_event("score_word", %{"index" => index, "score" => score}, socket) do
    {index_int, ""} = Integer.parse(index)
    {score_int, ""} = Integer.parse(score)

    case GameServer.score_word(socket.assigns.session_id, index_int, score_int) do
      {:ok, _state} ->
        {:noreply, socket}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to score word")}
    end
  end

  @impl true
  def handle_event("next_round", _params, socket) do
    case GameServer.next_round(socket.assigns.session_id) do
      {:ok, _state} ->
        {:noreply, socket}

      {:error, :no_teams} ->
        # If no teams available, redirect to home to create a new session
        {:noreply, push_navigate(socket, to: ~p"/")}

      {:error, reason} ->
        IO.inspect({:next_round_error, reason: reason}, label: "NEXT_ROUND_DEBUG")

        error_message =
          case reason do
            :not_round_end -> "Can only start next round from round end"
            :no_current_team -> "No current team found"
            _ -> "Failed to start next round: #{inspect(reason)}"
          end

        {:noreply, put_flash(socket, :error, error_message)}
    end
  end

  @impl true
  def handle_event("start_new_game", _params, socket) do
    # Reset the game to lobby phase
    case GameServer.reset_to_lobby(socket.assigns.session_id) do
      {:ok, _state} ->
        {:noreply, socket}

      {:error, reason} ->
        IO.inspect({:reset_game_error, reason: reason}, label: "RESET_GAME_DEBUG")
        {:noreply, put_flash(socket, :error, "Failed to start new game")}
    end
  end

  @impl true
  def handle_info({:game_update, state}, socket) do
    {:noreply, assign(socket, game_state: state)}
  end

  @impl true
  def handle_info(:timer_finished, socket) do
    {:noreply, assign(socket, timer_sound: true)}
  end

  @impl true
  def terminate(_reason, socket) do
    # Clean up: remove user from game session if they disconnect
    if Map.get(socket.assigns, :session_id) && Map.get(socket.assigns, :user_id) do
      GameServer.leave_session(socket.assigns.session_id, socket.assigns.user_id)
    end

    :ok
  end

  defp generate_session_id do
    :crypto.strong_rand_bytes(8) |> Base.url_encode64() |> String.slice(0, 8)
  end

  defp generate_user_id do
    :crypto.strong_rand_bytes(16) |> Base.url_encode64()
  end

  defp get_player_ready_status(socket) do
    game_state = Map.get(socket.assigns, :game_state, %{players: %{}})
    user_id = Map.get(socket.assigns, :user_id)

    case Map.get(game_state.players, user_id) do
      %{ready: ready} -> ready
      _ -> false
    end
  end

  defp can_start_game?(teams, players) do
    teams_with_members = Enum.filter(teams, &(length(&1.members) > 0))
    team_members = teams |> Enum.flat_map(& &1.members) |> MapSet.new()
    total_team_members = teams_with_members |> Enum.map(&length(&1.members)) |> Enum.sum()

    ready_statuses =
      team_members
      |> Enum.map(fn user_id ->
        case Map.get(players, user_id) do
          %{ready: ready, nickname: nickname} -> {nickname, ready}
          _ -> {"unknown", false}
        end
      end)

    all_ready =
      team_members
      |> Enum.all?(fn user_id ->
        case Map.get(players, user_id) do
          %{ready: true} -> true
          _ -> false
        end
      end)

    can_start = length(teams_with_members) >= 1 and total_team_members >= 2 and all_ready

    IO.inspect(
      {:can_start_game_debug,
       teams_count: length(teams_with_members),
       total_members: total_team_members,
       ready_statuses: ready_statuses,
       all_ready: all_ready,
       can_start: can_start},
      label: "CAN_START_GAME_DEBUG"
    )

    can_start
  end

  defp time_class(time) do
    cond do
      time > 30 -> "text-green-500"
      time > 10 -> "text-yellow-500"
      true -> "text-red-500"
    end
  end

  defp format_time(seconds) do
    minutes = div(seconds, 60)
    secs = rem(seconds, 60)
    "#{minutes}:#{String.pad_leading(Integer.to_string(secs), 2, "0")}"
  end
end
