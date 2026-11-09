# EXAMPLE OF FILES IN HILBERT SYSTEM

## Pool File

###### SMX1_FIN_RA1_Pool.txt
```txt
SMX1 FIN RA1 Fonaments de la Informàtica

1 Passa de binari a decimal el número $1001001_2$
5
1 $73_{10}$
0 $77_{10}$
0 $71_{10}$
0 $69_{10}$
0 $67_{10}$
--vspace 3cm --group 1.1

1 Passa de binari a decimal el número $1000101_2$
5
1 $69_{10}$
0 $71_{10}$
0 $67_{10}$
0 $73_{10}$
0 $65_{10}$
--vspace 3cm --group 1.1

2 Fes la suma dels números binaris $11000101_2 + 10011010_2$
5
1 $15F_{16}$
1 $351_{10}$
1 $537_8$
1 $101011111_2$
0 $240_3$
--vspace 3cm --group 1.C

2 Fes la suma dels números binaris $10101101_2 + 10011010_2$
5
1 $147_{16}$
1 $327_{10}$
1 $507_8$
1 $101000111_2$
0 $241_3$
--vspace 3cm --group 1.C
```

## Exams Files
```sh
hilbert generate --exams=5 --items=2 --date=202610 SMX1_FIN_RA1
```

### SMX1_FIN_RA1_Exams.txt (HV <= 25.12)
```txt
SMX1 FIN RA1 Fonaments de la Informàtica
EXAM SMX1_FIN_RA1_202610/001 2 010/002/100 00010 10000
1 Passa de binari a decimal el número $1000101_2$
5
1 $69_{10}$
0 $71_{10}$
0 $67_{10}$
0 $73_{10}$
0 $65_{10}$
--vspace 3cm
2 Fes la suma dels números binaris $10101101_2 + 10011010_2$
5
1 $147_{16}$
1 $327_{10}$
1 $507_8$
1 $101000111_2$
0 $241_3$
--vspace 3cm
EXAM SMX1_FIN_RA1_202610/002 2 010/002/100 01000 00100
1 Passa de binari a decimal el número $1001001_2$
5
1 $73_{10}$
0 $77_{10}$
0 $71_{10}$
0 $69_{10}$
0 $67_{10}$
--vspace 3cm
2 Fes la suma dels números binaris $11000101_2 + 10011010_2$
5
1 $15F_{16}$
1 $351_{10}$
1 $537_8$
1 $101011111_2$
0 $240_3$
--vspace 3cm
  •••
  etc
  •••
```

###### Legend
```txt
EXAM SMX1_FIN_RA1_202610/001 2 010/002/100 00010 10000
--1- --2-------------------- 3 -4- -5- -6- --7--------

  1 prefix
  2 exam id
  3 number of items
  4 number of options
  5 number of "trues"
  6 average difficulty * 100
  7 answers per item
```

### SMX1_FIN_RA1_Exams.txt (HV >= 26.10)
```txt
SMX1 FIN RA1 Fonaments de la Informàtica
EXAM SMX1_FIN_RA1_202610/001 002/004 1 00010 3 10000
1 Passa de binari a decimal el número $1000101_2$ (1 punt)
5
1 $69_{10}$
0 $71_{10}$
0 $67_{10}$
0 $73_{10}$
0 $65_{10}$
--vspace 3cm
2 Fes la suma dels números binaris $10101101_2 + 10011010_2$ (3 punts)
5
1 $147_{16}$
1 $327_{10}$
1 $507_8$
1 $101000111_2$
0 $241_3$
--vspace 3cm
EXAM SMX1_FIN_RA1_202610/002 002/004 1 01000 3 00100
1 Passa de binari a decimal el número $1001001_2$ (1 punt)
5
1 $73_{10}$
0 $77_{10}$
0 $71_{10}$
0 $69_{10}$
0 $67_{10}$
--vspace 3cm
2 Fes la suma dels números binaris $11000101_2 + 10011010_2$ (3 punts)
5
1 $15F_{16}$
1 $351_{10}$
1 $537_8$
1 $101011111_2$
0 $240_3$
--vspace 3cm
  •••
  etc
  •••
```

###### Legend
```txt
EXAM SMX1_FIN_RA1_202610/001 002/004 1 00010 3 10000
--1- --2-------------------- --3 --4 5 --6-- 7 --8--

  1 prefix
  2 exam id
  3 number of items
  4 number of points
  1st item points
  1st item answers
  2nd item points
  2nd item answers
```

## Batch File

### SMX1_FIN_RA1_Batch.txt (HV <= 25.12)
```txt
SMX1 FIN RA1 Fonaments de la Informàtica
EXAM SMX1_FIN_RA1_202610/001 2 010/002/100 00010 10000
EXAM SMX1_FIN_RA1_202610/002 2 010/002/100 01000 00100
EXAM SMX1_FIN_RA1_202610/003 2 010/002/100 00001 10000
EXAM SMX1_FIN_RA1_202610/004 2 010/002/100 00001 00010
EXAM SMX1_FIN_RA1_202610/005 2 010/002/100 00100 10000
```

###### Legend
```txt
EXAM SMX1_FIN_RA1_202610/001 2 010/002/100 00010 10000
--1- --2-------------------- 3 -4- -5- -6- --7--------

  1 prefix
  2 exam id
  3 number of items
  4 number of options
  5 number of "trues"
  6 average difficulty * 100
  7 answers per item
```

### SMX1_FIN_RA1_Batch.txt (HV >= 26.10)
```txt
EXAM SMX1_FIN_RA1_202610/001 2/4 1 00010 3 10000
EXAM SMX1_FIN_RA1_202610/002 2/4 1 01000 3 00100
EXAM SMX1_FIN_RA1_202610/003 2/4 3 00001 1 10000
EXAM SMX1_FIN_RA1_202610/004 2/4 1 00001 3 00010
EXAM SMX1_FIN_RA1_202610/005 2/4 3 00100 1 10000
```

###### Legend
```txt
EXAM SMX1_FIN_RA1_202610/001 2/4 1 00010 3 10000
--1- --2-------------------- 3 4 5 --6-- 7 --8--

  1 prefix
  2 exam id
  3 number of items
  4 total points
  5 1st item points
  6 1st item answers
  7 2nd item points
  8 2nd item answers
```
