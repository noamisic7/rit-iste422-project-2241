#!/bin/sh

echo "Cleaning existing classes..."
rm -rf build/
mkdir -p build/

# This command looks for matching .class files and removes them
find . -name "*.class" -exec rm {} \;

echo "Compiling source code..."
# Compile the Java source files in src/main/java and place .class files in build/
javac -classpath .:lib/junit-4.12.jar:lib/hamcrest-core-1.3.jar -d build src/main/java/*.java
if [ $? -ne 0 ]; then echo "BUILD FAILED!"; exit 1; fi

echo "Compiling unit tests..."
# Compile the test files in src/test/java and place the .class files in build/
javac -classpath build:lib/junit-4.12.jar:lib/hamcrest-core-1.3.jar -d build src/test/java/*.java
if [ $? -ne 0 ]; then echo "TEST BUILD FAILED!"; exit 1; fi

echo "Running unit tests..."
# Run the tests using JUnit
java -cp build:lib/junit-4.12.jar:lib/hamcrest-core-1.3.jar org.junit.runner.JUnitCore EdgeConnectorTest
if [ $? -ne 0 ]; then echo "TESTS FAILED!"; exit 1; fi

echo "Running application..."
# Run the main class of your application
java -cp build RunEdgeConvert
