CXX = mpic++
CFLAGS = -ggdb -O0 -Wall -std=c11
LFLAGS = -L/Users/jmft2/local/lib -lm -lpng -lpnghelpers
OBJS =
TARGETS = fields3d  hcs_fun_t  load_multiple_data_test  ls_simulator ls_simulator_2d v_fun_centreline  v_fun_cs
.PHONY: clean fullclean

all: $(OBJS) $(TARGETS)

$(TARGETS): %: %.o $(OBJS)
	$(CXX) $(LFLAGS) $(OBJS) $< -o $@

clean:
	rm -f *.o

fullclean: clean
	rm -f $(TARGETS)

## See stackoverflow.com/questions/25102075/loop-through-files-in-a-makefile
#FILENAME:= $(patsubst %.cpp,%,$(wildcard *.cpp))
#
#all:$(FILENAME)
#	@echo $(FILENAME)
#
#% : %.cpp
#	mpic++ -std=c++11 $< -o $@
#
#clean:
#	rm $(FILENAME)
