PROCEDURE areaCircle;
VAR area: REAL;
VAR i: INTEGER;

BEGIN

WRITELN ("Computing area of a circle with r from 1 to 10")
FOR i := 1 TO 10 DO
  BEGIN
  	area := 2 * 3.14 * i
  	WRITELN ("For circle with radius = ")
  	WRITELN (i)
  	WRITELN ("area is ")
  	WRITELN (area)
  END
END

