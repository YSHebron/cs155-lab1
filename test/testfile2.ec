PROCEDURE MergeSort(arr: ARRAY, low: INTEGER, high: INTEGER)
VAR
    middle: INTEGER
BEGIN
    IF low < high THEN
        middle := (low + high) DIV 2
        MergeSort(arr, low, middle)
        MergeSort(arr, middle + 1, high)
        Merge(arr, low, middle, high)
    END IF
END
"Sda _ASdas asdsad 'asds "

PROCEDURE Merge(arr: ARRAY, low: INTEGER, middle: INTEGER, high: INTEGER)
VAR
    leftArray, rightArray: ARRAY
    n1, n2, i, j, k: INTEGER
BEGIN
    n1 := middle - low + 1
    n2 := high - middle
    
    FOR i := 0 TO n1 - 1 DO
        leftArray[i] := arr[low + i]
    END FOR
    
    FOR j := 0 TO n2 - 1 DO
        rightArray[j] := arr[middle + 1 + j]
    END FOR
    
    i := 0
    j := 0
    k := low
    
    WHILE i < n1 AND j < n2 DO
        IF leftArray[i] <= rightArray[j] THEN
            arr[k] := leftArray[i]
            i := i + 1
        ELSE
            arr[k] := rightArray[j]
            j := j + 1
        END IF
        k := k + 1
    END WHILE
    
    WHILE i < n1 DO
        arr[k] := leftArray[i]
        i := i + 1
        k := k + 1
    END WHILE
    
    WHILE j < n2 DO
        arr[k] := rightArray[j]
        j := j + 1
        k := k + 1
    END WHILE
END


00545434243
34234kdafak
"dfdsfdf/nss.dfsdfsd"