%{
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
void yyerror(const char *s);
int yylex(void);
void move_robot(const char* direction, int distance);
void action(const char* action_name,const char* direction, int dis-tance);
bool check(const char* direction, int distance);
void execute_commands(const char* direction, int distance);
int command_count = 0;
typedef struct {
    int x;
    int y;
    //int painted[100][100];
    int paintedX,paintedY;
} Coordinates;
 
Coordinates coordinates_t;
%}
 
%union {
    int num;
    char* dir;
}
 
%token MOVE DO IF NCLEAR WHILE
%token <dir> ACTION DIRECTION D
%token <num> NUMBER
%token LPAREN RPAREN COMMA LBRA RBRA
 
%%
commands:
| command
| commands command
;
 
command:
|MOVE LPAREN DIRECTION COMMA NUMBER RPAREN { move_robot($3, $5); }
| DO LPAREN ACTION COMMA DIRECTION COMMA NUMBER RPAREN { action($3, $5, $7); }
| IF LPAREN D COMMA NUMBER COMMA NCLEAR RPAREN LBRA command RBRA { 
    check($3, $5) ? printf("The cell is already painted. Robot can't move.\n") : move_robot($3, $5);}
| WHILE LPAREN D COMMA NUMBER RPAREN LBRA commands RBRA { exe-cute_commands($3, $5); }
;
// do(paint,down,4)
// move(up,4)
//if(d,4,nclear){move(up,5)}
//while(d,4){move(up,5)}
%%
void yyerror(const char *s) {
    fprintf(stderr, "Error:%s\n", s);
}
 
void move_robot(const char* direction, int distance) {
    command_count++;
    coordinates_t.x += (strcmp(direction,"right") == 0) ? distance : (strcmp(direction,"left") == 0) ? -distance : 0;
    coordinates_t.y += (strcmp(direction,"up") == 0) ? distance : (strcmp(direction,"down") == 0) ? -distance : 0;
    printf("%d. Moving robot %s by %d...\ncoordinates:(%d,%d)\n", com-mand_count, direction, distance,coordinates_t.x,coordinates_t.y);
}
void action(const char* action_name, const char* direction, int dis-tance) {
    command_count++;
    int deltaX = (strcmp(direction,"right") == 0) ? distance
                : (strcmp(direction,"left") == 0) ? -distance : 0;
    int deltaY = (strcmp(direction,"up") == 0) ? distance
                : (strcmp(direction,"down") == 0) ? -distance : 0;
 
    coordinates_t.x += deltaX;
    coordinates_t.y += deltaY;
 
    printf("%d. Robot performed the action: %s by coordinates %d...\ncoordinates:(%d,%d)\n", 
           command_count, action_name, distance, coordinates_t.x, coor-dinates_t.y);
 
    if (strcmp(action_name, "paint") == 0) {
        coordinates_t.paintedX = coordinates_t.x;
        coordinates_t.paintedY = coordinates_t.y;
        printf("Painted at coordinates: (%d,%d)\n", coordi-nates_t.paintedX, coordinates_t.paintedY);
    }
}
bool check(const char* direction, int distance) {
 
    int targetX = coordinates_t.x;
    int targetY = coordinates_t.y;
 
    targetX += (strcmp(direction, "r") == 0) ? distance
             : (strcmp(direction, "l") == 0) ? -distance : 0;
    targetY += (strcmp(direction, "u") == 0) ? distance
             : (strcmp(direction, "d") == 0) ? -distance : 0;
 
    return (targetX == coordinates_t.paintedX && targetY == coordi-nates_t.paintedY) ? true : false;
}
 
void execute_commands(const char* direction, int distance) { 
    while (true) { 
        if (!check(direction, distance)) { 
            break; 
        } 
        move_robot(direction, distance);
 } }
int main() {
    yyparse();
    return 0;
}
