defmodule Aliasx.WordSets do
  @moduledoc """
  Word sets for the Alias game, organized by difficulty level and language.
  Each difficulty level contains 100 words.
  """
  
  alias Aliasx.WordSetsRu

  @simple [
    # Basic everyday objects and concepts (100 words)
    "cat", "dog", "house", "tree", "car", "book", "water", "food", "sun", "moon",
    "star", "sky", "rain", "snow", "wind", "fire", "ice", "road", "door", "window",
    "table", "chair", "bed", "phone", "computer", "shoe", "hat", "shirt", "pants", "bag",
    "ball", "game", "toy", "friend", "family", "mother", "father", "sister", "brother", "baby",
    "school", "teacher", "student", "class", "homework", "test", "pencil", "paper", "desk", "board",
    "city", "town", "street", "park", "store", "money", "price", "buy", "sell", "pay",
    "breakfast", "lunch", "dinner", "eat", "drink", "cook", "kitchen", "plate", "cup", "spoon",
    "happy", "sad", "angry", "tired", "hungry", "thirsty", "hot", "cold", "big", "small",
    "fast", "slow", "new", "old", "good", "bad", "clean", "dirty", "easy", "hard",
    "run", "walk", "jump", "sit", "stand", "sleep", "wake", "work", "play", "help"
  ]

  @easy [
    # Common activities and intermediate concepts (100 words)
    "airplane", "train", "bicycle", "motorcycle", "boat", "ship", "bus", "taxi", "driver", "passenger",
    "hospital", "doctor", "nurse", "patient", "medicine", "health", "sick", "pain", "fever", "emergency",
    "restaurant", "waiter", "menu", "order", "bill", "tip", "chef", "recipe", "ingredient", "taste",
    "movie", "theater", "actor", "director", "scene", "ticket", "audience", "screen", "popcorn", "show",
    "music", "song", "singer", "band", "concert", "instrument", "guitar", "piano", "drum", "dance",
    "sport", "team", "player", "coach", "score", "win", "lose", "match", "champion", "stadium",
    "beach", "ocean", "wave", "sand", "shell", "vacation", "hotel", "tourist", "camera", "photo",
    "birthday", "party", "cake", "candle", "gift", "surprise", "celebrate", "invite", "guest", "fun",
    "garden", "flower", "plant", "grass", "seed", "grow", "water", "sunshine", "butterfly", "bird",
    "market", "shop", "customer", "sale", "discount", "receipt", "change", "queue", "basket", "checkout"
  ]

  @medium [
    # Abstract concepts and complex activities (100 words)
    "adventure", "journey", "destination", "explore", "discover", "travel", "tourist", "guide", "map", "compass",
    "education", "knowledge", "learning", "teaching", "lesson", "subject", "exam", "grade", "diploma", "graduation",
    "technology", "internet", "website", "software", "hardware", "program", "code", "data", "network", "system",
    "business", "company", "office", "meeting", "project", "deadline", "salary", "employee", "manager", "client",
    "environment", "nature", "pollution", "climate", "weather", "season", "temperature", "forecast", "storm", "disaster",
    "government", "politics", "election", "vote", "president", "minister", "law", "court", "judge", "justice",
    "culture", "tradition", "custom", "festival", "ceremony", "religion", "belief", "prayer", "temple", "church",
    "relationship", "marriage", "wedding", "divorce", "friendship", "love", "trust", "respect", "loyalty", "betrayal",
    "emotion", "feeling", "mood", "stress", "anxiety", "depression", "happiness", "sadness", "fear", "courage",
    "success", "failure", "achievement", "goal", "dream", "ambition", "motivation", "effort", "challenge", "opportunity"
  ]

  @difficult [
    # Complex abstract concepts and sophisticated ideas (100 words)
    "philosophy", "metaphysics", "epistemology", "ethics", "morality", "consciousness", "existence", "reality", "perception", "cognition",
    "democracy", "capitalism", "socialism", "ideology", "revolution", "constitution", "sovereignty", "diplomacy", "bureaucracy", "legislation",
    "psychology", "psychiatry", "therapy", "diagnosis", "syndrome", "disorder", "treatment", "counseling", "behavior", "personality",
    "economics", "inflation", "recession", "investment", "portfolio", "dividend", "equity", "liability", "asset", "bankruptcy",
    "astronomy", "galaxy", "universe", "constellation", "telescope", "orbit", "gravity", "atmosphere", "radiation", "eclipse",
    "biology", "evolution", "genetics", "mutation", "chromosome", "ecosystem", "biodiversity", "organism", "metabolism", "photosynthesis",
    "literature", "poetry", "prose", "metaphor", "symbolism", "narrative", "protagonist", "antagonist", "plot", "theme",
    "architecture", "structure", "foundation", "blueprint", "construction", "design", "aesthetic", "facade", "interior", "landscape",
    "mathematics", "equation", "theorem", "hypothesis", "probability", "statistics", "calculus", "algebra", "geometry", "algorithm",
    "innovation", "technology", "artificial", "intelligence", "automation", "digitalization", "cryptocurrency", "blockchain", "sustainability", "globalization"
  ]

  @all_words @simple ++ @easy ++ @medium ++ @difficult

  @doc """
  Returns word set for the specified difficulty level.
  """
  def get_words(:simple), do: @simple
  def get_words(:easy), do: @easy
  def get_words(:medium), do: @medium
  def get_words(:difficult), do: @difficult
  def get_words(:all), do: @all_words
  def get_words(_), do: @medium  # Default fallback

  @doc """
  Returns word set for the specified difficulty level and language.
  """
  def get_words(difficulty, :en), do: get_words(difficulty)
  def get_words(difficulty, :ru), do: WordSetsRu.get_words(difficulty)
  def get_words(difficulty, "en"), do: get_words(difficulty)
  def get_words(difficulty, "ru"), do: WordSetsRu.get_words(difficulty)
  def get_words(difficulty, _), do: get_words(difficulty)  # Default to English

  @doc """
  Returns a map of all word sets by difficulty.
  """
  def all_word_sets do
    %{
      simple: @simple,
      easy: @easy,
      medium: @medium,
      difficult: @difficult
    }
  end

  @doc """
  Returns a random selection of words from the specified difficulty.
  """
  def random_words(difficulty, count \\ 100) do
    difficulty
    |> get_words()
    |> Enum.shuffle()
    |> Enum.take(count)
  end

  @doc """
  Returns word count for a difficulty level.
  """
  def word_count(difficulty) do
    difficulty
    |> get_words()
    |> length()
  end

  @doc """
  Returns list of supported languages.
  """
  def supported_languages do
    [
      %{code: "en", name: "English", native_name: "English"},
      %{code: "ru", name: "Russian", native_name: "Русский"}
    ]
  end

  @doc """
  Returns word count for a difficulty level and language.
  """
  def word_count(difficulty, language) do
    difficulty
    |> get_words(language)
    |> length()
  end
end