#!/bin/bash

echo "=== NexaLang Compiler Build ==="

# Change to src directory
cd src

# Generate lexer
echo "Step 1: Generating lexer with Flex..."
flex scanner.l

# Compile the C code
echo "Step 2: Compiling generated C code..."
gcc lex.yy.c -o ../scanner -lfl

if [ $? -eq 0 ]; then
    echo "✅ Scanner compiled successfully!"
    
    # Run scanner on test program
    echo "Step 3: Running scanner on test program..."
    echo "=== TOKENIZATION OUTPUT ===" > ../output/tokens.txt
    echo "=== ERROR LOG ===" > ../output/errors.txt
    
    ../scanner < test_program.mcpp >> ../output/tokens.txt 2>> ../output/errors.txt
    
    echo "✅ Tokenization complete!"
    echo "📁 Output files created in /output folder"
    
    # Display results
    echo -e "\n=== TOKENS ==="
    cat ../output/tokens.txt
    
    echo -e "\n=== ERRORS ==="
    cat ../output/errors.txt
    
else
    echo "❌ Compilation failed!"
    exit 1
fi