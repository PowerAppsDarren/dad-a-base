-- =============================================
-- Dad-a-Base Schema (UUID Edition)
-- "DROP TABLE IF EXISTS bad_jokes;
--  -- Error: table 'bad_jokes' does not exist.
--  -- All dad jokes are good jokes."
-- =============================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) UNIQUE NOT NULL,
    emoji VARCHAR(10) NOT NULL DEFAULT '😄',
    description TEXT
);

CREATE TABLE IF NOT EXISTS jokes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    setup TEXT NOT NULL,
    punchline TEXT NOT NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    groan_factor DECIMAL(3,2) DEFAULT 3.00 CHECK (groan_factor >= 1.00 AND groan_factor <= 5.00),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    joke_id UUID NOT NULL REFERENCES jokes(id) ON DELETE CASCADE,
    score INTEGER NOT NULL CHECK (score >= 1 AND score <= 5),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_jokes_category ON jokes(category_id);
CREATE INDEX idx_ratings_joke ON ratings(joke_id);
CREATE INDEX idx_jokes_search ON jokes USING gin(to_tsvector('english', setup || ' ' || punchline));

-- =============================================
-- Seed Categories
-- =============================================

INSERT INTO categories (name, emoji, description) VALUES
    ('Classic', '👴', 'The timeless groaners that started it all'),
    ('Food', '🍕', 'Jokes that are in good taste... or bad taste'),
    ('Science', '🔬', 'Periodically funny'),
    ('Tech', '💻', 'Binary jokes: you either get them or you don''t'),
    ('Animals', '🐾', 'Paws-itively hilarious'),
    ('Work', '💼', 'Monday through Friday funnies'),
    ('Holiday', '🎄', 'Seasonal silliness'),
    ('Sports', '⚽', 'Jokes that really hit different'),
    ('Music', '🎵', 'These jokes hit the right note'),
    ('Math', '🔢', 'Calculated humor'),
    ('Weather', '🌧️', 'Forecasting laughs'),
    ('School', '📚', 'Class clown material'),
    ('Medical', '🏥', 'Laughter is the best medicine'),
    ('Space', '🚀', 'Out of this world humor'),
    ('Ocean', '🌊', 'Deep jokes that make waves');

-- =============================================
-- Seed Jokes (246 certified groaners)
-- Categories referenced by name — IDs are UUIDs
-- =============================================

-- Classic Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why don''t scientists trust atoms?', 'Because they make up everything!', (SELECT id FROM categories WHERE name = 'Classic'), 3.50),
('I''m reading a book about anti-gravity.', 'It''s impossible to put down!', (SELECT id FROM categories WHERE name = 'Classic'), 4.00),
('Did you hear about the claustrophobic astronaut?', 'He just needed a little space.', (SELECT id FROM categories WHERE name = 'Classic'), 3.75),
('Why don''t eggs tell jokes?', 'They''d crack each other up!', (SELECT id FROM categories WHERE name = 'Classic'), 3.25),
('I used to hate facial hair...', 'But then it grew on me.', (SELECT id FROM categories WHERE name = 'Classic'), 4.25),
('What do you call a fake noodle?', 'An impasta!', (SELECT id FROM categories WHERE name = 'Classic'), 4.50),
('Why did the scarecrow win an award?', 'He was outstanding in his field!', (SELECT id FROM categories WHERE name = 'Classic'), 4.75),
('I''m afraid for the calendar.', 'Its days are numbered.', (SELECT id FROM categories WHERE name = 'Classic'), 3.00),
('What do you call a belt made of watches?', 'A waist of time!', (SELECT id FROM categories WHERE name = 'Classic'), 4.00),
('Why couldn''t the bicycle stand up by itself?', 'It was two tired!', (SELECT id FROM categories WHERE name = 'Classic'), 4.50),
('What did the ocean say to the beach?', 'Nothing, it just waved.', (SELECT id FROM categories WHERE name = 'Classic'), 3.50),
('Why do fathers take an extra pair of socks when they go golfing?', 'In case they get a hole in one!', (SELECT id FROM categories WHERE name = 'Classic'), 3.75),
('How do you organize a space party?', 'You planet!', (SELECT id FROM categories WHERE name = 'Classic'), 4.00),
('What do you call a snowman with a six-pack?', 'An abdominal snowman!', (SELECT id FROM categories WHERE name = 'Classic'), 3.50),
('I only know 25 letters of the alphabet.', 'I don''t know Y.', (SELECT id FROM categories WHERE name = 'Classic'), 4.25),
('Why can''t you give Elsa a balloon?', 'Because she''ll let it go!', (SELECT id FROM categories WHERE name = 'Classic'), 3.50),
('What do you call a man with a rubber toe?', 'Roberto!', (SELECT id FROM categories WHERE name = 'Classic'), 4.70),
('What do you call a parade of rabbits hopping backwards?', 'A receding hare-line!', (SELECT id FROM categories WHERE name = 'Classic'), 4.30),
('Why don''t skeletons fight each other?', 'They don''t have the guts!', (SELECT id FROM categories WHERE name = 'Classic'), 4.10),
('What do you call a boomerang that won''t come back?', 'A stick!', (SELECT id FROM categories WHERE name = 'Classic'), 3.80),
('Why did the invisible man turn down the job offer?', 'He couldn''t see himself doing it!', (SELECT id FROM categories WHERE name = 'Classic'), 4.00),
('What do you call a bear with no ears?', 'B!', (SELECT id FROM categories WHERE name = 'Classic'), 4.60),
('Why did the picture go to jail?', 'Because it was framed!', (SELECT id FROM categories WHERE name = 'Classic'), 3.70),
('I told my wife she was drawing her eyebrows too high.', 'She looked surprised.', (SELECT id FROM categories WHERE name = 'Classic'), 4.50),
('What do you call a deer with no eyes?', 'No idea!', (SELECT id FROM categories WHERE name = 'Classic'), 4.25),
('I''m on a seafood diet.', 'I see food and I eat it.', (SELECT id FROM categories WHERE name = 'Classic'), 3.75),
('Why did the stadium get hot after the game?', 'All the fans left!', (SELECT id FROM categories WHERE name = 'Classic'), 4.00);

-- Food Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What do you call a cheese that isn''t yours?', 'Nacho cheese!', (SELECT id FROM categories WHERE name = 'Food'), 4.50),
('Why did the coffee file a police report?', 'It got mugged!', (SELECT id FROM categories WHERE name = 'Food'), 3.75),
('What do you call a sleeping pizza?', 'A piZZZa!', (SELECT id FROM categories WHERE name = 'Food'), 3.25),
('Why did the banana go to the doctor?', 'Because it wasn''t peeling well!', (SELECT id FROM categories WHERE name = 'Food'), 3.50),
('What did the grape do when it got stepped on?', 'Nothing, it just let out a little wine.', (SELECT id FROM categories WHERE name = 'Food'), 4.00),
('Why did the tomato turn red?', 'Because it saw the salad dressing!', (SELECT id FROM categories WHERE name = 'Food'), 3.75),
('What do you call a sad strawberry?', 'A blueberry!', (SELECT id FROM categories WHERE name = 'Food'), 3.00),
('Why don''t eggs tell each other jokes?', 'They might crack up!', (SELECT id FROM categories WHERE name = 'Food'), 3.50),
('What did the sushi say to the bee?', 'Wasabi!', (SELECT id FROM categories WHERE name = 'Food'), 4.25),
('How do you make a lemon drop?', 'Just let it fall!', (SELECT id FROM categories WHERE name = 'Food'), 3.25),
('Why did the cookie cry?', 'Because his mother was a wafer so long!', (SELECT id FROM categories WHERE name = 'Food'), 4.00),
('What do you call a fake noodle?', 'An im-pasta!', (SELECT id FROM categories WHERE name = 'Food'), 4.50),
('Why did the mushroom go to the party?', 'Because he was a fungi!', (SELECT id FROM categories WHERE name = 'Food'), 4.75),
('What did the buffalo say when his son left for college?', 'Bison!', (SELECT id FROM categories WHERE name = 'Food'), 4.00),
('Why do melons have weddings?', 'Because they cantaloupe!', (SELECT id FROM categories WHERE name = 'Food'), 4.50),
('Why do potatoes make good detectives?', 'Because they keep their eyes peeled!', (SELECT id FROM categories WHERE name = 'Food'), 4.40),
('Why did the pie go to the dentist?', 'Because it needed a filling!', (SELECT id FROM categories WHERE name = 'Food'), 4.00),
('Why do hamburgers go to the gym?', 'To get better buns!', (SELECT id FROM categories WHERE name = 'Food'), 3.80),
('What do you call a peanut in a spacesuit?', 'An astro-nut!', (SELECT id FROM categories WHERE name = 'Food'), 4.30),
('Why did the orange stop?', 'Because it ran out of juice!', (SELECT id FROM categories WHERE name = 'Food'), 3.70),
('What did the baby corn say to the mama corn?', 'Where is pop corn?', (SELECT id FROM categories WHERE name = 'Food'), 4.60),
('Why did the soup get a trophy?', 'It was souper!', (SELECT id FROM categories WHERE name = 'Food'), 4.10),
('What do you call an angry carrot?', 'A steamed veggie!', (SELECT id FROM categories WHERE name = 'Food'), 3.50),
('What do you call a lazy spud?', 'A couch potato!', (SELECT id FROM categories WHERE name = 'Food'), 3.75),
('Why did the bread break up with the margarine?', 'For a butter lover!', (SELECT id FROM categories WHERE name = 'Food'), 4.25),
('What do you call a dinosaur that crashes their car?', 'Tyrannosaurus wrecks!', (SELECT id FROM categories WHERE name = 'Food'), 3.90),
('Why did the donut go to the dentist?', 'To get a filling!', (SELECT id FROM categories WHERE name = 'Food'), 3.25);

-- Science Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why can you never trust atoms?', 'They make up literally everything!', (SELECT id FROM categories WHERE name = 'Science'), 3.50),
('What did the biologist wear to impress their date?', 'Designer genes!', (SELECT id FROM categories WHERE name = 'Science'), 4.00),
('Why did the photon check no luggage at the airport?', 'Because it was traveling light!', (SELECT id FROM categories WHERE name = 'Science'), 4.25),
('What is a physicist''s favorite food?', 'Fission chips!', (SELECT id FROM categories WHERE name = 'Science'), 3.75),
('Why are chemists excellent for solving problems?', 'They have all the solutions!', (SELECT id FROM categories WHERE name = 'Science'), 4.00),
('What did one tectonic plate say when it bumped into another?', 'Sorry, my fault!', (SELECT id FROM categories WHERE name = 'Science'), 3.50),
('Why did the germ cross the microscope?', 'To get to the other slide!', (SELECT id FROM categories WHERE name = 'Science'), 3.25),
('How does the moon cut his hair?', 'Eclipse it!', (SELECT id FROM categories WHERE name = 'Science'), 4.50),
('What do you do with a sick chemist?', 'If you can''t helium and you can''t curium, you might as well barium!', (SELECT id FROM categories WHERE name = 'Science'), 4.75),
('Why is the ocean so salty?', 'Because the land never waves back!', (SELECT id FROM categories WHERE name = 'Science'), 3.00),
('What element is a girl''s future best friend?', 'Carbon!', (SELECT id FROM categories WHERE name = 'Science'), 3.50),
('Why did the noble gas cry?', 'Because all its friends argon!', (SELECT id FROM categories WHERE name = 'Science'), 4.25),
('What do you call an acid with an attitude?', 'A-mean-oh acid!', (SELECT id FROM categories WHERE name = 'Science'), 3.75),
('Why do biologists look forward to casual Fridays?', 'They''re allowed to wear genes to work!', (SELECT id FROM categories WHERE name = 'Science'), 4.00),
('What fruit contains barium and double sodium?', 'BaNaNa!', (SELECT id FROM categories WHERE name = 'Science'), 4.50),
('Why did the physicist break up with the biologist?', 'There was no chemistry.', (SELECT id FROM categories WHERE name = 'Science'), 4.20),
('What did one cell say to his sister when she stepped on his toe?', 'Mitosis!', (SELECT id FROM categories WHERE name = 'Science'), 4.50),
('What do you call an educated tube?', 'A graduated cylinder.', (SELECT id FROM categories WHERE name = 'Science'), 3.70),
('Why did the scientist install a knocker on his door?', 'He wanted to win the No-bell prize!', (SELECT id FROM categories WHERE name = 'Science'), 4.60),
('Why is electricity so dangerous?', 'Because it doesn''t know how to conduct itself.', (SELECT id FROM categories WHERE name = 'Science'), 3.40),
('What did the DNA say to the other DNA?', 'Do these genes make me look fat?', (SELECT id FROM categories WHERE name = 'Science'), 3.20),
('Why do chemists like nitrates so much?', 'They''re cheaper than day rates!', (SELECT id FROM categories WHERE name = 'Science'), 4.10),
('What did the thermometer say to the graduated cylinder?', 'You may have more degrees, but I''ve got the temperature!', (SELECT id FROM categories WHERE name = 'Science'), 4.30),
('Why did Pavlov''s hair always look so good?', 'Because he conditioned it!', (SELECT id FROM categories WHERE name = 'Science'), 4.75),
('What did the limestone say to the geologist?', 'Don''t take me for granite!', (SELECT id FROM categories WHERE name = 'Science'), 4.00);

-- Tech Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why do programmers prefer dark mode?', 'Because light attracts bugs!', (SELECT id FROM categories WHERE name = 'Tech'), 4.75),
('What''s a computer''s favorite snack?', 'Microchips!', (SELECT id FROM categories WHERE name = 'Tech'), 3.50),
('Why was the JavaScript developer sad?', 'Because he didn''t Node how to Express himself!', (SELECT id FROM categories WHERE name = 'Tech'), 4.50),
('How many programmers does it take to change a light bulb?', 'None, that''s a hardware problem!', (SELECT id FROM categories WHERE name = 'Tech'), 4.00),
('Why did the developer go broke?', 'Because he used up all his cache!', (SELECT id FROM categories WHERE name = 'Tech'), 4.25),
('What''s a computer''s least favorite food?', 'Spam!', (SELECT id FROM categories WHERE name = 'Tech'), 3.25),
('Why did the computer go to the doctor?', 'Because it had a virus!', (SELECT id FROM categories WHERE name = 'Tech'), 3.00),
('What do you call a computer that sings?', 'A-Dell!', (SELECT id FROM categories WHERE name = 'Tech'), 4.00),
('Why do Java developers wear glasses?', 'Because they can''t C#!', (SELECT id FROM categories WHERE name = 'Tech'), 4.50),
('What''s a robot''s favorite type of music?', 'Heavy metal!', (SELECT id FROM categories WHERE name = 'Tech'), 3.50),
('Why did the WiFi break up with the computer?', 'There was no connection!', (SELECT id FROM categories WHERE name = 'Tech'), 3.75),
('How does a computer get drunk?', 'It takes screenshots!', (SELECT id FROM categories WHERE name = 'Tech'), 3.50),
('Why did the PowerPoint presentation cross the road?', 'To get to the other slide!', (SELECT id FROM categories WHERE name = 'Tech'), 3.25),
('What do you call 8 hobbits?', 'A hobbyte!', (SELECT id FROM categories WHERE name = 'Tech'), 4.75),
('Why did the database admin leave his wife?', 'She had one-to-many relationships!', (SELECT id FROM categories WHERE name = 'Tech'), 5.00),
('How do you comfort a JavaScript bug?', 'You console it.', (SELECT id FROM categories WHERE name = 'Tech'), 4.70),
('Why don''t programmers like nature?', 'It has too many bugs and no documentation.', (SELECT id FROM categories WHERE name = 'Tech'), 4.30),
('What''s the object-oriented way to become wealthy?', 'Inheritance!', (SELECT id FROM categories WHERE name = 'Tech'), 4.80),
('What''s a programmer''s favorite place to hang out?', 'Foo Bar!', (SELECT id FROM categories WHERE name = 'Tech'), 4.10),
('Why did the computer go to the doctor?', 'It had a terminal illness!', (SELECT id FROM categories WHERE name = 'Tech'), 4.40),
('What did the router say to the modem?', 'Got any IP on you?', (SELECT id FROM categories WHERE name = 'Tech'), 3.50),
('Why did the functions stop calling each other?', 'They got into too many arguments!', (SELECT id FROM categories WHERE name = 'Tech'), 4.50),
('What''s a computer virus''s favorite meal?', 'Spam and bytes!', (SELECT id FROM categories WHERE name = 'Tech'), 3.25),
('Why did the API go to therapy?', 'It had too many unresolved issues!', (SELECT id FROM categories WHERE name = 'Tech'), 4.25);

-- Animal Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What do you call a bear with no teeth?', 'A gummy bear!', (SELECT id FROM categories WHERE name = 'Animals'), 4.00),
('Why don''t oysters share?', 'Because they''re shellfish!', (SELECT id FROM categories WHERE name = 'Animals'), 4.25),
('What do you call a dog that does magic tricks?', 'A Labracadabrador!', (SELECT id FROM categories WHERE name = 'Animals'), 4.50),
('Why do cows wear bells?', 'Because their horns don''t work!', (SELECT id FROM categories WHERE name = 'Animals'), 3.75),
('What do you call an alligator in a vest?', 'An investigator!', (SELECT id FROM categories WHERE name = 'Animals'), 4.75),
('Why don''t elephants use computers?', 'Because they''re afraid of the mouse!', (SELECT id FROM categories WHERE name = 'Animals'), 3.50),
('What do you call a fish without eyes?', 'A fsh!', (SELECT id FROM categories WHERE name = 'Animals'), 4.00),
('Why do seagulls fly over the sea?', 'Because if they flew over the bay, they''d be bagels!', (SELECT id FROM categories WHERE name = 'Animals'), 4.50),
('What did the duck say when it bought lipstick?', 'Put it on my bill!', (SELECT id FROM categories WHERE name = 'Animals'), 3.75),
('Why are cats bad storytellers?', 'Because they only have one tail!', (SELECT id FROM categories WHERE name = 'Animals'), 3.50),
('What do you call a lazy kangaroo?', 'A pouch potato!', (SELECT id FROM categories WHERE name = 'Animals'), 4.25),
('How do you count cows?', 'With a cowculator!', (SELECT id FROM categories WHERE name = 'Animals'), 4.00),
('What do you call a sleeping dinosaur?', 'A dino-snore!', (SELECT id FROM categories WHERE name = 'Animals'), 3.25),
('Why did the chicken join a band?', 'Because it had the drumsticks!', (SELECT id FROM categories WHERE name = 'Animals'), 3.75),
('What did the fish say when it hit the wall?', 'Dam!', (SELECT id FROM categories WHERE name = 'Animals'), 4.50),
('What do you call a pig that does karate?', 'A pork chop!', (SELECT id FROM categories WHERE name = 'Animals'), 4.50),
('What do you call a snake that works for the government?', 'A civil serpent!', (SELECT id FROM categories WHERE name = 'Animals'), 4.50),
('Why did the owl invite friends over?', 'He didn''t want to be owl by himself!', (SELECT id FROM categories WHERE name = 'Animals'), 3.50),
('What do you call a camel with no humps?', 'Humphrey!', (SELECT id FROM categories WHERE name = 'Animals'), 4.75),
('What do you call a frog with no legs?', 'Unhoppy!', (SELECT id FROM categories WHERE name = 'Animals'), 4.25),
('Why did the cow go to therapy?', 'She had a lot of beef with herself!', (SELECT id FROM categories WHERE name = 'Animals'), 3.75),
('What do you call a bee who can''t make up his mind?', 'A maybee!', (SELECT id FROM categories WHERE name = 'Animals'), 4.50),
('Why did the spider go online?', 'To check out his web site!', (SELECT id FROM categories WHERE name = 'Animals'), 3.25),
('Why did the cat sit on the computer?', 'To keep an eye on the mouse!', (SELECT id FROM categories WHERE name = 'Animals'), 4.00),
('What do you call a penguin in the Sahara?', 'Lost!', (SELECT id FROM categories WHERE name = 'Animals'), 3.50),
('Why don''t leopards play hide and seek?', 'Because they''re always spotted!', (SELECT id FROM categories WHERE name = 'Animals'), 4.00),
('What do you call a wolf that uses bad language?', 'A swear-wolf!', (SELECT id FROM categories WHERE name = 'Animals'), 4.25);

-- Work Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why did the can crusher quit his job?', 'Because it was soda pressing!', (SELECT id FROM categories WHERE name = 'Work'), 4.25),
('I got fired from the calendar factory.', 'All I did was take a day off!', (SELECT id FROM categories WHERE name = 'Work'), 4.00),
('Why did the mathematician work from home?', 'Because he could only function in his domain!', (SELECT id FROM categories WHERE name = 'Work'), 3.75),
('I used to work at a shoe recycling shop.', 'It was sole destroying!', (SELECT id FROM categories WHERE name = 'Work'), 4.50),
('Why did the employee get fired from the keyboard factory?', 'He wasn''t putting in enough shifts!', (SELECT id FROM categories WHERE name = 'Work'), 3.50),
('I got a job at a bakery because I kneaded dough.', 'Now I''m rolling in it!', (SELECT id FROM categories WHERE name = 'Work'), 4.00),
('Why did the accountant break up with the calculator?', 'She felt she could only count on herself!', (SELECT id FROM categories WHERE name = 'Work'), 3.75),
('I used to be a banker but I lost interest.', 'It just wasn''t my calling!', (SELECT id FROM categories WHERE name = 'Work'), 4.25),
('What do you call a factory that sells passable products?', 'A satisfactory!', (SELECT id FROM categories WHERE name = 'Work'), 4.50),
('Why don''t scientists trust stairs?', 'Because they''re always up to something!', (SELECT id FROM categories WHERE name = 'Work'), 3.50),
('What''s an astronaut''s favorite key on the keyboard?', 'The space bar!', (SELECT id FROM categories WHERE name = 'Work'), 4.50),
('Why did the programmer quit his job?', 'Because he didn''t get arrays!', (SELECT id FROM categories WHERE name = 'Work'), 4.80),
('Why did the janitor win employee of the month?', 'He swept the competition!', (SELECT id FROM categories WHERE name = 'Work'), 4.30),
('Why did the electrician get promoted?', 'He really conducted himself well!', (SELECT id FROM categories WHERE name = 'Work'), 3.70),
('What do you call a lawyer who only does paperwork?', 'A brief-case worker!', (SELECT id FROM categories WHERE name = 'Work'), 3.50),
('I got fired from the orange juice factory.', 'I couldn''t concentrate!', (SELECT id FROM categories WHERE name = 'Work'), 4.25),
('Why did the construction worker break up with his girlfriend?', 'He was tired of being taken for granite!', (SELECT id FROM categories WHERE name = 'Work'), 4.00),
('I used to work for a blanket company, but it folded.', 'Now I''m just trying to cover my expenses!', (SELECT id FROM categories WHERE name = 'Work'), 3.75);

-- Holiday Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What do you call an obnoxious reindeer?', 'Rude-olph!', (SELECT id FROM categories WHERE name = 'Holiday'), 3.75),
('Why did the turkey cross the road?', 'To prove he wasn''t chicken!', (SELECT id FROM categories WHERE name = 'Holiday'), 3.50),
('What do you call a scary jack-o-lantern?', 'A fright light!', (SELECT id FROM categories WHERE name = 'Holiday'), 3.25),
('Why does Santa go down chimneys?', 'Because it soots him!', (SELECT id FROM categories WHERE name = 'Holiday'), 4.00),
('What does the Easter Bunny get for making a basket?', 'Two points, just like everyone else!', (SELECT id FROM categories WHERE name = 'Holiday'), 3.75),
('What do you call a Valentine''s Day greeting from a cat?', 'A purrfect card!', (SELECT id FROM categories WHERE name = 'Holiday'), 3.50),
('Why was the snowman looking through the carrots?', 'He was picking his nose!', (SELECT id FROM categories WHERE name = 'Holiday'), 4.25),
('Why did Santa go to music school?', 'To improve his wrap skills!', (SELECT id FROM categories WHERE name = 'Holiday'), 3.80),
('What do elves learn in school?', 'The elf-abet!', (SELECT id FROM categories WHERE name = 'Holiday'), 4.20),
('Why did the Christmas tree go to the barber?', 'It needed a trim!', (SELECT id FROM categories WHERE name = 'Holiday'), 3.50),
('Why does Scrooge love reindeer so much?', 'Because every buck is dear to him!', (SELECT id FROM categories WHERE name = 'Holiday'), 4.50),
('What did the gingerbread man use for his bed?', 'A cookie sheet!', (SELECT id FROM categories WHERE name = 'Holiday'), 3.75),
('Why did the Thanksgiving turkey join a band?', 'Because he had the drumsticks!', (SELECT id FROM categories WHERE name = 'Holiday'), 4.00),
('What do ghosts eat for dessert?', 'I-scream!', (SELECT id FROM categories WHERE name = 'Holiday'), 4.25);

-- Sports Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why is a baseball game a good place to go on a hot day?', 'Because there are lots of fans!', (SELECT id FROM categories WHERE name = 'Sports'), 3.50),
('Why did the golfer bring two pairs of pants?', 'In case he got a hole in one!', (SELECT id FROM categories WHERE name = 'Sports'), 4.00),
('What lights up a soccer stadium?', 'A soccer match!', (SELECT id FROM categories WHERE name = 'Sports'), 3.25),
('Why are basketball players messy eaters?', 'They''re always dribbling!', (SELECT id FROM categories WHERE name = 'Sports'), 3.75),
('Why did the football coach go to the bank?', 'To get his quarterback!', (SELECT id FROM categories WHERE name = 'Sports'), 4.00),
('What''s a boxer''s favorite drink?', 'Punch!', (SELECT id FROM categories WHERE name = 'Sports'), 3.50),
('Why are skeletons bad at hockey?', 'Because they have no body to pass to!', (SELECT id FROM categories WHERE name = 'Sports'), 4.50),
('What do swimmers put on their toast?', 'Butterfly spread!', (SELECT id FROM categories WHERE name = 'Sports'), 4.25),
('What sport do horses love most?', 'Stable tennis!', (SELECT id FROM categories WHERE name = 'Sports'), 4.50),
('Why do cyclists make terrible secret agents?', 'They''re always getting caught in their chain of events!', (SELECT id FROM categories WHERE name = 'Sports'), 4.00),
('Why did the tennis player bring a ladder?', 'She wanted to reach a higher ranking!', (SELECT id FROM categories WHERE name = 'Sports'), 3.50),
('What do you call a pig who plays basketball?', 'A ball hog!', (SELECT id FROM categories WHERE name = 'Sports'), 4.25),
('Why did the baseball player bring rope to the game?', 'He wanted to tie the score!', (SELECT id FROM categories WHERE name = 'Sports'), 3.75),
('What do you call a boat full of polite soccer players?', 'A good sportsman-ship!', (SELECT id FROM categories WHERE name = 'Sports'), 4.00);

-- Music Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What do you call a musical insect?', 'A humbug!', (SELECT id FROM categories WHERE name = 'Music'), 3.50),
('Why did the music teacher need a ladder?', 'To reach the high notes!', (SELECT id FROM categories WHERE name = 'Music'), 3.25),
('What type of music are balloons afraid of?', 'Pop music!', (SELECT id FROM categories WHERE name = 'Music'), 4.00),
('What do you call a cow that plays an instrument?', 'A moo-sician!', (SELECT id FROM categories WHERE name = 'Music'), 3.75),
('Why can''t you hear a pterodactyl go to the bathroom?', 'Because the P is silent!', (SELECT id FROM categories WHERE name = 'Music'), 4.50),
('Why don''t skeletons play music in church?', 'They have no organs!', (SELECT id FROM categories WHERE name = 'Music'), 4.75),
('What''s a pirate''s favorite music genre?', 'Aarrr and B!', (SELECT id FROM categories WHERE name = 'Music'), 4.50),
('Why is a piano so hard to open?', 'Because all the keys are inside!', (SELECT id FROM categories WHERE name = 'Music'), 4.00),
('What do you call a musician with problems?', 'A treble maker!', (SELECT id FROM categories WHERE name = 'Music'), 4.25),
('Why did the music note go to the principal?', 'For being too sharp in class!', (SELECT id FROM categories WHERE name = 'Music'), 3.50),
('What do you call a guitarist who only knows two chords?', 'A music critic!', (SELECT id FROM categories WHERE name = 'Music'), 3.75),
('Why did the DJ bring a ladder to the gig?', 'To reach the high notes!', (SELECT id FROM categories WHERE name = 'Music'), 3.50);

-- Math Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why was the math book sad?', 'It had too many problems!', (SELECT id FROM categories WHERE name = 'Math'), 3.75),
('What do you call friends who love math?', 'Algebros!', (SELECT id FROM categories WHERE name = 'Math'), 4.00),
('Why should you never talk to Pi?', 'Because it''ll go on forever!', (SELECT id FROM categories WHERE name = 'Math'), 4.25),
('What did the zero say to the eight?', 'Nice belt!', (SELECT id FROM categories WHERE name = 'Math'), 4.50),
('Why did seven eat nine?', 'Because you''re supposed to eat 3 squared meals a day!', (SELECT id FROM categories WHERE name = 'Math'), 4.75),
('What do you call a number that can''t keep still?', 'A roamin'' numeral!', (SELECT id FROM categories WHERE name = 'Math'), 4.40),
('Why was the equal sign so humble?', 'It knew it wasn''t less than or greater than anyone else.', (SELECT id FROM categories WHERE name = 'Math'), 4.20),
('Why do plants hate math?', 'Because it gives them square roots!', (SELECT id FROM categories WHERE name = 'Math'), 4.50),
('Why was the math lecture so long?', 'The professor kept going off on a tangent.', (SELECT id FROM categories WHERE name = 'Math'), 4.30),
('What do you call an angle that is adorable?', 'Acute angle!', (SELECT id FROM categories WHERE name = 'Math'), 3.80),
('Why is the obtuse angle always upset?', 'Because it''s never right!', (SELECT id FROM categories WHERE name = 'Math'), 4.60),
('How do you stay warm in any room?', 'Go to the corner — it''s always 90 degrees!', (SELECT id FROM categories WHERE name = 'Math'), 4.80),
('What tool do mathematicians use to fix pipes?', 'A multi-plier!', (SELECT id FROM categories WHERE name = 'Math'), 4.70);

-- Weather Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What did one raindrop say to the other?', 'Two''s company, three''s a cloud!', (SELECT id FROM categories WHERE name = 'Weather'), 3.50),
('Why did the weather report go to school?', 'To improve its climate!', (SELECT id FROM categories WHERE name = 'Weather'), 3.25),
('What''s a tornado''s favorite game?', 'Twister!', (SELECT id FROM categories WHERE name = 'Weather'), 4.00),
('How do hurricanes see?', 'With one eye!', (SELECT id FROM categories WHERE name = 'Weather'), 3.75),
('What do you call dangerous precipitation?', 'A rain of terror!', (SELECT id FROM categories WHERE name = 'Weather'), 4.60),
('Why can''t it rain for two days in a row?', 'Because there''s always a night in between!', (SELECT id FROM categories WHERE name = 'Weather'), 3.80),
('What season is it when you''re on a trampoline?', 'Spring-time!', (SELECT id FROM categories WHERE name = 'Weather'), 4.10),
('Why did the fog go to therapy?', 'It had too many issues it couldn''t see through!', (SELECT id FROM categories WHERE name = 'Weather'), 4.30),
('What did one lightning bolt say to the other?', 'You''re shocking!', (SELECT id FROM categories WHERE name = 'Weather'), 3.50),
('Why did the weather vane break up with the wind?', 'It was tired of being pushed around!', (SELECT id FROM categories WHERE name = 'Weather'), 3.75);

-- Space Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why did the sun go to school?', 'To get a little brighter!', (SELECT id FROM categories WHERE name = 'Space'), 3.25),
('What kind of music do planets sing?', 'Neptunes!', (SELECT id FROM categories WHERE name = 'Space'), 4.00),
('How do you throw a space party?', 'You planet!', (SELECT id FROM categories WHERE name = 'Space'), 4.25),
('Why did the star go to school?', 'To get a little more stellar!', (SELECT id FROM categories WHERE name = 'Space'), 3.50),
('What do you call a tick on the moon?', 'A luna-tick!', (SELECT id FROM categories WHERE name = 'Space'), 4.50),
('What did Mars say to Saturn?', 'Give me a ring sometime!', (SELECT id FROM categories WHERE name = 'Space'), 4.40),
('What do you call an alien who can''t stop talking?', 'Extra-verbal-estrial!', (SELECT id FROM categories WHERE name = 'Space'), 3.90),
('Why don''t astronauts get hungry in space?', 'Because they had a big launch!', (SELECT id FROM categories WHERE name = 'Space'), 4.80),
('Why did the cow go to outer space?', 'To see the Milky Way!', (SELECT id FROM categories WHERE name = 'Space'), 4.00),
('What do planets read?', 'Comet books!', (SELECT id FROM categories WHERE name = 'Space'), 3.50),
('Why did the astronaut break up with gravity?', 'He felt like she was always bringing him down!', (SELECT id FROM categories WHERE name = 'Space'), 4.25);

-- Ocean Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What did the ocean say to the sailboat?', 'Nothing, it just waved!', (SELECT id FROM categories WHERE name = 'Ocean'), 3.50),
('Why do scuba divers fall backwards off the boat?', 'Because if they fell forward, they''d still be on the boat!', (SELECT id FROM categories WHERE name = 'Ocean'), 4.75),
('What do sea monsters eat?', 'Fish and ships!', (SELECT id FROM categories WHERE name = 'Ocean'), 3.75),
('Why did the fisherman put peanut butter in the sea?', 'To go with the jellyfish!', (SELECT id FROM categories WHERE name = 'Ocean'), 4.00),
('What lies at the bottom of the ocean and twitches?', 'A nervous wreck!', (SELECT id FROM categories WHERE name = 'Ocean'), 4.25),
('What do you call a lazy crayfish?', 'A slobster!', (SELECT id FROM categories WHERE name = 'Ocean'), 4.10),
('Why did the ocean go to the doctor?', 'It was feeling a little blue!', (SELECT id FROM categories WHERE name = 'Ocean'), 3.70),
('What do you get when you cross a shark and a snowman?', 'Frostbite!', (SELECT id FROM categories WHERE name = 'Ocean'), 4.60),
('Why do fish swim in salt water?', 'Because pepper makes them sneeze!', (SELECT id FROM categories WHERE name = 'Ocean'), 4.20),
('What do you call a crab that plays baseball?', 'A pinch hitter!', (SELECT id FROM categories WHERE name = 'Ocean'), 4.50),
('Why did the whale blush?', 'Because the sea-weed!', (SELECT id FROM categories WHERE name = 'Ocean'), 4.00);

-- School Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why did the student eat his homework?', 'The teacher told him it was a piece of cake!', (SELECT id FROM categories WHERE name = 'School'), 4.40),
('What do you call a student who never turns in late work?', 'A myth!', (SELECT id FROM categories WHERE name = 'School'), 4.70),
('What do librarians use as bait when they go fishing?', 'Bookworms!', (SELECT id FROM categories WHERE name = 'School'), 3.80),
('Why did the geography teacher get lost?', 'His career took too many turns!', (SELECT id FROM categories WHERE name = 'School'), 3.60),
('Why did the pencil go to school?', 'To get to the point!', (SELECT id FROM categories WHERE name = 'School'), 4.00),
('What do you call a teacher who never farts in class?', 'A private tutor!', (SELECT id FROM categories WHERE name = 'School'), 4.50);

-- Medical Dad Jokes
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why did the doctor carry a red pen?', 'In case he needed to draw blood!', (SELECT id FROM categories WHERE name = 'Medical'), 4.80),
('What do you call a doctor who fixes websites?', 'A URL-ologist!', (SELECT id FROM categories WHERE name = 'Medical'), 4.50),
('What did the X-ray say to the broken bone?', 'I can see right through you!', (SELECT id FROM categories WHERE name = 'Medical'), 4.00),
('Why did the stethoscope break up with the blood pressure cuff?', 'Too much pressure in the relationship!', (SELECT id FROM categories WHERE name = 'Medical'), 4.25),
('What do you call a fake doctor?', 'A doc-umentary!', (SELECT id FROM categories WHERE name = 'Medical'), 3.75),
('Why did the skeleton go to the party alone?', 'He had no body to go with!', (SELECT id FROM categories WHERE name = 'Medical'), 4.50);

-- Seed some initial ratings for variety
INSERT INTO ratings (joke_id, score)
SELECT id, (random() * 4 + 1)::int FROM jokes ORDER BY random() LIMIT 100;
INSERT INTO ratings (joke_id, score)
SELECT id, (random() * 4 + 1)::int FROM jokes ORDER BY random() LIMIT 100;
INSERT INTO ratings (joke_id, score)
SELECT id, (random() * 4 + 1)::int FROM jokes ORDER BY random() LIMIT 60;
