CC = gcc
FLEX = flex
TARGET = scanner
SOURCE = scanner.l
TEST_FILE = test.minicpp
OUTPUT = tokens.txt

$(TARGET): lex.yy.c
	$(CC) -o $(TARGET) lex.yy.c

lex.yy.c: $(SOURCE)
	$(FLEX) $(SOURCE)

test: $(TARGET)
	./$(TARGET) $(TEST_FILE) > $(OUTPUT) 2>&1

clean:
	rm -f $(TARGET) lex.yy.c $(OUTPUT)

.PHONY: test clean