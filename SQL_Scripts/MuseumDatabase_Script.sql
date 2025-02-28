DROP DATABASE IF EXISTS artmuseum;
CREATE DATABASE artmuseum;
USE artmuseum;

CREATE TABLE ARTIST (
    ArtistName 			VARCHAR(255)		NOT NULL, /*Assumption: Artist is a strong entity, Name is unique and assumed to be not null*/
    DateBorn 			DATE,
    Date_died 			DATE,
    Country_of_origin 	VARCHAR(255),
    Epoch 				VARCHAR(255),
    Main_style 			VARCHAR(255),
    ArtistDescription 	TEXT,	
    
    CONSTRAINT ARTISTN PRIMARY KEY (ArtistName)
);

CREATE TABLE ART_OBJECTS (
    Id_no 				INT 				NOT NULL,
    Artist 				VARCHAR(255),
    YearCreated 		INT,
    Title 				VARCHAR(255) 		NOT NULL, /*Assumption: all art objects will have a title*/
    Origin 				VARCHAR(255) 		NOT NULL, /*Assumption: all art objects have an origin*/
    Epoch 				VARCHAR(255) 		NOT NULL,
    CollectionName		VARCHAR(255)		NOT NULL,
    ArtDescription 		TEXT,
    
    CONSTRAINT ARTID PRIMARY KEY (Id_no),
    FOREIGN KEY (Artist) REFERENCES ARTIST(ArtistName)
);

CREATE TABLE PAINTING (
    Id_no 				INT 				NOT NULL,
    Paint_type 			VARCHAR(255)		NOT NULL,
    Drawn_on 			VARCHAR(255)		NOT NULL,
    Style 				VARCHAR(255)		NOT NULL,
    FOREIGN KEY (Id_no) REFERENCES ART_OBJECTS(Id_no)
);

CREATE TABLE SCULPTURE (
    Id_no 				INT					NOT NULL,
    Material 			VARCHAR(255)		NOT NULL,
    Height 				FLOAT				NOT NULL, /*height is in cm*/
    SculptWeight 		FLOAT				NOT NULL,
    Style 				VARCHAR(255)		NOT NULL,
    FOREIGN KEY (Id_no) REFERENCES ART_OBJECTS(Id_no)
);
CREATE TABLE STATUE (
    Id_no 				INT					NOT NULL,
    Material 			VARCHAR(255)		NOT NULL,
    Height 				FLOAT				NOT NULL, /*height is in meters*/
    StatWeight 			FLOAT				NOT NULL,
    Style 				VARCHAR(255)		NOT NULL,
    FOREIGN KEY (Id_no) REFERENCES ART_OBJECTS(Id_no)
);


CREATE TABLE OTHER (
    Id_no 				INT 				NOT NULL,
    ArtType 			VARCHAR(255)		NOT NULL,
    Style 				VARCHAR(255)		NOT NULL,
    
    FOREIGN KEY (Id_no) REFERENCES ART_OBJECTS(Id_no)
);

CREATE TABLE COLLECTIONS (
    CollectionsName 	VARCHAR(255) 		NOT NULL    Default 'Closed',
    CollectionsType 	VARCHAR(255)		NOT NULL,
    C_Address 			VARCHAR(255)		NOT NULL,
    Phone 				VARCHAR(20)			NOT NULL,
    Contact_person 		VARCHAR(255)		NOT NULL,
    CollectionsDescr 	TEXT				NOT NULL,
    
    CONSTRAINT COLN PRIMARY KEY (CollectionsName)
);

CREATE TABLE PERMANENT_COLLECTION (
    Id_no 				INT 				NOT NULL,
    Date_acquired 		DATE				NOT NULL,
    CollectionStatus    VARCHAR(255)		NOT NULL,
    Cost 				FLOAT				NOT NULL,
    PCollectionN		VARCHAR(255)		NOT NULL,
    
    FOREIGN KEY (Id_no) REFERENCES ART_OBJECTS(Id_no),
    FOREIGN KEY (PCollectionN) REFERENCES COLLECTIONS(CollectionsName)
);

CREATE TABLE BORROWED (
    Id_no 				INT 				NOT NULL,
    CollectionN 		VARCHAR(255)	    NOT NULL,
    Date_borrowed 		DATE				NOT NULL,
    Date_returned 		DATE				NOT NULL,
    
    FOREIGN KEY (Id_no) REFERENCES ART_OBJECTS(Id_no),
    FOREIGN KEY (CollectionN) REFERENCES COLLECTIONS(CollectionsName)
);

CREATE TABLE EXHIBITIONS (
    ExhibitionName 		VARCHAR(255)		NOT NULL,
    Exb_Start_date 			DATE			NOT NULL,
    Exb_End_date 			DATE			NOT NULL,
    
    CONSTRAINT EXBN PRIMARY KEY (ExhibitionName)
);

CREATE TABLE DISPLAYED_IN (
    Id_No 				INT					NOT NULL,
    ExhibitionName  	VARCHAR(255)		NOT NULL,
    PRIMARY KEY (ExhibitionName, Id_No),
    FOREIGN KEY (ExhibitionName) REFERENCES EXHIBITIONS(ExhibitionName),
    FOREIGN KEY (Id_No) REFERENCES ART_OBJECTS(Id_no)
);




CREATE TRIGGER SCULPTURE_UPDATE_VIOLATION 
BEFORE UPDATE ON SCULPTURE 
FOR EACH ROW 

SET NEW.Height= IF((SELECT Height 
                    FROM SCULPTURE AS S, ART_OBJECTS AS A 
                    WHERE A.Id_no = new.S.Id_no)<400, 
                    new.Height, 
                    old.Height);

INSERT INTO COLLECTIONS
VALUES          ('The Met', 'Museum', '1000 5th Ave, New York, NY 10028, USA', '212-535-7710', 'Max Hollein',
                'Travel around the world and across 5,000 years of history through 490,000+ works of art.'),
                ('The Louvre', 'Museum', '75001 Paris, France', '314-020-5317', 'Marie-Laure de Rochebrune',
                'The Louvre is a universal museum with eight curatorial departments. It is the worlds largest museum and houses one of the most impressive art collections in history.'),
                ('The British Museum', 'Museum', 'Great Russell St, London WC1B 3DG, UK', '207-323-8299', 'Mark Jones',
                'The first national public museum of the world. The British Museum is unique in bringing together under one roof the cultures of the world, spanning continents and oceans.'),
                ('European Sculpture and Decorative Arts', 'Museum', '1000 5th Ave, New York, NY 10028, USA','+1 212-535-7710','Max Hollein',
                "The fifty thousand objects in the Museum's comprehensive and historically important collection of European sculpture and decorative arts reflect the development of a number of art forms in Western European countries from the early fifteenth through the early twentieth century."),
                ('Arms and Armor', 'Museum','1000 5th Ave, New York, NY 10028, USA','+1 212-535-7710','Max Hollein', 
                'The collection comprises approximately fourteen thousand objects, of which more than five thousand are European, two thousand are from the Near East, and four thousand from the Far East.'),
                ('Modern and Contemporary Art', 'Museum', '1000 5th Ave, New York, NY 10028, USA','+1 212-535-7710','Max Hollein', 
                "The Modern and Contemporary Art department at The Met is devoted to the study, collection and exhibition of art from 1890 to the present. An era marked by seismic cultural, social and 
                political shifts across the globe, artistic responses to these changes have shaped multiple modernities and diverse contemporary practices. "),
                ('The American Wing', 'Museum', '1000 5th Ave, New York, NY 10028, USA','+1 212-535-7710','Max Hollein',
                "Ever since its establishment in 1870, the Museum has acquired important examples of American art. A separate 'American Wing' to display the domestic arts of the seventeenth to early nineteenth centuries 
                opened in 1924. Today, the Wing's ever-evolving collection comprises some 20,000 works of art by African American, Euro American, Latin American, and Native American men and women."),
                ('Department of Oriental Antiquities', 'Museum', '75001 Paris, France', '+33 1 40 20 53 17', 'Marie-Laure de Rochebrune',
                "After World War II, 61,000 works of art were retrieved in Germany and brought back to France. Many had been stolen from Jewish families. To date, more than 45,000 have been returned to their rightful owners. Unclaimed works were sold by the French State, with the exception of 2,143 objects placed under the legal responsibility of the Ministry of Foreign Affairs and entrusted to French national museums for safekeeping."),
                ('Department of Greek, Etruscan and Roman Antiquities', 'Museum','75001 Paris, France', '+33 1 40 20 53 17', 'Marie-Laure de Rochebrune',
                "Artwork recovered after World War II, retrieved by the Office of Private Property and Interests (OBIP); to be returned to its rightful owner once they have been identified."),
                ('Department of Sculptures of the Middle Ages, Renaissance and Modern Times', 'Museum','75001 Paris, France', '+33 1 40 20 53 17', 'Marie-Laure de Rochebrune',
                "Department of Sculptures of the Middle Ages, Renaissance and Modern Times");

INSERT INTO ARTIST
VALUES          ('Gustave Courbet', '1819-06-10', '1877-12-31', 'France', 'Romantic', 'Realism', 
                'Jean Désiré Gustave Courbet was a French painter who led the Realism movement in 19th-century French painting.'),
                ('Nicolaes Maes', '1634-01-01', '1693-12-01', 'Netherlands', 'Baroque', 'Realism',
                'Nicolaes Maes was a Dutch painter known for his genre scenes, portraits, religious compositions and the occasional still life.'),
                ('Christian Claus', '1750-03-17', '1802-12-08', 'Germany', 'Neoclassical', NULL, NULL),
                ('Jacob Denner', '1681-01-01', '1735-08-17', 'Germany', 'Baroque', 'Baroque',
                'Jacob Denner was an esteemed oboist with the municipal band of Nuremberg and an important maker of oboes.'),
                ('Jean Barbault', '1718-08-01', '1762-09-09', 'France', 'Baroque', 'Realism',
                'Jean Barbault was a French painter, etcher and printmaker, who worked in Rome for most of his life. He is noted for paintings of local people, wearing traditional costumes or Oriental costumes and for his work documenting iconic Roman monuments and antiquities which were published in two volumes.'),
                ('Eugenio Velasquez', '1817-02-09', '1870-09-11', 'Spain', 'Romantic', 'Realism',
                'Eugenio Lucas Velázquez is, without a doubt, one of the greatest masters of 19th-century Spanish painting and is deservedly hailed as the Spanish Romantic artist who best understood the art of Goya.'),
                ('Andrieu Bertrand', '1787-12-09', '1856-12-02', 'France', 'Romantic', 'Realism',NULL),
                ('John Wood', '1801-05-11', '1870-11-15', 'Britain', 'Romantic', 'Realism', NULL),
                ('Johannes Martinn', '1642-10-10', '1721-03-14', 'German', 'Baroque', NULL,
                'Individual; clockmaker/watchmaker; German; Male'),
                ('Pietro Torrigiano', '1472-11-24', '1528-07-01', 'Italy', 'Renaissance', 'Realism', 
                "Pietro Torrigiani was a Florentine sculptor and painter who became the first exponent of the Italian Renaissance idiom in England."),
                ('Multiple Artists', NULL, NULL, 'Italy', 'Renaissance', 'Anime', 
                "This impressive armor was made for Henry VIII (reigned 1509-47) toward the end of his life, when he was overweight and crippled with gout."),
                ('Jacob Halder', NULL, NULL, 'Britain', 'Renaissance', 'Greenwich',
                "Jacob Halder (active 1576-1608) was Master Workman at the Almain Armoury at Greenwich from 1576 until his death in 1608."),
                ('Pablo Picasso', '1881-10-25', '1973-03-08','Spain', 'Cubism', 'Cubism', "Pablo Ruiz Picasso was a Spanish painter, sculptor, printmaker, ceramicist, and theatre designer."),
                ('Unknown Potter', NULL, NULL, 'USA', '19th-centry ceramics', 'Southern folk art', "Face jugs were made by African American slaves and freedmen working in potteries in the Edgefield District of South Carolina, an area of significant stoneware production in the nineteenth century."),
                ('Woody de Othello', NULL, NULL, 'USA', 'Contemporary', 'Modern Ceramics', "Woody De Othello (b. 1991, Miami, Florida) is a Miami-born, California-based artist whose subject matter spans household objects, bodily features, and  the natural world."),
                ('Vili (Kongo)', NULL, NULL, 'USA', 'African tribal', 'African tribal art', NULL),
                ('Syrian sculptor', NULL, NULL, 'Syria', 'Ancient art', 'Roman','Artist from the Imperial Roman era (-63 -324)'),
                ('Greek sculptor #1', NULL, NULL, 'Greece', 'Ancient art', 'Classic', 'Artist from Athens, (2nd quarter 5th century BC; 3rd quarter 5th century BC)'),
                ('Greek sculptor #2', NULL, NULL, 'Greece', 'Ancient art', 'Classic', 'Ancient sculptor from Athens'),
                ('Michelangelo', '1475-03-06', '1564-02-18', 'Italy', 'Renaissance', 'Classic', "Michelangelo di Lodovico Buonarroti Simoni, known mononymously as Michelangelo, was an Italian sculptor, painter, architect, and poet of the High Renaissance."),
                ('Greek sculptor #3', NULL, NULL, 'Greece', 'Hellenistic', 'Classic', 'Ancient Greek sculptor of the Renaissance'),
                ('Guillaume Coustou', '1677-04-25', '1746-02-22', 'France', 'Renaissance', 'Classic', "Guillaume Coustou the Elder was a French sculptor of the Baroque and Louis XIV style. He was a royal sculptor for Louis XIV and Louis XV and became Director of the Royal Academy of Painting and Sculpture in 1735.");

INSERT INTO ART_OBJECTS
VALUES          (10000, 'Gustave Courbet', 1865, 'The Fishing Boat', 'French', 'Realistic', 'The Met', 'Courbet painted this work during an intensely productive visit to Trouville with James McNeill Whistler from September until November 1865' ),
                (10001, 'Nicolaes Maes', 1655, 'Young Woman Peeling Apples', 'Dutch', 'Baroque', 'The Met','Bright red tones unify this painting, linking the maid’s costume, the apples she peels, and the Turkish carpet on the table. Painted a few years after Maes left Rembrandt’s studio, this picture reveals the artist’s debt to his teacher in its soft contours and effects of light.'),
                (10002, 'Christian Claus', 1785, 'Pianoforte Guittar', 'British', 'Neoclassical', 'The Met','The English guittar [sic] was a six-course wire-strung cittern, most popular in Britain in the second half of the eighteenth century. '),
                (10003, 'Jacob Denner', 1735, 'Oboe in C', 'German', 'Baroque', 'The Met', 'Design modifications such as a longer bore gradually distinguished oboes from shawms in the mid-seventeenth century. These developments first occurred in France, where the instrument was referred to as hautbois (loud wood), from which the term oboe derives.'),
                (10004, 'Jean Barbault', 1755, 'Venitienne', 'French', 'Neoclassical', 'The Louvre','Barbault painted figures known as “Costumes of Italy” several times. A first series of twelve figures is documented by a letter dated November 10 from Jean-François de Troy, director of the French Academy in Rome to Vandières, future Marquis de Marigny.'),
                (10005, 'Eugenio Velasquez', 1869, 'La Fusillade', 'Spanish', 'Realistic', 'The Louvre','It is the counterpart of a painting of similar dimensions which, under the title Dos de Mayo, entered the Museum of Fine Arts in Budapest in 1952. This pair is inspired by Goyas famous Dos de Mayo and Tres de Mayo, kept at the Prado, immortalizing the revolt of the people of Madrid against the Napoleonic army.'),
                (10006, 'Andrieu Bertrand', 1850, 'Ordre de la Legion Dhonneur', 'French', 'Realistic', 'The Louvre','The decoration of the Order of the Legion of Honor: a star with five double rays, surrounded by an oak branch and a laurel branch forming a crown. Inside a circle bearing the inscription HONOR AND HOMELAND, an eagle holding a thunderbolt between its claws.'),
                (10032, 'Andrieu Bertrand', 1807, 'Passage du Simplon', 'French', 'Realistic', 'The Louvre','The Simplon represented in the form of an old man seated in the middle of enormous mountains, through which are traced the windings of a road followed by troops and military crews.'),
                (10033, 'John Wood', 1850, 'Portrait of Sir Charles Fellows', 'British', 'Realistic', 'The British Museum','The traveller and archaeologist Sir Charles Fellows is seen here in front of a model of the 4th century BC Payava tomb from Xanthus in Ancient Lycia, his table laden with antiquarian books.'),
                (10034, 'John Wood', 1845, 'Head of a Lady', 'British', 'Realistic', 'The British Museum', NULL),
                (10035, 'Johannes Martinn', 1665, 'Spring-Driven Table Clock', 'German', 'Baroque', 'The British Museum','Horizontal table timepiece with alarm; spring-driven.'),
                (10036, 'Johannes Martinn', 1672, 'Free Blown Glass Vase', 'German', 'Baroque', 'The British Museum', NULL),
                (10008, 'Pietro Torrigiano', 1510, 'Portrait Bust of John Fisher, Bishop of Rochester','British','Renaissance','European Sculpture and Decorative Arts',"The subject was traditionally identified as John Fisher, Bishop of Rochester and confessor to Henry VIII's first queen, Catherine of Aragon, but the identification has been increasingly called into question."),
                (10009, 'Multiple Artists', 1544, 'Field Armor of King Henry VIII of England', 'Italy','Renaissance','Arms and Armor','This impressive armor was made for Henry VIII (reigned 1509-47) toward the end of his life, when he was overweight and crippled with gout.'),
                (10010, 'Jacob Halder', 1586, 'Armor Garniture of George Clifford (1558-1605), Third Earl of Cumberland', 'Britian','Renaissance','Arms and Armor',"The Cumberland armor is part of a garniture for field and tournament use. It was made in the royal workshops at Greenwich under the direction of the master armorer Jacob Halder."),
                (10011, 'Pablo Picasso', 1914, 'Glass and Die', 'Spain', 'Cubism','Modern and Contemporary Art', "The carved and marbleized piece of wood fixed to the backboard may represent a curtain or a screen. In any case, it complements the flat, marbleized shadow apparently cast by the white fluted wineglass. Decorative pattern thus supersedes realism in this exercise in trompe l'esprit (fool the mind)."),
                (10012, 'Pablo Picasso', 1914, 'The Absinthe Glass', 'Spain', 'Cubism', 'Modern and Contemporary Art', "In an age when sculpture usually meant allegorical figures and portrait busts, Picasso's life-size rendering of a glass of alcohol was shocking for its banality. Cast in bronze in an edition of six, and then hand-painted, none of the finished works is colored green, so it was clearly not absinthe's distinctive color that inspired Picasso."),
                (10013, 'Unknown Potter', 1867, 'Face Jug', 'USA', '19th-century ceramics', 'The American Wing', "Face jugs were made by African American slaves and freedmen working in potteries in the Edgefield District of South Carolina, an area of significant stoneware production in the nineteenth century. The distinctive features of the jugs, notably the kaolin inserts for the eyes, relate in style and material to ritualistic objects of the Congo and Angola region of western Africa, whence many slaves in South Carolina descended."),
                (20001, 'Woody de Othello', 2022, 'Tools', 'USA', 'Contemporary', 'Modern and Contemporary Art', "Ceramic piece by sculptor Woody de Othello."),
                (20002, 'Vili (Kongo)', '1850', 'Power figure', 'USA', 'African tribal', 'The American Wing', "Depiction of power figure influenced by those created by the Kongo people."),
                (30000, 'Syrian sculptor', 324, 'Sculpture', 'Syria', 'Ancient art', 'Department of Oriental Antiquities', "Fragment of sculpture representing part of a headless, draped bust. It was reused in the vertical direction for a relief showing the head of a bearded man."),
                (30001, 'Greek sculptor #1', 475, 'Lekythos', 'Greece', 'Ancient art', 'Department of Greek, Etruscan and Roman Antiquities',"Condition of the work: the vases are incomplete; a large part of the belly is missing; the drawing is very faded (traces of a character on the left?); the surface is very damaged; the vase was completed and repainted (the black varnish chips in black, the threads in yellow and brown, the himation in red)."),
                (30002, 'Greek sculptor #2', 750, 'pitcher lid', 'Greece', 'Ancient art', 'Department of Greek, Etruscan and Roman Antiquities', "Condition of the work: the cover is incomplete; a fragment of the rim and a large chip are missing; chips on breaks; the surface is damaged; it was glued back together, the gaps and chips on the breaks were filled."),
                (30003, 'Michelangelo', 1513, 'Rebel slave', 'Italy', 'Renaissance', 'Department of Sculptures of the Middle Ages, Renaissance and Modern Times', "Commissioned in 1505 by Julius II (pontificate 1503-1513) for his tomb in Saint Peter's Basilica in Rome. Made by Michelangelo in Rome between 1513 and 1515 and originally intended for the base of his funerary monument (layout known from the second project)."),
                (30004, 'Greek sculptor #3', -150, 'Venus de Milo', 'Greece', 'Hellenistic', 'Department of Greek, Etruscan and Roman Antiquities', "Condition of the work: incomplete: the left arm, a large part of the right arm, the left foot are missing. The nose has chips. The back has numerous scratches."),
                (30005, 'Guillaume Coustou', 1745, 'Horse restrained by a groom', 'France','Renaissance','Department of Sculptures of the Middle Ages, Renaissance and Modern Times', "Commissioned by Philibert Orry (1689-1747), director of the King's Buildings, to replace the groups of Antoine Coysevox (see MR 1822 and MR 1824)."); 

INSERT INTO PAINTING
VALUES          (10000, 'Oil', 'Canvas', 'Realism'),
                (10001, "Oil", 'Wood', 'Realism'),
                (10004, 'Oil', 'Canvas', 'Impressionism'),
                (10005, 'Oil', 'Canvas', 'Realism'),
                (10033, 'Oil', 'Canvas', 'Realism'),
                (10034, 'Oil', 'Canvas', 'Realism');

INSERT INTO SCULPTURE
VALUES          (10008, 'Polychrome terracotta', 34.00, 28.1, 'Renaissance'),
                (10011, 'Painted wood', 21.9, 1.0, 'Cubism'),
                (10012, 'Painted bronze and perforated tin absinthe spoon', 22.5, 1.0, 'Realistic'),
                (10013, 'Alkaline-glazed stoneware with kaolin', 17.8, 0.5, 'Southern folk art'),
                (30000, 'Marble', 34, 14.74, 'Roman'),
                (30001, 'Clay', 47.5, 13.56, 'Classic'),
                (30002, 'Clay', 10, 0.5, 'Classic');

INSERT INTO STATUE
VALUES          (10009,'Steel and leather', 184.2, 22.91, 'Anime'),
                (10010, 'Steel and leather', 176.5, 27.2, 'Greenwich'),
                (20001, 'Bronze, glazed ceramic, wood', 154.9, 10.50, 'Contemporary'),
                (20002, 'Wood, iron, nails', 103.5, 18.1, 'African tribal art'),
                (30003, 'Marble', 215, 916, 'Classic'),
                (30004, 'Marble', 204, 920, 'Classic'),
                (30005, 'Marble', 304, 10546, 'Classic');

INSERT INTO OTHER
VALUES          (10002, 'Musical Instrument', 'Neoclassicism'),
                (10003, 'Musical Instrument', 'Baroque'),
                (10006, 'Medal', 'Realism'),
                (10032, 'Medal', 'Realism'),
                (10035, 'Furniture', 'Realism'),
                (10036, 'Vase', 'Realism');

INSERT INTO PERMANENT_COLLECTION
VALUES          (10008, '1936-12-20', 'On display', 500.00, 'European Sculpture and Decorative Arts'),
                (10009, '1932-01-23', 'On display', 1499.60, 'Arms and Armor'),
                (10010, '1932-06-14', 'On display', 1549.00, 'Arms and Armor'),
                (10011, '1970-10-01', 'Stored', 351959, 'Modern and Contemporary Art'),
                (10012, '1914-04-16', 'Stored', 350000, 'Modern and Contemporary Art'),
                (10013, '1922-09-07', 'Stored', 30000, 'The American Wing'),
                (20001, '2022-01-25', 'Stored', 100000, 'Modern and Contemporary Art'),
                (20002, '1900-09-16', 'Stored', 50000, 'The American Wing'),
                (10000, '1956-02-03', 'On display', 45500, 'The Met'),
                (10001, '1994-09-18', 'On display', 57000, 'The Met'),
                (10002, '2002-11-11', 'Stored', 70600, 'The Met'),
                (10003, '2016-05-14', 'Stored', 59000, 'The Met'),
                (10004, '1935-04-17', 'On display', 65000, 'The Louvre'),
                (10005, '1901-12-16', 'Stored', 43700, 'The Louvre'),
                (10006, '1918-07-25', 'On display', 14000, 'The Louvre'),
                (10032, '1988-09-26', 'Stored', 17550, 'The Louvre');

INSERT INTO BORROWED
VALUES          (30000, 'Department of Oriental Antiquities', '1945-05-02', '2022-01-23'),
                (30001, 'Department of Greek, Etruscan and Roman Antiquities', '1951-02-20', '2023-12-04'),
                (30002, 'Department of Greek, Etruscan and Roman Antiquities', '1950-11-21', '2023-12-04'),
                (30003, 'Department of Sculptures of the Middle Ages, Renaissance and Modern Times', '1794-02-19', '2023-12-04'),
                (30004, 'Department of Greek, Etruscan and Roman Antiquities', '1820-04-25', '2023-12-04'),
                (30005, 'Department of Sculptures of the Middle Ages, Renaissance and Modern Times', '1795-09-11', '1984-11-06'),
                (10033, 'The British Museum', '1978-02-01', '2002-07-16'),
                (10034, 'The British Museum', '2004-11-14', '2014-11-04'),
                (10035, 'The British Museum', '1937-09-16', '2023-11-19'),
                (10036, 'The British Museum', '2020-01-15', '2023-12-04');


INSERT INTO EXHIBITIONS
VALUES          ('Look Again: European Paintings 1300-1800', '2023-11-04', '2024-02-16'),
                ('Music All Around the World', '2023-09-14', '2023-12-15'),
                ('Brushstrokes through the Ages', '2022-12-06', '2023-12-18'),
                ('Coins and Medals', '2023-06-09', '2024-08-07'),
                ('Masters of the Brush', '2022-11-01', '2023-12-30'),
                ('Timeless Treasures', '2023-01-19', '2024-01-19'),
                ('The Tudors: Art and Majesty in Renaissance England', '2022-10-10', '2023-01-08'),
                ("Cubism and the Trompe l'Oeil Tradition", '2022-12-20', '2023-01-22'),
                ("Hear Me Now: The Black Potters of Old Edgefield, South Carolina", '2022-12-09', '2023-02-05'),
                ('National Museums Recovery', '1945-04-11', '2023-01-01'),
                ('Masterpieces of the Louvre', '1793-08-10', '2023-01-01');

INSERT INTO DISPLAYED_IN
VALUES          (10000, 'Look Again: European Paintings 1300-1800'),
                (10001, 'Look Again: European Paintings 1300-1800'),
                (10002, 'Music All Around the World'),
                (10003, 'Music All Around the World'),
                (10004, 'Brushstrokes through the Ages'),
                (10005, 'Brushstrokes through the Ages'),
                (10006, 'Coins and Medals'),
                (10032, 'Coins and Medals'),
                (10033, 'Masters of the Brush'),
                (10034, 'Masters of the Brush'),
                (10035, 'Timeless Treasures'),
                (10036, 'Timeless Treasures'),
                (10008, 'The Tudors: Art and Majesty in Renaissance England'),
                (10009, 'The Tudors: Art and Majesty in Renaissance England'),
                (10010, 'The Tudors: Art and Majesty in Renaissance England'),
                (10011, "Cubism and the Trompe l'Oeil Tradition"),
                (10012, "Cubism and the Trompe l'Oeil Tradition"),
                (10013, "Hear Me Now: The Black Potters of Old Edgefield, South Carolina"),
                (20001, "Hear Me Now: The Black Potters of Old Edgefield, South Carolina"),
                (20002, "Hear Me Now: The Black Potters of Old Edgefield, South Carolina"),
                (30000, 'National Museums Recovery'),
                (30001, 'National Museums Recovery'),
                (30002, 'National Museums Recovery'),
                (30003, 'Masterpieces of the Louvre'),
                (30004, 'Masterpieces of the Louvre'),
                (30005, 'Masterpieces of the Louvre'); 

ALTER TABLE ART_OBJECTS
ADD CONSTRAINT COLNFK	FOREIGN KEY (CollectionName) REFERENCES COLLECTIONS(CollectionsName)		ON DELETE CASCADE			ON UPDATE CASCADE;


/*Setting user access and privileges*/

DROP ROLE IF EXISTS db_admin@localhost, read_access@localhost;

CREATE ROLE db_admin@localhost, read_access@localhost;
GRANT ALL PRIVILEGES ON ARTMUSEUM.* TO db_admin@localhost;
GRANT Select ON ARTMUSEUM.* TO read_access@localhost;

DROP USER IF EXISTS admin1@localhost;       
DROP USER IF EXISTS guest@localhost;  

CREATE USER admin1@localhost IDENTIFIED WITH mysql_native_password BY 'password';       /*Creating user with admin role*/
CREATE USER guest@localhost;                                                            /*Creating user with guest role*/

GRANT db_admin@localhost TO admin1@localhost;       
GRANT read_access@localhost TO guest@localhost; 

SET DEFAULT ROLE ALL TO admin1@localhost;
SET DEFAULT ROLE ALL TO guest@localhost;



