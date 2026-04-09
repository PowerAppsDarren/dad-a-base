-- =============================================
-- Dad-a-Base Schema
-- "DROP TABLE IF EXISTS bad_jokes;
--  -- Error: table 'bad_jokes' does not exist.
--  -- All dad jokes are good jokes."
-- =============================================

CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    emoji VARCHAR(10) NOT NULL DEFAULT '😄',
    description TEXT
);

CREATE TABLE IF NOT EXISTS jokes (
    id SERIAL PRIMARY KEY,
    setup TEXT NOT NULL,
    punchline TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    groan_factor DECIMAL(3,2) DEFAULT 3.00 CHECK (groan_factor >= 1.00 AND groan_factor <= 5.00),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ratings (
    id SERIAL PRIMARY KEY,
    joke_id INTEGER NOT NULL REFERENCES jokes(id) ON DELETE CASCADE,
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
-- Seed Jokes (100+ certified groaners)
-- =============================================

-- Classic Dad Jokes (1-15)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why don''t scientists trust atoms?', 'Because they make up everything!', 1, 3.50),
('I''m reading a book about anti-gravity.', 'It''s impossible to put down!', 1, 4.00),
('Did you hear about the claustrophobic astronaut?', 'He just needed a little space.', 1, 3.75),
('Why don''t eggs tell jokes?', 'They''d crack each other up!', 1, 3.25),
('I used to hate facial hair...', 'But then it grew on me.', 1, 4.25),
('What do you call a fake noodle?', 'An impasta!', 1, 4.50),
('Why did the scarecrow win an award?', 'He was outstanding in his field!', 1, 4.75),
('I''m afraid for the calendar.', 'Its days are numbered.', 1, 3.00),
('What do you call a belt made of watches?', 'A waist of time!', 1, 4.00),
('Why couldn''t the bicycle stand up by itself?', 'It was two tired!', 1, 4.50),
('What did the ocean say to the beach?', 'Nothing, it just waved.', 1, 3.50),
('Why do fathers take an extra pair of socks when they go golfing?', 'In case they get a hole in one!', 1, 3.75),
('How do you organize a space party?', 'You planet!', 1, 4.00),
('What do you call a snowman with a six-pack?', 'An abdominal snowman!', 1, 3.50),
('I only know 25 letters of the alphabet.', 'I don''t know Y.', 1, 4.25);

-- Food Dad Jokes (16-30)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What do you call a cheese that isn''t yours?', 'Nacho cheese!', 2, 4.50),
('Why did the coffee file a police report?', 'It got mugged!', 2, 3.75),
('What do you call a sleeping pizza?', 'A piZZZa!', 2, 3.25),
('Why did the banana go to the doctor?', 'Because it wasn''t peeling well!', 2, 3.50),
('What did the grape do when it got stepped on?', 'Nothing, it just let out a little wine.', 2, 4.00),
('Why did the tomato turn red?', 'Because it saw the salad dressing!', 2, 3.75),
('What do you call a sad strawberry?', 'A blueberry!', 2, 3.00),
('Why don''t eggs tell each other jokes?', 'They might crack up!', 2, 3.50),
('What did the sushi say to the bee?', 'Wasabi!', 2, 4.25),
('How do you make a lemon drop?', 'Just let it fall!', 2, 3.25),
('Why did the cookie cry?', 'Because his mother was a wafer so long!', 2, 4.00),
('What do you call a fake noodle?', 'An im-pasta!', 2, 4.50),
('Why did the mushroom go to the party?', 'Because he was a fungi!', 2, 4.75),
('What did the buffalo say when his son left for college?', 'Bison!', 2, 4.00),
('Why do melons have weddings?', 'Because they cantaloupe!', 2, 4.50);

-- Science Dad Jokes (31-45)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why can you never trust atoms?', 'They make up literally everything!', 3, 3.50),
('What did the biologist wear to impress their date?', 'Designer genes!', 3, 4.00),
('Why did the photon check no luggage at the airport?', 'Because it was traveling light!', 3, 4.25),
('What is a physicist''s favorite food?', 'Fission chips!', 3, 3.75),
('Why are chemists excellent for solving problems?', 'They have all the solutions!', 3, 4.00),
('What did one tectonic plate say when it bumped into another?', 'Sorry, my fault!', 3, 3.50),
('Why did the germ cross the microscope?', 'To get to the other slide!', 3, 3.25),
('How does the moon cut his hair?', 'Eclipse it!', 3, 4.50),
('What do you do with a sick chemist?', 'If you can''t helium and you can''t curium, you might as well barium!', 3, 4.75),
('Why is the ocean so salty?', 'Because the land never waves back!', 3, 3.00),
('What element is a girl''s future best friend?', 'Carbon!', 3, 3.50),
('Why did the noble gas cry?', 'Because all its friends argon!', 3, 4.25),
('What do you call an acid with an attitude?', 'A-mean-oh acid!', 3, 3.75),
('Why do biologists look forward to casual Fridays?', 'They''re allowed to wear genes to work!', 3, 4.00),
('What fruit contains barium and double sodium?', 'BaNaNa!', 3, 4.50);

-- Tech Dad Jokes (46-60)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why do programmers prefer dark mode?', 'Because light attracts bugs!', 4, 4.75),
('What''s a computer''s favorite snack?', 'Microchips!', 4, 3.50),
('Why was the JavaScript developer sad?', 'Because he didn''t Node how to Express himself!', 4, 4.50),
('How many programmers does it take to change a light bulb?', 'None, that''s a hardware problem!', 4, 4.00),
('Why did the developer go broke?', 'Because he used up all his cache!', 4, 4.25),
('What''s a computer''s least favorite food?', 'Spam!', 4, 3.25),
('Why did the computer go to the doctor?', 'Because it had a virus!', 4, 3.00),
('What do you call a computer that sings?', 'A-Dell!', 4, 4.00),
('Why do Java developers wear glasses?', 'Because they can''t C#!', 4, 4.50),
('What''s a robot''s favorite type of music?', 'Heavy metal!', 4, 3.50),
('Why did the WiFi break up with the computer?', 'There was no connection!', 4, 3.75),
('How does a computer get drunk?', 'It takes screenshots!', 4, 3.50),
('Why did the PowerPoint presentation cross the road?', 'To get to the other slide!', 4, 3.25),
('What do you call 8 hobbits?', 'A hobbyte!', 4, 4.75),
('Why did the database admin leave his wife?', 'She had one-to-many relationships!', 4, 5.00);

-- Animal Dad Jokes (61-75)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What do you call a bear with no teeth?', 'A gummy bear!', 5, 4.00),
('Why don''t oysters share?', 'Because they''re shellfish!', 5, 4.25),
('What do you call a dog that does magic tricks?', 'A Labracadabrador!', 5, 4.50),
('Why do cows wear bells?', 'Because their horns don''t work!', 5, 3.75),
('What do you call an alligator in a vest?', 'An investigator!', 5, 4.75),
('Why don''t elephants use computers?', 'Because they''re afraid of the mouse!', 5, 3.50),
('What do you call a fish without eyes?', 'A fsh!', 5, 4.00),
('Why do seagulls fly over the sea?', 'Because if they flew over the bay, they''d be bagels!', 5, 4.50),
('What did the duck say when it bought lipstick?', 'Put it on my bill!', 5, 3.75),
('Why are cats bad storytellers?', 'Because they only have one tail!', 5, 3.50),
('What do you call a lazy kangaroo?', 'A pouch potato!', 5, 4.25),
('How do you count cows?', 'With a cowculator!', 5, 4.00),
('What do you call a sleeping dinosaur?', 'A dino-snore!', 5, 3.25),
('Why did the chicken join a band?', 'Because it had the drumsticks!', 5, 3.75),
('What did the fish say when it hit the wall?', 'Dam!', 5, 4.50);

-- Work Dad Jokes (76-85)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why did the can crusher quit his job?', 'Because it was soda pressing!', 6, 4.25),
('I got fired from the calendar factory.', 'All I did was take a day off!', 6, 4.00),
('Why did the mathematician work from home?', 'Because he could only function in his domain!', 6, 3.75),
('I used to work at a shoe recycling shop.', 'It was sole destroying!', 6, 4.50),
('Why did the employee get fired from the keyboard factory?', 'He wasn''t putting in enough shifts!', 6, 3.50),
('I got a job at a bakery because I kneaded dough.', 'Now I''m rolling in it!', 6, 4.00),
('Why did the accountant break up with the calculator?', 'She felt she could only count on herself!', 6, 3.75),
('I used to be a banker but I lost interest.', 'It just wasn''t my calling!', 6, 4.25),
('What do you call a factory that sells passable products?', 'A satisfactory!', 6, 4.50),
('Why don''t scientists trust stairs?', 'Because they''re always up to something!', 6, 3.50);

-- Holiday Dad Jokes (86-92)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What do you call an obnoxious reindeer?', 'Rude-olph!', 7, 3.75),
('Why did the turkey cross the road?', 'To prove he wasn''t chicken!', 7, 3.50),
('What do you call a scary jack-o-lantern?', 'A fright light!', 7, 3.25),
('Why does Santa go down chimneys?', 'Because it soots him!', 7, 4.00),
('What does the Easter Bunny get for making a basket?', 'Two points, just like everyone else!', 7, 3.75),
('What do you call a Valentine''s Day greeting from a cat?', 'A purrfect card!', 7, 3.50),
('Why was the snowman looking through the carrots?', 'He was picking his nose!', 7, 4.25);

-- Sports Dad Jokes (93-98)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why is a baseball game a good place to go on a hot day?', 'Because there are lots of fans!', 8, 3.50),
('Why did the golfer bring two pairs of pants?', 'In case he got a hole in one!', 8, 4.00),
('What lights up a soccer stadium?', 'A soccer match!', 8, 3.25),
('Why are basketball players messy eaters?', 'They''re always dribbling!', 8, 3.75),
('Why did the football coach go to the bank?', 'To get his quarterback!', 8, 4.00),
('What''s a boxer''s favorite drink?', 'Punch!', 8, 3.50);

-- Music Dad Jokes (99-103)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What do you call a musical insect?', 'A humbug!', 9, 3.50),
('Why did the music teacher need a ladder?', 'To reach the high notes!', 9, 3.25),
('What type of music are balloons afraid of?', 'Pop music!', 9, 4.00),
('What do you call a cow that plays an instrument?', 'A moo-sician!', 9, 3.75),
('Why can''t you hear a pterodactyl go to the bathroom?', 'Because the P is silent!', 9, 4.50);

-- Math Dad Jokes (104-108)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why was the math book sad?', 'It had too many problems!', 10, 3.75),
('What do you call friends who love math?', 'Algebros!', 10, 4.00),
('Why should you never talk to Pi?', 'Because it''ll go on forever!', 10, 4.25),
('What did the zero say to the eight?', 'Nice belt!', 10, 4.50),
('Why did seven eat nine?', 'Because you''re supposed to eat 3 squared meals a day!', 10, 4.75);

-- Weather Dad Jokes (109-112)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What did one raindrop say to the other?', 'Two''s company, three''s a cloud!', 11, 3.50),
('Why did the weather report go to school?', 'To improve its climate!', 11, 3.25),
('What''s a tornado''s favorite game?', 'Twister!', 11, 4.00),
('How do hurricanes see?', 'With one eye!', 11, 3.75);

-- Space Dad Jokes (113-117)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why did the sun go to school?', 'To get a little brighter!', 14, 3.25),
('What kind of music do planets sing?', 'Neptunes!', 14, 4.00),
('How do you throw a space party?', 'You planet!', 14, 4.25),
('Why did the star go to school?', 'To get a little more stellar!', 14, 3.50),
('What do you call a tick on the moon?', 'A luna-tick!', 14, 4.50);

-- Ocean Dad Jokes (118-122)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What did the ocean say to the sailboat?', 'Nothing, it just waved!', 15, 3.50),
('Why do scuba divers fall backwards off the boat?', 'Because if they fell forward, they''d still be on the boat!', 15, 4.75),
('What do sea monsters eat?', 'Fish and ships!', 15, 3.75),
('Why did the fisherman put peanut butter in the sea?', 'To go with the jellyfish!', 15, 4.00),
('What lies at the bottom of the ocean and twitches?', 'A nervous wreck!', 15, 4.25);

-- Seed some initial ratings for variety
INSERT INTO ratings (joke_id, score)
SELECT id, (random() * 4 + 1)::int FROM jokes ORDER BY random() LIMIT 50;
INSERT INTO ratings (joke_id, score)
SELECT id, (random() * 4 + 1)::int FROM jokes ORDER BY random() LIMIT 50;
INSERT INTO ratings (joke_id, score)
SELECT id, (random() * 4 + 1)::int FROM jokes ORDER BY random() LIMIT 30;
