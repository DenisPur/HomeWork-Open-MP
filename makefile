FLAGS = -Wall -O2 
TM = task
CM = const

main: main.f95 $(TM).o $(CM).o
	gfortran $^ $(FLAGS) -o $@

$(TM).o: $(TM).f95 $(CM).o
	gfortran $^ $(FLAGS) -c
$(CM).o: $(CM).f95
	gfortran $^ $(FLAGS) -c

clear:
	rm -f *.o *.mod
