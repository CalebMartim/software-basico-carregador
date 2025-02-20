int min(int a, int b){
  if (a < b) {
    return a;
  }
  return b;
}

int stoi(char* s) {
  int ret = 0, p10 = 1, n = 0;
  for(; s[n] != '\0'; ++n) {}
  for (int i = n - 1; i >= 0; --i) {
    ret += (s[i] - '0') * p10;
    p10 *= 10;
  }
  return ret;
}
