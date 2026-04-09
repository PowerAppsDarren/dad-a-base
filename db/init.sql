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

-- =============================================
-- Fresh Batch: 100 More Certified Groaners
-- "I told my wife she was drawing her eyebrows
--  too high. She looked surprised."
-- =============================================

-- Classic Dad Jokes (123-134)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why can''t you give Elsa a balloon?', 'Because she''ll let it go!', 1, 3.50),
('What do you call a man with a rubber toe?', 'Roberto!', 1, 4.70),
('What do you call a parade of rabbits hopping backwards?', 'A receding hare-line!', 1, 4.30),
('Why don''t skeletons fight each other?', 'They don''t have the guts!', 1, 4.10),
('What do you call a boomerang that won''t come back?', 'A stick!', 1, 3.80),
('Why did the invisible man turn down the job offer?', 'He couldn''t see himself doing it!', 1, 4.00),
('What do you call a bear with no ears?', 'B!', 1, 4.60),
('Why did the picture go to jail?', 'Because it was framed!', 1, 3.70),
('I told my wife she was drawing her eyebrows too high.', 'She looked surprised.', 1, 4.50),
('What do you call a deer with no eyes?', 'No idea!', 1, 4.25),
('I''m on a seafood diet.', 'I see food and I eat it.', 1, 3.75),
('Why did the stadium get hot after the game?', 'All the fans left!', 1, 4.00);

-- Food Dad Jokes (135-146)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why do potatoes make good detectives?', 'Because they keep their eyes peeled!', 2, 4.40),
('Why did the pie go to the dentist?', 'Because it needed a filling!', 2, 4.00),
('Why do hamburgers go to the gym?', 'To get better buns!', 2, 3.80),
('What do you call a peanut in a spacesuit?', 'An astro-nut!', 2, 4.30),
('Why did the orange stop?', 'Because it ran out of juice!', 2, 3.70),
('What did the baby corn say to the mama corn?', 'Where is pop corn?', 2, 4.60),
('Why did the soup get a trophy?', 'It was souper!', 2, 4.10),
('What do you call an angry carrot?', 'A steamed veggie!', 2, 3.50),
('Why did the donut go to the dentist?', 'To get a filling!', 2, 3.25),
('What do you call a lazy spud?', 'A couch potato!', 2, 3.75),
('Why did the bread break up with the margarine?', 'For a butter lover!', 2, 4.25),
('What do you call a group of musical whales?', 'An orca-stra... eating krill!', 2, 3.50);

-- Science Dad Jokes (147-156)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why did the physicist break up with the biologist?', 'There was no chemistry.', 3, 4.20),
('What did one cell say to his sister when she stepped on his toe?', 'Mitosis!', 3, 4.50),
('What do you call an educated tube?', 'A graduated cylinder.', 3, 3.70),
('Why did the scientist install a knocker on his door?', 'He wanted to win the No-bell prize!', 3, 4.60),
('Why is electricity so dangerous?', 'Because it doesn''t know how to conduct itself.', 3, 3.40),
('What did the DNA say to the other DNA?', 'Do these genes make me look fat?', 3, 3.20),
('Why do chemists like nitrates so much?', 'They''re cheaper than day rates!', 3, 4.10),
('What did the thermometer say to the graduated cylinder?', 'You may have more degrees, but I''ve got the temperature!', 3, 4.30),
('Why did Pavlov''s hair always look so good?', 'Because he conditioned it!', 3, 4.75),
('What did the limestone say to the geologist?', 'Don''t take me for granite!', 3, 4.00);

-- Tech Dad Jokes (157-166)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('How do you comfort a JavaScript bug?', 'You console it.', 4, 4.70),
('Why don''t programmers like nature?', 'It has too many bugs and no documentation.', 4, 4.30),
('What''s the object-oriented way to become wealthy?', 'Inheritance!', 4, 4.80),
('What''s a programmer''s favorite place to hang out?', 'Foo Bar!', 4, 4.10),
('Why did the computer go to the doctor?', 'It had a terminal illness!', 4, 4.40),
('Why did the developer go broke?', 'He cleared his cache!', 4, 3.75),
('What did the router say to the modem?', 'Got any IP on you?', 4, 3.50),
('Why did the functions stop calling each other?', 'They got into too many arguments!', 4, 4.50),
('What''s a computer virus''s favorite meal?', 'Spam and bytes!', 4, 3.25),
('Why did the API go to therapy?', 'It had too many unresolved issues!', 4, 4.25);

-- Animals Dad Jokes (167-178)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What do you call a pig that does karate?', 'A pork chop!', 5, 4.50),
('What do you call a snake that works for the government?', 'A civil serpent!', 5, 4.50),
('Why did the owl invite friends over?', 'He didn''t want to be owl by himself!', 5, 3.50),
('What do you call a camel with no humps?', 'Humphrey!', 5, 4.75),
('What do you call a frog with no legs?', 'Unhoppy!', 5, 4.25),
('Why did the cow go to therapy?', 'She had a lot of beef with herself!', 5, 3.75),
('What do you call a bee who can''t make up his mind?', 'A maybee!', 5, 4.50),
('Why did the spider go online?', 'To check out his web site!', 5, 3.25),
('Why did the cat sit on the computer?', 'To keep an eye on the mouse!', 5, 4.00),
('What do you call a penguin in the Sahara?', 'Lost!', 5, 3.50),
('Why don''t leopards play hide and seek?', 'Because they''re always spotted!', 5, 4.00),
('What do you call a wolf that uses bad language?', 'A swear-wolf!', 5, 4.25);

-- Work Dad Jokes (179-186)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What''s an astronaut''s favorite key on the keyboard?', 'The space bar!', 6, 4.50),
('Why did the programmer quit his job?', 'Because he didn''t get arrays!', 6, 4.80),
('Why did the janitor win employee of the month?', 'He swept the competition!', 6, 4.30),
('Why did the electrician get promoted?', 'He really conducted himself well!', 6, 3.70),
('What do you call a lawyer who only does paperwork?', 'A brief-case worker!', 6, 3.50),
('I got fired from the orange juice factory.', 'I couldn''t concentrate!', 6, 4.25),
('Why did the construction worker break up with his girlfriend?', 'He was tired of being taken for granite!', 6, 4.00),
('I used to work for a blanket company, but it folded.', 'Now I''m just trying to cover my expenses!', 6, 3.75);

-- Holiday Dad Jokes (187-193)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why did Santa go to music school?', 'To improve his wrap skills!', 7, 3.80),
('What do elves learn in school?', 'The elf-abet!', 7, 4.20),
('Why did the Christmas tree go to the barber?', 'It needed a trim!', 7, 3.50),
('Why does Scrooge love reindeer so much?', 'Because every buck is dear to him!', 7, 4.50),
('What did the gingerbread man use for his bed?', 'A cookie sheet!', 7, 3.75),
('Why did the Thanksgiving turkey join a band?', 'Because he had the drumsticks!', 7, 4.00),
('What do ghosts eat for dessert?', 'I-scream!', 7, 4.25);

-- Sports Dad Jokes (194-201)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why are skeletons bad at hockey?', 'Because they have no body to pass to!', 8, 4.50),
('What do swimmers put on their toast?', 'Butterfly spread!', 8, 4.25),
('What sport do horses love most?', 'Stable tennis!', 8, 4.50),
('Why do cyclists make terrible secret agents?', 'They''re always getting caught in their chain of events!', 8, 4.00),
('Why did the tennis player bring a ladder?', 'She wanted to reach a higher ranking!', 8, 3.50),
('What do you call a pig who plays basketball?', 'A ball hog!', 8, 4.25),
('Why did the baseball player bring rope to the game?', 'He wanted to tie the score!', 8, 3.75),
('What do you call a boat full of polite soccer players?', 'A good sportsman-ship!', 8, 4.00);

-- Music Dad Jokes (202-208)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why don''t skeletons play music in church?', 'They have no organs!', 9, 4.75),
('What''s a pirate''s favorite music genre?', 'Aarrr and B!', 9, 4.50),
('Why is a piano so hard to open?', 'Because all the keys are inside!', 9, 4.00),
('What do you call a musician with problems?', 'A treble maker!', 9, 4.25),
('Why did the music note go to the principal?', 'For being too sharp in class!', 9, 3.50),
('What do you call a guitarist who only knows two chords?', 'A music critic!', 9, 3.75),
('Why did the DJ bring a ladder to the gig?', 'To reach the high notes!', 9, 3.50);

-- Math Dad Jokes (209-216)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What do you call a number that can''t keep still?', 'A roamin'' numeral!', 10, 4.40),
('Why was the equal sign so humble?', 'It knew it wasn''t less than or greater than anyone else.', 10, 4.20),
('Why do plants hate math?', 'Because it gives them square roots!', 10, 4.50),
('Why was the math lecture so long?', 'The professor kept going off on a tangent.', 10, 4.30),
('What do you call an angle that is adorable?', 'Acute angle!', 10, 3.80),
('Why is the obtuse angle always upset?', 'Because it''s never right!', 10, 4.60),
('How do you stay warm in any room?', 'Go to the corner — it''s always 90 degrees!', 10, 4.80),
('What tool do mathematicians use to fix pipes?', 'A multi-plier!', 10, 4.70);

-- Weather Dad Jokes (217-222)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What do you call dangerous precipitation?', 'A rain of terror!', 11, 4.60),
('Why can''t it rain for two days in a row?', 'Because there''s always a night in between!', 11, 3.80),
('What season is it when you''re on a trampoline?', 'Spring-time!', 11, 4.10),
('Why did the fog go to therapy?', 'It had too many issues it couldn''t see through!', 11, 4.30),
('What did one lightning bolt say to the other?', 'You''re shocking!', 11, 3.50),
('Why did the weather vane break up with the wind?', 'It was tired of being pushed around!', 11, 3.75);

-- School Dad Jokes (223-228)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why did the student eat his homework?', 'The teacher told him it was a piece of cake!', 12, 4.40),
('What do you call a student who never turns in late work?', 'A myth!', 12, 4.70),
('What do librarians use as bait when they go fishing?', 'Bookworms!', 12, 3.80),
('Why did the geography teacher get lost?', 'His career took too many turns!', 12, 3.60),
('Why did the pencil go to school?', 'To get to the point!', 12, 4.00),
('What do you call a teacher who never farts in class?', 'A private tutor!', 12, 4.50);

-- Medical Dad Jokes (229-234)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('Why did the doctor carry a red pen?', 'In case he needed to draw blood!', 13, 4.80),
('What do you call a doctor who fixes websites?', 'A URL-ologist!', 13, 4.50),
('Why did the nurse carry a red marker?', 'In case she needed to draw blood... from a chart!', 13, 3.50),
('What did the X-ray say to the broken bone?', 'I can see right through you!', 13, 4.00),
('Why did the stethoscope break up with the blood pressure cuff?', 'Too much pressure in the relationship!', 13, 4.25),
('What do you call a fake doctor?', 'A doc-umentary!', 13, 3.75);

-- Space Dad Jokes (235-240)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What did Mars say to Saturn?', 'Give me a ring sometime!', 14, 4.40),
('What do you call an alien who can''t stop talking?', 'Extra-verbal-estrial!', 14, 3.90),
('Why don''t astronauts get hungry in space?', 'Because they had a big launch!', 14, 4.80),
('Why did the cow go to outer space?', 'To see the Milky Way!', 14, 4.00),
('What do planets read?', 'Comet books!', 14, 3.50),
('Why did the astronaut break up with gravity?', 'He felt like she was always bringing him down!', 14, 4.25);

-- Ocean Dad Jokes (241-246)
INSERT INTO jokes (setup, punchline, category_id, groan_factor) VALUES
('What do you call a lazy crayfish?', 'A slobster!', 15, 4.10),
('Why did the ocean go to the doctor?', 'It was feeling a little blue!', 15, 3.70),
('What do you get when you cross a shark and a snowman?', 'Frostbite!', 15, 4.60),
('Why do fish swim in salt water?', 'Because pepper makes them sneeze!', 15, 4.20),
('What do you call a crab that plays baseball?', 'A pinch hitter!', 15, 4.50),
('Why did the whale blush?', 'Because the sea-weed!', 15, 4.00);

-- Seed some initial ratings for variety
INSERT INTO ratings (joke_id, score)
SELECT id, (random() * 4 + 1)::int FROM jokes ORDER BY random() LIMIT 100;
INSERT INTO ratings (joke_id, score)
SELECT id, (random() * 4 + 1)::int FROM jokes ORDER BY random() LIMIT 100;
INSERT INTO ratings (joke_id, score)
SELECT id, (random() * 4 + 1)::int FROM jokes ORDER BY random() LIMIT 60;
