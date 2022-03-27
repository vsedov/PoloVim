#include <iostream>
#include <string>

int add(int x, int y) { return x + y; }
int main(int argc, char *argv[]) {
  printf("here");
  int x = 20;
  printf("%d", x);

  auto r = add(1, 4);

  return 0;
}
