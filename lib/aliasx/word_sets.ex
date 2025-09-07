defmodule Aliasx.WordSets do
  @moduledoc """
  Word sets for the Alias game in English, organized by difficulty levels.
  Each difficulty level contains 200 carefully selected words.
  """

  @simple [
    # Simple everyday objects and concepts (200 words)
    # Animals
    "cat", "dog", "bird", "fish", "mouse", "rabbit", "horse", "cow", "pig", "chicken",
    "duck", "sheep", "goat", "lion", "tiger", "elephant", "monkey", "bear", "wolf", "fox",
    
    # Food & Drinks
    "bread", "milk", "cheese", "egg", "butter", "water", "juice", "coffee", "tea", "sugar",
    "salt", "pepper", "apple", "banana", "orange", "grape", "strawberry", "pizza", "pasta", "rice",
    
    # Household Items
    "table", "chair", "bed", "door", "window", "lamp", "clock", "mirror", "carpet", "curtain",
    "pillow", "blanket", "towel", "soap", "brush", "comb", "key", "lock", "bottle", "glass",
    
    # Body Parts
    "head", "eye", "nose", "mouth", "ear", "hair", "face", "hand", "finger", "foot",
    "leg", "arm", "knee", "shoulder", "neck", "back", "chest", "stomach", "heart", "brain",
    
    # Clothing
    "shirt", "pants", "dress", "skirt", "shoes", "socks", "hat", "coat", "jacket", "gloves",
    "scarf", "belt", "tie", "sweater", "jeans", "boots", "sandals", "shorts", "underwear", "pajamas",
    
    # Colors & Shapes
    "red", "blue", "green", "yellow", "black", "white", "brown", "pink", "purple", "gray",
    "circle", "square", "triangle", "rectangle", "star", "diamond", "line", "dot", "cross", "arrow",
    
    # Nature
    "tree", "flower", "grass", "leaf", "sun", "moon", "sky", "cloud", "rain", "snow",
    "wind", "fire", "ice", "earth", "mountain", "river", "lake", "ocean", "beach", "forest",
    
    # Transportation
    "car", "bus", "train", "plane", "bike", "boat", "ship", "truck", "taxi", "subway",
    
    # Common Actions
    "run", "walk", "jump", "sit", "stand", "sleep", "eat", "drink", "read", "write",
    "talk", "listen", "watch", "play", "work", "study", "cook", "clean", "wash", "drive",
    
    # Places
    "home", "school", "store", "park", "street", "city", "country", "hospital", "airport", "station",
    
    # Time
    "day", "night", "morning", "afternoon", "evening", "hour", "minute", "second", "week", "month",
    
    # Basic Adjectives
    "big", "small", "hot", "cold", "new", "old", "good", "bad", "happy", "sad",
    "fast", "slow", "tall", "short", "long", "wide", "thick", "thin", "heavy", "light"
  ]

  @easy [
    # Easy level - common activities and intermediate concepts (200 words)
    # Professions
    "teacher", "doctor", "nurse", "police", "firefighter", "pilot", "driver", "cook", "waiter", "artist",
    "singer", "dancer", "actor", "writer", "photographer", "farmer", "builder", "mechanic", "electrician", "plumber",
    
    # Sports & Activities
    "football", "basketball", "tennis", "swimming", "running", "cycling", "skiing", "dancing", "singing", "painting",
    "reading", "writing", "drawing", "playing", "fishing", "camping", "hiking", "climbing", "surfing", "skating",
    
    # Technology
    "computer", "phone", "television", "radio", "camera", "printer", "keyboard", "mouse", "screen", "speaker",
    "headphones", "microphone", "battery", "charger", "cable", "internet", "website", "email", "password", "download",
    
    # Buildings & Places
    "restaurant", "hotel", "museum", "library", "theater", "cinema", "bank", "church", "temple", "mosque",
    "office", "factory", "warehouse", "garage", "stadium", "gym", "pool", "playground", "zoo", "aquarium",
    
    # Weather & Environment
    "storm", "thunder", "lightning", "rainbow", "fog", "frost", "heat", "temperature", "humidity", "pressure",
    "climate", "season", "spring", "summer", "autumn", "winter", "sunrise", "sunset", "twilight", "dawn",
    
    # Emotions & Feelings
    "love", "hate", "fear", "anger", "joy", "sadness", "surprise", "disgust", "trust", "hope",
    "excitement", "boredom", "frustration", "relief", "pride", "shame", "guilt", "envy", "jealousy", "gratitude",
    
    # Music & Entertainment
    "song", "melody", "rhythm", "beat", "instrument", "guitar", "piano", "drums", "violin", "trumpet",
    "concert", "album", "band", "orchestra", "opera", "ballet", "comedy", "drama", "documentary", "cartoon",
    
    # Education
    "student", "lesson", "homework", "exam", "test", "grade", "subject", "mathematics", "science", "history",
    "geography", "language", "literature", "biology", "chemistry", "physics", "art", "music", "sports", "recess",
    
    # Health & Medicine
    "illness", "disease", "fever", "cough", "headache", "pain", "medicine", "pill", "injection", "surgery",
    "emergency", "ambulance", "bandage", "blood", "bone", "muscle", "vitamin", "diet", "exercise", "fitness",
    
    # Money & Shopping
    "price", "cost", "sale", "discount", "receipt", "change", "credit", "debit", "cash", "wallet",
    "purse", "budget", "savings", "expense", "profit", "loss", "tax", "tip", "refund", "exchange",
    
    # Travel & Tourism
    "vacation", "holiday", "trip", "journey", "adventure", "passport", "visa", "luggage", "suitcase", "backpack",
    "ticket", "reservation", "tourist", "guide", "map", "souvenir", "destination", "departure", "arrival", "delay",
    
    # Relationships
    "family", "friend", "neighbor", "colleague", "boss", "employee", "customer", "client", "partner", "team"
  ]

  @medium [
    # Medium level - abstract concepts and complex ideas (200 words)
    # Business & Economics
    "investment", "stock", "market", "trade", "export", "import", "supply", "demand", "inflation", "recession",
    "corporation", "enterprise", "startup", "merger", "acquisition", "bankruptcy", "dividend", "portfolio", "asset", "liability",
    
    # Science & Technology
    "experiment", "hypothesis", "theory", "research", "analysis", "data", "algorithm", "artificial", "intelligence", "robot",
    "automation", "innovation", "invention", "discovery", "evolution", "genetics", "molecule", "atom", "energy", "gravity",
    
    # Psychology & Philosophy
    "consciousness", "perception", "memory", "attention", "motivation", "personality", "behavior", "attitude", "belief", "value",
    "ethics", "morality", "justice", "freedom", "truth", "wisdom", "knowledge", "ignorance", "prejudice", "bias",
    
    # Politics & Society
    "democracy", "dictatorship", "monarchy", "republic", "constitution", "parliament", "congress", "senate", "election", "campaign",
    "policy", "legislation", "regulation", "bureaucracy", "corruption", "revolution", "protest", "activism", "reform", "ideology",
    
    # Culture & Arts
    "tradition", "custom", "ritual", "ceremony", "festival", "heritage", "folklore", "mythology", "legend", "symbol",
    "metaphor", "allegory", "satire", "irony", "paradox", "aesthetic", "masterpiece", "exhibition", "gallery", "curator",
    
    # Communication
    "dialogue", "debate", "argument", "persuasion", "negotiation", "compromise", "consensus", "conflict", "resolution", "mediation",
    "presentation", "lecture", "seminar", "conference", "workshop", "interview", "survey", "feedback", "criticism", "praise",
    
    # Environment & Ecology
    "pollution", "conservation", "sustainability", "renewable", "biodiversity", "ecosystem", "habitat", "extinction", "endangered", "climate",
    "greenhouse", "emission", "recycling", "deforestation", "urbanization", "agriculture", "pesticide", "organic", "wilderness", "sanctuary",
    
    # Law & Justice
    "contract", "agreement", "lawsuit", "trial", "verdict", "sentence", "appeal", "evidence", "witness", "testimony",
    "prosecutor", "defendant", "plaintiff", "jury", "judge", "lawyer", "attorney", "custody", "divorce", "inheritance",
    
    # Media & Journalism
    "headline", "article", "editorial", "column", "reporter", "journalist", "editor", "publisher", "broadcast", "podcast",
    "documentary", "investigation", "source", "interview", "quotation", "deadline", "exclusive", "breaking", "coverage", "censorship",
    
    # Personal Development
    "goal", "achievement", "success", "failure", "challenge", "opportunity", "strength", "weakness", "improvement", "progress",
    "discipline", "persistence", "confidence", "ambition", "creativity", "leadership", "teamwork", "communication", "problem", "solution"
  ]

  @difficult [
    # Difficult level - complex abstract concepts (200 words)
    # Advanced Philosophy
    "epistemology", "metaphysics", "ontology", "phenomenology", "existentialism", "nihilism", "determinism", "solipsism", "relativism", "absolutism",
    "utilitarianism", "deontology", "pragmatism", "empiricism", "rationalism", "transcendentalism", "materialism", "idealism", "dualism", "monism",
    
    # Complex Psychology
    "cognitive", "dissonance", "sublimation", "projection", "transference", "catharsis", "neurosis", "psychosis", "schizophrenia", "paranoia",
    "narcissism", "empathy", "resilience", "trauma", "phobia", "anxiety", "depression", "bipolar", "autism", "syndrome",
    
    # Advanced Science
    "quantum", "relativity", "entropy", "thermodynamics", "electromagnetic", "radiation", "mutation", "photosynthesis", "metabolism", "osmosis",
    "catalyst", "equilibrium", "oxidation", "synthesis", "chromosome", "mitochondria", "neurotransmitter", "antibody", "pathogen", "vaccine",
    
    # Economic Theory
    "capitalism", "socialism", "communism", "neoliberalism", "keynesian", "monetarism", "globalization", "privatization", "nationalization", "deregulation",
    "oligopoly", "monopoly", "cartel", "subsidy", "tariff", "embargo", "sanctions", "austerity", "stimulus", "quantitative",
    
    # Literary Concepts
    "protagonist", "antagonist", "narrative", "exposition", "climax", "denouement", "foreshadowing", "symbolism", "alliteration", "onomatopoeia",
    "hyperbole", "oxymoron", "euphemism", "synecdoche", "metonymy", "apostrophe", "allusion", "archetype", "motif", "genre",
    
    # Sociological Terms
    "hegemony", "patriarchy", "feminism", "intersectionality", "gentrification", "marginalization", "assimilation", "segregation", "stratification", "mobility",
    "anomie", "alienation", "socialization", "stigma", "taboo", "norm", "deviance", "conformity", "ethnocentrism", "xenophobia",
    
    # Political Theory
    "sovereignty", "legitimacy", "authority", "totalitarianism", "authoritarianism", "libertarianism", "anarchism", "federalism", "nationalism", "imperialism",
    "colonialism", "neocolonialism", "geopolitics", "diplomacy", "propaganda", "treaty", "alliance", "coalition", "referendum", "plebiscite",
    
    # Technology & Innovation
    "blockchain", "cryptocurrency", "encryption", "cybersecurity", "biometrics", "nanotechnology", "biotechnology", "augmented", "virtual", "singularity",
    "algorithm", "heuristic", "optimization", "automation", "digitalization", "disruption", "scalability", "interoperability", "bandwidth", "latency",
    
    # Medical & Health
    "diagnosis", "prognosis", "symptom", "chronic", "acute", "benign", "malignant", "metastasis", "remission", "epidemiology",
    "immunology", "pathology", "oncology", "cardiology", "neurology", "psychiatry", "pediatrics", "geriatrics", "palliative", "anesthesia",
    
    # Abstract Concepts
    "paradigm", "paradox", "dichotomy", "juxtaposition", "ambiguity", "nuance", "context", "perspective", "interpretation", "implication",
    "correlation", "causation", "hypothesis", "axiom", "theorem", "corollary", "inference", "deduction", "induction", "abstraction"
  ]

  @doc """
  Returns a list of words for the given difficulty and language.
  """
  def get_words(difficulty, language \\ :en)

  def get_words(:simple, :en), do: @simple
  def get_words(:easy, :en), do: @easy
  def get_words(:medium, :en), do: @medium
  def get_words(:difficult, :en), do: @difficult

  def get_words(:simple, :ru), do: Aliasx.WordSetsRu.get_words(:simple)
  def get_words(:easy, :ru), do: Aliasx.WordSetsRu.get_words(:easy)
  def get_words(:medium, :ru), do: Aliasx.WordSetsRu.get_words(:medium)
  def get_words(:difficult, :ru), do: Aliasx.WordSetsRu.get_words(:difficult)

  # Default fallback
  def get_words(_, _), do: @simple
end