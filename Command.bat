bison -d robot.y
flex robot.l      
gcc -o robot lex.yy.c robot.tab.c
pause
