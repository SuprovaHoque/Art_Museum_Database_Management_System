use artmuseum;

/*  1) Show all tables and explain how they are related to one another (keys, triggers, etc.) 
	Art object is related to Artist through a foreign key in art object called "Artist." Painting, sculpture, statue, other, permanent collection
    and borrowed are all related to art object through Id_no, which is a foreign key referencing the primary key Id_no of art object. Permanent collection
    and borrowed have foreign keys that reference the collection table's CollectionName. Finally, there is a relationship table called displayed_in 
    which is made up of 2 foreign keys, one that references the primary key Id_no of art objects and another that references the primary key of exhibitions
    called ExhibitionName. There is a before update trigger on sculpture which specifies that if something is to be added onto sculpture to increase its height,
    the total height of the sculpture cannot exceed 400cm or 4m which is the height of this museum's gallery. Therefore, before updating it will check if the height
    is less than 4m, in which case it will allow the user to set it, otherwise the height will remain the same and the user will not be able to change it.
*/
SELECT *
FROM information_schema.tables
WHERE table_type='BASE TABLE'
      AND table_schema = 'artmuseum';

  /*2) Basic retrieval query
    Retrieves all items from the table ART_OBJECTS that were made in the Renaissance epoch*/

SELECT *
FROM ART_OBJECTS
WHERE Epoch = 'Renaissance';

/*  3) A retrieval query with ordered results
    Orders the museum's permanent collections currently on display by least to most expensive*/

SELECT      Id_no, Cost
FROM        PERMANENT_COLLECTION
WHERE       CollectionStatus = 'On Display'
ORDER BY    Cost;

  /*4) Nested retrieval query
    Retrieves all paintings from ART_OBJECTS that have the style Realism*/

SELECT AO.Title, AO.Artist, AO.YearCreated, AO.Origin, AO.Epoch, AO.CollectionName, AO.ArtDescription
FROM ART_OBJECTS AS AO
WHERE AO.Id_no IN (
    SELECT P.Id_no
    FROM PAINTING AS P
    WHERE P.Style = 'Realism');

/*  5)A retrieval query using joined tables
    Retrieves the Title, Artist, Paint_type, and Style of all paintings having a Realistic Style
    by joining ART_OBJECTS and PAINTING  */

SELECT  Title, Artist, Paint_type, Style
FROM    ART_OBJECTS AS A JOIN PAINTING AS P ON A.Id_no = P.Id_no
WHERE   Style = 'Realism';

/* 6) An update operation with any necessary triggers */
CREATE TRIGGER SCULPTURE_UPDATE_VIOLATION 
BEFORE UPDATE ON SCULPTURE 
FOR EACH ROW 

SET NEW.Height= IF((SELECT Height 
                    FROM SCULPTURE AS S, ART_OBJECTS AS A 
                    WHERE A.Id_no = new.S.Id_no)<400, 
                    new.Height, 
                    old.Height);
UPDATE SCULPTURE
SET Height = 450   /* Wouldn't let you do this update because height > 400  */
WHERE Id_no = 10008;
SELECT * FROM SCULPTURE;