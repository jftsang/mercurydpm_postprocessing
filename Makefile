# See stackoverflow.com/questions/25102075/loop-through-files-in-a-makefile
FILENAME:= $(patsubst %.cpp,%,$(wildcard *.cpp))

all:$(FILENAME)
	@echo $(FILENAME)

% : %.cpp
	mpic++ -std=c++11 $< -o $@

clean:
	rm $(FILENAME)
